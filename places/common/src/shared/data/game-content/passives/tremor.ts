import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const Tremor: PassiveData = {
    name: "Tremor",
    description: "After each 30 eliminations the next attack will stun the enemies.",
    // maxKillsForStun: 30,
    callbacks: {
        onKill: (unit: Unit) => {
            // TODO: Implement attribute getting/setting
            // let kills = unit.getAttribute("TremorKills") || 0;
            // if (kills < (Tremor.maxKillsForStun || 30)) {
            //     kills++;
            //     unit.setAttribute("TremorKills", kills);
            // }
        },
        onAttack: (unit: Unit) => {
            // TODO: Implement attribute getting/setting
            // unit.setAttribute("PassiveStun", false); // Default for this attack
            // const kills = unit.getAttribute("TremorKills") || 0;

            // if (kills >= (Tremor.maxKillsForStun || 30)) {
            //     unit.setAttribute("PassiveStun", true); // Signal attack system to apply stun
            //     unit.setAttribute("TremorKills", 0);    // Reset kill count
            // }
        },
        // Luau's onWave for "StrongestManStacks2" is commented out and seems unrelated.
    },
};
