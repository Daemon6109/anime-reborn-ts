import { Controller, OnStart } from "@flamework/core";
import { UserInputService, Workspace, RunService } from "@rbxts/services";
import { Janitor } from "@rbxts/janitor";
import { atom, subscribe } from "@rbxts/charm";
import ClientNetwork from "@network/client";
import { TowerType, EnemyType } from "@shared/config/game-config";
import { TOWER_CONFIGS, ENEMY_CONFIGS } from "@shared/config/game-config";
import {
	Tower as NetworkTower,
	Enemy as NetworkEnemy,
	Projectile as NetworkProjectile,
	GameState as NetworkGameState,
	EnemyDeathData,
} from "@network/types";

@Controller()
export class TowerDefenseController implements OnStart {
	private readonly janitor = new Janitor();
	private readonly towerModels = new Map<string, Model>();
	private readonly enemyModels = new Map<string, Model>();
	private readonly projectileModels = new Map<string, Part>();
	private placementPreview?: Model;
	private placementGrid?: Part;

	private readonly selectedTowerTypeAtom = atom<TowerType | undefined>(undefined);
	private readonly gameStateAtom = atom<NetworkGameState | undefined>(undefined);

	onStart(): void {
		this.setupUI();
		this.setupNetworkListeners();
		this.setupInputHandling();
		this.setupPlacementGrid();

		print("Tower Defense Client Controller initialized!");
	}

	private setupUI(): void {
		// Create a simple UI for selecting towers and starting waves
		const screenGui = new Instance("ScreenGui");
		screenGui.Name = "TowerDefenseUI";
		screenGui.Parent = game.GetService("Players").LocalPlayer.WaitForChild("PlayerGui");
		this.janitor.Add(screenGui);

		const towerFrame = new Instance("Frame");
		towerFrame.Size = new UDim2(0, 200, 0, 50);
		towerFrame.Position = new UDim2(0, 10, 0, 10);
		towerFrame.Parent = screenGui;

		let xOffset = 0;
		for (const [towerType, towerConfig] of pairs(TOWER_CONFIGS)) {
			const button = new Instance("TextButton");
			button.Size = new UDim2(0, 40, 0, 40);
			button.Position = new UDim2(0, xOffset, 0, 5);
			button.Text = towerConfig.name;
			button.Parent = towerFrame;
			button.MouseButton1Click.Connect(() => {
				this.selectedTowerTypeAtom(towerType as TowerType);
			});
			xOffset += 50;
		}

		const startWaveButton = new Instance("TextButton");
		startWaveButton.Size = new UDim2(0, 100, 0, 50);
		startWaveButton.Position = new UDim2(0, 10, 0, 70);
		startWaveButton.Text = "Start Wave";
		startWaveButton.Parent = screenGui;
		startWaveButton.MouseButton1Click.Connect(() => {
			ClientNetwork.TowerDefense.StartWaveRequest.fire({});
		});
	}

	private setupNetworkListeners(): void {
		ClientNetwork.TowerDefense.TowerPlaced.on((data: NetworkTower) => {
			this.createTowerVisual(data);
		});

		ClientNetwork.TowerDefense.EnemySpawned.on((data: NetworkEnemy) => {
			this.createEnemyVisual(data);
		});

		ClientNetwork.TowerDefense.EnemyDied.on((data: EnemyDeathData) => {
			const enemyModel = this.enemyModels.get(data.enemyId);
			if (enemyModel) {
				enemyModel.Destroy();
				this.enemyModels.delete(data.enemyId);
			}
		});

		ClientNetwork.TowerDefense.ProjectileCreated.on((data: NetworkProjectile) => {
			this.createProjectileVisual(data);
		});

		ClientNetwork.TowerDefense.GameStateUpdated.on((data: NetworkGameState) => {
			this.gameStateAtom(data);
		});
	}

