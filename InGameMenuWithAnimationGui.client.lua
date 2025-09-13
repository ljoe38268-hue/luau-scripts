-- IN-GAME MENU WITH ANIMATION GUI INTEGRATION
-- Put this LocalScript in StarterPlayer > StarterPlayerScripts
-- Press M to open/close menu

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local isMenuOpen = false

local function findAnimationGui()
    -- Look for AnimationGui in PlayerGui first
    local animGui = playerGui:FindFirstChild("AnimationGui")
    if animGui then
        return animGui
    end
    
    -- Look in StarterGui as backup
    local starterGui = game:GetService("StarterGui")
    animGui = starterGui:FindFirstChild("AnimationGui")
    if animGui then
        return animGui
    end
    
    return nil
end

local function createInGameMenu()
    local character = player.Character
    if not character then return end
    
    -- Use the head as our menu part (always exists)
    local head = character:FindFirstChild("Head")
    if not head then return end
    
    -- Remove old menu if it exists
    local oldMenu = head:FindFirstChild("InGameMenu")
    if oldMenu then oldMenu:Destroy() end
    
    -- Create the SurfaceGui
    local surfaceGui = Instance.new("SurfaceGui")
    surfaceGui.Name = "InGameMenu"
    surfaceGui.Parent = head
    surfaceGui.Face = Enum.NormalId.Front
    surfaceGui.AlwaysOnTop = true
    surfaceGui.LightInfluence = 0
    surfaceGui.CanvasSize = Vector2.new(800, 600)
    surfaceGui.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
    surfaceGui.PixelsPerStud = 50
    
    -- Create the main container frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainContainer"
    mainFrame.Size = UDim2.new(1, 0, 1, 0)
    mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30) -- Dark background
    mainFrame.BorderSizePixel = 3
    mainFrame.BorderColor3 = Color3.fromRGB(0, 255, 255) -- Cyan border
    mainFrame.Parent = surfaceGui
    
    -- Add a title bar
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0.1, 0)
    titleBar.Position = UDim2.new(0, 0, 0, 0)
    titleBar.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(0.8, 0, 1, 0)
    titleLabel.Position = UDim2.new(0, 0, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "IN-GAME MENU (Press M to close)"
    titleLabel.TextColor3 = Color3.new(1, 1, 1)
    titleLabel.TextScaled = true
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Parent = titleBar
    
    -- Add close button in title bar
    local closeButton = Instance.new("TextButton")
    closeButton.Size = UDim2.new(0.2, 0, 1, 0)
    closeButton.Position = UDim2.new(0.8, 0, 0, 0)
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    closeButton.Text = "X"
    closeButton.TextColor3 = Color3.new(1, 1, 1)
    closeButton.TextScaled = true
    closeButton.Font = Enum.Font.GothamBold
    closeButton.BorderSizePixel = 0
    closeButton.Parent = titleBar
    
    -- Content area for AnimationGui
    local contentFrame = Instance.new("Frame")
    contentFrame.Name = "ContentFrame"
    contentFrame.Size = UDim2.new(1, 0, 0.9, 0)
    contentFrame.Position = UDim2.new(0, 0, 0.1, 0)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Parent = mainFrame
    
    -- Try to load AnimationGui content
    local animGui = findAnimationGui()
    if animGui then
        print("✅ Found AnimationGui! Loading content...")
        
        -- Clone all GUI elements from AnimationGui
        for _, child in ipairs(animGui:GetChildren()) do
            if child:IsA("GuiBase2d") or child:IsA("UIBase") then
                local clone = child:Clone()
                clone.Parent = contentFrame
                print("📋 Cloned:", child.Name, "from AnimationGui")
            end
        end
        
        -- Try to hide the original AnimationGui so it doesn't show twice
        if animGui:IsA("ScreenGui") then
            animGui.Enabled = false
        elseif animGui:IsA("GuiObject") then
            animGui.Visible = false
        end
        
        print("🎯 AnimationGui content loaded into in-game menu!")
    else
        -- Fallback content if no AnimationGui found
        print("⚠️ AnimationGui not found! Creating fallback content...")
        
        local fallbackLabel = Instance.new("TextLabel")
        fallbackLabel.Size = UDim2.new(1, 0, 1, 0)
        fallbackLabel.BackgroundTransparency = 1
        fallbackLabel.Text = "AnimationGui not found!\n\nCreate a ScreenGui named 'AnimationGui'\nin PlayerGui or StarterGui\nto see your custom content here."
        fallbackLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
        fallbackLabel.TextScaled = true
        fallbackLabel.Font = Enum.Font.Gotham
        fallbackLabel.Parent = contentFrame
    end
    
    -- Close button functionality
    closeButton.MouseButton1Click:Connect(function()
        closeMenu()
    end)
    
    print("✅ IN-GAME MENU CREATED! Press M to close.")
    return surfaceGui
end

local function openMenu()
    if isMenuOpen then return end
    
    local menuGui = createInGameMenu()
    if menuGui then
        isMenuOpen = true
        print("🟢 MENU OPENED with M key! Look for the cyan-bordered panel!")
        
        -- Disable player movement
        local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.PlatformStand = true
        end
    end
end

function closeMenu()
    if not isMenuOpen then return end
    
    local character = player.Character
    if character then
        local head = character:FindFirstChild("Head")
        if head then
            local menu = head:FindFirstChild("InGameMenu")
            if menu then
                menu:Destroy()
                print("🔴 MENU CLOSED with M key")
            end
        end
        
        -- Re-enable player movement
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.PlatformStand = false
        end
        
        -- Re-show the original AnimationGui if it exists
        local animGui = findAnimationGui()
        if animGui then
            if animGui:IsA("ScreenGui") then
                animGui.Enabled = true
            elseif animGui:IsA("GuiObject") then
                animGui.Visible = true
            end
        end
    end
    
    isMenuOpen = false
end

-- Handle input - PRESS M TO OPEN/CLOSE
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.M then
        if isMenuOpen then
            closeMenu()
        else
            openMenu()
        end
    end
end)

-- Handle respawning
player.CharacterAdded:Connect(function()
    isMenuOpen = false -- Reset menu state
    wait(1) -- Wait for character to fully load
end)

print("🚀 IN-GAME MENU SCRIPT LOADED!")
print("📋 Press M to open menu and load AnimationGui content!")
print("💡 Make sure you have a ScreenGui named 'AnimationGui' in PlayerGui or StarterGui!")