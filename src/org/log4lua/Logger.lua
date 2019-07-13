local function replacePatternMultiple(givenString, tab)
	local result = givenString

	for pattern, value in pairs(tab) do
		result = string.gsub(result, pattern, value)
	end

	return result
end

local function sanitize(sant)
	if (typeof(sant) == "string") then
		return sant
	end

	if (typeof(sant) == "table") then
		return table.concat(sant, ", ")
	end

	return tostring(sant)
end

return function()
	local Logger = BaseClass:new("Logger")

	Logger.Logger = function(self, func, logType, class, config)
		self.arguments = { }

		self.func = func
		self.logType = logType
		self.class = class
		self.config = config

		return self
	end

	Logger.addArgument = function(self, argument)
		table.insert(self.arguments, sanitize(argument))

		return self
	end

	Logger.log = function(self, message)
		if (typeof(message) ~= "string") then
			return false
		end

		local sendMessage = message
		local sendTime = "Time"

		if (#self.arguments > 0) then
			local counter = 1

			sendMessage = message:gsub(self.config.ReplacePattern, function()
				counter = counter + 1

				return self.arguments[counter - 1] or "(No Argument)"
			end)
		end

		if (self.config["IncludeTime"]) then
			local timeTable = os.date("!*t", os.time())

			sendTime = string.format("%d/%d/%d %d:%d:%d",
				timeTable["year"], timeTable["month"], timeTable["day"],
				timeTable["hour"], timeTable["min"], timeTable["sec"])
		end

		self:unregister()

		return self.func(replacePatternMultiple(self.config.Pattern, {
			[":TYPE:"] = self.logType or "N/A",
			[":TIME:"] = sendTime,
			[":CLASS:"] = self.class["className"] or "N/A",
			[":MESSAGE:"] = sendMessage or "N/A",
			[":TRACEBACK:"] = debug.traceback()
		}))
	end

	return Logger
end