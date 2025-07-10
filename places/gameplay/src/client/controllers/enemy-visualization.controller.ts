import { Controller, OnStart } from "@flamework/core";
import { RunService, TweenService, Workspace } from "@rbxts/services";
import { atom, subscribe } from "@rbxts/charm";
import { Janitor } from "@rbxts/janitor";
import Signal from "@rbxts/lemon-signal";
import { EnemyType, EnemyComponent } from "@shared/components/tower-defense.components";
import { ENEMY_CONFIGS, DEFAULT_PATH_POINTS } from "@shared/config/game-config";

interface EnemyVisual {
	id: string;
	model: Model;
	healthBar: BillboardGui;
	tween?: Tween;
	currentPathIndex: number;
	pathProgress: number;
	enemyType: EnemyType;
}

@Controller()
export class EnemyVisualizationController implements OnStart {
	private readonly janitor = new Janitor();

	// State management
	private readonly enemiesAtom = atom<Map<string, EnemyVisual>>(new Map());

	// Signals
	public readonly onEnemyModelCreated = new Signal<(enemyId: string, model: Model) => void>();
	public readonly onEnemyModelDestroyed = new Signal<(enemyId: string) => void>();

	// Visual cache
	private readonly enemyModels = new Map<string, Model>();

	onStart(): void {
		this.setupEnemyVisualizationSystem();
		print("Enemy Visualization Controller started!");
	}

	private setupEnemyVisualizationSystem(): void {
		// Listen for enemy updates from server
		this.janitor.Add(
			RunService.Heartbeat.Connect(() => {
				this.updateEnemyVisuals();
			}),
			(connection) => connection.Disconnect(),
		);

		// React to enemy state changes
		this.janitor.Add(
			subscribe(this.enemiesAtom, (enemies) => {
				this.synchronizeEnemyVisuals(enemies);
			}),
			(subscription) => subscription(),
		);
	}

	public addEnemy(enemy: EnemyComponent, position: Vector3, health: number, maxHealth: number): void {
		const enemyModel = this.createEnemyModel(enemy.enemyType, enemy.id);
		const healthBar = this.createHealthBar(enemyModel);

		const enemyVisual: EnemyVisual = {
			id: enemy.id,
			model: enemyModel,
			healthBar: healthBar,
			currentPathIndex: 0,
			pathProgress: 0,
			enemyType: enemy.enemyType,
		};

		// Set initial position
		enemyModel.PivotTo(new CFrame(position));

		// Update health bar
		this.updateHealthBar(healthBar, health, maxHealth);

		// Update state
		const enemies = this.enemiesAtom();
		const newEnemies = new Map([...enemies]);
		newEnemies.set(enemy.id, enemyVisual);
		this.enemiesAtom(newEnemies);

		this.enemyModels.set(enemy.id, enemyModel);
		this.onEnemyModelCreated.Fire(enemy.id, enemyModel);

		print(`Enemy visual created: ${enemy.id} (${enemy.enemyType})`);
	}

	public updateEnemyPosition(
		enemyId: string,
		newPosition: Vector3,
		pathIndex: number,
		pathProgress: number,
		health: number,
		maxHealth: number,
	): void {
		const enemies = this.enemiesAtom();
		const enemy = enemies.get(enemyId);

		if (!enemy) return;

		// Update path data
		enemy.currentPathIndex = pathIndex;
		enemy.pathProgress = pathProgress;

		// Smooth movement with tween
		this.moveEnemyToPosition(enemy, newPosition);

		// Update health bar
		this.updateHealthBar(enemy.healthBar, health, maxHealth);

		// Update state
		const newEnemies = new Map([...enemies]);
		newEnemies.set(enemyId, enemy);
		this.enemiesAtom(newEnemies);
	}

	public removeEnemy(enemyId: string): void {
		const enemies = this.enemiesAtom();
		const enemy = enemies.get(enemyId);

		if (!enemy) return;

		// Play death animation
		this.playDeathAnimation(enemy.model).then(() => {
			// Clean up after animation
			enemy.model.Destroy();
			this.enemyModels.delete(enemyId);
			this.onEnemyModelDestroyed.Fire(enemyId);
		});

		// Remove from state immediately
		const newEnemies = new Map([...enemies]);
		newEnemies.delete(enemyId);
		this.enemiesAtom(newEnemies);
	}

	private createEnemyModel(enemyType: EnemyType, enemyId: string): Model {
		const model = new Instance("Model");
		model.Name = `Enemy_${enemyType}_${enemyId}`;

		// Create main body
		const body = new Instance("Part");
		body.Name = "Body";
		body.Size = this.getEnemySizeForType(enemyType);
		body.Shape = Enum.PartType.Block;
		body.Anchored = false;
		body.CanCollide = false;
		body.BrickColor = this.getEnemyColorForType(enemyType);
		body.Material = Enum.Material.Neon;
		body.Parent = model;

		// Set as primary part
		model.PrimaryPart = body;

		// Add BodyVelocity for smooth movement
		const bodyVelocity = new Instance("BodyVelocity");
		bodyVelocity.MaxForce = new Vector3(4000, 4000, 4000);
		bodyVelocity.Velocity = new Vector3(0, 0, 0);
		bodyVelocity.Parent = body;

		// Add visual details based on enemy type
		this.addEnemyDetails(model, enemyType);

		// Add floating animation
		this.addFloatingAnimation(body);

		model.Parent = Workspace;
		return model;
	}

