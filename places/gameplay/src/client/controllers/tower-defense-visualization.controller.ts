import { Controller, OnStart } from "@flamework/core";
import { Players, UserInputService, RunService, Workspace } from "@rbxts/services";
import { atom, effect, peek } from "@rbxts/charm";
import { Janitor } from "@rbxts/janitor";
import Signal from "@rbxts/lemon-signal";
import { TowerType } from "@shared/components/tower-defense.components";
import { TOWER_CONFIGS, DEFAULT_PATH_POINTS } from "@shared/config/game-config";

interface MouseState {
	position: Vector3;
	hit: BasePart | undefined;
	isOverUI: boolean;
}

interface TowerPlacementState {
	selectedTowerType: TowerType | undefined;
	isPlacing: boolean;
	canPlace: boolean;
	previewModel: Model | undefined;
}

@Controller()
export class TowerDefenseVisualizationController implements OnStart {
	private readonly janitor = new Janitor();
	private readonly player = Players.LocalPlayer;
	private readonly camera = Workspace.CurrentCamera!;

	// State atoms for reactive UI
	private readonly mouseStateAtom = atom<MouseState>({
		position: new Vector3(0, 0, 0),
		hit: undefined,
		isOverUI: false,
	});

	private readonly placementStateAtom = atom<TowerPlacementState>({
		selectedTowerType: undefined,
		isPlacing: false,
		canPlace: false,
		previewModel: undefined,
	});

	private readonly playerGoldAtom = atom<number>(500);
	private readonly gameActiveAtom = atom<boolean>(false);

	// Signals for communication
	public readonly onTowerPlaceRequest = new Signal<(towerType: TowerType, position: Vector3) => void>();
	public readonly onTowerSelectRequest = new Signal<(towerType: TowerType) => void>();

	// Visual elements
	private pathVisualization: Model | undefined;
	private rangeIndicator: Part | undefined;

	onStart(): void {
		this.setupPathVisualization();
		this.setupInputHandling();
		this.setupTowerPlacement();
		this.setupReactiveEffects();
		this.setupUI();

		print("Tower Defense Visualization Controller started!");
	}

	private setupPathVisualization(): void {
		// Create visual path that enemies will follow
		this.pathVisualization = new Instance("Model");
		this.pathVisualization.Name = "PathVisualization";
		this.pathVisualization.Parent = Workspace;

		// Create path segments
		for (let i = 0; i < DEFAULT_PATH_POINTS.size() - 1; i++) {
			const currentPoint = DEFAULT_PATH_POINTS[i];
			const nextPoint = DEFAULT_PATH_POINTS[i + 1];

			this.createPathSegment(currentPoint, nextPoint, i);
		}

		// Create waypoint markers
		DEFAULT_PATH_POINTS.forEach((point, index) => {
			this.createWaypoint(point, index);
		});
	}

	private createPathSegment(startPos: Vector3, endPos: Vector3, index: number): void {
		const segment = new Instance("Part");
		segment.Name = `PathSegment_${index}`;
		segment.Material = Enum.Material.Neon;
		segment.BrickColor = new BrickColor("Bright yellow");
		segment.Anchored = true;
		segment.CanCollide = false;
		segment.TopSurface = Enum.SurfaceType.Smooth;
		segment.BottomSurface = Enum.SurfaceType.Smooth;

		// Calculate size and position
		const distance = startPos.sub(endPos).Magnitude;
		segment.Size = new Vector3(0.5, 0.1, distance);
		segment.CFrame = CFrame.lookAt(startPos, endPos).add(new Vector3(0, 0, -distance / 2));
		segment.Parent = this.pathVisualization;
	}

	private createWaypoint(position: Vector3, index: number): void {
		const waypoint = new Instance("Part");
		waypoint.Name = `Waypoint_${index}`;
		waypoint.Shape = Enum.PartType.Ball;
		waypoint.Material = Enum.Material.Neon;
		waypoint.BrickColor = new BrickColor("Lime green");
		waypoint.Anchored = true;
		waypoint.CanCollide = false;
		waypoint.Size = new Vector3(2, 2, 2);
		waypoint.Position = position;

		// Add glowing effect
		const pointLight = new Instance("PointLight");
		pointLight.Color = Color3.fromRGB(0, 255, 0);
		pointLight.Brightness = 2;
		pointLight.Range = 10;
		pointLight.Parent = waypoint;

		waypoint.Parent = this.pathVisualization;
	}

