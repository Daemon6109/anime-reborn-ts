/**
 * Enhanced Jest setup that can use Lune for executing Roblox globals
 * This provides a hybrid approach: mocks for simple cases, Lune for complex ones
 */

import { LuneBridgeService } from './lune-bridge';

// Global flag to determine which execution mode to use
let useLuneForRobloxGlobals = process.env.JEST_USE_LUNE === 'true';

// Initialize Lune bridge if needed
let luneBridge: LuneBridgeService | null = null;
if (useLuneForRobloxGlobals) {
    luneBridge = new LuneBridgeService();
}

// Enhanced typeof that can use Lune or fallback to mock
export const createTypeof = () => {
    if (useLuneForRobloxGlobals && luneBridge) {
        return async (value: any) => {
            const code = `local value = ${JSON.stringify(value)}; return typeof(value)`;
            const result = await luneBridge.execute(code);
            return result.success ? result.result : "unknown";
        };
    } else {
        // Fallback to mock implementation
        return (value: any) => {
            if (value === null || value === undefined) return "nil";
            if (typeof value === "object" && Array.isArray(value)) return "table";
            if (typeof value === "object") return "table";
            return typeof value;
        };
    }
};

// Enhanced tick function
export const createTick = () => {
    if (useLuneForRobloxGlobals && luneBridge) {
        return async () => {
            const result = await luneBridge.execute("return tick()");
            return result.success ? result.result : Date.now() / 1000;
        };
    } else {
        // Fallback to mock
        return () => Date.now() / 1000;
    }
};

// Enhanced wait function
export const createWait = () => {
    if (useLuneForRobloxGlobals && luneBridge) {
        return async (duration: number = 0) => {
            const result = await luneBridge.execute(`return wait(${duration})`);
            return result.success ? result.result : 0;
        };
    } else {
        // Fallback to mock (no actual waiting in tests)
        return (duration: number = 0) => Promise.resolve(0);
    }
};

// Enhanced task library
export const createTask = () => {
    if (useLuneForRobloxGlobals && luneBridge) {
        return {
            spawn: async (func: Function, ...args: any[]) => {
                // For Lune execution, we need to serialize the function
                const funcString = func.toString();
                const argsString = JSON.stringify(args);
                const code = `
                    local func = ${funcString}
                    local args = ${argsString}
                    return task.spawn(func, unpack(args))
                `;
                const result = await luneBridge.execute(code);
                return result.success ? result.result : null;
            },
            defer: async (func: Function, ...args: any[]) => {
                const funcString = func.toString();
                const argsString = JSON.stringify(args);
                const code = `
                    local func = ${funcString}
                    local args = ${argsString}
                    return task.defer(func, unpack(args))
                `;
                const result = await luneBridge.execute(code);
                return result.success ? result.result : null;
            },
            wait: async (duration: number = 0) => {
                const result = await luneBridge.execute(`return task.wait(${duration})`);
                return result.success ? result.result : 0;
            }
        };
    } else {
        // Fallback to mock implementation
        return {
            spawn: (func: Function, ...args: any[]) => {
                // Simple mock - just call the function
                try {
                    func(...args);
                    return {};
                } catch (error) {
                    console.warn("Mock task.spawn error:", error);
                    return {};
                }
            },
            defer: (func: Function, ...args: any[]) => {
                // Simple mock - defer with setTimeout
                setTimeout(() => {
                    try {
                        func(...args);
                    } catch (error) {
                        console.warn("Mock task.defer error:", error);
                    }
                }, 0);
                return {};
            },
            wait: (duration: number = 0) => Promise.resolve(0)
        };
    }
};

// Utility to execute arbitrary Luau code in Lune
export const executeLuauCode = async (code: string) => {
    if (useLuneForRobloxGlobals && luneBridge) {
        return await luneBridge.execute(code);
    } else {
        throw new Error("Lune execution not available. Set JEST_USE_LUNE=true to enable.");
    }
};

// Function to switch execution mode (useful for testing)
export const setLuneMode = (enabled: boolean) => {
    useLuneForRobloxGlobals = enabled;
    if (enabled && !luneBridge) {
        luneBridge = new LuneBridgeService();
    }
};

// Function to check if Lune mode is active
export const isLuneModeActive = () => useLuneForRobloxGlobals;

// Export the bridge for direct access if needed
export const getLuneBridge = () => luneBridge;
