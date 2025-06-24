import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const HitmanTricks: PassiveData = {
    name: "Hitman Tricks",
    description: "Applies special DoT effect dealing 5% of this unit damage, if enemy was eliminated by the effect, unit gets 2.5% DoT damage buff, resets every 3rd wave",
    callbacks: {
        // onApplyDoT: (unit: Unit, enemy: any) => {
        //     // TODO: This passive implies a special DoT. The application of this DoT (5% of unit damage)
        //     // would need to be handled by the attack system, possibly by adding a temporary status effect to the enemy
        //     // that stores the DoT damage and a source ID (this unit).
        // },
        // onEnemyKilledByDoTFromThisUnit: (unit: Unit, dotSourceUnit: Unit) => { // Event fired when an enemy is killed by a DoT applied by `dotSourceUnit`
        //     // TODO: Implement attribute getting/setting.
        //     // if (dotSourceUnit === unit) { // Check if the DoT was from this Hitman unit
        //     //     let dotStacks = unit.getAttribute("HitmanTricksDoTBuffStacks") || 0;
        //     //     // Assuming there's a max for this buff, though not specified.
        //     //     dotStacks++;
        //     //     unit.setAttribute("HitmanTricksDoTBuffStacks", dotStacks);
        //     //
        //     //     // How is "2.5% DoT damage buff" applied?
        //     //     // Does it increase the 5% base for future DoTs? Or a general DoT damage multiplier for the unit?
        //     //     // Luau: Unit.configuration.AttackEffectDamageMultiplier.Value -= .025*DoTStacks (on wave reset, this is a revert)
        //     //     // This implies AttackEffectDamageMultiplier is *increased* by 0.025 when this procs.
        //     //     // This needs careful handling of how `AttackEffectDamageMultiplier` is used.
        //     //     // unit.setAttribute("SomeDotDamageMultiplier", (unit.getAttribute("SomeDotDamageMultiplier") || initialMultiplier) + 0.025);
        //     // }
        // },
        onWave: (unit: Unit) => {
            // TODO: Implement attribute getting/setting.
            // let waveCount = unit.getAttribute("HitmanTricksWaveCount") || 0;
            // waveCount++;

            // if (waveCount >= 3) {
            //     waveCount = 0; // Reset wave counter

            //     const dotBuffStacksApplied = unit.getAttribute("HitmanTricksDoTBuffStacks") || 0;
            //     if (dotBuffStacksApplied > 0) {
            //         // Revert the accumulated DoT damage buff
            //         // This depends on how the buff was applied. If it modified a config value directly (like Luau):
            //         // unit.configuration.AttackEffectDamageMultiplier.Value -= 0.025 * dotBuffStacksApplied; // This is problematic for TS.
            //         // Better:
            //         // unit.setAttribute("SomeDotDamageMultiplier", initialMultiplier); // Reset to base
            //         // Or if it was an additive attribute:
            //         // unit.setAttribute("SomeDotDamageMultiplier", (unit.getAttribute("SomeDotDamageMultiplier") || someBase) - (0.025 * dotBuffStacksApplied));
            //     }
            //     unit.setAttribute("HitmanTricksDoTBuffStacks", 0); // Reset buff stacks
            // }
            // unit.setAttribute("HitmanTricksWaveCount", waveCount);
        },
        // The description "Applies special DoT effect dealing 5% of this unit damage" would likely be
        // a tag or property this passive grants, which the main attack/damage system then uses to create the DoT status effect.
    },
};
