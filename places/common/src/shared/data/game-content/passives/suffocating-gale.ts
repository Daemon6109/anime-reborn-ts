import { PassiveData } from "../passive";

export const SuffocatingGale: PassiveData = {
    name: "Suffocating Gale",
    description: "With each attack applies `Suffocation` status effect, slowing down the target by 50%, lasting 15 seconds and has a per-enemy application cooldown of 15 seconds.",
    callbacks: {}, // This describes a status effect ("Suffocation").
                   // - Slow: 50%
                   // - Duration: 15s
                   // - Per-enemy cooldown: 15s (prevents reapplication on same target until CD expires)
                   // The unit would get a tag like "AppliesSuffocatingGale".
                   // The attack/status system would handle the application and cooldown logic for the "Suffocation" effect.
};
