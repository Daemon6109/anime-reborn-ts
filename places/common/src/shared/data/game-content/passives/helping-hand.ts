import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

// This passive has a continuous targeting and buffing logic in a spawned task (while loop).
// This will need careful translation to an event-driven or tick-based system in TS.
export const HelpingHand: PassiveData = {
    name: "Helping Hand",
    description: "Boosts the DMG of a `Fire` element ally with the least amount of eliminations in the range by +35%",
    // percentIncrease: 0.35,
    // tagName: "HelpingHand", // Tag for the buffed unit and the host
    callbacks: {
        onPlace: (unit: Unit) => { // unit is the one with Helping Hand
            // TODO: Implement attribute/tag setting, task.spawn, _G.UnitHandler, ReplicatedStorage.GameVariables.GameSpeed.Value
            // unit.addTag(`${HelpingHand.tagName}Host`);
            // unit.setAttribute(`${HelpingHand.tagName}HostId`, unit.getAttribute("IUUID"));

            // task.spawn(async () => { // Placeholder for the continuous logic
            //     let currentlyBuffedUnit: Unit | undefined = undefined;
            //     const hostId = unit.getAttribute("IUUID");

            //     while (unit && unit.getInstance().Parent) { // Check if host unit still exists
            //         // await task.wait(1 / game.GetService("ReplicatedStorage").GameVariables.GameSpeed.Value); // Placeholder
            //         if (!unit || !unit.getInstance().Parent) break;

            //         if (currentlyBuffedUnit && (!currentlyBuffedUnit.getInstance().Parent || !currentlyBuffedUnit.hasTag(HelpingHand.tagName))) {
            //             // Clear buff if buffed unit is gone or no longer has the tag from this source
            //             if (currentlyBuffedUnit.getAttribute(`${HelpingHand.tagName}Id`) === hostId) {
            //                  // currentlyBuffedUnit.setAttribute("PermanentDamageMulti", (currentlyBuffedUnit.getAttribute("PermanentDamageMulti") || 1) - HelpingHand.percentIncrease);
            //                  // currentlyBuffedUnit.removeTag(HelpingHand.tagName);
            //                  // currentlyBuffedUnit.removeAttribute(`${HelpingHand.tagName}Id`);
            //             }
            //             currentlyBuffedUnit = undefined;
            //         }

            //         const alliesInRange = _G.UnitHandler.GetAllyUnitsInRange(unit); // Placeholder
            //         const potentialTargets: { unit: Unit; elims: number }[] = [];

            //         for (const ally of alliesInRange) {
            //             // const config = ally.getInstance().FindFirstChild("configuration"); // Placeholder
            //             // if (config && config.Element.Value === "Fire" && !ally.hasTag(HelpingHand.tagName)) { // Not already buffed by any HelpingHand
            //             //     potentialTargets.push({ unit: ally, elims: ally.getAttribute("Eliminations") || 0 });
            //             // }
            //         }
            //         // Include currently buffed unit in re-evaluation if it's still valid and of Fire element
            //         // if (currentlyBuffedUnit && currentlyBuffedUnit.getInstance().FindFirstChild("configuration")?.Element.Value === "Fire") {
            //         //    potentialTargets.push({ unit: currentlyBuffedUnit, elims: currentlyBuffedUnit.getAttribute("Eliminations") || 0 });
            //         //}


            //         if (potentialTargets.length > 0) {
            //             potentialTargets.sort((a, b) => a.elims - b.elims); // Sort by elims ascending
            //             const newTarget = potentialTargets[0].unit;

            //             if (newTarget !== currentlyBuffedUnit) {
            //                 // Debuff old target if there was one and it was buffed by this host
            //                 if (currentlyBuffedUnit && currentlyBuffedUnit.getAttribute(`${HelpingHand.tagName}Id`) === hostId) {
            //                     // currentlyBuffedUnit.setAttribute("PermanentDamageMulti", (currentlyBuffedUnit.getAttribute("PermanentDamageMulti") || 1) - HelpingHand.percentIncrease);
            //                     // currentlyBuffedUnit.removeTag(HelpingHand.tagName);
            //                     // currentlyBuffedUnit.removeAttribute(`${HelpingHand.tagName}Id`);
            //                 }
            //                 // Buff new target
            //                 currentlyBuffedUnit = newTarget;
            //                 // currentlyBuffedUnit.addTag(HelpingHand.tagName);
            //                 // currentlyBuffedUnit.setAttribute("PermanentDamageMulti", (currentlyBuffedUnit.getAttribute("PermanentDamageMulti") || 1) + HelpingHand.percentIncrease);
            //                 // currentlyBuffedUnit.setAttribute(`${HelpingHand.tagName}Id`, hostId);
            //             }
            //         } else if (currentlyBuffedUnit && currentlyBuffedUnit.getAttribute(`${HelpingHand.tagName}Id`) === hostId) {
            //             // No valid targets found, remove buff from current if it was buffed by this host
            //             // currentlyBuffedUnit.setAttribute("PermanentDamageMulti", (currentlyBuffedUnit.getAttribute("PermanentDamageMulti") || 1) - HelpingHand.percentIncrease);
            //             // currentlyBuffedUnit.removeTag(HelpingHand.tagName);
            //             // currentlyBuffedUnit.removeAttribute(`${HelpingHand.tagName}Id`);
            //             currentlyBuffedUnit = undefined;
            //         }
            //     }
            // });
        },
        onRemove: (unit: Unit) => { // unit is the one with Helping Hand being removed
            // TODO: Implement workspace, attribute, and tag equivalents
            // const hostId = unit.getAttribute("IUUID");
            // const currentlyPlaced = workspace.UnitsPlaced.GetChildren(); // Placeholder
            // for (const allyInstance of currentlyPlaced) {
            //     const ally = allyInstance as Unit;
            //     if (ally.hasTag(HelpingHand.tagName) && ally.getAttribute(`${HelpingHand.tagName}Id`) === hostId) {
            //         // ally.setAttribute("PermanentDamageMulti", (ally.getAttribute("PermanentDamageMulti") || 1) - HelpingHand.percentIncrease);
            //         // ally.removeTag(HelpingHand.tagName);
            //         // ally.removeAttribute(`${HelpingHand.tagName}Id`);
            //     }
            // }
        },
    },
};
