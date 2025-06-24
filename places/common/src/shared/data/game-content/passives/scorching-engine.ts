import { PassiveData } from "../passive";

export const ScorchingEngine: PassiveData = {
    name: "Scorching Engine",
    description: "With each attack Jenos applies `Burning` status effect, lasts for 5 seconds",
    callbacks: {}, // This passive implies that attacks from a unit with "ScorchingEngine"
                   // should apply a "Burning" status effect with a 5-second duration.
                   // This is typically handled by:
                   // 1. Tagging the unit (e.g., "AppliesScorchingBurn").
                   // 2. The attack/damage system recognizes this tag and, upon a successful hit,
                   //    applies the "Burning" status effect to the target with the specified duration.
                   // No active Luau callbacks are present for this passive.
};
