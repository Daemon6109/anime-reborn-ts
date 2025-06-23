// Mock for @rbxts/lemon-signal
// This provides a compatible Signal implementation for Jest testing

class MockSignal {
	constructor() {
		this.connections = [];
	}

	Connect(callback) {
		const connection = {
			callback,
			connected: true,
			Disconnect() {
				this.connected = false;
			},
		};
		this.connections.push(connection);
		return connection;
	}

	Fire(...args) {
		this.connections.forEach((connection) => {
			if (connection.connected) {
				connection.callback(...args);
			}
		});
	}

	Wait() {
		return Promise.resolve();
	}
}

module.exports = {
	Signal: MockSignal,
};
