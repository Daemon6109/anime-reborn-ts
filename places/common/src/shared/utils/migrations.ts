// Data migration utilities for handling version upgrades

export type MigrationFunction = (data: Record<string, unknown>) => Record<string, unknown>;

export interface Migration {
	fromVersion: number;
	toVersion: number;
	migrationFunction: MigrationFunction;
	description: string;
}

class DataMigrations {
	private migrations = new Map<number, Migration>();
	
	public readonly CurrentVersion = 6;

	public registerMigration(
		fromVersion: number, 
		migrationFunction: MigrationFunction, 
		description: string
	): void {
		this.migrations.set(fromVersion, {
			fromVersion,
			toVersion: fromVersion + 1,
			migrationFunction,
			description,
		});
	}

	public migrateData(data: Record<string, unknown>, currentVersion: number): [Record<string, unknown>, number] {
		let migratedData = { ...data };
		let version = currentVersion;

		while (version < this.CurrentVersion) {
			const migration = this.migrations.get(version);
			if (!migration) {
				warn(`No migration found for version ${version} to ${version + 1}`);
				break;
			}

			print(`Migrating data from version ${version} to ${version + 1}: ${migration.description}`);
			migratedData = migration.migrationFunction(migratedData);
			version = migration.toVersion;
		}

		return [migratedData, version];
	}

	public getRegisteredMigrations(): Migration[] {
		const result: Migration[] = [];
		this.migrations.forEach((migration) => {
			result.push(migration);
		});
		return result;
	}
}

export const migrations = new DataMigrations();
