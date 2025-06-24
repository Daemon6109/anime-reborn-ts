import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const CharmingImpact: PassiveData = {
    name: "Charming Impact",
    description: "Every 3rd attack applies `Charm` to enemies in radius for 10 seconds, Charmed enemies are slowed by 25% and recieve +15% more DMG. Has a 5 seconds cooldown in between next `Charm` application.",
    callbacks: {
        onAttack: (unit: Unit) => {
            // TODO: Implement BuffLib, FastVector, _G.Constructs, _G.Registry (for status effects), attribute, and tag equivalents
            // const BuffLib = require(replicated.Libs.BuffLib); // Placeholder
            // const FastVector = require(replicated.Libs.FastVector).new(); // Placeholder
            // const unitRange = BuffLib.GetRangeScaled(unit);
            // let stacks = unit.getAttribute("BoaStacks") || 0;
            // stacks++;
            // if (stacks >= 3) { // Every 3rd attack
            //     unit.setAttribute("BoaStacks", 0); // Reset stacks
            //     // Cooldown logic for charm application needs to be implemented.
            //     // This might involve setting a timestamp attribute on the unit.
            //     const statusName = unit.hasTag("ColdHeartedEmpress") ? "CharmBoaEvo" : "Charm";
            //     // const allEnemies = _G.Constructs; // How to get all enemy constructs?
            //     // for (const enemyConstruct of allEnemies) { // Iterate over actual enemy objects
            //     //     const distance = FastVector.FastMagnitudeVec3(unit.getInstance().PrimaryPart.Position, enemyConstruct.Position);
            //     //     if (distance <= unitRange) {
            //     //         const statusEffectDefinition = _G.Registry.registry.StatusEffects[statusName];
            //     //         // Prevent applying Charm if CharmBoaEvo is present and vice-versa
            //     //         if (statusName === "CharmBoaEvo" && enemyConstruct.StatusEffects["Charm"] === true) continue;
            //     //         if (statusName === "Charm" && enemyConstruct.StatusEffects["CharmBoaEvo"] === true) continue;
            //     //         if (statusEffectDefinition) {
            //     //             // statusEffectDefinition.OnServer(unit, [enemyConstruct], 10); // Apply status effect
            //     //         }
            //     //     }
            //     // }
            // } else {
            //     unit.setAttribute("BoaStacks", stacks);
            // }
        },
    },
};
