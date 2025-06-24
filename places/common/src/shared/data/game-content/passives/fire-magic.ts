import { PassiveData } from "../passive";

export const FireMagic: PassiveData = {
    name: "Fire Magic",
    description: "With each attack this unit applies `Burn` status effect, lasts for 3 seconds.",
    callbacks: {}, // Logic for applying status effect likely handled by attack/status system via a tag or property.
                   // e.g., unit could have a tag "AppliesFireMagicBurn"
};
