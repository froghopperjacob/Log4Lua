return function()
	local FDK = require(script.Parent.Parent.src.FDK)

	FDK:wrapEnvironment(getfenv())

	local LogClass = import("org.log4lua.Log")

	local Test = BaseClass:new("Test")

	local config, noLog, Log, ClassLog, BadLog, NoLog = {
		["Debug"] = true,

		["FunctionCalls"] = {
			["Debug"] = function() return 1 end,
			["Info"] = function() return 2 end,
			["Warn"] = function() return 3 end,
			["Error"] = function() return 4 end
		}
	}, {
		["Debug"] = false,
		["Info"] = false,
		["Warn"] = false,
		["Error"] = false
	}, nil, nil, nil, nil

	--print(ClassLog:atDebug())

	describe("Log", function()
		it("should be ok", function()
			expect(LogClass).to.be.ok()
		end)

		describe("Error checking", function()
			it("should fail with no config", function()
				expect(function()
					LogClass:getLogger({})
				end).to.throw()
			end)

			it("should give default config for invalid config", function()
				expect(function()
					 BadLog = LogClass("a")
				end).never.to.throw()
			end)

			it("should fail with non string message", function()
				expect(BadLog:getLogger(Test):debug(123)).to.equal(false)
			end)
		end)

		it("should use the log correctly", function()
			expect(function()
				Log = LogClass(config)
			end).never.to.throw()
		end)

		it("should create the handler properly", function()
			expect(function()
				ClassLog = Log:getLogger(Test)
			end).never.to.throw()

			expect(ClassLog).to.be.ok()
		end)

		describe("ClassLog", function()
			describe("Debug", function()
				it("atDebug should log", function()
					expect(ClassLog:atDebug()
						:log("asd")).to.equal(1)
				end)

				it("atDebug should log with arguments", function()
					expect(ClassLog:atDebug()
						:addArgument("asd")
						:log("{} {}")).to.equal(1)
				end)

				it("debug should log", function()
					expect(ClassLog:debug("t")).to.equal(1)
				end)

				it("debug should log with arguments", function()
					expect(ClassLog:debug("t {} {}", 't')).to.equal(1)
				end)
			end)

			describe("Info", function()
				it("atInfo should log", function()
					expect(ClassLog:atInfo()
						:log("asd")).to.equal(2)
				end)

				it("atInfo should log with arguments", function()
					expect(ClassLog:atInfo()
						:addArgument("asd")
						:log("{} {}")).to.equal(2)
				end)

				it("info should log", function()
					expect(ClassLog:info("t")).to.equal(2)
				end)

				it("info should log with arguments", function()
					expect(ClassLog:info("t {} {}", 't')).to.equal(2)
				end)
			end)

			describe("Warn", function()
				it("atWarn should log", function()
					expect(ClassLog:atWarn()
						:log("asd")).to.equal(3)
				end)

				it("atWarn should log with arguments", function()
					expect(ClassLog:atWarn()
						:addArgument("t")
						:log("{} {}")).to.equal(3)
				end)

				it("warn should log", function()
					expect(ClassLog:warn("t")).to.equal(3)
				end)

				it("warn should log with arguments", function()
					expect(ClassLog:warn("t {} {}", 't')).to.equal(3)
				end)
			end)

			describe("Error", function()
				it("atError should log", function()
					expect(ClassLog:atError()
						:log("asd")).to.equal(4)
				end)

				it("atError should log with arguments", function()
					expect(ClassLog:atError()
						:addArgument("asd")
						:log("{} {}")).to.equal(4)
				end)

				it("error should log", function()
					expect(ClassLog:error("t")).to.equal(4)
				end)

				it("error should log with arguments", function()
					expect(ClassLog:error("t {} {}", 't')).to.equal(4)
				end)
			end)

			it("should concat tables", function()
				expect(ClassLog:debug("{}", {1,2,3,4})).to.equal(1)
			end)

			it("should tostring non string/table arguments", function()
				expect(ClassLog:debug("{}", 1)).to.equal(1)
			end)

			describe("Fakelogger", function()
				NoLog = LogClass(noLog)
				local NoLogClass = NoLog:getLogger(Test)

				it("false for debug", function()
					expect(NoLogClass:debug()).to.equal(false)
				end)

				it("false for info", function()
					expect(NoLogClass:info()).to.equal(false)
				end)

				it("false for warn", function()
					expect(NoLogClass:warn()).to.equal(false)
				end)

				it("false for error", function()
					expect(NoLogClass:error()).to.equal(false)
				end)

				it("false for atDebug", function()
					expect(NoLogClass:atDebug():addArgument():log()).to.equal(false)
				end)

				it("false for atInfo", function()
					expect(NoLogClass:atInfo():addArgument():log()).to.equal(false)
				end)

				it("false for atWarn", function()
					expect(NoLogClass:atWarn():addArgument():log()).to.equal(false)
				end)

				it("false for atError", function()
					expect(NoLogClass:atError():addArgument():log()).to.equal(false)
				end)
			end)

			it("should destroy properly", function()
				expect(function()
					Log:destroy()
					BadLog:destroy()
					NoLog:destroy()
				end).never.to.throw()
			end)
		end)
	end)
end