-- Complete remaining L-units migration for Luffy units
local luffyUnits = {"Luffy [DR]", "Luffy [DR] [Evo]", "Luffy [PTS]"}

print("=== REMAINING L-UNITS STATUS ===")

for _, unitName in ipairs(luffyUnits) do
    local unitModule = game.ReplicatedStorage.Registry.Units:FindFirstChild(unitName)
    if unitModule then
        local released = unitModule:FindFirstChild("Released")
        local summonable = unitModule:FindFirstChild("Summonable")
        
        print(unitName .. ":")
        if released and summonable then
            print("  Released: " .. tostring(released.Value))
            print("  Summonable: " .. tostring(summonable.Value))
        else
            print("  Missing status data")
        end
        print()
    else
        print(unitName .. ": NOT FOUND")
        print()
    end
end

print("Next step: Extract configuration from old_common files and add to TypeScript registry")
