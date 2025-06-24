import { Unit } from "shared/components/unit";

export interface PassiveData {
    name: string;
    description: string;
    callbacks: {
        onUnitsInRange?: (unit: Unit) => void;
        onRemove?: (unit: Unit) => void;
        onPlace?: (unit: Unit) => void;
        onConditionalDamage?: (unit: Unit, enemy: any) => number;
        // Add other callback types as needed
    };
}
