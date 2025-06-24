import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

// TODO: Implement workspace, _G (AllyAPI, Registry), ReplicatedStorage (GameVariables), task.spawn, task.wait, deepCopy, CountMultiPathPaths equivalents
// const IsMultipath = () => typeof workspace !== "undefined" && workspace.FindFirstChild("MultiPath");
// const CountMultiPathPaths = () => {
//     let x = 0;
//     const multipathInstance = typeof workspace !== "undefined" ? workspace.FindFirstChild("MultiPath") : undefined;
//     if (multipathInstance) {
//         const paths = multipathInstance.GetChildren();
//         for (const v of paths) {
//             if (v.Name.includes("Ally")) continue;
//             if (!v.GetAttribute("Locked")) {
//                 x++;
//             }
//         }
//     }
//     return x;
// };

// const deepCopy = <T extends object>(original: T): T => { /* ... see previous implementations ... */ return {} as T; };

export const CrystalLord: PassiveData = {
    name: "Crystal Lord",
    description: "Summons Crystal Servants each 10 seconds, up to 15 Servants at the same time. On multipath maps the cap is: Limit x Path Count.",
    // summonName: "Crystal Servant", // Configuration specific to this passive
    // maximumSummons: 15, // Configuration specific to this passive
    callbacks: {
        onPlace: (unit: Unit) => {
            // task.spawn(async () => { // Assuming async nature
            //     const GameVariables = game.GetService("ReplicatedStorage").GameVariables; // Placeholder
            //     const AllMultiPath = GameVariables.GetAttribute("AllMultiPath");
            //     let currentlySpawned = 0;
            //     const getSummonCap = () => {
            //         return IsMultipath() ? CrystalLord.maximumSummons * CountMultiPathPaths() : CrystalLord.maximumSummons;
            //     };
            //     const spawnClone = async (pathNumber?: number) => {
            //         while (currentlySpawned >= getSummonCap()) {
            //             // await task.wait(1); // Placeholder for async wait
            //         }
            //         currentlySpawned++;
            //         // const allyConfig = _G.AllyAPI.buildAllyConfig(
            //         //     unit,
            //         //     CrystalLord.summonName,
            //         //     deepCopy(_G.Registry.registry.AllyNPC[CrystalLord.summonName]),
            //         //     GameVariables.CurrentWave.Value,
            //         //     undefined,
            //         //     pathNumber
            //         // );
            //         // _G.AllyAPI.SpawnAlly(allyConfig, () => {
            //         //     currentlySpawned--;
            //         // });
            //     };
            //     const initialPathCount = CountMultiPathPaths();
            //     if (AllMultiPath) {
            //         for (let pn = 1; pn <= initialPathCount; pn++) {
            //             spawnClone(pn);
            //         }
            //     } else {
            //         spawnClone();
            //     }
            //     while (unit && unit.getInstance().Parent) { // Check if unit still exists
            //         // await task.wait(10 / GameVariables.GameSpeed.Value); // Placeholder
            //         if (!unit || !unit.getInstance().Parent) break;
            //         const currentPathCount = CountMultiPathPaths(); // Recalculate in case paths change
            //         if (AllMultiPath) {
            //             for (let pn = 1; pn <= currentPathCount; pn++) {
            //                 spawnClone(pn);
            //             }
            //         } else {
            //             spawnClone();
            //         }
            //     }
            // });
        },
    },
};
