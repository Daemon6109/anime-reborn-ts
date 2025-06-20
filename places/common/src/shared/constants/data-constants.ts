// Data constants for the data service

export const DATA_CONSTANTS = {
	// Player Datastore
	DATASTORE_NAME: "Production1",
	MAX_RECEIPT_HISTORY: 100, // The maximum number of receipts to store in the player data

	// Ordered Datastores
	DISPLAY_COUNT: 100,
	UPDATE_INTERVAL: 60,
	UPDATE_MAX_ATTEMPTS: 3, // Make up to 3 attempts (Initial attempt + 2 retries)
	UPDATE_RETRY_PAUSE_CONSTANT: 1, // Base wait time between attempts
	UPDATE_RETRY_PAUSE_EXPONENT_BASE: 2, // Base number raised to the power of the retry number for exponential backoff
} as const;
