import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const OverwhelmingSpiritualPressure: PassiveData = {
    name: "Overwhelming Spiritual Pressure",
    description: "The closer the enemies, The more damage they'll take (up to 20% more)",
    callbacks: {
        onConditionalDamage: (unit: Unit, enemy: any) => {
            // TODO: Implement BuffLib.GetRangeScaled, FastVector.FastMagnitudeVec3, enemy.Position access
            // const BuffLib = require(replicated.Libs.BuffLib); // Placeholder
            // const FastVector = require(replicated.Libs.FastVector).new(); // Placeholder
            // const unitRange = BuffLib.GetRangeScaled(unit);

            // if (enemy && enemy.Health > 0 && enemy.Position && unit.getInstance()?.PrimaryPart) {
            //     const distance = FastVector.FastMagnitudeVec3(unit.getInstance().PrimaryPart.Position, enemy.Position);
            //     if (distance <= unitRange && unitRange > 0) { // Check unitRange > 0 to avoid division by zero
            //         // Damage increases linearly from +0% at max range to +20% at point-blank (distance 0)
            //         // Multiplier = 1.2 (max bonus) - (distance / unitRange * 0.2 (total bonus range))
            //         const damageMultiplier = 1.2 - (distance / unitRange * 0.2);
            //         return Math.max(1, damageMultiplier); // Ensure multiplier doesn't go below 1 if logic is slightly off
            //                                           // Luau uses math.clamp(..., 0, 1.2), but damage multiplier shouldn't be 0.
            //                                           // Clamping between 1.0 and 1.2 makes more sense.
            //     }
            // }
            return 1; // Default damage multiplier
        },
    },
};
