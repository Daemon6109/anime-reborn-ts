local AnalyticsService = game:GetService("AnalyticsService")

return {
	Close = function(plr)
		if not plr:GetAttribute("ClosedUpdLogs") then
			plr:SetAttribute("ClosedUpdLogs", true)
			AnalyticsService:LogOnboardingFunnelStepEvent(plr, 3, "Closed Update Log")
		end
	end,
}
