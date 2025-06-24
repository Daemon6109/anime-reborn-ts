import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const SaiyansPride: PassiveData = {
    name: "Saiyans Pride",
    description: "Each attack against boss enemy infuriates him, increasing his dmg by 0.2% up to 30% and resets on kill. (unlocks on max transformation)",
    // damageIncreasePerHitOnBoss: 0.02, // Luau uses 0.02 (2%), not 0.002 (0.2%)
    // maxDamageIncrease: 0.30,
    callbacks: {
        onConditionalDamage: (unit: Unit, enemy: any) => {
            // TODO: Implement attribute getting/setting, enemy.IsBoss check.
            // TODO: Check "SecondPassiveUnlocked" attribute from SaiyanPrince passive.
            // const isUnlocked = unit.getAttribute("SecondPassiveUnlocked");
            // if (!isUnlocked) return 1;

            // if (enemy && enemy.Health > 0 && enemy.IsBoss) {
            //     let currentDamageBonus = unit.getAttribute("SaiyansPrideDmgBonusSP") || 0; // SP for SaiyansPride
            //     const actualDmgIncreasePerHit = SaiyansPride.damageIncreasePerHitOnBoss || 0.02;
            //     const maxBonus = SaiyansPride.maxDamageIncrease || 0.30;

            //     if (currentDamageBonus < maxBonus) {
            //         const newBonusAmount = Math.min(currentDamageBonus + actualDmgIncreasePerHit, maxBonus);
            //         const diffToApply = newBonusAmount - currentDamageBonus;

            //         // unit.setAttribute("PermanentDamageMulti", (unit.getAttribute("PermanentDamageMulti") || 1) + diffToApply);
            //         // unit.setAttribute("SaiyansPrideDmgBonusSP", newBonusAmount);
            //     }
            // }
            return 1; // Luau logic applies buff for future hits, doesn't modify current hit damage here.
        },
        onAnyKill: (unit: Unit, killer: Unit, killedEnemy: any) => {
            // TODO: Implement attribute getting/setting, enemy.IsBoss check.
            // const isUnlocked = unit.getAttribute("SecondPassiveUnlocked");
            // if (!isUnlocked) return;

            // if (killedEnemy && killedEnemy.IsBoss) { // Resets if a boss is killed
            //     const currentDamageBonus = unit.getAttribute("SaiyansPrideDmgBonusSP") || 0;
            //     if (currentDamageBonus > 0) {
            //         // unit.setAttribute("PermanentDamageMulti", (unit.getAttribute("PermanentDamageMulti") || 1) - currentDamageBonus);
            //         // unit.setAttribute("SaiyansPrideDmgBonusSP", 0);
            //     }
            // }
        },
    },
};
