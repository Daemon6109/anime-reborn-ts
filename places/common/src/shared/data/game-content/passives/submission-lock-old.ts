import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const SubmissionLockOLD: PassiveData = {
    name: "Submission Lock", // Same name as non-OLD
    description: "On every 15th attack, Stuns all the enemies hit for 2.5 seconds.",
    // attacksNeededForStun: 15,
    // stunDuration: 2.5, // Implied duration for the stun applied
    callbacks: {
        onAttack: (unit: Unit) => {
            // TODO: Implement attribute getting/setting
            // let attackCount = unit.getAttribute("SubmissionLockOLDAttackCount") || 0;
            // attackCount++;
            // unit.setAttribute("PassiveStun", false);

            // if (attackCount >= (SubmissionLockOLD.attacksNeededForStun || 15)) {
            //     unit.setAttribute("SubmissionLockOLDAttackCount", 0);
            //     unit.setAttribute("PassiveStun", true); // Attack system applies stun with appropriate duration
            // } else {
            //     unit.setAttribute("SubmissionLockOLDAttackCount", attackCount);
            // }
        },
    },
};
