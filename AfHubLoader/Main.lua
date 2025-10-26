-- ZenX Hub Fullscreen UI + Minimal UI (Draggable Main + Red FX + Auto Farm for Blox Fruits)
-- Place in StarterPlayer > StarterPlayerScripts

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")

local GUI_NAME = "ZenX_FullUI"
local TWEEN_INFO = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

-- Clean old GUI
local old = PlayerGui:FindFirstChild(GUI_NAME)
if old then old:Destroy() end

-- Colors
local COLORS = {
    BG = Color3.fromRGB(15, 15, 18),
    RED = Color3.fromRGB(255, 70, 70),
    STROKE = Color3.fromRGB(28, 28, 28),
    TEXT = Color3.fromRGB(240, 240, 240)
}

-- ScreenGui
local gui = Instance.new("ScreenGui")
gui.Name = GUI_NAME
gui.ResetOnSpawn = false
gui.DisplayOrder = 999
gui.IgnoreGuiInset = true
gui.Parent = PlayerGui

----------------------------------------------------
-- 🔻 Fullscreen Loading Screen
----------------------------------------------------
local loadingFrame = Instance.new("Frame")
loadingFrame.Size = UDim2.fromScale(1, 1)
loadingFrame.BackgroundColor3 = COLORS.BG
loadingFrame.Parent = gui

local glow = Instance.new("ImageLabel")
glow.Size = UDim2.fromScale(1.5, 1.5)
glow.Position = UDim2.fromScale(0.5, 0.5)
glow.AnchorPoint = Vector2.new(0.5, 0.5)
glow.Image = "rbxassetid://11778771457"
glow.ImageColor3 = COLORS.RED
glow.ImageTransparency = 0.8
glow.BackgroundTransparency = 1
glow.ZIndex = 0
glow.Parent = loadingFrame

local loadingLabel = Instance.new("TextLabel")
loadingLabel.AnchorPoint = Vector2.new(0.5, 0.5)
loadingLabel.Position = UDim2.fromScale(0.5, 0.45)
loadingLabel.Size = UDim2.fromOffset(300, 50)
loadingLabel.BackgroundTransparency = 1
loadingLabel.Font = Enum.Font.GothamBlack
loadingLabel.Text = "Loading"
loadingLabel.TextSize = 40
loadingLabel.TextColor3 = COLORS.RED
loadingLabel.Parent = loadingFrame

task.spawn(function()
    local dots = 0
    while loadingFrame.Parent do
        dots = (dots + 1) % 4
        loadingLabel.Text = "Loading" .. string.rep(".", dots)
        task.wait(0.5)
    end
end)

local barContainer = Instance.new("Frame")
barContainer.AnchorPoint = Vector2.new(0.5, 0.5)
barContainer.Position = UDim2.fromScale(0.5, 0.55)
barContainer.Size = UDim2.fromOffset(400, 10)
barContainer.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
barContainer.BorderSizePixel = 0
barContainer.Parent = loadingFrame
Instance.new("UICorner", barContainer).CornerRadius = UDim.new(0, 8)

local progressBar = Instance.new("Frame")
progressBar.Size = UDim2.fromScale(0, 1)
progressBar.BackgroundColor3 = COLORS.RED
progressBar.BorderSizePixel = 0
progressBar.Parent = barContainer
Instance.new("UICorner", progressBar).CornerRadius = UDim.new(0, 8)

TweenService:Create(progressBar, TweenInfo.new(5, Enum.EasingStyle.Sine), {Size = UDim2.fromScale(1, 1)}):Play()
task.wait(5)

TweenService:Create(loadingFrame, TweenInfo.new(1), {BackgroundTransparency = 1}):Play()
TweenService:Create(loadingLabel, TweenInfo.new(1), {TextTransparency = 1}):Play()
TweenService:Create(barContainer, TweenInfo.new(1), {BackgroundTransparency = 1}):Play()
TweenService:Create(progressBar, TweenInfo.new(1), {BackgroundTransparency = 1}):Play()
TweenService:Create(glow, TweenInfo.new(1), {ImageTransparency = 1}):Play()
task.wait(1)
loadingFrame:Destroy()

----------------------------------------------------
-- 🔻 ZenX Hub Main UI
----------------------------------------------------
-- Fixed Icon Creation
local icon = Instance.new("TextButton")
icon.Name = "ZenX_Hub_Icon"
icon.Size = UDim2.fromOffset(56, 56)
icon.Position = UDim2.new(1, -90, 0, 20)
icon.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
icon.Text = "ZenX"
icon.Font = Enum.Font.GothamBlack
icon.TextSize = 14
icon.TextColor3 = Color3.fromRGB(255, 255, 255)
icon.TextScaled = true
icon.TextWrapped = true
icon.ZIndex = 10         -- increased ZIndex to ensure clicks
icon.Active = true       -- ensure input detection
icon.Parent = gui
Instance.new("UICorner", icon).CornerRadius = UDim.new(1, 0)
local iconStroke = Instance.new("UIStroke", icon)
iconStroke.Color = Color3.fromRGB(255, 255, 255)
iconStroke.Thickness = 1

