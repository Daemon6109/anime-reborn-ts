/**
 * Lune Bridge Service - Node.js interface to Lune runtime
 * This service allows Jest tests to execute code in the real Luau runtime via Lune
 */

import { spawn } from 'child_process';
import * as path from 'path';

interface LuneResult {
    success: boolean;
    result: any;
    error?: string;
}

export class LuneBridgeService {
    private bridgeScript: string;

    constructor() {
        this.bridgeScript = path.join(__dirname, '../lune/test-bridge.luau');
    }

    /**
     * Execute Luau code in the Lune runtime
     */
    async execute(code: string): Promise<LuneResult> {
        return new Promise((resolve, reject) => {
            const luneProcess = spawn('lune', ['run', this.bridgeScript, '--execute', code], {
                cwd: path.dirname(this.bridgeScript)
            });

            let stdout = '';
            let stderr = '';

            luneProcess.stdout.on('data', (data) => {
                stdout += data.toString();
            });

            luneProcess.stderr.on('data', (data) => {
                stderr += data.toString();
            });

            luneProcess.on('close', (code) => {
                try {
                    if (stdout.trim()) {
                        const result = JSON.parse(stdout.trim());
                        resolve(result);
                    } else if (stderr.trim()) {
                        resolve({
                            success: false,
                            error: stderr.trim(),
                            result: null
                        });
                    } else {
                        resolve({
                            success: false,
                            error: 'No output from Lune process',
                            result: null
                        });
                    }
                } catch (parseError: any) {
                    resolve({
                        success: false,
                        error: `Failed to parse Lune output: ${parseError.message}. Raw output: ${stdout}`,
                        result: null
                    });
                }
            });

            luneProcess.on('error', (error) => {
                reject(new Error(`Failed to start Lune process: ${error.message}`));
            });
        });
    }

    /**
     * Test if a value is a table using Lune's typeof
     */
    async isTable(value: any): Promise<boolean> {
        const serializedValue = JSON.stringify(value);
        const code = `local value = ${serializedValue}; return typeof(value) == "table"`;
        const result = await this.execute(code);
        return result.success ? result.result : false;
    }

    /**
     * Test Roblox-specific functions
     */
    async testRobloxGlobals(): Promise<any> {
        const code = `
            local result = {
                tick = tick(),
                typeof_table = typeof({}),
                typeof_string = typeof("test"),
                typeof_number = typeof(42)
            }
            return result
        `;
        
        const result = await this.execute(code);
        return result.success ? result.result : null;
    }

    /**
     * Execute a test function in the Lune environment
     */
    async runTest(testCode: string): Promise<any> {
        return this.execute(testCode);
    }
}
