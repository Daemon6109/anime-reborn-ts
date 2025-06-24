import { PassiveData } from "../passive";

export const FreezingTouch: PassiveData = {
    name: "Freezing Touch",
    description: "Each attack freezes enemies for 3 seconds.",
    callbacks: {}, // Logic for applying status effect likely handled by attack/status system via a tag or property.
                   // e.g., unit could have a tag "AppliesFreezingTouch"
};
