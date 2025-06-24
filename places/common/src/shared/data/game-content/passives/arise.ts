import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

// TODO: Implement workspace, _G, ReplicatedStorage, task.spawn, task.wait, BuffLib equivalents
// const IsMultipath = workspace.FindFirstChild("MultiPath");
// const PathRoot = IsMultipath ? workspace.FindFirstChild("MultiPath") : workspace.FindFirstChild("Path");
// const MultipathPaths = IsMultipath ? IsMultipath.GetChildren() : undefined;

// const countMultiPathPaths = () => {
//     let x = 0;
//     if (MultipathPaths) {
//         for (const v of MultipathPaths) {
//             if (string.find(v.Name, "Ally")[0]) {
//                 continue;
//             }
//             if (!v.GetAttribute("Locked")) {
//                 x += 1;
//             }
//         }
//     }
//     return x;
// };

// const deepCopy = <T extends object>(original: T): T => {
//     const copy = {} as T;
//     for (const [k, v] of pairs(original)) {
//         if (typeIs(v, "table")) {
//             copy[k as keyof T] = deepCopy(v as unknown as object) as any;
//         } else {
//             copy[k as keyof T] = v;
//         }
//     }
//     return copy;
// };

export const Arise: PassiveData = {
    name: "Arise",
    description: "For every 10 kills he gets, he summons a shadow of the fallen enemy with the hp of 40% of the damage, If it's a boss it'll resummon with 30% of its previous hp.",
    // summonName: "Shadow Knight", // Configuration specific to this passive
    // summonDelay: 0.5, // Configuration specific to this passive
    // killsToSummon: 10, // Configuration specific to this passive
    // maximumSummons: 10, // Configuration specific to this passive
    callbacks: {
        onKill: (unit: Unit, enemy: any) => {
            // task.spawn(() => {
            //     killCounter = killCounter + 1;
            //     if (killCounter % Arise.killsToSummon === 0) {
            //         // IsMultipath = workspace.FindFirstChild("MultiPath");
            //         // PathRoot = IsMultipath ? workspace.FindFirstChild("MultiPath") : workspace.FindFirstChild("Path");
            //         // MultipathPaths = IsMultipath ? IsMultipath.GetChildren() : undefined;
            //         // const BuffLib = require(replicated.Libs.BuffLib);
            //         // const damage = BuffLib.GetDamage(unit);
            //         // let hp = damage * 0.4;
            //         // if (enemy.IsBoss) {
            //         //     hp = enemy.MaxHealth * 0.3;
            //         // }
            //         // const blackHeartStacks = unit.getAttribute("BlackHeartStacks");
            //         // if (blackHeartStacks) {
            //         //     hp = hp * (1 + 0.013 * blackHeartStacks);
            //         // }
            //         // let chosenPathNumber: number | undefined = undefined;
            //         // if (AllMultiPath) {
            //         //     const pathsCount = countMultiPathPaths();
            //         //     if (pathsCount > 0) {
            //         //         chosenPathNumber = math.random(1, pathsCount);
            //         //     }
            //         // }
            //         // summonQueue.push({ unit, pathNumber: chosenPathNumber, hp });
            //         // processSummonQueue();
            //     }
            // });
        },
    },
};

// let killCounter = 0;
// const summonQueue: { unit: Unit; pathNumber?: number; hp: number }[] = [];
// let isProcessingQueue = false;

// const getSummonCap = () => {
//     // return IsMultipath ? Arise.maximumSummons * countMultiPathPaths() : Arise.maximumSummons;
// };

// const AllMultiPath = game.GetService("ReplicatedStorage").GameVariables.GetAttribute("AllMultiPath");
// let currentlySpawned = 0;

// const spawnClone = (unit: Unit, pathNumber: number | undefined, hp: number) => {
//     // if (currentlySpawned < getSummonCap()) {
//     //     currentlySpawned += 1;
//     //     _G.AllyAPI.SpawnAlly(
//     //         _G.AllyAPI.buildAllyConfig(
//     //             unit,
//     //             Arise.summonName,
//     //             deepCopy(_G.Registry.registry.AllyNPC[Arise.summonName]),
//     //             game.GetService("ReplicatedStorage").GameVariables.CurrentWave.Value,
//     //             undefined,
//     //             pathNumber,
//     //             hp,
//     //         ),
//     //         () => {
//     //             currentlySpawned -= 1;
//     //         },
//     //     );
//     // }
// };

// const processSummonQueue = () => {
//     // if (isProcessingQueue) return;
//     // isProcessingQueue = true;
//     // while (summonQueue.length > 0) {
//     //     const summonData = summonQueue.shift();
//     //     if (summonData) {
            // spawnClone(summonData.unit, summonData.pathNumber, summonData.hp);
    //      }
//     //     task.wait(Arise.summonDelay / game.GetService("ReplicatedStorage").GameVariables.GameSpeed.Value);
//     // }
//     // isProcessingQueue = false;
// };
