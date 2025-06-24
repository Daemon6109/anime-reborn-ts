import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const PinpointStrikes: PassiveData = {
    name: "Pinpoint Strikes",
    description: "Does +35% more damage to enemies under `Scar` status effect.",
    // percentIncrease: 1.35, // Damage multiplier
    // statusNeeded: "Scar",
    callbacks: {
        onConditionalDamage: (unit: Unit, enemy: any) => {
            // TODO: Implement status effect checking (enemy.StatusEffects[PinpointStrikes.statusNeeded])
            // if (enemy && enemy.Health > 0 && enemy.StatusEffects && enemy.StatusEffects[PinpointStrikes.statusNeeded] === true) {
            //     return PinpointStrikes.percentIncrease;
            // }
            return 1;
        },
    },
};
