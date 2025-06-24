import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const AlienTechnologyII: PassiveData = {
    name: "Alien Technology II",
    description: "Does 110% more damage to heavy foes.",
    callbacks: {
        onPlace: (unit: Unit) => {
            unit.addTag("HeavyStrong");
        },
        onConditionalDamage: (unit: Unit, enemy: any) => {
            // TODO: Implement BuffLib equivalent
            // const BuffLib = require(replicated.Libs.BuffLib);
            if (enemy && enemy.Health > 0 && (enemy.Class === "Shield" || enemy.Class === "Guardian")) {
                return 2.1;
            }
            return 1;
        },
    },
};
