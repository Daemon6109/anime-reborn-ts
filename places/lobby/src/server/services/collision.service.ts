import { Service, OnStart } from "@flamework/core";
import { Players, PhysicsService, ReplicatedStorage } from "@rbxts/services";

@Service({})
export class CollisionService implements OnStart {
	onStart(): void {
		PhysicsService.RegisterCollisionGroup("GeneralCollisions");
		PhysicsService.CollisionGroupSetCollidable("GeneralCollisions", "GeneralCollisions", false);

		const units = ReplicatedStorage.FindFirstChild("assets")?.FindFirstChild("units") as Folder;
		if (units) {
			for (const unit of units.GetDescendants()) {
				if (unit.IsA("BasePart") || unit.IsA("MeshPart")) {
					unit.CollisionGroup = "GeneralCollisions";
				}
			}
		}

		Players.PlayerAdded.Connect((player) => {
			player.CharacterAdded.Connect((character) => {
				this.handleCharacterAdded(character);
			});
		});
	}

	private handleCharacterAdded(character: Model): void {
		for (const part of character.GetDescendants()) {
			if (part.IsA("BasePart")) {
				part.CollisionGroup = "GeneralCollisions";
			}
		}
	}
}
