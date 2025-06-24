import { PassiveData } from "../passive";

export const Overtime: PassiveData = {
    name: "Overtime",
    description: "Nonomi's attacks leave a `Weak Point` status effect on enemies, making them take +35% DMG for 10 seconds",
    callbacks: {}, // Logic for applying "Weak Point" status effect and the subsequent damage increase
                   // would likely be handled by the attack/status effect system and damage calculation system.
                   // This passive would grant a tag like "AppliesWeakPointOnHit".
                   // The damage system then checks if a target has "WeakPoint" from this source
                   // (or any source if WeakPoint is generic) and applies +35% damage.
};
