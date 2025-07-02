Use the "Roblox Studio" mcp server with the "run_code" & "insert_model" commands and print the data of game.ReplicatedStorage.Registry.BingoQuests which is a folder. Print all of it's children which is a ModuleScript and use the ModuleScript.Source property to get its content.
Create a json configuration file under `places/common/src/shared/configuration/bingo-quests-data.json` with the following structure:

```json
{
	"ModuleName": {
		"key": Value
	}
}
```