	private getEnemySizeForType(enemyType: EnemyType): Vector3 {
		switch (enemyType) {
			case EnemyType.BasicEnemy:
				return new Vector3(2, 2, 2);
			case EnemyType.FastEnemy:
				return new Vector3(1.5, 1.5, 1.5);
			case EnemyType.TankEnemy:
				return new Vector3(3, 3, 3);
			case EnemyType.FlyingEnemy:
				return new Vector3(1.8, 1.8, 1.8);
			default:
				return new Vector3(2, 2, 2);
		}
	}

	private getEnemyColorForType(enemyType: EnemyType): BrickColor {
		switch (enemyType) {
			case EnemyType.BasicEnemy:
				return new BrickColor("Bright red");
			case EnemyType.FastEnemy:
				return new BrickColor("Bright yellow");
			case EnemyType.TankEnemy:
				return new BrickColor("Dark stone grey");
			case EnemyType.FlyingEnemy:
				return new BrickColor("Bright violet");
			default:
				return new BrickColor("Bright red");
		}
	}

	private addEnemyDetails(model: Model, enemyType: EnemyType): void {
		const body = model.PrimaryPart!;

		switch (enemyType) {
			case EnemyType.FastEnemy: {
				// Add speed trail effect
				const trail = new Instance("Trail");
				trail.Color = new ColorSequence(Color3.fromRGB(255, 255, 0));
				trail.Transparency = new NumberSequence([
					new NumberSequenceKeypoint(0, 0),
					new NumberSequenceKeypoint(1, 1),
				]);
				trail.Lifetime = 0.5;
				trail.MinLength = 0;

				const attachment0 = new Instance("Attachment");
				const attachment1 = new Instance("Attachment");
				attachment0.Position = new Vector3(-1, 0, 0);
				attachment1.Position = new Vector3(1, 0, 0);
				attachment0.Parent = body;
				attachment1.Parent = body;

				trail.Attachment0 = attachment0;
				trail.Attachment1 = attachment1;
				trail.Parent = body;
				break;
			}
			case EnemyType.TankEnemy: {
				// Add armor plating
				const armor = new Instance("Part");
				armor.Name = "Armor";
				armor.Size = body.Size.add(new Vector3(0.5, 0.5, 0.5));
				armor.CFrame = body.CFrame;
				armor.Anchored = false;
				armor.CanCollide = false;
				armor.Transparency = 0.3;
				armor.BrickColor = new BrickColor("Really black");
				armor.Material = Enum.Material.Metal;
				armor.Parent = model;

				// Weld to body
				const weld = new Instance("WeldConstraint");
				weld.Part0 = body;
				weld.Part1 = armor;
				weld.Parent = body;
				break;
			}
			case EnemyType.FlyingEnemy: {
				// Add wings
				const leftWing = new Instance("Part");
				leftWing.Name = "LeftWing";
				leftWing.Size = new Vector3(0.2, 0.1, 1);
				leftWing.CFrame = body.CFrame.mul(new CFrame(-1, 0, 0));
				leftWing.Anchored = false;
				leftWing.CanCollide = false;
				leftWing.BrickColor = new BrickColor("White");
				leftWing.Material = Enum.Material.Neon;
				leftWing.Parent = model;

				const rightWing = leftWing.Clone();
				rightWing.Name = "RightWing";
				rightWing.CFrame = body.CFrame.mul(new CFrame(1, 0, 0));
				rightWing.Parent = model;

				// Weld wings
				const leftWeld = new Instance("WeldConstraint");
				leftWeld.Part0 = body;
				leftWeld.Part1 = leftWing;
				leftWeld.Parent = body;

				const rightWeld = new Instance("WeldConstraint");
				rightWeld.Part0 = body;
				rightWeld.Part1 = rightWing;
				rightWeld.Parent = body;

				// Add wing flapping animation
				this.addWingAnimation(leftWing, rightWing);
				break;
			}
		}
	}

