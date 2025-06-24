import { EnemyData } from './enemy-data.model';

export const angel: EnemyData = {
  configuration: {
    RandomizeCustomization: false,
    MapAffinity: "Land of the Sky",
  },
  reward: {
    money: 20,
  },
  stats: {
    Speed: 2.2,
    Damage: 10,
    HealthMultiplier: 1,
    // Health: 7000, // Original value: 50
    NPC_Type: "Ground",
    Class: "Regular",
    Element: "Neutral",
  },
  misc: {
    Model: "old_common/src/constants/Enemies/Angel/Model", // Path to Model asset
    ShinyModel: "old_common/src/constants/Enemies/Angel/ShinyModel", // Path to ShinyModel asset
    ModelsPool: "ReplicatedStorage.EnemyModels.Land_of_the_Sky.Basic", // Adjusted path
  },
};
