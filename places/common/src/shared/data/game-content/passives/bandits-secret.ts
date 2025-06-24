import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const BanditsSecret: PassiveData = {
    name: "Bandit’s Secret",
    description: "For every unit in his range Chrollo gains +3% Damage up to 15%, but if there is more than 5 units in his range he loses the buff.",
    callbacks: {
        onUnitsInRange: (unit: Unit) => {
            // TODO: Implement BuffLib, FastVector, workspace, and attribute equivalents
            // const BuffLib = require(replicated.Libs.BuffLib);
            // const FastVector = require(replicated.Libs.FastVector).new();
            // const unitRange = BuffLib.GetRangeScaled(unit);
            // const unitIndividualID = unit.getAttribute("IUUID");
            // const currentlyPlaced = workspace.UnitsPlaced.GetChildren();
            // let buffAmount = unit.getAttribute("gYBuffIncrease") || 0;
            // const lastBuffAmount = unit.getAttribute("GVYBuffIncrease") || 0;
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
            // if (buffedUnits.length <= 5) {
            //     unit.setAttribute("gYBuffIncrease", buffedUnits.length * 3);
            //     buffAmount = unit.getAttribute("gYBuffIncrease");
            //     if (lastBuffAmount < buffAmount) {
            //         const amount = buffAmount - lastBuffAmount;
            //         unit.setAttribute("PermanentDamageMulti", unit.getAttribute("PermanentDamageMulti") + amount / 100);
            //     } else if (lastBuffAmount > buffAmount) {
            //         const amount = lastBuffAmount - buffAmount;
            //         unit.setAttribute("PermanentDamageMulti", unit.getAttribute("PermanentDamageMulti") - amount / 100);
            //     }
            //     unit.setAttribute("GVYBuffIncrease", buffAmount);
            // } else if (buffedUnits.length > 5) {
            //     unit.setAttribute("gYBuffIncrease", 0);
            //     unit.setAttribute("PermanentDamageMulti", unit.getAttribute("PermanentDamageMulti") - lastBuffAmount / 100);
            //     unit.setAttribute("GVYBuffIncrease", 0);
            // }
        },
        onRemove: (unit: Unit) => {
            // Implementation here
        },
    },
};
