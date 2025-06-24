import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const IceSpears: PassiveData = {
    name: "Ice Spears",
    description: "This unit damages enemy every 5th hit, dealing 150% of current damage and freezes the enemy for 5s",
    callbacks: {
        onAttack: (unit: Unit) => {
            // TODO: Implement attribute getting/setting, BuffLib, FastVector, _G.Constructs, _G.Registry (StatusEffects),
            // TODO: ReplicatedStorage.Events.VisualEffects, ReplicatedStorage.GameVariables.GameSpeed.Value, _G.EnemyAPI.DamageEnemy, task.delay
            // This is a complex onAttack that triggers an AOE damage and freeze on the 5th hit.

            // let spearStacks = unit.getAttribute("SpearStack") || 0;
            // spearStacks++;
            // unit.setAttribute("SpearStack", spearStacks);

            // if (spearStacks >= 5) {
            //     unit.setAttribute("SpearStack", 0); // Reset stack

            //     const gameSpeed = game.GetService("ReplicatedStorage").GameVariables.GameSpeed.Value || 1; // Placeholder
            //     // task.delay(0.33 / gameSpeed, async () => { // Placeholder for async delay
            //     //     if (!(unit && unit.getInstance() && unit.getInstance().Parent)) return;

            //     //     const BuffLib = require(replicated.Libs.BuffLib); // Placeholder
            //     //     const FastVector = require(replicated.Libs.FastVector).new(); // Placeholder
            //     //     const unitRange = BuffLib.GetRangeScaled(unit); // Or is it a fixed AOE range?
            //     //     const damageToDeal = BuffLib.GetDamage(unit) * 1.5;
            //     //     const statusEffectToApply = _G.Registry.registry.StatusEffects["Frozen"]; // Placeholder
            //     //     const enemyIdsHit: string[] = [];

            //     //     // for (const enemyId in _G.Constructs) { // Placeholder for iterating global enemies
            //     //     //     const enemyConstruct = _G.Constructs[enemyId];
            //     //     //     if (enemyConstruct && enemyConstruct.Position) {
            //     //     //         const distance = FastVector.FastMagnitudeVec3(unit.getInstance().PrimaryPart.Position, enemyConstruct.Position);
            //     //     //         if (distance <= unitRange) { // Check if target is in unit's range or a specific AOE range
            //     //     //             // Visual effect for spear hitting this enemy
            //     //     //             // game.GetService("ReplicatedStorage").Events.VisualEffects.FireAllClients("DirectPassiveRun", script["Ice Trident"], null, null, null, {Unit, Unit.HumanoidRootPart, enemyConstruct.EnemyID}); // Placeholder
            //     //     //             if (statusEffectToApply) {
            //     //     //                 // statusEffectToApply.OnServer(unit, [enemyConstruct], 5); // Apply Frozen for 5s
            //     //     //             }
            //     //     //             // _G.EnemyAPI.DamageEnemy(enemyConstruct.EnemyID, damageToDeal, game.HttpService.GenerateGUID(false), unit); // Placeholder
            //     //     //             enemyIdsHit.push(enemyConstruct.EnemyID);
            //     //     //         }
            //     //     //     }
            //     //     // }

            //     //     // await task.wait(0.33 / gameSpeed); // Placeholder for async wait
            //     //     // Visual effect for direct damage after hits
            //     //     // game.GetService("ReplicatedStorage").Events.VisualEffects.FireAllClients("PassiveDirectDamage", null, null, Unit, enemyIdsHit, damageToDeal); // Placeholder
            //     // });
            // }
        },
    },
};
