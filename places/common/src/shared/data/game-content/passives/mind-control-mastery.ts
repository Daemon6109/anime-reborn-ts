import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

// TODO: Implement workspace, _G (AllyAPI, Registry), ReplicatedStorage (GameVariables), BuffLib, CountMultiPathPaths, deepCopy equivalents
// const IsMultipath = () => typeof workspace !== "undefined" && workspace.FindFirstChild("MultiPath");
// const CountMultiPathPaths = () => { /* ... see previous ... */ return 0; };
// const deepCopy = <T extends object>(original: T): T => { /* ... see previous ... */ return {} as T; };

export const MindControlMastery: PassiveData = {
    name: "Mind Control Mastery",
    description: "When this unit eliminates, there's 35% chance to summon (50% if the enemy has Needle), with 25% of enemy health. (Caps health at x10 unit damage)",
    // summonName: "Light Servant", // Luau uses "Light Servant", description is generic.
    // baseSpawnChance: 0.35,
    // needleSpawnChance: 0.50,
    // healthPercentOfEnemy: 0.25,
    // healthCapMultiplierOfUnitDamage: 10,
    // spawnCooldown: 15, // Seconds
    callbacks: {
        onKill: (unit: Unit, killedEnemy: any) => {
            // TODO: Implement all dependencies mentioned above. Check for "NeedleHas" property on enemy.
            // const BuffLib = require(replicated.Libs.BuffLib); // Placeholder
            // const GameVariables = game.GetService("ReplicatedStorage").GameVariables; // Placeholder
            // const AllMultiPath = GameVariables.GetAttribute("AllMultiPath");
            // const now = tick(); // Placeholder
            // const lastSpawnTime = unit.getAttribute("MindControlSpawnCD") || 0;

            // const chance = killedEnemy && killedEnemy["NeedleHas"] ? MindControlMastery.needleSpawnChance : MindControlMastery.baseSpawnChance;

            // if (Math.random() < chance && (now - lastSpawnTime) > MindControlMastery.spawnCooldown) {
            //     unit.setAttribute("MindControlSpawnCD", now);

            //     const spawnClone = (pathNumber?: number) => {
            //         // const allyNPCConfig = _G.Registry.registry.AllyNPC[MindControlMastery.summonName]; // Placeholder
            //         // const template = _G.AllyAPI.buildAllyConfig( // Placeholder
            //         //     unit,
            //         //     MindControlMastery.summonName,
            //         //     deepCopy(allyNPCConfig),
            //         //     GameVariables.CurrentWave.Value,
            //         //     undefined,
            //         //     pathNumber
            //         // );

            //         // let servantHealth = (killedEnemy.MaxHealth || 1000) * MindControlMastery.healthPercentOfEnemy;
            //         // const maxHealthCap = BuffLib.GetDamage(unit) * MindControlMastery.healthCapMultiplierOfUnitDamage;
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
