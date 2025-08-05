Class = setmetatable(
	{
		new = function(_ENV, tbl)
			return setmetatable(
				tbl or {}, {
					__index = _ENV
				}
			)
		end
	}, {
		__index = _ENV
	}
)