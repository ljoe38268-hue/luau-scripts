-- InGameMenuFix.lua
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local function createSurfaceGui(part)
    if not part then
        warn("Part is missing!")
        return nil
    end
    
    local surfaceGui = Instance.new("SurfaceGui", part)
    surfaceGui.Adornee = part
    surfaceGui.Face = Enum.NormalId.Front
    surfaceGui.CanvasSize = Vector2.new(200, 100)

    local frame = Instance.new("Frame", surfaceGui)
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- Bright red

    local textLabel = Instance.new("TextLabel", frame)
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.Text = "In-Game Menu"
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255) -- White text
    textLabel.BackgroundTransparency = 1

    return surfaceGui
end

local function onTabPressed()
    local player = Players.LocalPlayer
    if not player then
        warn("LocalPlayer is not found.")
        return
    end

    local character = player.Character
    if not character then
        warn("Player character is missing.")
        return
    end

    local part = character:FindFirstChild("Head") -- Change this to the desired part
    if not part then
        warn("Part 'Head' is missing from character.")
        return
    end

    print("Creating SurfaceGui on part: " .. part.Name)
    createSurfaceGui(part)
end

UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if input.KeyCode == Enum.KeyCode.Tab and not gameProcessedEvent then
        onTabPressed()
    end
end)

print("InGameMenuFix script loaded successfully.")
