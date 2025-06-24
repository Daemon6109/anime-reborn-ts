import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const ShrimpBoxingI: PassiveData = {
    name: "Shrimp Boxing I",
    description: "Every 5th attack deals a 40% critical chance hit dealing +75% more critical damage",
    // hitsNeeded: 5,
    // tagNameForBuff: "ShrimpBoxingActiveI", // Unique tag for this version
    // critChanceBonus: 0.40,
    // critDamageBonus: 0.75,
    callbacks: {
        onAttack: (unit: Unit) => {
            // TODO: Implement attribute getting/setting, tag manipulation
            // This is called before the attack calculation.
            // It sets up buffs for the current attack if conditions are met.
            // let attackCount = unit.getAttribute("ShrimpBoxingIAttackCount") || 0;
            // attackCount++;

            // if (attackCount >= (ShrimpBoxingI.hitsNeeded || 5)) {
            //     unit.setAttribute("ShrimpBoxingIAttackCount", 0);
            //     unit.addTag(ShrimpBoxingI.tagNameForBuff || "ShrimpBoxingActiveI");
            //     // These are temporary buffs for this specific hit
            //     unit.setAttribute("TemporaryCritChanceBonus", (unit.getAttribute("TemporaryCritChanceBonus") || 0) + (ShrimpBoxingI.critChanceBonus || 0.40));
            //     unit.setAttribute("TemporaryCritDamageBonus", (unit.getAttribute("TemporaryCritDamageBonus") || 0) + (ShrimpBoxingI.critDamageBonus || 0.75));
            // } else {
            //     unit.setAttribute("ShrimpBoxingIAttackCount", attackCount);
            // }
        },
        onAttackEnded: (unit: Unit) => {
            // TODO: Implement attribute getting/setting, tag manipulation
            // This is called after the attack has resolved.
            // if (unit.hasTag(ShrimpBoxingI.tagNameForBuff || "ShrimpBoxingActiveI")) {
            //     unit.removeTag(ShrimpBoxingI.tagNameForBuff || "ShrimpBoxingActiveI");
            //     // Revert temporary buffs
            //     unit.setAttribute("TemporaryCritChanceBonus", (unit.getAttribute("TemporaryCritChanceBonus") || 0) - (ShrimpBoxingI.critChanceBonus || 0.40));
            //     unit.setAttribute("TemporaryCritDamageBonus", (unit.getAttribute("TemporaryCritDamageBonus") || 0) - (ShrimpBoxingI.critDamageBonus || 0.75));
            // }
            // Luau directly modifies PermanentAttackCriticalChance/Damage. A temporary system is safer.
        },
    },
};