	private setupInputHandling(): void {
		// Update mouse position continuously
		this.janitor.Add(
			RunService.RenderStepped.Connect(() => {
				this.updateMouseState();
			}),
		);

		// Handle mouse clicks
		this.janitor.Add(
			UserInputService.InputBegan.Connect((input, gameProcessed) => {
				if (gameProcessed) return;

				if (input.UserInputType === Enum.UserInputType.MouseButton1) {
					this.handleLeftClick();
				} else if (input.UserInputType === Enum.UserInputType.MouseButton2) {
					this.handleRightClick();
				}
			}),
		);
	}

	private setupTowerPlacement(): void {
		// Effect for showing/hiding placement preview
		this.janitor.Add(
			effect(() => {
				const placementState = this.placementStateAtom();
				if (placementState.isPlacing && placementState.selectedTowerType) {
					this.showPlacementPreview(placementState.selectedTowerType);
				} else {
					this.hidePlacementPreview();
				}
			}),
		);

		// Effect for updating preview position
		this.janitor.Add(
			effect(() => {
				const mouseState = this.mouseStateAtom();
				const placementState = this.placementStateAtom();

				if (placementState.previewModel) {
					placementState.previewModel.PivotTo(new CFrame(mouseState.position));
				}
			}),
		);
	}

	private setupReactiveEffects(): void {
		// Update canPlace based on mouse position and gold
		this.janitor.Add(
			effect(() => {
				const mouseState = this.mouseStateAtom();
				const placementState = this.placementStateAtom();
				const gold = this.playerGoldAtom();

				if (placementState.isPlacing && placementState.selectedTowerType) {
					const towerConfig = TOWER_CONFIGS[placementState.selectedTowerType];
					const canAfford = gold >= towerConfig.cost;
					const isValidPosition = this.isValidPlacementPosition(mouseState.position);

					this.placementStateAtom({
						...placementState,
						canPlace: canAfford && isValidPosition,
					});
				}
			}),
		);

		// Update preview color based on canPlace
		this.janitor.Add(
			effect(() => {
				const placementState = this.placementStateAtom();
				if (placementState.previewModel) {
					const basePart = placementState.previewModel.PrimaryPart as Part;
					if (basePart) {
						basePart.Color = placementState.canPlace ? new Color3(0, 1, 0) : new Color3(1, 0, 0);
					}
				}
			}),
		);
	}

	private setupUI(): void {
		// Create tower selection UI
		this.createTowerSelectionUI();
	}

	private updateMouseState(): void {
		const mouse = this.player.GetMouse();
		const ray = this.camera.ScreenPointToRay(mouse.X, mouse.Y);

		const raycastParams = new RaycastParams();
		raycastParams.FilterType = Enum.RaycastFilterType.Whitelist;
		raycastParams.FilterDescendantsInstances = [Workspace.FindFirstChild("Ground") as BasePart];

		const result = Workspace.Raycast(ray.Origin, ray.Direction.mul(1000), raycastParams);

		this.mouseStateAtom({
			position: result ? result.Position : new Vector3(),
			hit: result ? result.Instance : undefined,
			isOverUI: mouse.Target ? mouse.Target.IsA("GuiObject") : false,
		});
	}

	private handleLeftClick(): void {
		const mouseState = peek(this.mouseStateAtom);
		const placementState = peek(this.placementStateAtom);

		if (mouseState.isOverUI) return;

		if (placementState.isPlacing && placementState.canPlace && placementState.selectedTowerType) {
			this.onTowerPlaceRequest.Fire(placementState.selectedTowerType, mouseState.position);
			this.placementStateAtom({
				...placementState,
				isPlacing: false,
				selectedTowerType: undefined,
			});
		}
	}

	private handleRightClick(): void {
		// Cancel tower placement
		this.placementStateAtom({
			...peek(this.placementStateAtom),
			isPlacing: false,
			selectedTowerType: undefined,
		});
	}

