import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

// TODO: Implement workspace, _G (AllyAPI, Registry), ReplicatedStorage (GameVariables), CountMultiPathPaths, deepCopy equivalents
// const IsMultipath = () => typeof workspace !== "undefined" && workspace.FindFirstChild("MultiPath");
// const CountMultiPathPaths = () => { /* ... see previous ... */ return 0; };
// const deepCopy = <T extends object>(original: T): T => { /* ... see previous ... */ return {} as T; };

export const SubmissionLock: PassiveData = {
    name: "Submission Lock",
    description: "On every 15th attack robin summons a tornado, `Stuns` everyone hit for 2.5 seconds Immobilized enemies take 15% more damage while having that status effect",
    // attacksNeededForTornado: 15, // Description value
    // summonName: "Tornado",
    // stunDuration: 2.5,
    // damageBonusVsImmobilized: 1.15,
    callbacks: {
        onAttack: (unit: Unit) => { // unit is Robin
            // TODO: Implement attribute getting/setting
            // unit.setAttribute("PassiveStun", false);
            // let attackCount = unit.getAttribute("SubmissionLockAttackCountSL") || 0; // SL for SubmissionLock
            // attackCount++;

            // // Luau: if PassiveStacks >= 1. Using description's 15th attack.
            // if (attackCount >= (SubmissionLock.attacksNeededForTornado || 15)) {
            //     unit.setAttribute("SubmissionLockAttackCountSL", 0);
            //     unit.setAttribute("PassiveStun", true); // For the tornado's stun effect
            //     unit.setAttribute("CanSummonTornadoSL", true);
            // } else {
            //     unit.setAttribute("SubmissionLockAttackCountSL", attackCount);
            // }
        },
        onPlace: (unit: Unit) => {
            // TODO: Implement all dependencies for the continuous tornado summoning.
            // task.spawn(async () => { // Placeholder
            //     const GameVariables = game.GetService("ReplicatedStorage").GameVariables; // Placeholder
            //     const AllMultiPath = GameVariables.GetAttribute("AllMultiPath");

            //     while (unit && unit.getInstance()?.Parent) {
            //         // await task.wait(1 / GameVariables.GameSpeed.Value); // Luau checks every tick.
            //         if (!(unit && unit.getInstance()?.Parent)) break;

            //         if (unit.getAttribute("CanSummonTornadoSL") === true) {
            //             unit.setAttribute("CanSummonTornadoSL", false);

            //             const spawnClone = (pathNumber?: number) => {
            //                 // const allyNPCConfig = _G.Registry.registry.AllyNPC[SubmissionLock.summonName || "Tornado"];
            //                 // const config = _G.AllyAPI.buildAllyConfig(unit, SubmissionLock.summonName || "Tornado", deepCopy(allyNPCConfig), GameVariables.CurrentWave.Value, undefined, pathNumber);
            //                 // _G.AllyAPI.SpawnAlly(config, GameVariables.CurrentWave.Value);
            //             };
            //             // const numPaths = AllMultiPath ? CountMultiPathPaths() : 1;
            //             // for (let i = 0; i < numPaths; i++) { spawnClone(AllMultiPath ? i + 1 : undefined); }
            //         }
            //     }
            // });
        },
        // onConditionalDamage: (unit: Unit, enemy: any) => {
        //     // TODO: Check if enemy is immobilized (e.g., has "Stun" or a specific "TornadoStun" status)
        //     // if (enemy.hasStatus("Stun") || enemy.hasStatus("Immobilized")) {
        //     //     return SubmissionLock.damageBonusVsImmobilized || 1.15;
        //     // }
        //     return 1;
        // }
    },
};
