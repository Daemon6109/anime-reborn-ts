import { PassiveData } from "../passive";

export const InfernalFury: PassiveData = {
    name: "Infernal Fury",
    description: "Applies `Burning` status effect on hit",
    callbacks: {}, // Logic for applying status effect likely handled by attack/status system via a tag or property.
                   // e.g., unit could have a tag "AppliesInfernalFuryBurn"
};