local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.fromOffset(500, 300)
main.Position = UDim2.new(0.5, -250, 0.5, -150)
main.BackgroundColor3 = COLORS.BG
main.Visible = false
main.Active = true
main.Draggable = true
main.ClipsDescendants = false
main.ZIndex = 1
main.Parent = gui
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)
local mainStroke = Instance.new("UIStroke", main)
mainStroke.Color = COLORS.STROKE
mainStroke.Thickness = 1

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 0.9
title.Font = Enum.Font.GothamBlack
title.TextSize = 16
title.TextColor3 = Color3.fromRGB(20, 20, 20)
title.Text = "ZenX Hub"
title.Parent = main

local close = Instance.new("TextButton")
close.Size = UDim2.fromOffset(30, 28)
close.Position = UDim2.new(1, -38, 0, 6)
close.BackgroundTransparency = 1
close.Font = Enum.Font.GothamBold
close.Text = "✕"
close.TextSize = 18
close.TextColor3 = COLORS.RED
close.Parent = title

local content = Instance.new("TextLabel")
content.Size = UDim2.new(1, -20, 1, -60)
content.Position = UDim2.fromOffset(10, 50)
content.BackgroundTransparency = 1
content.Font = Enum.Font.Gotham
content.TextSize = 14
content.TextColor3 = COLORS.TEXT
content.Text = "ZenX Hub ready.\nCinematic loading screen + Red FX + draggable panel!"
content.TextWrapped = true
content.Parent = main

----------------------------------------------------
-- 🔻 Toggle Buttons
----------------------------------------------------
local toggles = {}
local function createToggle(name, posY)
    local btn = Instance.new("TextButton")
    btn.Name = name .. "_Toggle"
    btn.Size = UDim2.new(0, 140, 0, 28)
    btn.Position = UDim2.new(0, 30, 0, posY)
    btn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 14
    btn.Font = Enum.Font.GothamBold
    btn.Text = name .. ": OFF"
    btn.AutoButtonColor = false
    btn.Parent = main
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    local stroke = Instance.new("UIStroke", btn)
    stroke.Color = Color3.fromRGB(255, 60, 60)
    stroke.Thickness = 2
    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        if state then
            btn.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
            stroke.Color = Color3.fromRGB(0, 255, 0)
            btn.Text = name .. ": ON"
        else
            btn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
            stroke.Color = Color3.fromRGB(255, 60, 60)
            btn.Text = name .. ": OFF"
        end
    end)
    toggles[name] = btn
end

createToggle("Auto Farm", 110)
createToggle("Farm Nearest", 145)
createToggle("Auto Attack", 255)

----------------------------------------------------
-- 🔻 Weapon Dropdown & Farm Distance Slider
----------------------------------------------------
local selectedWeapon = "Melee Sword"
local farmDistance = 20

local function createDropdown(name, options, posY)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 140, 0, 28)
    label.Position = UDim2.new(0, 30, 0, posY)
    label.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 14
    label.Font = Enum.Font.Gotham
    label.Text = name .. ": " .. options[1]
    label.Parent = main
    Instance.new("UICorner", label).CornerRadius = UDim.new(0, 6)
    local state = false

    label.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            state = not state
            if state then
                for i, option in ipairs(options) do
                    local opt = Instance.new("TextButton")
                    opt.Name = option
                    opt.Size = UDim2.new(0, 140, 0, 28)
                    opt.Position = UDim2.new(0, 30, 0, posY + 28 * i)
                    opt.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
                    opt.TextColor3 = Color3.fromRGB(255, 255, 255)
                    opt.TextSize = 14
                    opt.Font = Enum.Font.Gotham
                    opt.Text = option
                    opt.Parent = main
                    Instance.new("UICorner", opt).CornerRadius = UDim.new(0, 6)
                    opt.MouseButton1Click:Connect(function()
                        selectedWeapon = option
                        label.Text = name .. ": " .. selectedWeapon
                        for _, child in ipairs(main:GetChildren()) do
                            if child:IsA("TextButton") and table.find(options, child.Name) then
                                child:Destroy()
                            end
                        end
                        state = false
                    end)
                end
            else
                for _, child in ipairs(main:GetChildren()) do
                    if child:IsA("TextButton") and table.find(options, child.Name) then
                        child:Destroy()
                    end
                end
            end
        end
    end)
end

createDropdown("Weapon", {"Melee Sword", "Katana", "Gun"}, 180)

----------------------------------------------------
-- 🔻 Slider for Distance
----------------------------------------------------
local slider = Instance.new("Frame")
slider.Size = UDim2.new(0, 200, 0, 20)
slider.Position = UDim2.new(0, 250, 0, 110)
slider.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
slider.Parent = main
Instance.new("UICorner", slider).CornerRadius = UDim.new(0, 6)

local handle = Instance.new("Frame")
handle.Size = UDim2.new(0, 20, 1, 0)
handle.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
handle.Parent = slider
Instance.new("UICorner", handle).CornerRadius = UDim.new(0, 6)

local dragging = false
handle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
    end
end)
handle.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local pos = math.clamp(input.Position.X - slider.AbsolutePosition.X, 0, slider.AbsoluteSize.X)
        handle.Position = UDim2.fromOffset(pos, 0)
        farmDistance = math.floor((pos / slider.AbsoluteSize.X) * 100)
    end
end)

----------------------------------------------------
-- 🔻 Click Events
----------------------------------------------------
icon.MouseButton1Click:Connect(function()
    main.Visible = not main.Visible
end)

close.MouseButton1Click:Connect(function()
    main.Visible = false
end)
