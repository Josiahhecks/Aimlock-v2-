local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local Library = {}

-- UI Colors
local COLORS = {
    Background = Color3.fromRGB(25, 25, 35),
    Border = Color3.fromRGB(50, 50, 75),
    Header = Color3.fromRGB(30, 30, 45),
    Text = Color3.fromRGB(255, 255, 255),
    Accent = Color3.fromRGB(114, 137, 218),
    Toggle = {
        On = Color3.fromRGB(114, 137, 218),
        Off = Color3.fromRGB(50, 50, 75)
    }
}

function Library:CreateWindow(title)
    -- Create Icon Button
    local iconButton = Instance.new("ImageButton")
    iconButton.Name = "AimLockIcon"
    iconButton.Size = UDim2.new(0, 50, 0, 50)
    iconButton.Position = UDim2.new(0, 10, 0.5, -25)
    iconButton.Image = "rbxassetid://6034509993"
    iconButton.BackgroundTransparency = 0.5
    iconButton.BackgroundColor3 = COLORS.Background
    iconButton.BorderSizePixel = 2
    iconButton.BorderColor3 = COLORS.Border
    iconButton.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

    -- Create Main Window
    local window = Instance.new("ScreenGui")
    local main = Instance.new("Frame")
    local titleBar = Instance.new("Frame")
    local titleLabel = Instance.new("TextLabel")
    local container = Instance.new("Frame")
    
    window.Name = "AimLockGui"
    window.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    
    main.Name = "Main"
    main.Size = UDim2.new(0, 350, 0, 450)
    main.Position = UDim2.new(0.5, -175, 0.5, -225)
    main.BackgroundColor3 = COLORS.Background
    main.BorderSizePixel = 0
    main.ClipsDescendants = true
    main.Parent = window
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = main
    
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    shadow.BackgroundTransparency = 1
    shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    shadow.Size = UDim2.new(1, 47, 1, 47)
    shadow.ZIndex = -1
    shadow.Image = "rbxassetid://6015897843"
    shadow.ImageColor3 = Color3.new(0, 0, 0)
    shadow.ImageTransparency = 0.5
    shadow.Parent = main
    
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.BackgroundColor3 = COLORS.Header
    titleBar.BorderSizePixel = 0
    titleBar.Parent = main
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 10)
    titleCorner.Parent = titleBar
    
    titleLabel.Text = title
    titleLabel.Size = UDim2.new(1, 0, 1, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.TextColor3 = COLORS.Text
    titleLabel.TextSize = 18
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Parent = titleBar
    
    container.Name = "Container"
    container.Size = UDim2.new(1, -20, 1, -50)
    container.Position = UDim2.new(0, 10, 0, 45)
    container.BackgroundTransparency = 1
    container.Parent = main

    -- Make window draggable
    local dragging = false
    local dragStart = nil
    local startPos = nil

    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = main.Position
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            main.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    -- Toggle window visibility with icon
    local windowVisible = true
    iconButton.MouseButton1Click:Connect(function()
        windowVisible = not windowVisible
        local targetPosition = windowVisible and UDim2.new(0.5, -175, 0.5, -225) or UDim2.new(-0.5, 0, 0.5, -225)
        
        local tween = TweenService:Create(main, TweenInfo.new(0.5, Enum.EasingStyle.Quart), {
            Position = targetPosition
        })
        tween:Play()
    end)

    return container
end

function Library:CreateToggle(parent, text, callback)
    local toggleFrame = Instance.new("Frame")
    local toggleButton = Instance.new("TextButton")
    local toggleIndicator = Instance.new("Frame")
    local status = false
    
    toggleFrame.Size = UDim2.new(1, 0, 0, 40)
    toggleFrame.BackgroundTransparency = 1
    toggleFrame.Parent = parent
    
    toggleButton.Text = text
    toggleButton.Size = UDim2.new(1, -60, 1, 0)
    toggleButton.Position = UDim2.new(0, 0, 0, 0)
    toggleButton.BackgroundTransparency = 1
    toggleButton.TextColor3 = COLORS.Text
    toggleButton.TextSize = 16
    toggleButton.Font = Enum.Font.Gotham
    toggleButton.TextXAlignment = Enum.TextXAlignment.Left
    toggleButton.Parent = toggleFrame
    
    toggleIndicator.Size = UDim2.new(0, 40, 0, 20)
    toggleIndicator.Position = UDim2.new(1, -45, 0.5, -10)
    toggleIndicator.BackgroundColor3 = COLORS.Toggle.Off
    toggleIndicator.Parent = toggleFrame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = toggleIndicator
    
    local indicator = Instance.new("Frame")
    indicator.Size = UDim2.new(0, 16, 0, 16)
    indicator.Position = UDim2.new(0, 2, 0.5, -8)
    indicator.BackgroundColor3 = COLORS.Text
    indicator.Parent = toggleIndicator
    
    local indicatorCorner = Instance.new("UICorner")
    indicatorCorner.CornerRadius = UDim.new(1, 0)
    indicatorCorner.Parent = indicator
    
    toggleButton.MouseButton1Click:Connect(function()
        status = not status
        local targetPos = status and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
        local targetColor = status and COLORS.Toggle.On or COLORS.Toggle.Off
        
        TweenService:Create(indicator, TweenInfo.new(0.2), {
            Position = targetPos
        }):Play()
        
        TweenService:Create(toggleIndicator, TweenInfo.new(0.2), {
            BackgroundColor3 = targetColor
        }):Play()
        
        callback(status)
    end)
end

local function createPlayerInfo(parent)
    local infoFrame = Instance.new("Frame")
    local avatar = Instance.new("ImageLabel")
    local username = Instance.new("TextLabel")
    local health = Instance.new("TextLabel")
    local distance = Instance.new("TextLabel")
    
    infoFrame.Size = UDim2.new(1, 0, 0, 120)
    infoFrame.BackgroundColor3 = COLORS.Header
    infoFrame.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = infoFrame
    
    avatar.Size = UDim2.new(0, 100, 0, 100)
    avatar.Position = UDim2.new(0, 10, 0, 10)
    avatar.BackgroundColor3 = COLORS.Border
    avatar.Parent = infoFrame
    
    local avatarCorner = Instance.new("UICorner")
    avatarCorner.CornerRadius = UDim.new(0, 10)
    avatarCorner.Parent = avatar
    
    username.Size = UDim2.new(0, 150, 0, 30)
    username.Position = UDim2.new(0, 120, 0, 10)
    username.BackgroundTransparency = 1
    username.TextColor3 = COLORS.Text
    username.TextXAlignment = Enum.TextXAlignment.Left
    username.Font = Enum.Font.GothamBold
    username.TextSize = 14
    username.Parent = infoFrame
    
    health.Size = UDim2.new(0, 150, 0, 30)
    health.Position = UDim2.new(0, 120, 0, 45)
    health.BackgroundTransparency = 1
    health.TextColor3 = COLORS.Text
    health.TextXAlignment = Enum.TextXAlignment.Left
    health.Font = Enum.Font.Gotham
    health.TextSize = 14
    health.Parent = infoFrame
    
    distance.Size = UDim2.new(0, 150, 0, 30)
    distance.Position = UDim2.new(0, 120, 0, 80)
    distance.BackgroundTransparency = 1
    distance.TextColor3 = COLORS.Text
    distance.TextXAlignment = Enum.TextXAlignment.Left
    distance.Font = Enum.Font.Gotham
    distance.TextSize = 14
    distance.Parent = infoFrame
    
    return {
        avatar = avatar,
        username = username,
        health = health,
        distance = distance
    }
end

-- Initialize
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
        local userId = player.UserId
        local thumbType = Enum.ThumbnailType.HeadShot
        local thumbSize = Enum.ThumbnailSize.Size100x100
        local content = Players:GetUserThumbnailAsync(userId, thumbType, thumbSize)
        playerInfo.avatar.Image = content
        
        playerInfo.username.Text = "Player: " .. player.Name
        
        local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
        if humanoid then
            playerInfo.health.Text = "Health: " .. math.floor(humanoid.Health)
        end
        
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
