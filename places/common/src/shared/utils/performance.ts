// Performance monitoring utilities for data operations

interface PerformanceMetric {
	name: string;
	duration: number;
	timestamp: number;
}

class PerformanceMonitor {
	private enabled = false;
	private metrics: PerformanceMetric[] = [];

	public enable(): void {
		this.enabled = true;
	}

	public disable(): void {
		this.enabled = false;
	}

	public measure<T>(name: string, operation: () => T): T {
		if (!this.enabled) {
			return operation();
		}

		const startTime = tick();
		const result = operation();
		const endTime = tick();
		const duration = endTime - startTime;

		this.metrics.push({
			name,
			duration,
			timestamp: startTime,
		});

		return result;
	}

	public getMetrics(): PerformanceMetric[] {
		return [...this.metrics];
	}

	public clearMetrics(): void {
		this.metrics = [];
	}

	public printReport(): void {
		if (this.metrics.size() === 0) {
			print("No performance metrics recorded");
			return;
		}

		print("=== Performance Report ===");
		for (const metric of this.metrics) {
			print(`${metric.name}: ${metric.duration}ms at ${metric.timestamp}`);
		}

		const totalTime = this.metrics.reduce((sum, metric) => sum + metric.duration, 0);
		const avgTime = totalTime / this.metrics.size();
		print(`Total time: ${totalTime}ms, Average: ${avgTime}ms`);
		print("========================");
	}
}

export const performance = new PerformanceMonitor();
