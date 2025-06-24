// eslint-disable-next-line @typescript-eslint/no-explicit-any
type AsyncFunction<T = any> = (...args: any[]) => Promise<T>;

/**
 * Takes an array of asynchronous functions (functions that return a Promise)
 * and returns a Promise that resolves or rejects with the result/error
 * of the first function in the array to settle.
 *
 * This is analogous to `Promise.race()` but takes functions that produce Promises.
 *
 * Note: This function does not cancel the other promises that do not win the race.
 * If cancellation is needed, the underlying asynchronous operations should support
 * cancellation (e.g., via AbortSignal).
 *
 * @param asyncFunctions An array of functions, each returning a Promise.
 * @param args Optional arguments to pass to each of the async functions.
 * @returns A Promise that resolves or rejects with the value or reason from the first promise to settle.
 * @template T The expected type of the resolved value from the promises.
 * @template TArgs The expected type of the arguments for the async functions.
 *
 * Example:
 * ```ts
 * const delay = (ms: number, value: string) => new Promise<string>(resolve => setTimeout(() => resolve(value), ms));
 *
 * const fn1 = () => delay(100, "one");
 * const fn2 = () => delay(50, "two");
 * const fn3 = () => delay(150, "three");
 *
 * waitForFirstAsync([fn1, fn2, fn3])
 *   .then(result => console.log(result)) // Expected: "two"
 *   .catch(error => console.error(error));
 *
 * const fnWithError = () => Promise.reject("error from fnWithError");
 * waitForFirstAsync([fn1, fnWithError, fn3])
 *   .then(result => console.log(result))
 *   .catch(error => console.error(error)); // Expected: "error from fnWithError"
 * ```
 */
export function waitForFirstAsync<T, TArgs extends unknown[] = []>(
	asyncFunctions: Array<(...args: TArgs) => Promise<T>>,
	...args: TArgs
): Promise<T> {
	if (!asyncFunctions || asyncFunctions.length === 0) {
		return Promise.reject(new Error("waitForFirstAsync requires at least one function."));
	}

	const promises = asyncFunctions.map((fn) => fn(...args));
	return Promise.race(promises);
}

/**
 * A more advanced version that allows passing an AbortSignal for cancellation.
 * If the signal is aborted, it will attempt to reject the race early.
 * Note: This does not automatically cancel the underlying operations within the
 * asyncFunctions unless they are designed to observe the AbortSignal.
 */
export function waitForFirstAsyncCancellable<T, TArgs extends unknown[] = []>(
	asyncFunctions: Array<(...args: TArgs) => Promise<T>>,
	signal?: AbortSignal,
	...args: TArgs
): Promise<T> {
	if (!asyncFunctions || asyncFunctions.length === 0) {
		return Promise.reject(new Error("waitForFirstAsyncCancellable requires at least one function."));
	}

	const promises = asyncFunctions.map((fn) => fn(...args));

	if (signal) {
		if (signal.aborted) {
			return Promise.reject(new DOMException("Aborted", "AbortError"));
		}
		return new Promise<T>((resolve, reject) => {
			const onAbort = () => {
				reject(new DOMException("Aborted", "AbortError"));
			};
			signal.addEventListener("abort", onAbort, { once: true });

			Promise.race(promises)
				.then((value) => {
					signal.removeEventListener("abort", onAbort);
					resolve(value);
				})
				.catch((error) => {
					signal.removeEventListener("abort", onAbort);
					reject(error);
				});
		});
	} else {
		return Promise.race(promises);
	}
}
