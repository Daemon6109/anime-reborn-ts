import { PassiveData } from "../passive";

export const PoisonSword: PassiveData = {
    name: "Poison Sword",
    description: "With each attack this unit applies `Poison` status effect, lasts for 25 seconds.",
    callbacks: {}, // Similar to PoisonMagic, this passive implies a specific type of "Poison"
                   // or that the unit's attacks are tagged to apply a standard "Poison"
                   // with a 25-second duration. The core game systems would handle this.
};
