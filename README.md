<h1 align="center">Log4Lua</h1>
<div align="center">
	<a href="https://github.com/froghopperjacob/Log4Lua/tree/master/LICENSE">
		<img src="https://img.shields.io/badge/License-Apache%202.0-brightgreen.svg?style=flat-square" alt="Lisence" />
	</a>
	<a href="https://travis-ci.com/froghopperjacob/Log4Lua">
		<img src="https://img.shields.io/travis/com/froghopperjacob/Log4Lua.svg?style=flat-square" alt="Travis" />
	</a>
	<a href="https://coveralls.io/github/froghopperjacob/Log4Lua?branch=master">
		<img src="https://img.shields.io/coveralls/github/froghopperjacob/Log4Lua.svg?style=flat-square" alt="Coveralls" />
	</a>
</div>

<div align="center">
	Log4Lua is a small logger that acts like <a href="https://www.slf4j.org/">SLF4J</a>.
</div>

<div>&nbsp;</div>

## Index

1. [Setup](#Setup)
2. [Usage](#Usage)
3. [Examples](#Examples)

## Setup
1. Install [FDK](https://github.com/TheFlamingBlaster/FDK).
2. Install Log4Lua through FDK's plugin OR the [releases](https://github.com/froghopperjacob/Log4Lua/releases).

## Usage
Importing Log4Lua:
```lua
local Log4Lua = import("org.fdk.log4lua.Log")
```

After importing it you need to provide a valid config file
The default config file that is provided is:
```lua
local defaultConfig = {
	["Debug"] = false,
	["Info"] = true,
	["Warn"] = true,
	["Error"] = true,

	["IncludeTime"] = true,

	["Pattern"] = "[%TYPE% | %TIME% | %CLASS%] - %MESSAGE%",
	["ReplacePattern"] = "{}"

	["FunctionCalls"] = {
		["Debug"] = print,
		["Info"] = print,
		["Warn"] = warn,
		["Error"] = error
	}
}
```

Getting the log handler:
```lua
local Handler = Log4Lua:getLogger(Class)
```

The handler allows you to directly log like:
```lua
Handler:warn("1 {} 3 {}", 2, 4) -- 1 2 3 4
```

The handler allows you to also use functions like:
```lua
Handler:atDebug()
	:addArgument("40°")
	:log("It is currently {}")
```

## Examples
Main Class:
```lua
local logConfig = {
	["Debug"] = true
}

return function()
	local Main = BaseClass:new("Main")

	local Log4Lua = import("org.fdk.log4lua.Log")(logConfig)
	local Handler = Log4Lua:getLogger(Main)

	Main.hello = function(name)
		return Handler:info("Hello {}!", name)
	end

	return Main
end
```

Other Class:
```lua
return function()
	local Other = BaseClass:new("Other")
	local Handler = import("org.fdk.log4lua.Log"):getLogger(Other)

	Other.bye = function(name)
		return Handler.atDebug()
			:addArgument(name)
			:log("Bye {}!")
	end

	return Other
end
```

Running:
```lua
local FDKModule = game:GetService("ReplicatedStorage"):FindFirstChild("FDK")
local FDK = require(fdkModule)
FDK:wra pEnvironment(getfenv())

local Main = import("game.Main")
local Other = import("game.Other")

Main.hello("World") -- This would return true and print: [INFO | TIME | Main] - Hello World!

Other.bye("World") -- This would return true and print: [DEBUG | TIME | Other] - Bye World!
