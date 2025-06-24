import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const LimitlessFuryII: PassiveData = {
    name: "Limitless Fury II",
    description: "Gohun’s attack power increases by 5% with each enemy defeated, up to 100%. The boost resets each wave, but once maxed, grants an extra +25% DMG for the rest of the game.",
    // maxTempStacks: 20,      // 100% / 5% = 20 kills for max temporary buff
    // percentPerTempStack: 0.05,
    // permanentBuffAtMax: 0.25, // Permanent buff is larger in version II
    callbacks: {
        onKill: (unit: Unit) => {
            // TODO: Implement attribute getting/setting
            // let tempStacks = unit.getAttribute("LimitlessFuryIITempStacks") || 0;
            // const permanentBuffApplied = unit.getAttribute("LimitlessFuryIIPermanentApplied") || false;
            // const currentTempDamageBonus = unit.getAttribute("LimitlessFuryIICurrentTempBonus") || 0;

            // if (tempStacks < LimitlessFuryII.maxTempStacks) {
            //     tempStacks++;
            //     unit.setAttribute("LimitlessFuryIITempStacks", tempStacks);

            //     const damageIncreaseThisKill = LimitlessFuryII.percentPerTempStack;
            //     unit.setAttribute("PermanentDamageMulti", (unit.getAttribute("PermanentDamageMulti") || 1) + damageIncreaseThisKill);
            //     unit.setAttribute("LimitlessFuryIICurrentTempBonus", currentTempDamageBonus + damageIncreaseThisKill);
            // }

            // if (tempStacks >= LimitlessFuryII.maxTempStacks && !permanentBuffApplied) {
            //     unit.setAttribute("LimitlessFuryIIPermanentApplied", true);
            //     unit.setAttribute("PermanentDamageMulti", (unit.getAttribute("PermanentDamageMulti") || 1) + LimitlessFuryII.permanentBuffAtMax);
            // }
        },
        onWave: (unit: Unit) => {
            // TODO: Implement attribute getting/setting
            // const currentTempDamageBonus = unit.getAttribute("LimitlessFuryIICurrentTempBonus") || 0;
            // if (currentTempDamageBonus > 0) {
            //     unit.setAttribute("PermanentDamageMulti", (unit.getAttribute("PermanentDamageMulti") || 1) - currentTempDamageBonus);
            // }
            // unit.setAttribute("LimitlessFuryIITempStacks", 0);
            // unit.setAttribute("LimitlessFuryIICurrentTempBonus", 0);
        },
    },
};
