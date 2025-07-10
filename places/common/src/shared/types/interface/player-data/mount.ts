export interface MountData {
	name: string;
	quantity: number;
	equipped: boolean;
	// Add other mount properties as needed
}

export interface Mount {
	ownedMounts: MountData[];
}

export default Mount;
