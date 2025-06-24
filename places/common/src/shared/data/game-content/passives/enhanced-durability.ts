import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const EnhancedDurability: PassiveData = {
    name: "Enhanced Durability",
    description: "Iron's armor makes him immune to stuns. Swinging his heavy hammer instantly breaks shields.",
    callbacks: {
        onPlace: (unit: Unit) => {
            unit.addTag("ShieldBreaker");    // For shield breaking
            unit.addTag("InnateNonTarget");  // For stun immunity (often implemented as non-targetable by stun effects)
            unit.addTag("InnateNoStun");     // Explicit stun immunity tag
        },
    },
};
