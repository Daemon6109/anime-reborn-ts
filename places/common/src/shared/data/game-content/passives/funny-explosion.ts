import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const FunnyExplosion: PassiveData = {
    name: "Funny Explosion",
    description: "Every 3 eliminations, applies stun to nearby enemies",
    // killsNeededForProc: 3,
    // explosionRadius: 30, // From Luau code
    // stunDuration: 5,    // From Luau code
    callbacks: {
        onKill: (unit: Unit, killedEnemy: any) => { // unit is the one with the passive
            // TODO: Implement attribute getting/setting, FastVector, _G.Constructs, _G.Registry (StatusEffects), ReplicatedStorage.Events.VisualEffects
            // let kills = unit.getAttribute("FunnyExplosionKills") || 0;
            // kills++;

            // if (kills >= (FunnyExplosion.killsNeededForProc || 3)) {
            //     unit.setAttribute("FunnyExplosionKills", 0); // Reset kill counter

            //     const FastVector = require(replicated.Libs.FastVector).new(); // Placeholder
            //     const explosionCenter = killedEnemy.Position; // Explosion is around the killed enemy

            //     // for (const enemyId in _G.Constructs) { // Placeholder for iterating global enemies
            //     //     const enemyConstruct = _G.Constructs[enemyId];
            //     //     if (enemyConstruct && enemyConstruct.Position) {
            //     //         const distance = FastVector.FastMagnitudeVec3(explosionCenter, enemyConstruct.Position);
            //     //         if (distance <= (FunnyExplosion.explosionRadius || 30)) {
            //     //             const StatusEffect = _G.Registry.registry.StatusEffects["Stun"]; // Placeholder
            //     //             if (StatusEffect) {
            //     //                 StatusEffect.OnServer(unit, [enemyConstruct], FunnyExplosion.stunDuration || 5);
            //     //             }
            //     //         }
            //     //     }
            //     // }

            //     // Visual effect: game.ReplicatedStorage.Events.VisualEffects:FireAllClients("DirectPassiveRun", script.Passive, nil, nil, nil, {Unit, Unit.HumanoidRootPart, Enemy.EnemyID})
            //     // This needs a client-server event system. The `script.Passive` part refers to the Luau script instance itself,
            //     // which might be used to locate client-side effect scripts or assets.
            //     // ReplicatedStorage.ClientEvents.playPassiveVisualEffect.fireAll({ passiveName: "FunnyExplosion", sourceUnit: unit, targetEnemyId: killedEnemy.EnemyID }); // Conceptual
            // } else {
            //     unit.setAttribute("FunnyExplosionKills", kills);
            // }
        },
    },
};
// Note: The `FunnyExplosion/Passive/init.luau` seems to be where the client-side visual effect script would be,
// based on the `script.Passive` reference in the server script.
