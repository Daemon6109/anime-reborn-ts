// eslint-disable-next-line @typescript-eslint/no-explicit-any
export type AnyFunction = (...args: any[]) => any;
// eslint-disable-next-line @typescript-eslint/no-explicit-any
export type AnyAsyncFunction = (...args: any[]) => Promise<any>;

export interface RetryResult<T = unknown> {
	success: boolean;
	value?: T;
	error?: unknown;
	attempts: number;
}

export interface RetryOptions<T extends AnyFunction | AnyAsyncFunction> {
	/** Maximum number of attempts. */
	maxAttempts: number;
	/** Constant pause time in seconds between attempts (default: 0). */
	pauseConstant?: number;
	/** Exponent to increase pause time between attempts (default: 0). Pause time = pauseConstant + (pauseExponent ^ attemptNumber). */
	pauseExponent?: number;
	/**
	 * Optional handler to call the function.
	 * If not provided, a standard try-catch (for sync) or promise catch (for async) will be used.
	 * The handler should return a tuple: [success: boolean, ...results: any[]].
	 */
	// eslint-disable-next-line @typescript-eslint/no-explicit-any
	functionCallHandler?: (fn: T, ...args: Parameters<T>) => [boolean, ...any[]];

	/**
	 * Optional handler to await the function if it's known to be async and the default
	 * Promise handling isn't sufficient (e.g., if functionCallHandler is also used for an async fn).
	 * Should return: [success: boolean, ...results: any[]]
	 */
	// eslint-disable-next-line @typescript-eslint/no-explicit-any
	asyncFunctionCallHandler?: (fn: T, ...args: Parameters<T>) => Promise<[boolean, ...any[]]>;

	/**
	 * A callback function that is invoked after each failed attempt.
	 * It receives the error and the current attempt number.
	 * If this function returns `false`, the retry loop will be stopped immediately.
	 */
	onRetry?: (error: unknown, attempt: number) => boolean | void | Promise<boolean | void>;
}

/**
 * Promisified version of task.wait for use in async functions.
 * @param seconds Time to wait in seconds.
 */
function delay(seconds: number): Promise<void> {
	return new Promise((resolve) => task.wait(seconds, resolve));
}

/**
 * Attempts to execute a given function multiple times until it succeeds or the maximum number of attempts is reached.
 * Supports exponential backoff. This version is for SYNCHRONOUS functions.
 *
 * @param func The synchronous function to be executed.
 * @param options Configuration for retry attempts.
 * @param args Arguments to pass to the function.
 * @returns A Promise resolving to an object indicating success, the function's return value or error, and attempts count.
 */
export async function retrySync<TFunc extends AnyFunction>(
	func: TFunc,
	options: RetryOptions<TFunc>,
	...args: Parameters<TFunc>
): Promise<RetryResult<ReturnType<TFunc>>> {
	const { maxAttempts, pauseConstant = 0, pauseExponent = 0, functionCallHandler, onRetry } = options;
	let attempts = 0;
	let lastError: unknown;

	while (attempts < maxAttempts) {
		attempts++;
		try {
			let success: boolean;
			// eslint-disable-next-line @typescript-eslint/no-explicit-any
			let resultValues: any[];

			if (functionCallHandler) {
				const [s, ...r] = functionCallHandler(func, ...args);
				success = s;
				resultValues = r;
			} else {
				const result = func(...args);
				success = true;
				resultValues = [result];
			}

			if (success) {
				return {
					success: true,
					value: resultValues[0] as ReturnType<TFunc>, // Assuming single primary return value
					attempts,
				};
			}
			// If functionCallHandler returned success: false
			lastError = resultValues[0]; // Error message is the first result
		} catch (err) {
			lastError = err;
		}

		if (attempts < maxAttempts) {
			if (onRetry) {
				const shouldContinue = await onRetry(lastError, attempts);
				if (shouldContinue === false) {
					break;
				}
			}
			const pauseTime = pauseConstant + pauseExponent ** attempts;
			if (pauseTime > 0) {
				await delay(pauseTime);
			}
		}
	}

	return { success: false, error: lastError, attempts };
}

/**
 * Attempts to execute a given ASYNCHRONOUS function multiple times until it succeeds or the maximum number of attempts is reached.
 * Supports exponential backoff.
 *
 * @param func The asynchronous function to be executed.
 * @param options Configuration for retry attempts.
 * @param args Arguments to pass to the function.
 * @returns A Promise resolving to an object indicating success, the function's return value or error, and attempts count.
 */
export async function retryAsync<TFunc extends AnyAsyncFunction>(
	func: TFunc,
	options: RetryOptions<TFunc>,
	...args: Parameters<TFunc>
): Promise<RetryResult<Awaited<ReturnType<TFunc>>>> {
	const { maxAttempts, pauseConstant = 0, pauseExponent = 0, asyncFunctionCallHandler, onRetry } = options;
	let attempts = 0;
	let lastError: unknown;

	while (attempts < maxAttempts) {
		attempts++;
		try {
			let success: boolean;
			// eslint-disable-next-line @typescript-eslint/no-explicit-any
			let resultValues: any[];

			if (asyncFunctionCallHandler) {
				const [s, ...r] = await asyncFunctionCallHandler(func, ...args);
				success = s;
				resultValues = r;
			} else {
				const result = await func(...args);
				success = true;
				resultValues = [result];
			}

			if (success) {
				return {
					success: true,
					value: resultValues[0] as Awaited<ReturnType<TFunc>>, // Assuming single primary return value
					attempts,
				};
			}
			// If asyncFunctionCallHandler returned success: false
			lastError = resultValues[0]; // Error message is the first result
		} catch (err) {
			lastError = err;
		}

		if (attempts < maxAttempts) {
			if (onRetry) {
				const shouldContinue = await onRetry(lastError, attempts);
				if (shouldContinue === false) {
					break;
				}
			}
			const pauseTime = pauseConstant + pauseExponent ** attempts;
			if (pauseTime > 0) {
				await delay(pauseTime);
			}
		}
	}

	return { success: false, error: lastError, attempts };
}