	private showPlacementPreview(towerType: TowerType): void {
		this.hidePlacementPreview(); // Clean up previous preview

		const towerConfig = TOWER_CONFIGS[towerType];
		const previewModel = new Instance("Model");
		previewModel.Name = "TowerPreview";

		const basePart = new Instance("Part");
		basePart.Name = "Base";
		basePart.Size = towerConfig.size;
		basePart.Material = Enum.Material.ForceField;
		basePart.Transparency = 0.5;
		basePart.Anchored = true;
		basePart.CanCollide = false;
		basePart.Parent = previewModel;

		previewModel.PrimaryPart = basePart;
		previewModel.Parent = Workspace;

		// Create range indicator
		this.rangeIndicator = new Instance("Part");
		this.rangeIndicator.Name = "RangeIndicator";
		this.rangeIndicator.Shape = Enum.PartType.Cylinder;
		this.rangeIndicator.Size = new Vector3(0.1, towerConfig.range * 2, towerConfig.range * 2);
		this.rangeIndicator.Material = Enum.Material.ForceField;
		this.rangeIndicator.Transparency = 0.8;
		this.rangeIndicator.Color = new Color3(1, 1, 0);
		this.rangeIndicator.Anchored = true;
		this.rangeIndicator.CanCollide = false;
		this.rangeIndicator.Parent = previewModel;

		this.placementStateAtom({
			...peek(this.placementStateAtom),
			previewModel: previewModel,
		});
	}

	private hidePlacementPreview(): void {
		const placementState = peek(this.placementStateAtom);
		if (placementState.previewModel) {
			placementState.previewModel.Destroy();
		}
		if (this.rangeIndicator) {
			this.rangeIndicator.Destroy();
			this.rangeIndicator = undefined;
		}
		this.placementStateAtom({
			...placementState,
			previewModel: undefined,
		});
	}

	private isValidPlacementPosition(position: Vector3): boolean {
		// Basic check: not too close to the path
		for (const point of DEFAULT_PATH_POINTS) {
			if (position.sub(point).Magnitude < 5) {
				return false;
			}
		}
		return true;
	}

	private createTowerSelectionUI(): void {
		const screenGui = new Instance("ScreenGui");
		screenGui.Name = "TowerSelectionUI";
		screenGui.Parent = this.player.FindFirstChildOfClass("PlayerGui");

		const mainFrame = new Instance("Frame");
		mainFrame.Name = "MainFrame";
		mainFrame.Size = new UDim2(0, 400, 0, 80);
		mainFrame.Position = new UDim2(0.5, -200, 1, -100);
		mainFrame.BackgroundColor3 = new Color3(0.1, 0.1, 0.1);
		mainFrame.BorderSizePixel = 0;
		mainFrame.Parent = screenGui;

		const towerTypes: TowerType[] = [
			TowerType.BasicTower,
			TowerType.ArcherTower,
			TowerType.MageTower,
			TowerType.CannonTower,
		];
		let xOffset = 10;

		for (const towerType of towerTypes) {
			const towerConfig = TOWER_CONFIGS[towerType];

			const button = new Instance("TextButton");
			button.Name = `${towerType}Button`;
			button.Size = new UDim2(0, 80, 0, 60);
			button.Position = new UDim2(0, xOffset, 0, 10);
			button.Text = `${towerConfig.name}\n(${towerConfig.cost}g)`;
			button.Parent = mainFrame;

			button.MouseButton1Click.Connect(() => {
				this.onTowerSelectRequest.Fire(towerType);
				this.placementStateAtom({
					...peek(this.placementStateAtom),
					isPlacing: true,
					selectedTowerType: towerType,
				});
			});

			xOffset += 90;
		}
	}

	public updateGold(newGold: number): void {
		this.playerGoldAtom(newGold);
	}

	public setGameActive(isActive: boolean): void {
		this.gameActiveAtom(isActive);
	}

	public destroy(): void {
		this.janitor.Cleanup();
		this.hidePlacementPreview();
		if (this.pathVisualization) {
			this.pathVisualization.Destroy();
		}
	}
}
