import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const PsychicConnection: PassiveData = {
    name: "Psychic Connection",
    description: "Every 40s, buffs range of all units named `Oktawalk` in radius by 15% for 5s, 15% chance to stun Oktawalk's for 3s",
    // targetAllyName: "Okarun", // Luau uses "Okarun", description "Oktawalk" - assuming Okarun from code.
    // rangeBuffPercent: 0.15,
    // buffInterval: 40, // seconds
    // buffDuration: 5,   // seconds
    // stunChance: 0.15,  // 15%
    // stunDuration: 3,   // seconds
    // tagName: "PsychicConnectionBuffed",
    callbacks: {
        onPlace: (unit: Unit) => { // unit is the one with Psychic Connection
            // TODO: Implement task.spawn, task.wait, BuffLib, FastVector, workspace, string.match, _G.UnitAPI.SetTimedStunnedState, CollectionService, ReplicatedStorage.GameVariables.GameSpeed.Value
            // task.spawn(async () => { // Placeholder for async background task
            //     const BuffLib = require(replicated.Libs.BuffLib); // Placeholder
            //     const FastVector = require(replicated.Libs.FastVector).new(); // Placeholder
            //     const unitIndividualID = unit.getAttribute("IUUID");
            //     const gameSpeed = game.GetService("ReplicatedStorage").GameVariables.GameSpeed.Value || 1; // Placeholder

            //     const applyEffectToTargetsInRange = () => {
            //         const unitRange = BuffLib.GetRangeScaled(unit);
            //         const currentlyPlaced = workspace.UnitsPlaced.GetChildren(); // Placeholder

            //         for (const allyInstance of currentlyPlaced) {
            //             const ally = allyInstance as Unit; // Type assertion
            //             if (ally === unit || !ally.getInstance()?.FindFirstChild("HumanoidRootPart")) continue;

            //             const isInRange = FastVector.FastMagnitudeVec3(unit.getInstance().PrimaryPart.Position, ally.getInstance().PrimaryPart.Position) <= unitRange;

            //             if (ally.Name.includes(PsychicConnection.targetAllyName || "Okarun") && isInRange) {
            //                 if (Math.random() < (PsychicConnection.stunChance || 0.15)) {
            //                     // _G.UnitAPI.SetTimedStunnedState(ally, PsychicConnection.stunDuration || 3); // Placeholder
            //                 } else {
            //                     // Apply range buff if not already buffed by this specific source (to avoid re-applying during its own duration)
            //                     const buffAttributeName = `${PsychicConnection.tagName || "PsychicConnectionBuffed"}Source`;
            //                     if (ally.getAttribute(buffAttributeName) !== unitIndividualID) {
            //                         ally.addTag(PsychicConnection.tagName || "PsychicConnectionBuffed");
            //                         ally.setAttribute(buffAttributeName, unitIndividualID);
            //                         ally.setAttribute("PermanentRangeMulti", (ally.getAttribute("PermanentRangeMulti") || 1) + (PsychicConnection.rangeBuffPercent || 0.15));

            //                         // task.delay((PsychicConnection.buffDuration || 5) / gameSpeed, () => { // Placeholder
            //                         //     if (ally && ally.getInstance()?.Parent && ally.hasTag(PsychicConnection.tagName || "PsychicConnectionBuffed") && ally.getAttribute(buffAttributeName) === unitIndividualID) {
            //                         //         ally.removeTag(PsychicConnection.tagName || "PsychicConnectionBuffed");
            //                         //         ally.removeAttribute(buffAttributeName);
            //                         //         ally.setAttribute("PermanentRangeMulti", (ally.getAttribute("PermanentRangeMulti") || 1) - (PsychicConnection.rangeBuffPercent || 0.15));
            //                         //     }
            //                         // });
            //                     }
            //                 }
            //             }
            //         }
            //     };

            //     applyEffectToTargetsInRange(); // Initial application

            //     while (unit && unit.getInstance() && unit.getInstance().Parent) {
            //         // await task.wait((PsychicConnection.buffInterval || 40) / gameSpeed); // Placeholder
            //         if (!(unit && unit.getInstance() && unit.getInstance().Parent)) break;
            //         applyEffectToTargetsInRange();
            //     }
            // });
        },
        onRemove: (unit: Unit) => {
            // TODO: Implement CollectionService, attribute, and tag removal for buffs applied by this unit
            // const unitIndividualID = unit.getAttribute("IUUID");
            // const CollectionService = game.GetService("CollectionService"); // Placeholder
            // const buffedAllies = CollectionService.GetTagged(PsychicConnection.tagName || "PsychicConnectionBuffed");
            // const buffAttributeName = `${PsychicConnection.tagName || "PsychicConnectionBuffed"}Source`;

            // for (const ally of buffedAllies) {
            //     if (ally.getAttribute(buffAttributeName) === unitIndividualID) {
            //         ally.removeTag(PsychicConnection.tagName || "PsychicConnectionBuffed");
            //         ally.removeAttribute(buffAttributeName);
            //         ally.setAttribute("PermanentRangeMulti", (ally.getAttribute("PermanentRangeMulti") || 1) - (PsychicConnection.rangeBuffPercent || 0.15));
            //     }
            // }
        },
    },
};
