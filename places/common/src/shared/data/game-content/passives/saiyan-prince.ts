import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const SaiyanPrince: PassiveData = {
    name: "Saiyan Prince",
    description: "After every 50 eliminations, he powers up and transforms, gaining +6% damage, +5% range, and -4% SPA on each transformation ",
    // killsPerTransformation: 50,
    // maxTransformations: 3, // Luau: LastTransformation < 4 (states 0,1,2,3 => 3 transforms to reach state 4)
    // damagePerTransformation: 0.06,
    // rangePerTransformation: 0.05,
    // spaPerTransformation: -0.04,
    callbacks: {
        onAnyKill: (unit: Unit, killer: Unit, killedEnemy: any) => {
            // TODO: Implement attribute getting/setting, ReplicatedStorage.Events.VisualEffects, ReplicatedStorage.Registry.Units
            // if (killer !== unit) return;

            // let killCount = unit.getAttribute("SaiyanPrinceKillCountSP") || 0; // SP for SaiyanPrince
            // let currentTransformState = unit.getAttribute("SaiyanPrinceTransformStateSP") || 0;

            // if (currentTransformState < (SaiyanPrince.maxTransformations || 3)) {
            //     killCount++;
            //     if (killCount >= (SaiyanPrince.killsPerTransformation || 50)) {
            //         unit.setAttribute("SaiyanPrinceKillCountSP", 0);
            //         currentTransformState++;
            //         unit.setAttribute("SaiyanPrinceTransformStateSP", currentTransformState);

            //         // Visual effect for transformation
            //         // replicated.Events.VisualEffects:FireAllClients("TriggerClientonWave", replicated.Registry.Units["Vegeta [Evo]"], Unit, currentTransformState, nil, nil) // Placeholder

            //         // Apply stat buffs
            //         // unit.setAttribute("PermanentDamageMulti", (unit.getAttribute("PermanentDamageMulti") || 1) + (SaiyanPrince.damagePerTransformation || 0.06));
            //         // unit.setAttribute("PermanentRangeMulti", (unit.getAttribute("PermanentRangeMulti") || 1) + (SaiyanPrince.rangePerTransformation || 0.05));
            //         // unit.setAttribute("PermanentAttackSpeedMulti", (unit.getAttribute("PermanentAttackSpeedMulti") || 1) + (SaiyanPrince.spaPerTransformation || -0.04));

            //         if (currentTransformState === (SaiyanPrince.maxTransformations || 3)) {
            //             unit.setAttribute("SecondPassiveUnlocked", true); // For Saiyans_Pride passive
            //         }
            //     } else {
            //         unit.setAttribute("SaiyanPrinceKillCountSP", killCount);
            //     }
            // }
        },
    },
};
