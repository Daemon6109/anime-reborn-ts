import { PassiveData } from "../passive";

export const Shock: PassiveData = {
    name: "Shock",
    description: "With each attack applies `Stun` status effect for 1.5s",
    callbacks: {}, // Logic for applying "Stun" (1.5s duration) would be handled by
                   // the attack/status system, likely via a tag "AppliesShockStun"
                   // or by unit's base attack properties modified by this passive.
};
