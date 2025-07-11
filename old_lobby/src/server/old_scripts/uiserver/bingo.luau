local Bingo = {
	ClaimSquare = function(...)
		_G.serverServices.BingoService:ClaimSquare(...)
	end,
	ClaimRow = function(...)
		_G.serverServices.BingoService:ClaimRow(...)
	end,
}

return Bingo
