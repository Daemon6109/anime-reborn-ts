import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const AlienTechnologyI: PassiveData = {
    name: "Alien Technology I",
    description: "Does 90% more damage to heavy foes.",
    callbacks: {
        onPlace: (unit: Unit) => {
            unit.addTag("HeavyStrong");
        },
        onConditionalDamage: (unit: Unit, enemy: any) => {
            // TODO: Implement BuffLib equivalent
            // const BuffLib = require(replicated.Libs.BuffLib);
            if (enemy && enemy.Health > 0 && (enemy.Class === "Shield" || enemy.Class === "Guardian")) {
                return 1.9;
            }
            return 1;
        },
    },
};
