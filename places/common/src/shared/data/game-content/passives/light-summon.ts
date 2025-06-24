import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

// TODO: Implement workspace, _G (AllyAPI, Registry), ReplicatedStorage (GameVariables), BuffLib, CountMultiPathPaths, deepCopy equivalents
// const IsMultipath = () => typeof workspace !== "undefined" && workspace.FindFirstChild("MultiPath");
// const CountMultiPathPaths = () => { /* ... see previous ... */ return 0; };
// const deepCopy = <T extends object>(original: T): T => { /* ... see previous ... */ return {} as T; };

export const LightSummon: PassiveData = {
    name: "Light mimicry", // Name in Luau is "Light mimicry"
    description: "When this unit eliminates an enemy, there's 35% chance to spawn a light servant with 80% of enemy health. (Caps health at x10 unit damage)",
    // summonName: "Light Servant",
    // spawnChance: 0.35,
    // healthPercentOfEnemy: 0.80,
    // healthCapMultiplierOfUnitDamage: 10,
    // spawnCooldown: 15, // Seconds
    callbacks: {
        onKill: (unit: Unit, killedEnemy: any) => {
            // TODO: Implement all dependencies mentioned above.
            // const BuffLib = require(replicated.Libs.BuffLib); // Placeholder
            // const GameVariables = game.GetService("ReplicatedStorage").GameVariables; // Placeholder
            // const AllMultiPath = GameVariables.GetAttribute("AllMultiPath");
            // const now = tick(); // Placeholder for current time
            // const lastSpawnTime = unit.getAttribute("LightSummonSpawnCD") || 0;

            // if (Math.random() < LightSummon.spawnChance && (now - lastSpawnTime) > LightSummon.spawnCooldown) {
            //     unit.setAttribute("LightSummonSpawnCD", now);

            //     const spawnClone = (pathNumber?: number) => {
            //         // const allyNPCConfig = _G.Registry.registry.AllyNPC[LightSummon.summonName]; // Placeholder
            //         // const template = _G.AllyAPI.buildAllyConfig( // Placeholder
            //         //     unit,
            //         //     LightSummon.summonName,
            //         //     deepCopy(allyNPCConfig),
            //         //     GameVariables.CurrentWave.Value,
            //         //     undefined,
            //         //     pathNumber
            //         // );

            //         // let servantHealth = (killedEnemy.MaxHealth || 1000) * LightSummon.healthPercentOfEnemy;
            //         // const maxHealthCap = BuffLib.GetDamage(unit) * LightSummon.healthCapMultiplierOfUnitDamage;
            //         // template.Health = Math.min(servantHealth, maxHealthCap);

            //         // _G.AllyAPI.SpawnAlly(template); // Placeholder
            //     };

            //     // const numPaths = AllMultiPath ? CountMultiPathPaths() : 1;
            //     // for (let i = 0; i < numPaths; i++) {
            //     //     spawnClone(AllMultiPath ? i + 1 : undefined);
            //     // }
            // }
        },
    },
};
