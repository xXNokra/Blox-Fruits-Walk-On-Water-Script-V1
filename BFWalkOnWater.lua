-- GUI for Walk-On-Water Script (Invisible Platform, Dark/Phone-Friendly, Real Circle Button)
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local enabled = false
local platform = nil

-- ===== GUI =====
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "BF_WaterWalk"

-- Variables to remember menu position
local lastMenuPosition = UDim2.new(0,80,0,100)

-- ===== Circle Toggle Button =====
local toggleButton = Instance.new("TextButton", gui)
toggleButton.Size = UDim2.new(0,60,0,60)
toggleButton.Position = UDim2.new(0.5,-30,0.5,-30)
toggleButton.Text = "🌊"
toggleButton.TextSize = 30 -- make emoji smaller
toggleButton.BackgroundColor3 = Color3.fromRGB(0,0,0) -- pure black
toggleButton.BorderColor3 = Color3.fromRGB(0,0,0)
toggleButton.BorderSizePixel = 2
toggleButton.TextColor3 = Color3.new(1,1,1)
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.TextScaled = true
toggleButton.AutoButtonColor = false
toggleButton.Active = true
toggleButton.Draggable = true
toggleButton.TextStrokeTransparency = 0.5

-- Make it a real circle
local toggleCorner = Instance.new("UICorner", toggleButton)
toggleCorner.CornerRadius = UDim.new(0.5,0)

-- ===== Menu Frame =====
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,220,0,120)
frame.Position = lastMenuPosition
frame.BackgroundColor3 = Color3.fromRGB(0,0,0) -- pure black inside
frame.BorderColor3 = Color3.fromRGB(0,0,0) -- pure black border
frame.BorderSizePixel = 2
frame.Visible = false
frame.Active = true
frame.Draggable = true

-- Title
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,30)
title.Position = UDim2.new(0,0,0,0)
title.Text = "Blox Fruits Walk on water script"
title.TextColor3 = Color3.fromRGB(0,150,255) -- blue text
title.BackgroundTransparency = 1
title.Font = Enum.Font.SourceSansBold
title.TextSize = 16

-- ON/OFF Button
local button = Instance.new("TextButton", frame)
button.Size = UDim2.new(1,-20,0,50)
button.Position = UDim2.new(0,10,0,50)
button.Text = "OFF"
button.BackgroundColor3 = Color3.fromRGB(170,50,50)
button.TextColor3 = Color3.new(1,1,1)
button.Font = Enum.Font.SourceSansBold
button.TextSize = 18

-- Toggle menu visibility
toggleButton.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
    if frame.Visible then
        frame.Position = lastMenuPosition
    else
        lastMenuPosition = frame.Position
    end
end)

-- ===== Platform Logic (invisible) =====
local waterLevel = 28
local offset = -32.5
local platformSize = Vector3.new(10,1,10)

local function createPlatform()
    if platform then return end
    platform = Instance.new("Part")
    platform.Size = platformSize
    platform.Position = Vector3.new(0, waterLevel + offset, 0)
    platform.Anchored = true
    platform.CanCollide = true
    platform.Material = Enum.Material.Neon
    platform.Color = Color3.fromRGB(0,0,0)
    platform.Transparency = 1 -- invisible
    platform.Parent = Workspace
end

local function removePlatform()
    if platform then
        platform:Destroy()
        platform = nil
    end
end

-- ON/OFF Button logic
button.MouseButton1Click:Connect(function()
    enabled = not enabled
    if enabled then
        button.Text = "ON"
        button.BackgroundColor3 = Color3.fromRGB(50,170,70)
        createPlatform()
    else
        button.Text = "OFF"
        button.BackgroundColor3 = Color3.fromRGB(170,50,50)
        removePlatform()
    end
end)

-- Platform follows player X/Z and prevents going under
RunService.RenderStepped:Connect(function()
    if enabled and platform and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = player.Character.HumanoidRootPart
        local platformY = waterLevel + offset
        platform.Position = Vector3.new(hrp.Position.X, platformY, hrp.Position.Z)
        if hrp.Position.Y < platformY then
            hrp.CFrame = CFrame.new(hrp.Position.X, platformY + 1, hrp.Position.Z)
            hrp.Velocity = Vector3.new(hrp.Velocity.X,0,hrp.Velocity.Z)
        end
    end
end)
