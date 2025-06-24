import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const EmployeeOfTheMonth: PassiveData = {
    name: "Employee of the Month",
    description: "Nonomi's CRIT CHANCE and CRIT DMG are increased by +15%",
    // percentIncrease: 0.15, // Configuration specific to this passive
    callbacks: {
        onPlace: (unit: Unit) => {
            // TODO: Implement attribute getting/setting
            // unit.setAttribute("PermanentAttackCriticalDamage", (unit.getAttribute("PermanentAttackCriticalDamage") || 0) + EmployeeOfTheMonth.percentIncrease);
            // unit.setAttribute("PermanentAttackCriticalChance", (unit.getAttribute("PermanentAttackCriticalChance") || 0) + EmployeeOfTheMonth.percentIncrease);
        },
    },
};
