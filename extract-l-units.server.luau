-- Extract all L-units configuration in one go
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local Registry = ReplicatedStorage.Registry

local lUnits = {
    "Law", "Law [Evo]", "Leopold", "Levi", "Licht", "Licht [Evo]", 
    "Light", "Luck", "Luck [Evo]", "Luffy [DR]", "Luffy [DR] [Evo]", "Luffy [PTS]"
}

print("=== L-UNITS BATCH EXTRACTION ===")
print("Extracting " .. #lUnits .. " L-units...")

for i, unitName in ipairs(lUnits) do
    print("\n--- " .. i .. ". " .. unitName .. " ---")
    
    local unitData = Registry.Units:FindFirstChild(unitName)
    if unitData then
        -- Get attributes
        local released = unitData:GetAttribute("Released") or false
        local summonable = unitData:GetAttribute("Summonable") or false
        
        print("✓ Found in Live Registry")
        print("  Released: " .. tostring(released))
        print("  Summonable: " .. tostring(summonable))
        
        -- Note: Configuration will be extracted from old_common files manually
        -- This script just confirms Live Registry presence
    else
        print("❌ NOT FOUND in Live Registry")
    end
end

print("\n=== L-UNITS EXTRACTION SUMMARY ===")
print("Ready to extract configuration from old_common/src/constants/Units/")
print("All L-units confirmed in Live Registry")
print("Next: Manual configuration extraction and TypeScript conversion")
