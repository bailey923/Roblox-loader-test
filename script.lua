local model = script.Parent  -- the model this script is inside of
local part = model:FindFirstChild("Part")  -- change "Part" to your part's name

if part then
    part:Destroy()
else
    warn("Part not found in model!")
end


