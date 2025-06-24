export interface EnemyAttackConfig {
  HitDelay?: number;
  Duration?: number;
  TurnTime?: number;
  StunTime?: number;
  AttackRange?: number;
  AttackSize?: number;
  HitCount?: number;
  MultihitDelay?: number;
}

export interface EnemyAttackModule {
  config: EnemyAttackConfig;
  // Representing the Effect function. It takes a table and returns void.
  // The actual signature in Luau is (Tab: {unit: any, rt: any, pos: any}) -> void
  // We'll simplify this for now, might need more specific typing later.
  Effect?: (tab: Record<string, any>) => void;
}

export interface EnemyRewardsOnDeath {
  Currencies?: Record<string, number>; // e.g. { Gems: 30, Gold: 80 }
  Items?: Record<string, { Amount: {min: number, max: number} | number; Chance: number; RNG: {min: number, max: number} | number }>; // e.g. { Hogyoku: { Amount: {min: 1, max: 1}, Chance: 5, RNG: {min: 1, max: 100} } }
  Units?: Record<string, { Amount: {min: number, max: number} | number; Chance: number; RNG: {min: number, max: number} | number }>;
}

export interface EnemyStats {
  Speed: number;
  Damage: number;
  HealthMultiplier: number;
  Health?: number; // Optional, as it's often commented out
  NPC_Type: "Ground" | "Air";
  Class: "Regular" | "Boss" | "Explosive" | "Speedster" | "Guardian" | "Shield" | "Shade" | "Regenerate";
  Element: "Neutral" | "Fire" | "Water" | "Wind" | "Earth" | "Light" | "Dark"; // Assuming more elements might exist
  IsBoss?: boolean;
  IsAttackingType?: boolean;
  AttackDelay?: number;
  Ressurect?: boolean;
  RessurectDuration?: number;
  RewardsOnDeath?: EnemyRewardsOnDeath;
  OnDeathAction?: "Explode"; // Can be expanded
  DeathActionData?: {
    Size: number;
    Duration: number;
  };
  Regen?: number; // e.g. 10/100 for 10%
  RegenDelay?: number;
  HideDelay?: number;
  HideDuration?: number;
  DetectedBy?: Record<string, boolean>; // For Shade class
  ShieldCharges?: number;
}

export interface EnemyConfiguration {
  DisplayName?: string;
  MapAffinity?: string; // This could be an enum if map names are fixed
  RandomizeCustomization?: boolean;
  Height?: number;
  WalkAnim?: string; // Path to animation
  RunAnim?: string; // Path to animation
  WingAnim?: string;
  FlinchAnim?: string;
  OverheadDisplay?: string;
  OverheadColor?: string; // Hex color string e.g. "9AFFF9"
  RessurectAnim?: string; // Path to animation
  CapeAnim?: string; // Path to animation
  BossPopupCorrection?: { x: number; y: number; z: number }; // Representing CFrame.new(0, -1.05, 0)
  ViewportOffset?: { x: number; y: number; z: number }; // Representing CFrame.new(0,-2.75,0)
  RootJointAngle?: { x: number; y: number; z: number }; // Representing CFrame.Angles(math.rad(-45),0,0)
}

export interface EnemyMisc {
  ScriptLink?: string; // Will likely be removed or transformed
  Model?: string; // Path to model
  ShinyModel?: string; // Path to shiny model
  ModelsPool?: string | Record<string, string>; // Path or map to models pool
}

export interface EnemyFunctions {
  onSpawn?: (npc: any) => void;
  onClientDeath?: (npc: any) => void;
  onRessurect?: (npc: any, anim: any) => void;
  onHide?: (body: any, state: "Yes" | "No") => void; // For Shade class
}

export interface EnemyData extends EnemyFunctions {
  configuration: EnemyConfiguration;
  reward: {
    money: number;
  };
  stats: EnemyStats;
  misc: EnemyMisc;
  Attack?: EnemyAttackModule; // For bosses with primary attack
  Attack2?: EnemyAttackModule; // For bosses with secondary attack (e.g. Frieza)
  AttackA?: EnemyAttackModule; // For bosses with alternative attack (e.g. Kaido)
}
