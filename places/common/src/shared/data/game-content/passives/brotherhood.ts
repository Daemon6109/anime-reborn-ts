import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const Brotherhood: PassiveData = {
    name: "Brotherhood",
    description: "Whenever Captain Yamo is within Osta's range - Osta gains +20% DMG and -5% SPA (non-stackable)",
    // targetAllyName: "Captain Yami", // Configuration specific to this passive
    callbacks: {
        onUnitsInRange: (unit: Unit) => {
            // TODO: Implement BuffLib, FastVector, workspace, and attribute equivalents
            // const BuffLib = require(replicated.Libs.BuffLib);
            // const FastVector = require(replicated.Libs.FastVector).new();
            // const unitRange = BuffLib.GetRangeScaled(unit);
            // const unitIndividualID = unit.getAttribute("IUUID");
            // const currentlyPlaced = workspace.UnitsPlaced.GetChildren();
            // let yamiInRange = false;
            // for (const unitToCheck of currentlyPlaced) {
            //     if (unitToCheck === unit || !unitToCheck.FindFirstChild("HumanoidRootPart")) {
            //         continue;
            //     }
            //     const isInRange = FastVector.FastMagnitudeVec3(unit.HumanoidRootPart.Position, unitToCheck.HumanoidRootPart.Position) <= unitRange;
            //     if (isInRange && unitToCheck.Name.includes(Brotherhood.targetAllyName)) { // string.match translates to includes or a regex
            //         yamiInRange = true;
            //         break;
            //     }
            // }
            // const brotherhoodBuff = unit.getAttribute("BrotherhoodBuff");
            // if (yamiInRange && !brotherhoodBuff) {
            //     unit.setAttribute("BrotherhoodBuff", true);
            //     unit.setAttribute("PermanentDamageMulti", unit.getAttribute("PermanentDamageMulti") + 0.2);
            //     unit.setAttribute("PermanentAttackSpeedMulti", unit.getAttribute("PermanentAttackSpeedMulti") - 0.05);
            // } else if (!yamiInRange && brotherhoodBuff) {
            //     unit.setAttribute("BrotherhoodBuff", false);
            //     unit.setAttribute("PermanentDamageMulti", unit.getAttribute("PermanentDamageMulti") - 0.2);
            //     unit.setAttribute("PermanentAttackSpeedMulti", unit.getAttribute("PermanentAttackSpeedMulti") + 0.05);
            // }
        },
    },
};
