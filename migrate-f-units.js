const fs = require('fs');
const path = require('path');

// F-units to migrate
const fUnits = [
    "Feitan",
    "Feitan_Evo",
    "Freiza", 
    "Freiza_Evo",
    "Fujitora",
    "Fujitora_Evo",
    "Funny_Valentine",
    "Funny_Valentine_Evo"
];

console.log("=== F-UNITS MIGRATION SCRIPT ===");
console.log(`Migrating ${fUnits.length} F-units...`);

// Function to convert Luau config to TypeScript
function convertLuauToTypescript(luauCode, unitName) {
    const lines = luauCode.split('\n');
    let tsConfig = `\t"${unitName.replace(/_/g, ' ')}": {\n`;
    tsConfig += `\t\tconfiguration: {\n`;
    
    // Extract configuration block
    const configStart = lines.findIndex(l => l.includes('configuration = {'));
    const configEnd = lines.findIndex((l, i) => i > configStart && l.includes('},') && !l.includes('UpgradesInfo'));
    
    if (configStart === -1 || configEnd === -1) {
        console.log(`Warning: Could not find config for ${unitName}`);
        return '';
    }
    
    let inUpgrades = false;
    let inEvolve = false;
    let braceLevel = 0;
    
    for (let i = configStart + 1; i < configEnd; i++) {
        const line = lines[i].trim();
        if (!line || line.startsWith('--')) continue;
        
        // Convert Luau to TypeScript syntax
        let tsLine = line
            .replace(/:: (.*?)(?:,|$)/g, '') // Remove type annotations
            .replace(/CFrame\.new/g, 'new CFrame')
            .replace(/CFrame\.Angles/g, 'CFrame.Angles')
            .replace(/math\.rad/g, 'math.rad')
            .replace(/script\.Name/g, `"${unitName.replace(/_/g, ' ')}"`)
            .replace(/= {/g, ': {')
            .replace(/\[(\d+)\] = {/g, '$1: {')
            .replace(/;$/g, ',');
            
        // Handle special cases
        if (line.includes('UpgradesInfo')) {
            inUpgrades = true;
            tsLine = '\t\t\tUpgradesInfo: {';
        } else if (line.includes('EvolveData')) {
            inEvolve = true;
            tsLine = '\t\t\tEvolveData: [{';
        }
        
        // Add proper indentation
        const indent = '\t\t\t';
        if (inUpgrades || inEvolve) {
            tsLine = indent + '\t' + tsLine;
        } else {
            tsLine = indent + tsLine;
        }
        
        tsConfig += tsLine + '\n';
    }
    
    // Add Released/Summonable (confirmed from MCP server)
    tsConfig += `\t\t\tReleased: true,\n`;
    tsConfig += `\t\t\tSummonable: false,\n`;
    
    tsConfig += `\t\t},\n`;
    
    // Add animations and other fields
    const animStart = lines.findIndex(l => l.includes('animations = {'));
    const animEnd = lines.findIndex((l, i) => i > animStart && l.includes('}'));
    
    if (animStart !== -1 && animEnd !== -1) {
        tsConfig += `\t\tanimations: {\n`;
        for (let i = animStart + 1; i < animEnd; i++) {
            const line = lines[i].trim();
            if (line && !line.startsWith('--')) {
                const tsLine = line.replace(/;$/, ',');
                tsConfig += `\t\t\t${tsLine}\n`;
            }
        }
        tsConfig += `\t\t},\n`;
    }
    
    // Add radius and tradable from Unit properties
    const radiusMatch = luauCode.match(/Unit\.Radius = ([\d.]+)/);
    const tradableMatch = luauCode.match(/Unit\.Tradable = (true|false)/);
    
    if (radiusMatch) {
        tsConfig += `\t\tradius: ${radiusMatch[1]},\n`;
    }
    if (tradableMatch) {
        tsConfig += `\t\ttradable: ${tradableMatch[1]},\n`;
    }
    
    tsConfig += `\t},\n\n`;
    return tsConfig;
}

// Process all F-units
let allUnitsData = '';

for (const unitName of fUnits) {
    const unitDir = path.join('/workspace/old_common/src/constants/Units', unitName);
    const initFile = path.join(unitDir, 'init.luau');
    
    if (fs.existsSync(initFile)) {
        console.log(`Processing ${unitName}...`);
        const luauCode = fs.readFileSync(initFile, 'utf8');
        const tsCode = convertLuauToTypescript(luauCode, unitName);
        allUnitsData += tsCode;
    } else {
        console.log(`Warning: ${initFile} not found`);
    }
}

console.log("\n=== GENERATED TYPESCRIPT ===");
console.log(allUnitsData);

// Write to output file
fs.writeFileSync('/workspace/f-units-migration.ts', allUnitsData);
console.log("\nSaved to f-units-migration.ts");
