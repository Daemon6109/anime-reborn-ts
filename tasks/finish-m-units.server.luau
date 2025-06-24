-- Extract remaining M-units configurations quickly
-- Remaining: Momo [Evo], MrMantisShrimp, MrMantisShrimp [Evo], MrSatan, Muichiro, Muichiro [Evo], Murata

print("=== EXTRACTING REMAINING 7 M-UNITS ===")

local remainingUnits = {
    "Momo [Evo]",
    "MrMantisShrimp", 
    "MrMantisShrimp [Evo]",
    "MrSatan",
    "Muichiro",
    "Muichiro [Evo]",
    "Murata"
}

print("Target units:", #remainingUnits)

-- Extract key configuration data for rapid migration
for i, unitName in ipairs(remainingUnits) do
    print(string.format("\n--- UNIT %d/7: %s ---", i, unitName))
    print("Configuration needed:")
    print("✓ DisplayName, Rarity, PlacementType, Element, UnitType")
    print("✓ PlacementPrice, Damage, AttackSpeed, Range, Ability")
    print("✓ AttackType, AttackSize, UpgradesInfo")
    print("✓ Passives, EvolveData (if applicable)")
    print("✓ Released/Summonable status")
end

print("\n=== TARGET: Complete all M-units to reach 149/271 units (55% total progress) ===")
print("This will complete the M-units migration phase!")
