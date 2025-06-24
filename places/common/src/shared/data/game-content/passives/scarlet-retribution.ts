import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const ScarletRetribution: PassiveData = {
    name: "Scarlet Retribution",
    description: "if boss is on the map this unit does 50% more damage against the boss and applies stun (every 15th hit) (5s cooldown).",
    // hitsForStun: 15,
    // stunCooldownDuration: 5, // seconds for the cooldown of the stun ability
    // bossDamageBonusMultiplier: 1.5, // 50% more damage
    callbacks: {
        onServerTick: (unit: Unit, deltaTime: number) => {
            // TODO: Implement _G.Constructs to check for boss, attribute getting/setting.
            // let bossIsCurrentlyOnMap = false;
            // // for (const enemyId in _G.Constructs) { // Placeholder
            // //     if (_G.Constructs[enemyId].IsBoss) {
            // //         bossIsCurrentlyOnMap = true;
            // //         break;
            // //     }
            // // }
            // unit.setAttribute("BossOnMapForSR", bossIsCurrentlyOnMap); // SR for ScarletRetribution

            // const bossDmgBuffActive = unit.getAttribute("SRBossDmgActive");
            // if (bossIsCurrentlyOnMap && !bossDmgBuffActive) {
            //     unit.setAttribute("SRBossDmgActive", true);
            //     // This part of Luau "PermanentDmgToBossMulti" seems to be a flat +0.5, not *1.5.
            //     // Assuming it's an additive bonus to a base multiplier of 1 for bosses.
            //     // unit.setAttribute("PermanentDmgToBossMulti", (unit.getAttribute("PermanentDmgToBossMulti") || 0) + 0.5);
            // } else if (!bossIsCurrentlyOnMap && bossDmgBuffActive) {
            //     unit.setAttribute("SRBossDmgActive", false);
            //     // unit.setAttribute("PermanentDmgToBossMulti", (unit.getAttribute("PermanentDmgToBossMulti") || 0) - 0.5);
            // }
        },
        onAttack: (unit: Unit) => {
            // TODO: Implement attribute getting/setting, task.delay, ReplicatedStorage.GameVariables.GameSpeed.Value
            // const stunIsOnCooldown = unit.getAttribute("SRStunOnCooldown") || false;
            // const bossIsPresent = unit.getAttribute("BossOnMapForSR") || false;

            // unit.setAttribute("PassiveStun", false); // Default: don't stun

            // if (stunIsOnCooldown || !bossIsPresent) {
            //     return;
            // }

            // let attackCounter = unit.getAttribute("SRAttackCount") || 0;
            // attackCounter++;

            // if (attackCounter >= (ScarletRetribution.hitsForStun || 15)) {
            //     unit.setAttribute("SRAttackCount", 0);
            //     unit.setAttribute("SRStunOnCooldown", true);
            //     unit.setAttribute("PassiveStun", true); // Signal attack system to stun

            //     const gameSpeed = game.GetService("ReplicatedStorage").GameVariables.GameSpeed.Value || 1; // Placeholder
            //     // task.delay((ScarletRetribution.stunCooldownDuration || 5) / gameSpeed, () => { // Placeholder
            //     //     if (unit && unit.getInstance()?.Parent) {
            //     //         unit.setAttribute("SRStunOnCooldown", false);
            //     //     }
            //     // });
            // } else {
            //     unit.setAttribute("SRAttackCount", attackCounter);
            // }
        },
        onConditionalDamage: (unit: Unit, enemy: any) => {
            // TODO: Implement attribute getting, enemy.IsBoss check
            // const bossIsPresent = unit.getAttribute("BossOnMapForSR") || false;
            // if (enemy && enemy.Health > 0 && bossIsPresent && enemy.IsBoss) {
            //     return ScarletRetribution.bossDamageBonusMultiplier || 1.5;
            // }
            return 1;
        },
    },
};
