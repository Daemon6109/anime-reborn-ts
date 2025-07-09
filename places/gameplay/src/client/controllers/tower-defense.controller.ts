import { Controller, OnStart } from "@flamework/core";
import { Players, UserInputService, RunService } from "@rbxts/services";
import { atom, effect } from "@rbxts/charm";

interface TowerPlacements {
	[position: string]: {
		type: "Archer" | "Mage" | "Cannon";
		position: Vector3;
	};
}

@Controller()
export class TowerDefenseController implements OnStart {
	private player = Players.LocalPlayer;
	private camera = game.Workspace.CurrentCamera!;

	// State atoms
	private selectedTowerTypeAtom = atom<"Archer" | "Mage" | "Cannon" | undefined>(undefined);
	private isPlacingTowerAtom = atom<boolean>(false);
	private playerGoldAtom = atom<number>(1000);
	private placedTowersAtom = atom<TowerPlacements>({});

	// Tower costs
	private readonly towerCosts = {
		Archer: 100,
		Mage: 150,
		Cannon: 200,
	};

	onStart(): void {
		this.setupInputHandling();
		this.setupUI();
		this.setupEffects();
		print("Tower Defense Client Controller Started!");
	}

	private setupInputHandling(): void {
		// Handle mouse clicks for tower placement
		UserInputService.InputBegan.Connect((input, gameProcessed) => {
			if (gameProcessed) return;

			if (input.UserInputType === Enum.UserInputType.MouseButton1) {
				this.handleLeftClick();
			} else if (input.UserInputType === Enum.UserInputType.MouseButton2) {
				this.handleRightClick();
			}
		});

		// Handle keyboard input for tower selection
		UserInputService.InputBegan.Connect((input, gameProcessed) => {
			if (gameProcessed) return;

			if (input.KeyCode === Enum.KeyCode.Q) {
				this.selectTowerType("Archer");
			} else if (input.KeyCode === Enum.KeyCode.W) {
				this.selectTowerType("Mage");
			} else if (input.KeyCode === Enum.KeyCode.E) {
				this.selectTowerType("Cannon");
			} else if (input.KeyCode === Enum.KeyCode.Escape) {
				this.cancelTowerPlacement();
			}
		});
	}

	private setupUI(): void {
		// Create a simple UI for tower selection
		const playerGui = this.player.WaitForChild("PlayerGui") as PlayerGui;

		const screenGui = new Instance("ScreenGui");
		screenGui.Name = "TowerDefenseUI";
		screenGui.Parent = playerGui;

		// Create tower selection frame
		const towerFrame = new Instance("Frame");
		towerFrame.Name = "TowerSelection";
		towerFrame.Size = UDim2.fromScale(0.3, 0.1);
		towerFrame.Position = UDim2.fromScale(0.05, 0.85);
		towerFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50);
		towerFrame.BorderSizePixel = 2;
		towerFrame.BorderColor3 = Color3.fromRGB(100, 100, 100);
		towerFrame.Parent = screenGui;

		// Create tower buttons
		const towerTypes: ("Archer" | "Mage" | "Cannon")[] = ["Archer", "Mage", "Cannon"];

		towerTypes.forEach((towerType, index) => {
			const button = new Instance("TextButton");
			button.Name = `${towerType}Button`;
			button.Size = UDim2.fromScale(0.3, 0.8);
			button.Position = UDim2.fromScale(0.05 + index * 0.32, 0.1);
			button.BackgroundColor3 = Color3.fromRGB(70, 70, 70);
			button.TextColor3 = Color3.fromRGB(255, 255, 255);
			button.TextScaled = true;
			button.Font = Enum.Font.SourceSansBold;
			button.Text = `${towerType}\n$${this.towerCosts[towerType]}`;
			button.Parent = towerFrame;

			// Handle button clicks
			button.MouseButton1Click.Connect(() => {
				this.selectTowerType(towerType);
			});
		});

		// Create gold display
		const goldLabel = new Instance("TextLabel");
		goldLabel.Name = "GoldDisplay";
		goldLabel.Size = UDim2.fromScale(0.15, 0.05);
		goldLabel.Position = UDim2.fromScale(0.8, 0.05);
		goldLabel.BackgroundColor3 = Color3.fromRGB(255, 215, 0);
		goldLabel.TextColor3 = Color3.fromRGB(0, 0, 0);
		goldLabel.TextScaled = true;
		goldLabel.Font = Enum.Font.SourceSansBold;
		goldLabel.Text = `Gold: ${this.playerGoldAtom()}`;
		goldLabel.Parent = screenGui;

		// Update gold display when gold changes
		effect(() => {
			goldLabel.Text = `Gold: ${this.playerGoldAtom()}`;
		});

