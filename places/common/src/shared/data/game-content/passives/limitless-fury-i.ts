import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const LimitlessFuryI: PassiveData = {
    name: "Limitless Fury I",
    description: "Gohun’s attack power increases by 5% with each enemy defeated, up to 100%. The boost resets each wave, but once maxed, grants an extra +10% DMG for the rest of the game.",
    // maxTempStacks: 20,      // 100% / 5% = 20 kills for max temporary buff
    // percentPerTempStack: 0.05,
    // permanentBuffAtMax: 0.10,
    callbacks: {
        onKill: (unit: Unit) => {
            // TODO: Implement attribute getting/setting
            // let tempStacks = unit.getAttribute("LimitlessFuryITempStacks") || 0;
            // const permanentBuffApplied = unit.getAttribute("LimitlessFuryIPermanentApplied") || false;
            // const currentTempDamageBonus = unit.getAttribute("LimitlessFuryICurrentTempBonus") || 0;

            // if (tempStacks < LimitlessFuryI.maxTempStacks) {
            //     tempStacks++;
            //     unit.setAttribute("LimitlessFuryITempStacks", tempStacks);

            //     const damageIncreaseThisKill = LimitlessFuryI.percentPerTempStack;
            //     unit.setAttribute("PermanentDamageMulti", (unit.getAttribute("PermanentDamageMulti") || 1) + damageIncreaseThisKill);
            //     unit.setAttribute("LimitlessFuryICurrentTempBonus", currentTempDamageBonus + damageIncreaseThisKill);
            // }

            // // Check after stacking if max is reached for permanent buff
            // if (tempStacks >= LimitlessFuryI.maxTempStacks && !permanentBuffApplied) {
            //     unit.setAttribute("LimitlessFuryIPermanentApplied", true);
            //     unit.setAttribute("PermanentDamageMulti", (unit.getAttribute("PermanentDamageMulti") || 1) + LimitlessFuryI.permanentBuffAtMax);
            // }
        },
        onWave: (unit: Unit) => {
            // TODO: Implement attribute getting/setting
            // const currentTempDamageBonus = unit.getAttribute("LimitlessFuryICurrentTempBonus") || 0;
            // if (currentTempDamageBonus > 0) {
            //     // Remove the temporary damage bonus accumulated during the wave
            //     unit.setAttribute("PermanentDamageMulti", (unit.getAttribute("PermanentDamageMulti") || 1) - currentTempDamageBonus);
            // }
            // unit.setAttribute("LimitlessFuryITempStacks", 0); // Reset temporary stack counter for the new wave
            // unit.setAttribute("LimitlessFuryICurrentTempBonus", 0);
            // // The permanent buff (LimitlessFuryIPermanentApplied) remains if it was triggered.
        },
    },
};
