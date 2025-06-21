export type TagDataType = {
	
	TagText : string,
	TagColor : Color3 | ColorSequence | Instance,
	ProductId : string,
	GroupRank : string,
}

local registry = _G.Registry.registry
local GradientRegistry = registry.GradientAnimations

local module = {
	{
		TagText = 'Owner',
		TagColor = 'Owner',
		GroupRank = 'Owner'

	},
	
	{
		TagText = 'Co-Owner',
		TagColor = 'Co-Owner',
		GroupRank = 'Co-Owner'

	},
	
	{
		TagText = 'Project Leader',
		TagColor = 'Project Leader',
		GroupRank = 'Project Leader'

	},
	{
		TagText = 'Developer+',
		TagColor = 'Developer+',
		GroupRank = 'Developer+',

	},
	{
		TagText = 'Developer',
		TagColor = 'Developer',
		GroupRank = 'Developer'

	},
	{
		TagText = 'Admin',
		TagColor = 'Admin',
		GroupRank = 'Admin'

	},
	{
		TagText = 'Moderator',
		TagColor = 'Moderator',
		GroupRank = 'Moderator'

	},
	{
		TagText = 'Tester',
		TagColor = 'Tester',
		GroupRank = 'Tester'

	},
	{
		TagText = 'Tester+',
		TagColor = 'Closed Tester',
		GroupRank = '[CLOSED] Tester'

	},
	{
		TagText = 'Contributor',
		TagColor = 'Early Bird',
		GroupRank = 'Contributor'

	},
	{
		TagText = 'Content Creator',
		TagColor = 'Content Creator',
		GroupRank = 'Content Creator'

	},
	{
		TagText = 'Early Bird',
		TagColor = 'Early Bird',
		GroupRank = 'Early Bird'

	},	

	{
		TagText = 'VIP',
		TagColor = 'Mythical',
		ProductId = '887686872',
	},
	
	
}:: {[number]: TagDataType}



return module
