-- credit to xylex (ty for isfile fix?)
repeat task.wait() until game:IsLoaded()
function githubRequest(scripturl)
	return game:HttpGet('https://raw.githubusercontent.com/NTDCore/NightbedForRoblox/main/'..scripturl, true)
end
local isfile = isfile or function(path)
	local suc, res = pcall(function() return readfile(path) end)
	return suc and res ~= nil 
end
local nightbedStore = shared.NBStore
local kavo
kavo = nightbedStore['GuiLibrary'].Kavo
shared.kavogui = kavo
local win = kavo:CreateWindow({
	['Title'] = 'Nightbed v'..shared.NBService['Version'],
	['Theme'] = (shared.CustomTheme and shared.SetCustomTheme or 'Luna')
})
local Tabs = {
	['Combat'] = win.CreateTab('Combat'),
	['Blatant'] = win.CreateTab('Blatant'),
	['Render'] = win.CreateTab('Render'),
	['Utility'] = win.CreateTab('Utility'),
	['World'] = win.CreateTab('World')
}
shared.Tabs = Tabs

local cloneref = cloneref or function(obj) return obj end
local playersService = cloneref(game:GetService('Players'))
local lplr = playersService.LocalPlayer
local httpService = cloneref(game:GetService('HttpService'))
local starterUI = cloneref(game:GetService('StarterGui'))

function MainLoaded()
	local customModuleURL = 'https://raw.githubusercontent.com/NTDCore/NightbedForRoblox/main/CustomModules/'..game.PlaceId..'.lua'
	local customModuleScript = game:HttpGet(customModuleURL, true)
	if customModuleScript then
		local success, error = pcall(function()
			loadstring(customModuleScript)()
		end)
		if not success then
			warn('Failed To Loaded Modules: ' .. tostring(error))
			loadstring(githubRequest('Universal.lua'))()
		end
	end
end

MainLoaded()

task.spawn(function()
	nightbedData = httpService:JSONDecode(game:HttpGet('https://raw.githubusercontent.com/NTDCore/NightbedForRoblox/main/Core/nightbeddata.json'))
	for i,v in nightbedData.Blacklist do	
		if tonumber(v) == lplr.UserId then
			lplr:Kick(v[lplr.UserId].Reason)
		end
	end	
	local nbAnnouncement = nightbedData.Announcement
	if nbAnnouncement.Use then
		repeat
			starterUI:SetCore('SendNotification', {
				Title = 'Nightbed',
				Text = nbAnnouncement.Message
				Duration = nbAnnouncement.Wait
			})
			task.wait(nbAnnouncement.Wait)
		until (not nbAnnouncement.Use)
	end
end)