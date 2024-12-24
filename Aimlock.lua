local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- Custom UI Library
local Library = {}

function Library:CreateWindow(title)
    local window = Instance.new("ScreenGui")
    local main = Instance.new("Frame")
    local titleLabel = Instance.new("TextLabel")
    local container = Instance.new("Frame")
    
    window.Name = "AimLockGui"
    window.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    
    main.Name = "Main"
    main.Size = UDim2.new(0, 300, 0, 400)
    main.Position = UDim2.new(0.5, -150, 0.5, -200)
    main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    main.Parent = window
    
    titleLabel.Text = title
    titleLabel.Size = UDim2.new(1, 0, 0, 30)
    titleLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.Parent = main
    
    container.Name = "Container"
    container.Size = UDim2.new(1, -20, 1, -40)
    container.Position = UDim2.new(0, 10, 0, 35)
    container.BackgroundTransparency = 1
    container.Parent = main
    
    return container
end

-- Create player info display
local function createPlayerInfo(parent)
    local infoFrame = Instance.new("Frame")
    local avatar = Instance.new("ImageLabel")
    local username = Instance.new("TextLabel")
    local health = Instance.new("TextLabel")
    local distance = Instance.new("TextLabel")
    
    infoFrame.Size = UDim2.new(1, 0, 0, 120)
    infoFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    infoFrame.Parent = parent
    
    avatar.Size = UDim2.new(0, 100, 0, 100)
    avatar.Position = UDim2.new(0, 10, 0, 10)
    avatar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    avatar.Parent = infoFrame
    
    username.Size = UDim2.new(0, 150, 0, 30)
    username.Position = UDim2.new(0, 120, 0, 10)
    username.BackgroundTransparency = 1
    username.TextColor3 = Color3.fromRGB(255, 255, 255)
    username.TextXAlignment = Enum.TextXAlignment.Left
    username.Parent = infoFrame
    
    health.Size = UDim2.new(0, 150, 0, 30)
    health.Position = UDim2.new(0, 120, 0, 45)
    health.BackgroundTransparency = 1
    health.TextColor3 = Color3.fromRGB(255, 255, 255)
    health.TextXAlignment = Enum.TextXAlignment.Left
    health.Parent = infoFrame
    
    distance.Size = UDim2.new(0, 150, 0, 30)
    distance.Position = UDim2.new(0, 120, 0, 80)
    distance.BackgroundTransparency = 1
    distance.TextColor3 = Color3.fromRGB(255, 255, 255)
    distance.TextXAlignment = Enum.TextXAlignment.Left
    distance.Parent = infoFrame
    
    return {
        avatar = avatar,
        username = username,
        health = health,
        distance = distance
    }
end

function Library:CreateToggle(parent, text, callback)
    local toggle = Instance.new("TextButton")
    local status = false
    
    toggle.Text = text
    toggle.Size = UDim2.new(1, 0, 0, 30)
    toggle.Position = UDim2.new(0, 0, 0, 130)
    toggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggle.Parent = parent
    
    toggle.MouseButton1Click:Connect(function()
        status = not status
        toggle.BackgroundColor3 = status and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(50, 50, 50)
        callback(status)
    end)
end

-- Main Script
local window = Library:CreateWindow("Aim Lock")
local playerInfo = createPlayerInfo(window)
local enabled = false
local target = nil

Library:CreateToggle(window, "Toggle Aim Lock", function(status)
    enabled = status
end)

-- Update player info
local function updatePlayerInfo(player)
    if player then
        -- Update avatar
        local userId = player.UserId
        local thumbType = Enum.ThumbnailType.HeadShot
        local thumbSize = Enum.ThumbnailSize.Size100x100
        local content = Players:GetUserThumbnailAsync(userId, thumbType, thumbSize)
        playerInfo.avatar.Image = content
        
        -- Update username
        playerInfo.username.Text = "Player: " .. player.Name
        
        -- Update health
        local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
        if humanoid then
            playerInfo.health.Text = "Health: " .. math.floor(humanoid.Health)
        end
        
        -- Update distance
        local distance = (player.Character.HumanoidRootPart.Position - Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
        playerInfo.distance.Text = "Distance: " .. math.floor(distance) .. " studs"
    else
        playerInfo.avatar.Image = ""
        playerInfo.username.Text = "No Target"
        playerInfo.health.Text = "Health: N/A"
        playerInfo.distance.Text = "Distance: N/A"
    end
end

-- Aim Lock Logic
local function getClosestPlayer()
    local closest = nil
    local shortestDistance = math.huge
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= Players.LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local distance = (player.Character.HumanoidRootPart.Position - Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
            if distance < shortestDistance then
                shortestDistance = distance
                closest = player
            end
        end
    end
    
    return closest
end

RunService.RenderStepped:Connect(function()
    if enabled and Players.LocalPlayer.Character then
        target = getClosestPlayer()
        updatePlayerInfo(target)
        
        if target and target.Character and target.Character:FindFirstChild("Head") then
            local camera = workspace.CurrentCamera
            camera.CFrame = CFrame.new(camera.CFrame.Position, target.Character.Head.Position)
        end
    else
        updatePlayerInfo(nil)
    end
end)

-- Keybind to toggle
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightAlt then
        enabled = not enabled
    end
end)
