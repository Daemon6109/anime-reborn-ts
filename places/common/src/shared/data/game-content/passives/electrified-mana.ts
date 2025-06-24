import { PassiveData } from "../passive";

export const ElectrifiedMana: PassiveData = {
    name: "Electrified Mana",
    description: "With each attack applies `Stun` status effect for 3 seconds.",
    callbacks: {}, // Logic for applying status effect likely handled by attack/status system via a tag or property.
                   // e.g., unit could have a tag "AppliesElectrifiedManaStun"
};
