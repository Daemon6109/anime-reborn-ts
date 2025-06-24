import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const ShrimpBoxingII: PassiveData = {
    name: "Shrimp Boxing II",
    description: "Every 5th attack deals a 40% critical chance hit dealing +125% more critical damage",
    // hitsNeeded: 5,
    // tagNameForBuff: "ShrimpBoxingActiveII", // Unique tag for this version
    // critChanceBonus: 0.40,
    // critDamageBonus: 1.25, // Increased crit damage for version II
    callbacks: {
        onAttack: (unit: Unit) => {
            // TODO: Implement attribute getting/setting, tag manipulation
            // let attackCount = unit.getAttribute("ShrimpBoxingIIAttackCount") || 0;
            // attackCount++;

            // if (attackCount >= (ShrimpBoxingII.hitsNeeded || 5)) {
            //     unit.setAttribute("ShrimpBoxingIIAttackCount", 0);
            //     unit.addTag(ShrimpBoxingII.tagNameForBuff || "ShrimpBoxingActiveII");
            //     // unit.setAttribute("TemporaryCritChanceBonus", (unit.getAttribute("TemporaryCritChanceBonus") || 0) + (ShrimpBoxingII.critChanceBonus || 0.40));
            //     // unit.setAttribute("TemporaryCritDamageBonus", (unit.getAttribute("TemporaryCritDamageBonus") || 0) + (ShrimpBoxingII.critDamageBonus || 1.25));
            // } else {
            //     unit.setAttribute("ShrimpBoxingIIAttackCount", attackCount);
            // }
        },
        onAttackEnded: (unit: Unit) => {
            // TODO: Implement attribute getting/setting, tag manipulation
            // if (unit.hasTag(ShrimpBoxingII.tagNameForBuff || "ShrimpBoxingActiveII")) {
            //     unit.removeTag(ShrimpBoxingII.tagNameForBuff || "ShrimpBoxingActiveII");
            //     // unit.setAttribute("TemporaryCritChanceBonus", (unit.getAttribute("TemporaryCritChanceBonus") || 0) - (ShrimpBoxingII.critChanceBonus || 0.40));
            //     // unit.setAttribute("TemporaryCritDamageBonus", (unit.getAttribute("TemporaryCritDamageBonus") || 0) - (ShrimpBoxingII.critDamageBonus || 1.25));
            // }
        },
    },
};
