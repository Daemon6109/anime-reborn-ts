import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const ChainLightning: PassiveData = {
    name: "Chain Lightning",
    description: "If other units are stunned inside Lucky's range, Lucky gets +5% DMG and +5% RNG, up to +25% increase.",
    // maxPassiveStacks: 5, // Configuration specific to this passive
    // percentPerStack: 0.05, // Configuration specific to this passive
    callbacks: {
        onAllyStunned: (unit: Unit, ally: Unit) => {
            // TODO: Implement attribute getting/setting, BuffLib, FastVector equivalents
            // let stacks = unit.getAttribute("ChainLightningStacks") || 0;
            // const BuffLib = require(replicated.Libs.BuffLib); // Placeholder
            // const FastVector = require(replicated.Libs.FastVector).new(); // Placeholder
            // const unitRange = BuffLib.GetRangeScaled(unit);
            // const isInRange = FastVector.FastMagnitudeVec3(unit.getInstance().PrimaryPart.Position, ally.getInstance().PrimaryPart.Position) <= unitRange; // Assuming unit has getInstance() and PrimaryPart
            // if (stacks < ChainLightning.maxPassiveStacks && isInRange) {
            //     stacks++;
            //     unit.setAttribute("ChainLightningStacks", stacks);
            //     unit.setAttribute("PermanentDamageMulti", (unit.getAttribute("PermanentDamageMulti") || 1) + ChainLightning.percentPerStack);
            //     unit.setAttribute("PermanentRangeMulti", (unit.getAttribute("PermanentRangeMulti") || 1) + ChainLightning.percentPerStack);
            // }
        },
        onAllyStunEnded: (unit: Unit, ally: Unit) => {
            // TODO: Implement attribute getting/setting, BuffLib, FastVector equivalents
            // let stacks = unit.getAttribute("ChainLightningStacks") || 0;
            // const BuffLib = require(replicated.Libs.BuffLib); // Placeholder
            // const FastVector = require(replicated.Libs.FastVector).new(); // Placeholder
            // const unitRange = BuffLib.GetRangeScaled(unit);
            // const isInRange = FastVector.FastMagnitudeVec3(unit.getInstance().PrimaryPart.Position, ally.getInstance().PrimaryPart.Position) <= unitRange;
            // if (stacks > 0 && isInRange) { // Check stacks > 0 before decrementing
            //     stacks--;
            //     unit.setAttribute("ChainLightningStacks", stacks);
            //     unit.setAttribute("PermanentDamageMulti", (unit.getAttribute("PermanentDamageMulti") || 1) - ChainLightning.percentPerStack);
            //     unit.setAttribute("PermanentRangeMulti", (unit.getAttribute("PermanentRangeMulti") || 1) - ChainLightning.percentPerStack);
            // }
        },
    },
};
