-- nightbed test log
--[[
	Version Info
		a = alpha
		pr = pre release
		fr = full release
		bt = beta test
		b = beta
		dl = dev log
		d = demo
		t = test
--]]
local NBFolder = function(folder)
	if isfolder(folder) == false then
		makefolder(folder)
	end
end

if isfolder("Nightbed") == false then
	makefolder("Nightbed")
end
NBFolder("Nightbed/CustomModules")
NBFolder("Nightbed/Core")
NBFolder("Nightbed/assets")
NBFolder("Nightbed/Profiles")

local githubRequest = function(scripturl)
	if (not isfile("Nightbed/"..scripturl)) then
		local suc,res = pcall(function()
			return game:HttpGet("https://raw.githubusercontent.com/NTDCore/NightbedForRoblox/"..readfile("Nightbed/commit.txt").."/"..scripturl, true)
		end)
		if scripturl:find(".lua") then
			res = "-- Watermask When Updated\n"..res
		end
		writefile("Nightbed/"..scripturl, res)
	end
	return readfile("Nightbed/"..scripturl)
end

local Service = function(name)
	return game:GetService(name)
end
local nightbedService = {
	["Version"] = "1.0dl",
	["Injected"] = true,
	["Assets"] = {
		["Cape.png"] = "rbxthumb://type=Asset&id=" .. 14391871286 .. "&w=420&h=420"
	}
}
local nightbedStore = {
	["GuiLibrary"] = {
		["Kavo"] = loadstring(githubRequest("Core/kavo.lua"))()
	},
	["Core"] = {
		["FunctionsLibrary"] = loadstring(githubRequest("Core/FunctionsHandler.lua"))(),
		["entity"] = loadstring(game:HttpGet("https://raw.githubusercontent.com/7GrandDadPGN/VapeV4ForRoblox/main/Libraries/entityHandler.lua", true))(),
		["sha"] = loadstring(githubRequest("Core/sha.lua"))()
	}
}
local robloxService = {
	["InputService"] = Service("UserInputService"),
	["ReplicatedStorage"] = Service("ReplicatedStorage"),
	["Game"] = {
		["PlaceId"] = game.PlaceId
	}
}
local executorService = {
	["queueteleport"] = queue_on_teleport
}
local getStore = function(store, store1)
	return nightbedStore[store][store1]
end

shared.NBStore = nightbedStore
shared.rblxService = robloxService
shared.executorService = executorService
shared.NBService = nightbedService
shared.NBAssets = nightbedService["Assets"]
shared.funcslib = getStore("Core", "FunctionsLibrary")
shared.vapeentity = getStore("Core", "entity")
shared.shalib = getStore("Core", "sha")
local customasset = function(asset)
	return nightbedService["Assets"][asset] or ""
end
getgenv().loadAsset = customasset
local nightbedConsole = function(message)
	print("[NIGHTBED]: "..message)
end

local NBFolder = function(folder)
	if isfolder(folder) == false then
		makefolder(folder)
	end
end

if isfolder("Nightbed") then
	task.wait()
	nightbedConsole("Loading...")
	task.wait(1)
	nightbedConsole("Success! Loaded")
end

local commit = "main"
for i,v in pairs(game:HttpGet("https://github.com/NTDCore/NightbedForRoblox"):split("\n")) do 
	if v:find("commit") and v:find("fragment") then 
		local str = v:split("/")[5]
		commit = str:sub(0, str:find('"') - 1)
		break
	end
end
if isfolder("Nightbed") then 
	if ((not isfile("Nightbed/commit.txt")) or (readfile("Nightbed/commit.txt") ~= commit or commit == "main")) then
		for i,v in pairs({"Nightbed/Universal.lua", "Nightbed/MainScript.lua"}) do 
			if isfile(v) and ({readfile(v):find("-- Watermask When Updated")})[1] == 1 then
				delfile(v)
			end 
		end
		if isfolder("Nightbed/CustomModules") then 
			for i,v in pairs(listfiles("Nightbed/CustomModules")) do 
				if isfile(v) and ({readfile(v):find("-- Watermask When Updated")})[1] == 1 then
					delfile(v)
				end 
			end
		end
		if isfolder("Nightbed/Core") then 
			for i,v in pairs(listfiles("Nightbed/Core")) do 
				if isfile(v) and ({readfile(v):find("-- Watermask When Updated")})[1] == 1 then
					delfile(v)
				end 
			end
		end
		writefile("Nightbed/commit.txt", commit)
	end
else
	writefile("Nightbed/commit.txt", commit)
end

loadstring(githubRequest("MainScript.lua"))()