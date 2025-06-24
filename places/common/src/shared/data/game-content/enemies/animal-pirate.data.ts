import { EnemyData } from './enemy-data.model';

export const animalPirate: EnemyData = {
  configuration: {
    RandomizeCustomization: false,
    MapAffinity: "Fujishima Island",
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
    Model: "old_common/src/constants/Enemies/Animal_Pirate/Model", // Path to Model asset
    ShinyModel: "old_common/src/constants/Enemies/Animal_Pirate/ShinyModel", // Path to ShinyModel asset
    ModelsPool: "ReplicatedStorage.EnemyModels.Fujishima_Island.Basic", // Adjusted path
  },
};
