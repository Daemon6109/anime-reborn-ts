import { Unit } from "shared/components/unit";
import { Passive, PassiveData } from "../passive";

export const AbsolutePerfection: PassiveData = {
    name: "Absolute Perfection",
    description: "If no allies are in his range this unit gains 20% damage and 10% range.",
    callbacks: {
        onUnitsInRange: (unit: Unit) => {
            // TODO: Implement BuffLib, FastVector, and workspace equivalents
            // const BuffLib = require(replicated.Libs.BuffLib);
            // const FastVector = require(replicated.Libs.FastVector).new();
            // const unitRange = BuffLib.GetRangeScaled(unit);
            // const unitIndividualID = unit.getAttribute("IUUID");
            // const currentlyPlaced = workspace.UnitsPlaced.GetChildren();
            // let buffed = unit.getAttribute("BuffedUnitSelf") || false;
            // const buffedUnits = [];
            // for (const unitToCheck of currentlyPlaced) {
            //     if (unitToCheck === unit || !unitToCheck.FindFirstChild("HumanoidRootPart")) {
            //         continue;
            //     }
            //     const isInRange = FastVector.FastMagnitudeVec3(unit.HumanoidRootPart.Position, unitToCheck.HumanoidRootPart.Position) <= unitRange;
            //     if (isInRange) {
            //         buffedUnits.push(unitToCheck);
            //     }
            // }
            // if (buffedUnits.length >= 1) {
            //     if (buffed) {
            //         unit.setAttribute("BuffedUnitSelf", false);
            //         unit.setAttribute("PermanentDamageMulti", unit.getAttribute("PermanentDamageMulti") - 0.2);
            //         unit.setAttribute("PermanentRangeMulti", unit.getAttribute("PermanentRangeMulti") - 0.1);
            //     }
            // } else {
            //     if (!buffed) {
            //         unit.setAttribute("BuffedUnitSelf", true);
            //         unit.setAttribute("PermanentDamageMulti", unit.getAttribute("PermanentDamageMulti") + 0.2);
            //         unit.setAttribute("PermanentRangeMulti", unit.getAttribute("PermanentRangeMulti") + 0.1);
            //     }
            // }
        },
        onRemove: (unit: Unit) => {
            // Implementation here
        },
    },
};
