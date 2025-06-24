import { Unit } from "shared/components/unit";
import { PassiveData } from "../passive";

export const SurgeonsPrecision: PassiveData = {
    name: "Surgeons precision",
    description: "Law becomes more powerful with every enemy defeated, increasing his damage by 0.1% per kill, up to a 10% cap.",
    // maxKillsForBuff: 100, // 10% / 0.1% = 100 kills for max bonus. Luau MaxPassiveStacks is 100.
    // damageIncreasePerKill: 0.001, // 0.1%
    callbacks: {
        onKill: (unit: Unit) => { // unit is Law
            // TODO: Implement attribute getting/setting
            // const maxKills = SurgeonsPrecision.maxKillsForBuff || 100;
            // const buffMaxedAttr = "SurgeonsPrecisionMaxedSP"; // SP for SurgeonsPrecision
            // const killCountAttr = "SurgeonsPrecisionKillCountSP";

            // if (unit.getAttribute(buffMaxedAttr)) return; // Buff already maxed

            // let killCount = unit.getAttribute(killCountAttr) || 0;

            // if (killCount < maxKills) {
            //     killCount++;
            //     unit.setAttribute(killCountAttr, killCount);
            //     unit.setAttribute("PermanentDamageMulti", (unit.getAttribute("PermanentDamageMulti") || 1) + (SurgeonsPrecision.damageIncreasePerKill || 0.001));

            //     if (killCount >= maxKills) {
            //         unit.setAttribute(buffMaxedAttr, true);
            //         // Luau: if Stacks == MaxPassiveStacks then ... unit:SetAttribute("PermanentDamageMulti", Unit:GetAttribute("PermanentDamageMulti")+0.1)
            //         // This is an additional 10% ON TOP of the accumulated 10% if it's a direct translation.
            //         // Description "up to a 10% cap" suggests the loop itself achieves the cap.
            //         // Assuming the description is the intent, the extra 0.1 is not added here.
            //     }
            // }
        },
    },
};
