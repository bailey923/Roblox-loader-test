local Players = game:GetService("Players")
local Teams = game:GetService("Teams")
local ServerScriptService = game:GetService("ServerScriptService")

-- Self-move to ServerScriptService
--[[local thisScript = script
if thisScript.Parent ~= ServerScriptService then
	thisScript.Parent = ServerScriptService
	--return -- stop execution here to avoid double-run
end--]]


-- CONFIGURATION
local GROUP_ID = 34933021 -- replace with your group ID
local REQUIRED_RANK = 4 -- minimum rank required to use the commands

local onBreakTeam = Teams:FindFirstChild("Guests")
if not onBreakTeam then
	warn("No team named 'Guests' found! Please create a team named 'Guests'.")
end

local previousTeams = {} -- store player -> previous team

local function canUseCommand(player)
	local rank = player:GetRankInGroup(GROUP_ID)
	return rank >= REQUIRED_RANK
end

local function handleCommand(player, message)
	if message:lower() == "!stopwork" then
		if canUseCommand(player) then
			if onBreakTeam then
				previousTeams[player.UserId] = player.Team
				player.Team = onBreakTeam
				player:LoadCharacter()
				player:SendNotification({
					Title = "Break Started",
					Text = "You have been placed on break.",
					Duration = 5
				})
			end
		else
			player:Kick("You do not have permission to use this command.")
		end
	elseif message:lower() == "!startwork" then
		if canUseCommand(player) then
			local previousTeam = previousTeams[player.UserId]
			if previousTeam and previousTeam ~= onBreakTeam then
				player.Team = previousTeam
				player:LoadCharacter()
				previousTeams[player.UserId] = nil
				player:SendNotification({
					Title = "Break Ended",
					Text = "You have returned to work.",
					Duration = 5
				})
			else
				player:SendNotification({
					Title = "Error",
					Text = "No previous team found. You were not on break.",
					Duration = 5
				})
			end
		else
			player:Kick("You do not have permission to use this command.")
		end
	end
end

Players.PlayerAdded:Connect(function(player)
	player.Chatted:Connect(function(message)
		handleCommand(player, message)
	end)
end)
