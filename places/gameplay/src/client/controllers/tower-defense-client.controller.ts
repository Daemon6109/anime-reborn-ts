import { Service, OnStart } from "@flamework/core";
import { Players, UserInputService, Workspace, TweenService, RunService } from "@rbxts/services";
import { Janitor } from "@rbxts/janitor";
import { atom, effect } from "@rbxts/charm";
import { TOWER_CONFIGS, ENEMY_CONFIGS, GameConfig } from "@shared/config/game-config";

@Service({
	loadOrder: 99,
})
/**
 * Tower Defense Client Controller
 * Handles UI, input, and visual effects for the tower defense game
 */
export class TowerDefenseClientController implements OnStart {
	private readonly janitor = new Janitor();

	// Visuals
	private placementPreview?: Part;
	private readonly pathVisualization: Part[] = [];
	private readonly towerVisuals = new Map<string, Model>();
	private readonly enemyVisuals = new Map<string, Model>();
	private readonly projectileVisuals = new Map<string, Part>();

	// State
	private readonly isPlacingTowerAtom = atom(false);
	private readonly selectedTowerTypeAtom = atom<TowerDefenseNetwork.TowerType | undefined>(undefined);
	private readonly mousePositionAtom = atom(new Vector3());
	private readonly gameStateAtom = atom<TowerDefenseNetwork.GameState | undefined>(undefined);

	constructor(private readonly networkService: TowerDefenseNetworkService) {}

	public onStart(): void {
		if (!RunService.IsClient()) return;

		this.setupUI();
		this.setupInput();
		this.setupVisualization();
		this.setupNetworkListeners();
		this.setupStateEffects();

		print("Tower Defense Client Controller started!");
	}

	private setupUI(): void {
		this.createUI();
		this.createTowerButtons();
	}

	private createUI(): void {
		// Create a simple UI for game stats
		const playerGui = Players.LocalPlayer.FindFirstChildOfClass("PlayerGui");
		if (playerGui) {
			const statsFrame = new Instance("ScreenGui");
			statsFrame.Name = "StatsFrame";
			statsFrame.Parent = playerGui;

			const waveLabel = new Instance("TextLabel");
			waveLabel.Name = "WaveLabel";
			waveLabel.Size = new UDim2(0, 200, 0, 50);
			waveLabel.Position = new UDim2(0, 10, 0, 10);
			waveLabel.Text = "Wave: 0";
			waveLabel.Parent = statsFrame;

			const goldLabel = new Instance("TextLabel");
			goldLabel.Name = "GoldLabel";
			goldLabel.Size = new UDim2(0, 200, 0, 50);
			goldLabel.Position = new UDim2(0, 10, 0, 70);
			goldLabel.Text = "Gold: 500";
			goldLabel.Parent = statsFrame;

			const livesLabel = new Instance("TextLabel");
			livesLabel.Name = "LivesLabel";
			livesLabel.Size = new UDim2(0, 200, 0, 50);
			livesLabel.Position = new UDim2(0, 10, 0, 130);
			livesLabel.Text = "Lives: 20";
			livesLabel.Parent = statsFrame;
		}
	}

	private createTowerButtons(): void {
		const towerTypes: TowerDefenseNetwork.TowerType[] = ["BasicTower", "ArcherTower", "MageTower", "CannonTower"];
		const playerGui = Players.LocalPlayer.FindFirstChildOfClass("PlayerGui");
		if (playerGui) {
			const buttonFrame = new Instance("ScreenGui");
			buttonFrame.Name = "TowerButtons";
			buttonFrame.Parent = playerGui;

			let yPos = 0;
			for (const towerType of towerTypes) {
				const towerConfig = TOWER_CONFIGS[towerType];
				if (towerConfig) {
					const button = new Instance("TextButton");
					button.Name = `${towerType}Button`;
					button.Text = `${towerConfig.name} (${towerConfig.cost}g)`;
					button.Size = new UDim2(0, 200, 0, 50);
					button.Position = new UDim2(0, 0, 0, yPos);
					button.Parent = buttonFrame;

					button.MouseButton1Click.Connect(() => {
						this.selectTowerType(towerType);
					});

					yPos += 60;
				}
			}
		}
	}

	private setupInput(): void {
		// Update mouse position continuously
		this.janitor.Add(
			RunService.RenderStepped.Connect(() => {
				this.updateMouseState();
			}),
		);

		// Mouse click for tower placement
		this.janitor.Add(
			UserInputService.InputBegan.Connect((input, gameProcessed) => {
				if (gameProcessed) return;

				if (input.UserInputType === Enum.UserInputType.MouseButton1) {
					this.handleMouseClick();
				} else if (input.KeyCode === Enum.KeyCode.Escape) {
					this.cancelTowerPlacement();
				}
			}),
		);
	}

	private setupVisualization(): void {
		// Create path visualization
		this.createPathVisualization();
	}