	private addFloatingAnimation(part: BasePart): void {
		const floatTween = TweenService.Create(
			part,
			new TweenInfo(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
			{ Position: part.Position.add(new Vector3(0, 0.5, 0)) },
		);
		floatTween.Play();
	}

	private addWingAnimation(leftWing: BasePart, rightWing: BasePart): void {
		const flapTween = TweenService.Create(
			leftWing,
			new TweenInfo(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
			{ Orientation: leftWing.Orientation.add(new Vector3(0, 0, 30)) },
		);

		const flapTween2 = TweenService.Create(
			rightWing,
			new TweenInfo(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
			{ Orientation: rightWing.Orientation.add(new Vector3(0, 0, -30)) },
		);

		flapTween.Play();
		flapTween2.Play();
	}

	private createHealthBar(enemyModel: Model): BillboardGui {
		const billboardGui = new Instance("BillboardGui");
		billboardGui.Name = "HealthBar";
		billboardGui.Size = UDim2.fromOffset(100, 10);
		billboardGui.StudsOffset = new Vector3(0, 3, 0);
		billboardGui.Adornee = enemyModel.PrimaryPart;
		billboardGui.Parent = enemyModel;

		// Background
		const background = new Instance("Frame");
		background.Name = "Background";
		background.Size = UDim2.fromScale(1, 1);
		background.BackgroundColor3 = Color3.fromRGB(0, 0, 0);
		background.BorderSizePixel = 0;
		background.Parent = billboardGui;

		// Health bar
		const healthBar = new Instance("Frame");
		healthBar.Name = "Health";
		healthBar.Size = UDim2.fromScale(1, 1);
		healthBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0);
		healthBar.BorderSizePixel = 0;
		healthBar.Parent = background;

		// Add corner radius
		const corner1 = new Instance("UICorner");
		corner1.CornerRadius = new UDim(0, 2);
		corner1.Parent = background;

		const corner2 = new Instance("UICorner");
		corner2.CornerRadius = new UDim(0, 2);
		corner2.Parent = healthBar;

		return billboardGui;
	}

	private updateHealthBar(healthBar: BillboardGui, currentHealth: number, maxHealth: number): void {
		const healthFrame = healthBar.FindFirstChild("Background")?.FindFirstChild("Health") as Frame;
		if (!healthFrame) return;

		const healthPercent = currentHealth / maxHealth;

		// Animate health bar
		const tween = TweenService.Create(
			healthFrame,
			new TweenInfo(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
			{ Size: UDim2.fromScale(healthPercent, 1) },
		);
		tween.Play();

		// Update color based on health percentage
		let color: Color3;
		if (healthPercent > 0.7) {
			color = Color3.fromRGB(0, 255, 0); // Green
		} else if (healthPercent > 0.3) {
			color = Color3.fromRGB(255, 255, 0); // Yellow
		} else {
			color = Color3.fromRGB(255, 0, 0); // Red
		}

		healthFrame.BackgroundColor3 = color;
	}

	private moveEnemyToPosition(enemy: EnemyVisual, targetPosition: Vector3): void {
		if (!enemy.model.PrimaryPart) return;

		// Cancel existing tween
		if (enemy.tween) {
			enemy.tween.Cancel();
		}

		// Calculate movement duration based on distance and enemy speed
		const currentPosition = enemy.model.PrimaryPart.Position;
		const distance = currentPosition.sub(targetPosition).Magnitude;
		const enemyConfig = ENEMY_CONFIGS[enemy.enemyType];
		const duration = distance / (enemyConfig.speed * 5); // Scale factor for visual smoothness

		// Create smooth movement tween
		enemy.tween = TweenService.Create(
			enemy.model.PrimaryPart,
			new TweenInfo(duration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out),
			{ Position: targetPosition },
		);

		enemy.tween.Play();
	}

	private playDeathAnimation(model: Model): Promise<void> {
		return new Promise((resolve) => {
			// Explosion effect
			const explosion = new Instance("Explosion");
			explosion.Position = model.GetPrimaryPartCFrame().Position;
			explosion.BlastRadius = 5;
			explosion.BlastPressure = 0; // No physics effect
			explosion.Parent = Workspace;

			// Fade out and scale down
			const parts: BasePart[] = [];
			for (const part of model.GetDescendants()) {
				if (part.IsA("BasePart")) {
					parts.push(part);
				}
			}

			const tweens: Tween[] = [];
			for (const part of parts) {
				const scaleTween = TweenService.Create(
					part,
					new TweenInfo(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.In),
					{ Size: new Vector3(0, 0, 0) },
				);

				const fadeTween = TweenService.Create(
					part,
					new TweenInfo(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.In),
					{ Transparency: 1 },
				);

				tweens.push(scaleTween);
				tweens.push(fadeTween);

				scaleTween.Play();
				fadeTween.Play();
			}

			// Wait for all tweens to complete
			if (tweens.size() > 0) {
				tweens[0].Completed.Connect(() => {
					resolve();
				});
			} else {
				resolve();
			}
		});
	}

	private updateEnemyVisuals(): void {
		// This would be called to update enemy positions based on server data
		// In a real implementation, this would receive updates from the networking layer
	}

	private synchronizeEnemyVisuals(enemies: Map<string, EnemyVisual>): void {
		// Sync visual state with atom state
		for (const [enemyId, enemyVisual] of enemies) {
			// Perform any necessary visual updates
		}
	}

	public destroy(): void {
		this.janitor.Cleanup();

		// Clean up all enemy models
		for (const [, model] of this.enemyModels) {
			model.Destroy();
		}
		this.enemyModels.clear();
	}
}
