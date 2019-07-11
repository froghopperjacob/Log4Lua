local fakeLogger = {
	addArgument = function(self)
		return self
	end,

	log = function()
		return false
	end
}

local deepCopy
deepCopy = function(orig)
	local originalType, copy = typeof(orig), { }

	if (originalType == 'table') then
		for originalKey, originalValue in next, orig, nil do
			copy[deepCopy(originalKey)] = deepCopy(originalValue)
		end

		setmetatable(copy, deepCopy(getmetatable(orig)))
	else
		copy = orig
	end

	return copy
end

return function()
	local ClassLog = BaseClass:new("ClassLog")

	local Logger = import("org.log4lua.Logger")

	ClassLog.ClassLog = function(self, config, class)
		self.config = config
		self.class = class

		return self
	end

	-- Ats
	ClassLog.__atLog = function(self, func, typeL)
		return Logger(func, typeL, self.class, self.config)
	end

	ClassLog.atDebug = function(self)
		if (not self.config["Debug"]) then
			return deepCopy(fakeLogger)
		end

		return self:__atLog(self.config["FunctionCalls"]["Debug"], "Debug")
	end

	ClassLog.atInfo = function(self)
		if (not self.config["Info"]) then
			return deepCopy(fakeLogger)
		end

		return self:__atLog(self.config["FunctionCalls"]["Info"], "Info")
	end

	ClassLog.atWarn = function(self)
		if (not self.config["Warn"]) then
			return deepCopy(fakeLogger)
		end

		return self:__atLog(self.config["FunctionCalls"]["Warn"], "Warn")
	end

	ClassLog.atError = function(self)
		if (not self.config["Error"]) then
			return deepCopy(fakeLogger)
		end

		return self:__atLog(self.config["FunctionCalls"]["Error"], "Error")
	end

	-- Functions that invoke the Ats
	ClassLog.__log = function(self, func, message, arguments, typeL)
		local newLogger = self:__atLog(func, typeL)

		for _, argument in pairs(arguments) do
			newLogger:addArgument(argument)
		end

		return newLogger:log(message)
	end

	ClassLog.debug = function(self, message, ...)
		if (not self.config["Debug"]) then
			return false
		end

		return self:__log(self.config["FunctionCalls"]["Debug"], message, { ... }, "Debug")
	end

	ClassLog.info = function(self, message, ...)
		if (not self.config["Info"]) then
			return false
		end

		return self:__log(self.config["FunctionCalls"]["Info"], message, { ... }, "Info")
	end

	ClassLog.warn = function(self, message, ...)
		if (not self.config["Warn"]) then
			return false
		end

		return self:__log(self.config["FunctionCalls"]["Warn"], message, { ... }, "Warn")
	end

	ClassLog.error = function(self, message, ...)
		if (not self.config["Error"]) then
			return false
		end

		return self:__log(self.config["FunctionCalls"]["Error"], message, { ... }, "Error")
	end

	ClassLog.destroy = function(self)
		return self:unregister()
	end

	return ClassLog
end