	private setupNetworkListeners(): void {
		// Listen for tower placement
		this.janitor.Add(
			this.networkService.onTowerPlaced.Connect((tower) => {
				this.createTowerVisual(tower);
			}),
		);

		// Listen for enemy spawn/update
		this.janitor.Add(
			this.networkService.onEnemySpawned.Connect((enemy) => {
				this.createEnemyVisual(enemy);
			}),
		);

		this.janitor.Add(
			this.networkService.onEnemyUpdated.Connect((enemy) => {
				this.updateEnemyVisual(enemy);
			}),
		);

		this.janitor.Add(
			this.networkService.onEnemyDied.Connect((data) => {
				this.removeEnemyVisual(data.enemyId);
			}),
		);

		// Listen for projectiles
		this.janitor.Add(
			this.networkService.onProjectileCreated.Connect((projectile) => {
				this.createProjectileVisual(projectile);
			}),
		);

		this.janitor.Add(
			this.networkService.onGameStateUpdated.Connect((gameState) => {
				this.gameStateAtom(gameState);
			}),
		);
	}

	private setupStateEffects(): void {
		// Update UI when game state changes
		this.janitor.Add(
			effect(() => {
				const gameState = this.gameStateAtom();
				if (gameState) {
					this.updateGameStatsUI(gameState);
				}
			}),
		);

		// Show/hide placement preview
		this.janitor.Add(
			effect(() => {
				const isPlacing = this.isPlacingTowerAtom();
				const towerType = this.selectedTowerTypeAtom();

				if (isPlacing && towerType) {
					this.showPlacementPreview(towerType);
				} else {
					this.hidePlacementPreview();
				}
			}),
		);

		// Update placement preview position
		this.janitor.Add(
			effect(() => {
				const mousePos = this.mousePositionAtom();
				if (this.placementPreview) {
					this.placementPreview.Position = mousePos;
				}
			}),
		);
	}

	private selectTowerType(towerType: TowerDefenseNetwork.TowerType): void {
		this.selectedTowerTypeAtom(towerType);
		this.isPlacingTowerAtom(true);
	}

	private cancelTowerPlacement(): void {
		this.selectedTowerTypeAtom(undefined);
		this.isPlacingTowerAtom(false);
	}

	private updateMouseState(): void {
		const mouse = Players.LocalPlayer.GetMouse();
		const camera = Workspace.CurrentCamera;

		if (camera) {
			const ray = camera.ScreenPointToRay(mouse.X, mouse.Y);
			const plane = new RaycastParams();
			plane.FilterType = Enum.RaycastFilterType.Blacklist;
			plane.FilterDescendantsInstances = [];

			const result = Workspace.Raycast(ray.Origin, ray.Direction.mul(1000));
			if (result) {
				this.mousePositionAtom(result.Position);
			}
		}
	}

	private handleMouseClick(): void {
		const isPlacing = this.isPlacingTowerAtom();
		const towerType = this.selectedTowerTypeAtom();
		const mousePos = this.mousePositionAtom();

		if (isPlacing && towerType) {
			// Place tower
			this.networkService.placeTower({
				position: mousePos,
				towerType: towerType,
				playerId: tostring(Players.LocalPlayer.UserId),
			});
			this.cancelTowerPlacement();
		}
	}

	private showPlacementPreview(towerType: TowerDefenseNetwork.TowerType): void {
		if (this.placementPreview) {
			this.placementPreview.Destroy();
		}

		this.placementPreview = new Instance("Part");
		this.placementPreview.Name = "TowerPreview";
		this.placementPreview.Size = new Vector3(2, 4, 2);
		this.placementPreview.Material = Enum.Material.ForceField;
		this.placementPreview.BrickColor = new BrickColor("Bright green");
		this.placementPreview.CanCollide = false;
		this.placementPreview.Anchored = true;
		this.placementPreview.Transparency = 0.5;
		this.placementPreview.Parent = Workspace;

		// Show range indicator
		const rangeIndicator = new Instance("Part");
		rangeIndicator.Name = "RangeIndicator";
		rangeIndicator.Shape = Enum.PartType.Cylinder;
		rangeIndicator.Size = new Vector3(
			0.1,
			TOWER_CONFIGS[towerType]?.range !== undefined ? TOWER_CONFIGS[towerType]!.range : 10,
			TOWER_CONFIGS[towerType]?.range !== undefined ? TOWER_CONFIGS[towerType]!.range : 10,
		);
		rangeIndicator.Material = Enum.Material.ForceField;
		rangeIndicator.BrickColor = new BrickColor("Bright yellow");
		rangeIndicator.CanCollide = false;
		rangeIndicator.Anchored = true;
		rangeIndicator.Transparency = 0.8;
		rangeIndicator.Rotation = new Vector3(0, 0, 90);
		rangeIndicator.Parent = this.placementPreview;
	}

	private hidePlacementPreview(): void {
		if (this.placementPreview) {
			this.placementPreview.Destroy();
			this.placementPreview = undefined;
		}
	}

