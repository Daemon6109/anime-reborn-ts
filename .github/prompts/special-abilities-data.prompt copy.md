Use the "Roblox Studio" mcp server with the "run_code" & "insert_model" commands and print the data of game.ReplicatedStorage.Registry.SpecialAbilities which is a folder. Print all of it's children which is a ModuleScript and use the ModuleScript.Source property to get its content.
Create a json configuration file under `places/common/src/shared/configuration/special-abilities-data.json` with the following structure:

```json
{
	"ModuleName": { -- skip AbilityData and Root, All the values should be numbers, strings, and booleans, nothing else
		"key": Value
	}
}
```
