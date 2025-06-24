import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const OniGiri: PassiveData = {
    name: "OniGiri",
    description: "This unit does 2x scar DoT damage to shielded & boss enemies.",
    // percentIncrease: 2, // Multiplier for Scar DoT damage, not direct attack damage.
    // statusNeeded: "Scar", // The DoT to amplify.
    callbacks: {
        onConditionalDamage: (unit: Unit, enemy: any) => {
            // TODO: Implement enemy.StatusEffects, enemy.ShieldCharges, enemy.IsBoss checks.
            // This passive modifies the DoT damage of "Scar", not the main attack damage.
            // The onConditionalDamage callback in Luau returns a multiplier for the *main attack*.
            // This seems to be a misunderstanding in the Luau implementation if the description is accurate.
            // Description: "2x scar DoT damage". Luau: "return 2x direct damage if enemy has Scar AND (shield OR boss)".
            // Assuming Luau logic for now for direct translation of the callback:
            // if (enemy && enemy.Health > 0 && enemy.StatusEffects && (enemy.ShieldCharges > 0 || enemy.IsBoss)) {
            //     const hasScar = enemy.StatusEffects[OniGiri.statusNeeded] === true;
            //     if (hasScar) {
            //         return OniGiri.percentIncrease; // This would be 2x direct damage.
            //     }
            // }
            return 1; // Default direct damage multiplier.

            // To implement the description accurately ("2x scar DoT damage"):
            // This passive would likely add a property/tag to the unit, e.g., "OniGiriScarAmplifier".
            // The system that calculates DoT damage for "Scar" would check if the source unit
            // has this property/tag and if the target is shielded or a boss, then multiply the Scar DoT tick by 2.
            // This callback (onConditionalDamage) is not the right place to modify DoT damage.
        },
    },
};
