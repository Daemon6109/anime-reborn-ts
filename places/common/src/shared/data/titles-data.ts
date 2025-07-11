import titles from "@shared/configuration/titles-data.json";

export type TitlesRegistry = typeof titles;
export type TitleName = keyof TitlesRegistry;
export type TitleData = TitlesRegistry[TitleName];

/**
 * All titles organized by their internal names
 */
export const TitlesRegistry: TitlesRegistry = titles;

/**
 * Helper functions for working with titles
 */
export namespace TitlesData {
	/**
	 * Get title data by name
	 */
	export function getTitle(name: TitleName): TitleData | undefined {
		return TitlesRegistry[name];
	}

	/**
	 * Get the description for a specific title
	 */
	export function getDescription(name: TitleName): string | undefined {
		return TitlesRegistry[name]?.Description;
	}
}
