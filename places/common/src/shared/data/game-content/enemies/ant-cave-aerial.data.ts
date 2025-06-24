import { EnemyData } from './enemy-data.model';

export const antCaveAerial: EnemyData = {
  configuration: {
    Height: 4,
    WalkAnim: "ReplicatedStorage.Animations.Flying_Anims.Land_of_the_Sky.Enemy_Fly1", // Adjusted path
    RunAnim: "ReplicatedStorage.Animations.Flying_Anims.Land_of_the_Sky.Enemy_Fly1Fast", // Adjusted path
    RandomizeCustomization: false,
    OverheadDisplay: "AERIAL",
    OverheadColor: "9AFFF9",
    MapAffinity: "Land of the Sky", // Note: Luau file has this as "Land of the Sky", but ModelsPool is "Ant Cave"
  },
  reward: {
    money: 20,
  },
  stats: {
    Speed: 1.9,
    Damage: 10,
    HealthMultiplier: 0.75,
    // Health: 7000,
    NPC_Type: "Air",
    Class: "Regular",
    Element: "Neutral",
  },
  misc: {
    Model: "old_common/src/constants/Enemies/Ant_Cave_Aerial/Model", // Path to Model asset
    ShinyModel: "old_common/src/constants/Enemies/Ant_Cave_Aerial/ShinyModel", // Path to ShinyModel asset
    ModelsPool: "ReplicatedStorage.EnemyModels.Ant_Cave.Ariel", // Adjusted path
  },
};
