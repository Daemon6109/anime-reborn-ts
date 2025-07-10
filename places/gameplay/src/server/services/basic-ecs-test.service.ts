import { Service } from "@flamework/core";
import { TDWorld } from "@shared/world/td-world";

@Service()
export class BasicECSTestService {
	constructor() {
		this.runTests();
	}

	private runTests() {
		print("Testing JECS Basic Functionality...");

		// Test 1: Create entity and add components
		const entity = TDWorld.createEntity();
		print(`Created entity: ${entity}`);

		// Test 2: Set position component
		TDWorld.world.set(entity, TDWorld.Position, {
			position: new Vector3(10, 20, 30),
		});
		print("Set position component");

		// Test 3: Set health component
		TDWorld.world.set(entity, TDWorld.Health, {
			current: 100,
			maximum: 100,
		});
		print("Set health component");

		// Test 4: Add a tag
		TDWorld.world.set(entity, TDWorld.EnemyTag, true);
		print("Added enemy tag");

		// Test 5: Query for entities
		print("Querying for entities with Position and Health:");
		for (const [queryEntity, position, health] of TDWorld.world.query(TDWorld.Position, TDWorld.Health)) {
			print(`Entity ${queryEntity}: pos=${position.position}, health=${health.current}/${health.maximum}`);
		}

		// Test 6: Query for entities with tags
		print("Querying for entities with EnemyTag:");
		for (const [queryEntity] of TDWorld.world.query(TDWorld.EnemyTag)) {
			print(`Enemy entity: ${queryEntity}`);
		}

		// Test 7: Test component update
		const health = TDWorld.world.get(entity, TDWorld.Health);
		if (health) {
			TDWorld.world.set(entity, TDWorld.Health, {
				current: health.current - 25,
				maximum: health.maximum,
			});
			print(`Updated health to: ${health.current - 25}/${health.maximum}`);
		}

		// Test 8: Multiple entities
		const entity2 = TDWorld.createEntity();
		TDWorld.world.set(entity2, TDWorld.Position, {
			position: new Vector3(50, 60, 70),
		});
		TDWorld.world.set(entity2, TDWorld.TowerTag, true);

		print("Testing queries with multiple entities:");
		for (const [queryEntity, position] of TDWorld.world.query(TDWorld.Position)) {
			const hasEnemy = TDWorld.world.has(queryEntity, TDWorld.EnemyTag);
			const hasTower = TDWorld.world.has(queryEntity, TDWorld.TowerTag);
			print(`Entity ${queryEntity}: pos=${position.position}, enemy=${hasEnemy}, tower=${hasTower}`);
		}

		print("JECS Tests completed successfully!");
	}
}
