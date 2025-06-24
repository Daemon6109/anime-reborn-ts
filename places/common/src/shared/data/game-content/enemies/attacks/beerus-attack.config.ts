import { EnemyAttackConfig } from "../enemy-data.model";

export const beerusAttackConfig: EnemyAttackConfig = {
  HitDelay: 3.55, // seconds
  Duration: 0.8,
  TurnTime: 0.7,
  StunTime: 4,
  AttackRange: 25,
  AttackSize: 15,
};

// The Luau 'Effect' function from Beerus/Attack/init.luau is highly imperative and
// involves direct manipulation of Roblox instances (Models, Particles, Sounds, Tweens, CFrame).
// This logic will be handled by the client-side game systems that consume this enemy data.
//
// Summary of Effect:
// - Plays "Animation2" on the unit.
// - Plays "Move2sfx" sound after a delay.
// - Spawns 6 "balls" (from "Attack2" model) at fixed offsets around the unit.
//   - These balls have an "aaaaaa" particle effect.
//   - They float smoothly up and down.
//   - They grow in size.
// - After a delay, each ball tweens towards a random offset from the target enemy's position
//   using a curved path (CFrame manipulation with sin function).
// - Upon reaching the destination, an "EXP" particle effect is played, and the ball is destroyed.
//
// This would be triggered by an event like:
// EventBus.emit('EnemyAttackEffect', { enemyId: 'Beerus', attackName: 'Primary', unit, target });