	private setupInputHandling(): void {
		this.janitor.Add(
			UserInputService.InputBegan.Connect((input, gameProcessed) => {
				if (gameProcessed) return;

				if (input.UserInputType === Enum.UserInputType.MouseButton1) {
					const selectedTower = this.selectedTowerTypeAtom();
					if (selectedTower && this.placementPreview) {
						ClientNetwork.TowerDefense.PlaceTowerRequest.fire({
							towerType: selectedTower,
							position: this.placementPreview.PrimaryPart!.Position,
						});
						this.selectedTowerTypeAtom(undefined);
						this.placementPreview.Destroy();
						this.placementPreview = undefined;
					}
				}
			}),
		);

		this.janitor.Add(
			subscribe(this.selectedTowerTypeAtom, (towerType) => {
				if (towerType) {
					this.showPlacementPreview(towerType);
				} else {
					if (this.placementPreview) {
						this.placementPreview.Destroy();
						this.placementPreview = undefined;
					}
				}
			}),
		);
	}

	private setupPlacementGrid(): void {
		this.placementGrid = new Instance("Part");
		this.placementGrid.Name = "PlacementGrid";
		this.placementGrid.Size = new Vector3(512, 0.1, 512);
		this.placementGrid.Position = new Vector3(0, 0, 0);
		this.placementGrid.Anchored = true;
		this.placementGrid.Transparency = 1;
		this.placementGrid.CanCollide = false;
		this.placementGrid.Parent = Workspace;
		this.janitor.Add(this.placementGrid);

		this.janitor.Add(
			RunService.RenderStepped.Connect(() => {
				if (this.placementPreview) {
					const mouse = UserInputService.GetMouseLocation();
					const ray = Workspace.CurrentCamera!.ViewportPointToRay(mouse.X, mouse.Y);
					const result = Workspace.Raycast(ray.Origin, ray.Direction.mul(1000), new RaycastParams());
					if (result && result.Instance === this.placementGrid) {
						this.placementPreview.SetPrimaryPartCFrame(new CFrame(result.Position));
					}
				}
			}),
		);
	}

	private showPlacementPreview(towerType: TowerType): void {
		if (this.placementPreview) {
			this.placementPreview.Destroy();
		}

		const towerConfig = TOWER_CONFIGS[towerType];
		this.placementPreview = new Instance("Model");
		const part = new Instance("Part");
		part.Size = towerConfig.size;
		part.Color = towerConfig.color;
		part.Transparency = 0.5;
		part.Anchored = true;
		part.CanCollide = false;
		part.Parent = this.placementPreview;
		this.placementPreview.PrimaryPart = part;
		this.placementPreview.Parent = Workspace;
	}

	private createTowerVisual(tower: NetworkTower): void {
		const towerConfig = TOWER_CONFIGS[tower.towerType as TowerType];
		const model = new Instance("Model");
		const part = new Instance("Part");
		part.Size = towerConfig.size;
		part.Color = towerConfig.color;
		part.Position = tower.position;
		part.Anchored = true;
		part.Parent = model;
		model.Parent = Workspace;
		this.towerModels.set(tower.id, model);
	}

	private createEnemyVisual(enemy: NetworkEnemy): void {
		const enemyConfig = ENEMY_CONFIGS[enemy.enemyType as EnemyType];
		const model = new Instance("Model");
		const part = new Instance("Part");
		part.Size = enemyConfig.size;
		part.Color = enemyConfig.color;
		part.Position = enemy.position;
		part.Anchored = true;
		part.Parent = model;
		model.Parent = Workspace;
		this.enemyModels.set(enemy.id, model);
	}

	private createProjectileVisual(projectile: NetworkProjectile): void {
		const part = new Instance("Part");
		part.Shape = Enum.PartType.Ball;
		part.Size = new Vector3(0.5, 0.5, 0.5);
		part.Color = new Color3(1, 1, 0);
		part.Position = projectile.position;
		part.Anchored = true;
		part.CanCollide = false;
		part.Parent = Workspace;
		this.projectileModels.set(projectile.id, part);

		const tweenInfo = new TweenInfo(0.2);
		const tween = game.GetService("TweenService").Create(part, tweenInfo, { Position: projectile.targetPosition });
		tween.Play();
		tween.Completed.Connect(() => {
			part.Destroy();
			this.projectileModels.delete(projectile.id);
		});
	}

	public destroy(): void {
		this.janitor.Cleanup();
	}
}
