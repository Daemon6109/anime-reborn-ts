import { EnemyAttackConfig } from "../enemy-data.model";

export const aizonAttackConfig: EnemyAttackConfig = {
  HitDelay: 2.1, // seconds
  Duration: 0.5,
  TurnTime: 0.7,
  StunTime: 6,
  AttackRange: 35,
  AttackSize: 15,
};

// The Luau 'Effect' function from Aizen/Attack/init.luau is highly imperative and
// involves direct manipulation of Roblox instances (Models, Particles, Sounds, Tweens).
// This logic will be handled by the client-side game systems that consume this enemy data,
// rather than being part of the data definition itself.
//
// Summary of Effect:
// - Plays an animation "Animation2" on the unit.
// - Plays "Move2sfx" sound.
// - Creates visual effects at the unit's position ("Ground" model, "Charge" particles).
// - Spawns "Aura" particles around the unit, moving towards the unit's "Left Arm".
// - Creates visual effects at the enemy's position ("Kurohitsugi" model with multiple particle systems).
// - Spawns "Aura" particles around the enemy, moving towards a CFrame above the enemy.
// - Uses functions like `Particle`, `lerp`, `quad`, `tp` (teleport visual effect) defined within the original Luau script.
// - These visual details (particle names, model names, tween parameters) would be used by
//   a dedicated visual effects system triggered by an attack event.
//
// Example of how it might be triggered:
// EventBus.emit('EnemyAttackEffect', { enemyId: 'Aizon', attackName: 'Primary', unit, targetPosition });
