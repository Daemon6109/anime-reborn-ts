export type CollisionEventData = {
	Bought: { [string]: boolean },
}

local function createCollisionEventData(): CollisionEventData
	return {
		Bought = {},
	}
end

return createCollisionEventData