		// Create instructions
		const instructionsLabel = new Instance("TextLabel");
		instructionsLabel.Name = "Instructions";
		instructionsLabel.Size = UDim2.fromScale(0.4, 0.1);
		instructionsLabel.Position = UDim2.fromScale(0.05, 0.05);
		instructionsLabel.BackgroundTransparency = 1;
		instructionsLabel.TextColor3 = Color3.fromRGB(255, 255, 255);
		instructionsLabel.TextScaled = true;
		instructionsLabel.Font = Enum.Font.SourceSans;
		instructionsLabel.Text = "Q/W/E: Select tower type\nLeft Click: Place tower\nRight Click: Cancel";
		instructionsLabel.Parent = screenGui;
	}

	private setupEffects(): void {
		// Visual feedback for tower placement
		effect(() => {
			const selectedType = this.selectedTowerTypeAtom();
			const isPlacing = this.isPlacingTowerAtom();

			if (selectedType && isPlacing) {
				print(`Ready to place ${selectedType} tower - Click to place!`);
			}
		});
	}

	private selectTowerType(towerType: "Archer" | "Mage" | "Cannon"): void {
		const currentGold = this.playerGoldAtom();
		const cost = this.towerCosts[towerType];

		if (currentGold >= cost) {
			this.selectedTowerTypeAtom(towerType);
			this.isPlacingTowerAtom(true);
			print(`Selected ${towerType} tower (Cost: $${cost})`);
		} else {
			print(`Not enough gold! Need $${cost}, have $${currentGold}`);
		}
	}

	private handleLeftClick(): void {
		const selectedType = this.selectedTowerTypeAtom();
		const isPlacing = this.isPlacingTowerAtom();

		if (!selectedType || !isPlacing) return;

		const mousePosition = UserInputService.GetMouseLocation();
		const ray = this.camera.ScreenPointToRay(mousePosition.X, mousePosition.Y);

		// Cast ray to find placement position
		const raycastParams = new RaycastParams();
		raycastParams.FilterType = Enum.RaycastFilterType.Blacklist;
		raycastParams.FilterDescendantsInstances = [];

		const raycastResult = game.Workspace.Raycast(ray.Origin, ray.Direction.mul(1000), raycastParams);

		if (raycastResult) {
			const placementPosition = raycastResult.Position;
			this.placeTower(selectedType, placementPosition);
		}
	}

	private handleRightClick(): void {
		this.cancelTowerPlacement();
	}

	private placeTower(towerType: "Archer" | "Mage" | "Cannon", position: Vector3): void {
		const cost = this.towerCosts[towerType];
		const currentGold = this.playerGoldAtom();

		if (currentGold >= cost) {
			// Deduct gold
			this.playerGoldAtom(currentGold - cost);

			// Add to placed towers
			const positionKey = `${math.floor(position.X)}_${math.floor(position.Z)}`;
			const currentTowers = this.placedTowersAtom();
			this.placedTowersAtom({
				...currentTowers,
				[positionKey]: { type: towerType, position },
			});

			// Create visual representation
			this.createTowerVisual(towerType, position);

			// Reset placement state
			this.cancelTowerPlacement();

			print(`Placed ${towerType} tower at ${position}`);

			// TODO: Send placement command to server
			// ServerNetwork.PlaceTower.fire(towerType, position);
		}
	}

	private createTowerVisual(towerType: "Archer" | "Mage" | "Cannon", position: Vector3): void {
		// Create a simple visual representation of the tower
		const tower = new Instance("Part");
		tower.Name = `${towerType}Tower`;
		tower.Size = new Vector3(4, 6, 4);
		tower.Position = position.add(new Vector3(0, 3, 0));
		tower.Anchored = true;
		tower.CanCollide = false;
		tower.Parent = game.Workspace;

		// Color based on tower type
		const colors = {
			Archer: Color3.fromRGB(139, 69, 19), // Brown
			Mage: Color3.fromRGB(128, 0, 128), // Purple
			Cannon: Color3.fromRGB(64, 64, 64), // Gray
		};
		tower.Color = colors[towerType];

		// Add a simple roof
		const roof = new Instance("Part");
		roof.Name = "Roof";
		roof.Size = new Vector3(5, 1, 5);
		roof.Position = position.add(new Vector3(0, 6.5, 0));
		roof.Anchored = true;
		roof.CanCollide = false;
		roof.Color = Color3.fromRGB(139, 0, 0); // Dark red
		roof.Parent = tower;

		// Add a label
		const billboardGui = new Instance("BillboardGui");
		billboardGui.Size = UDim2.fromOffset(100, 50);
		billboardGui.StudsOffset = new Vector3(0, 4, 0);
		billboardGui.Parent = tower;

		const label = new Instance("TextLabel");
		label.Size = UDim2.fromScale(1, 1);
		label.BackgroundTransparency = 1;
		label.TextColor3 = Color3.fromRGB(255, 255, 255);
		label.TextScaled = true;
		label.Font = Enum.Font.SourceSansBold;
		label.Text = towerType;
		label.TextStrokeTransparency = 0;
		label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0);
		label.Parent = billboardGui;
	}

	private cancelTowerPlacement(): void {
		this.selectedTowerTypeAtom(undefined);
		this.isPlacingTowerAtom(false);
		print("Tower placement cancelled");
	}

	// Public methods for external control
	public addGold(amount: number): void {
		const currentGold = this.playerGoldAtom();
		this.playerGoldAtom(currentGold + amount);
	}

	public getSelectedTowerType(): "Archer" | "Mage" | "Cannon" | undefined {
		return this.selectedTowerTypeAtom();
	}

	public isPlacingTower(): boolean {
		return this.isPlacingTowerAtom();
	}

	public getPlayerGold(): number {
		return this.playerGoldAtom();
	}
}
