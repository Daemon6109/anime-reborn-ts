import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const OffWhite: PassiveData = {
    name: "Off White",
    description: "When stunned, unit becomes temporarily immune to stun and does +50% Damage for the next 5 seconds ",
    // buffDuration: 5, // seconds
    // damageBonus: 0.50,
    callbacks: {
        onStunEnded: (unit: Unit) => { // Luau: onStunEnded. This means the buff applies *after* a stun wears off.
            // TODO: Implement attribute getting/setting, tag adding/removing, task.delay, ReplicatedStorage.GameVariables.GameSpeed.Value
            // const isAlreadyBuffed = unit.getAttribute("IsBuffedDoffy") || false; // Doffy specific attr name in Luau

            // if (!isAlreadyBuffed) {
            //     unit.setAttribute("IsBuffedDoffy", true);
            //     unit.addTag("InnateNoStun"); // Temporary stun immunity
            //     unit.setAttribute("PermanentDamageMulti", (unit.getAttribute("PermanentDamageMulti") || 1) + OffWhite.damageBonus);

            //     const gameSpeed = game.GetService("ReplicatedStorage").GameVariables.GameSpeed.Value || 1; // Placeholder
            //     // task.delay(OffWhite.buffDuration / gameSpeed, () => { // Placeholder for async delay
            //     //     // Check if unit still exists and still has the buff before removing
            //     //     if (unit && unit.getInstance() && unit.getInstance().Parent && unit.getAttribute("IsBuffedDoffy") === true) {
            //     //         unit.removeTag("InnateNoStun");
            //     //         unit.setAttribute("IsBuffedDoffy", false);
            //     //         unit.setAttribute("PermanentDamageMulti", (unit.getAttribute("PermanentDamageMulti") || 1) - OffWhite.damageBonus);
            //     //     }
            //     // });
            // }
        },
    },
};