	private createPathVisualization(): void {
		// Clear existing path
		this.pathVisualization.forEach((part) => part.Destroy());
		this.pathVisualization.clear();

		// Create path parts
		for (let i = 0; i < GameConfig.path.size() - 1; i++) {
			const startPos = GameConfig.path[i];
			const endPos = GameConfig.path[i + 1];
			const midpoint = startPos.add(endPos).div(2);
			const distance = startPos.sub(endPos).Magnitude;

			const pathPart = new Instance("Part");
			pathPart.Name = `PathSegment${i}`;
			pathPart.Size = new Vector3(distance, 0.5, 2);
			pathPart.Position = midpoint;
			pathPart.Material = Enum.Material.Neon;
			pathPart.BrickColor = new BrickColor("Bright blue");
			pathPart.CanCollide = false;
			pathPart.Anchored = true;
			pathPart.CFrame = CFrame.lookAt(startPos, endPos);
			pathPart.Parent = Workspace;

			this.pathVisualization.push(pathPart);
		}
	}

	private createTowerVisual(tower: TowerDefenseNetwork.Tower): void {
		const towerConfig = TOWER_CONFIGS[tower.towerType];
		if (towerConfig === undefined) return;

		const towerModel = new Instance("Model");
		towerModel.Name = tower.id;
		towerModel.PrimaryPart = new Instance("Part");
		towerModel.PrimaryPart.Name = "Base";
		towerModel.PrimaryPart.Size = towerConfig.size;
		towerModel.PrimaryPart.Color = towerConfig.color;
		towerModel.PrimaryPart.Position = tower.position;
		towerModel.PrimaryPart.Anchored = true;
		towerModel.PrimaryPart.CanCollide = false;
		towerModel.PrimaryPart.Parent = towerModel;
		towerModel.Parent = Workspace;

		this.towerVisuals.set(tower.id, towerModel);
	}

	private createEnemyVisual(enemy: TowerDefenseNetwork.Enemy): void {
		const enemyConfig = ENEMY_CONFIGS[enemy.enemyType];
		if (enemyConfig === undefined) return;

		const enemyModel = new Instance("Model");
		enemyModel.Name = enemy.id;
		enemyModel.PrimaryPart = new Instance("Part");
		enemyModel.PrimaryPart.Name = "Body";
		enemyModel.PrimaryPart.Size = enemyConfig.size;
		enemyModel.PrimaryPart.Color = enemyConfig.color;
		enemyModel.PrimaryPart.Position = enemy.position;
		enemyModel.PrimaryPart.Anchored = true;
		enemyModel.PrimaryPart.CanCollide = false;
		enemyModel.PrimaryPart.Parent = enemyModel;
		enemyModel.Parent = Workspace;

		this.enemyVisuals.set(enemy.id, enemyModel);
	}

	private updateEnemyVisual(enemy: TowerDefenseNetwork.Enemy): void {
		const enemyModel = this.enemyVisuals.get(enemy.id);
		if (enemyModel) {
			enemyModel.PivotTo(new CFrame(enemy.position));
		}
	}

	private removeEnemyVisual(enemyId: string): void {
		const enemyModel = this.enemyVisuals.get(enemyId);
		if (enemyModel) {
			enemyModel.Destroy();
			this.enemyVisuals.delete(enemyId);
		}
	}

	private createProjectileVisual(projectile: TowerDefenseNetwork.Projectile): void {
		const projectilePart = new Instance("Part");
		projectilePart.Name = projectile.id;
		projectilePart.Size = new Vector3(0.5, 0.5, 0.5);
		projectilePart.Material = Enum.Material.Neon;
		projectilePart.Color = Color3.fromRGB(255, 255, 0);
		projectilePart.CanCollide = false;
		projectilePart.Anchored = true;
		projectilePart.Position = projectile.position;
		projectilePart.Parent = Workspace;

		// Animate projectile
		const tweenInfo = new TweenInfo(0.2, Enum.EasingStyle.Linear);
		const tween = TweenService.Create(projectilePart, tweenInfo, { Position: projectile.targetPosition });
		tween.Play();

		// Cleanup after tween
		tween.Completed.Connect(() => {
			projectilePart.Destroy();
		});
	}

	private updateGameStatsUI(gameState: TowerDefenseNetwork.GameState): void {
		// Update UI elements with game state data
		const playerGui = Players.LocalPlayer.FindFirstChildOfClass("PlayerGui");
		if (playerGui) {
			const statsFrame = playerGui.FindFirstChild("StatsFrame") as ScreenGui;
			if (statsFrame) {
				const waveLabel = statsFrame.FindFirstChild("WaveLabel") as TextLabel;
				const goldLabel = statsFrame.FindFirstChild("GoldLabel") as TextLabel;
				const livesLabel = statsFrame.FindFirstChild("LivesLabel") as TextLabel;

				if (waveLabel) waveLabel.Text = `Wave: ${gameState.currentWave}`;
				if (goldLabel) goldLabel.Text = `Gold: ${gameState.playerGold}`;
				if (livesLabel) livesLabel.Text = `Lives: ${gameState.playerLives}`;
			}
		}
	}

	public destroy(): void {
		this.janitor.Cleanup();
		if (this.placementPreview) {
			this.placementPreview.Destroy();
		}
		this.pathVisualization.forEach((part) => part.Destroy());
		this.towerVisuals.forEach((model) => model.Destroy());
		this.enemyVisuals.forEach((model) => model.Destroy());
	}
}
