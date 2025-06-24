import { EnemyData } from './enemy-data.model';

export const anomaly: EnemyData = {
  configuration: {
    RandomizeCustomization: false,
    MapAffinity: "Land of the Sky", // Note: Luau file specified "Land of the Sky", but ModelsPool is "Ghost Tunnel"
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
    Model: "old_common/src/constants/Enemies/Anomaly/Model", // Path to Model asset
    ShinyModel: "old_common/src/constants/Enemies/Anomaly/ShinyModel", // Path to ShinyModel asset
    ModelsPool: "ReplicatedStorage.EnemyModels.Ghost_Tunnel.Basic", // Adjusted path
  },
};
