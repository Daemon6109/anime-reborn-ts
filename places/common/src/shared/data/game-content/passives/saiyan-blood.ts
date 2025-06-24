import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const SaiyanBlood: PassiveData = {
    name: "Saiyan Blood",
    description: "After every 2 waves goku powers up and transforms, each transformation increasing his dmg by 5%, his range by 3% and decreasing his spa by -3%.",
    // wavesPerTransformation: 2, // Luau uses "Stacks >= 1" (GokuStacks) which implies every wave after the first if Stacks is wave counter since last transform. Description says "every 2 waves".
    // maxTransformations: 4,     // Luau: LastTransformation < 5 (states 0,1,2,3,4 = 5 states, 4 transforms)
    // damagePerTransformation: 0.05,
    // rangePerTransformation: 0.03,
    // spaPerTransformation: -0.03, // Negative for SPA decrease (faster attack)
    callbacks: {
        onWave: (unit: Unit) => {
            // TODO: Implement attribute getting/setting, ReplicatedStorage.Events.VisualEffects, ReplicatedStorage.Registry.Units
            // let waveCounter = unit.getAttribute("SaiyanBloodWaveCounter") || 0;
            // waveCounter++;

            // let currentTransformState = unit.getAttribute("SaiyanBloodTransformState") || 0; // 0 is base, 1-4 are transformed states

            // // Luau uses "GokuStacks", if >= 1 it transforms. This happens every wave if not reset.
            // // Description "every 2 waves" is different. Assuming description for clarity.
            // if (waveCounter >= (SaiyanBlood.wavesPerTransformation || 2)) {
            //     unit.setAttribute("SaiyanBloodWaveCounter", 0); // Reset wave counter for this cycle

            //     if (currentTransformState < (SaiyanBlood.maxTransformations || 4)) {
            //         currentTransformState++;
            //         unit.setAttribute("SaiyanBloodTransformState", currentTransformState);

            //         // Trigger visual effect for transformation
            //         // replicated.Events.VisualEffects:FireAllClients("TriggerClientonWave", replicated.Registry.Units["Goku [Evo]"], Unit, currentTransformState, nil, nil) // Placeholder

            //         // Apply stat buffs
            //         // unit.setAttribute("PermanentDamageMulti", (unit.getAttribute("PermanentDamageMulti") || 1) + (SaiyanBlood.damagePerTransformation || 0.05));
            //         // unit.setAttribute("PermanentRangeMulti", (unit.getAttribute("PermanentRangeMulti") || 1) + (SaiyanBlood.rangePerTransformation || 0.03));
            //         // unit.setAttribute("PermanentAttackSpeedMulti", (unit.getAttribute("PermanentAttackSpeedMulti") || 1) + (SaiyanBlood.spaPerTransformation || -0.03)); // SPA decrease
            //     } else if (currentTransformState === (SaiyanBlood.maxTransformations || 4)) {
            //         // This is the state *after* the last defined transformation, becomes immune
            //         // To prevent re-applying immunity tags, check if already applied or use a different state marker.
            //         if (!unit.hasTag("SaiyanBloodMaxFormImmunity")) {
            //             unit.addTag("InnateNonTarget");
            //             unit.addTag("InnateNoStun");
            //             unit.addTag("SaiyanBloodMaxFormImmunity");
            //         }
            //     }
            // } else {
            //     unit.setAttribute("SaiyanBloodWaveCounter", waveCounter);
            // }
        },
    },
};
