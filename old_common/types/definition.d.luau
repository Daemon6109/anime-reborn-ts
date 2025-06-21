local DataTemplate = require("@data/data_template")

export type ProductCallback = (Player, number) -> nil
export type ReceiptInfo = {
	PurchaseId: string, -- A unique identifier for the specific purchase
	PlayerId: number, -- The ID of the player who made the purchase
	ProductId: number, -- The ID of the purchased product
	CurrencySpent: number, -- The amount of currency spent in the purchase
	CurrencyType: Enum.CurrencyType, -- The type of currency spent in the purchase; always Enum.CurrencyType.Robux
	PlaceIdWherePurchased: number, -- The ID of the place where the product was purchased (not necessarily the same as the current place's ID)
}
export type Callback = () -> ...any
export type DataTemplate = typeof(DataTemplate)
export type PrivacyType = "Public" | "Private"
export type EffectData = { StartTime: number, Duration: number }
export type EffectsData = {
	[Multiplier]: EffectData,
}
export type Effects = {
	[Multiplier]: Effect,
}
export type Effect = {
	Icon: string,
	Gradient: Instance,
	Description: string,
	DisplayName: string,
	Multiplier: { Multiplier: number },
}

export type Multiplier = "BannerLuck" | "Exp" | "ShinyBoost" | "LegendsBoost" | "MegaLuck" | "SuperLuck"

return
