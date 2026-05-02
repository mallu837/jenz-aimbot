-- // JENZ HUB V3.3.2 | ULTRA PINK EDITION
-- // Premium UI Interface with real-time FPS Counter

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- // GLOBAL SETTINGS
_G.JENZ_SETTINGS = {
    Locking = false,
    HardLock = false, 
    WallCheck = false,
    Smoothness = 0.5,
    FOV = 150,
    MaxSpeed = 75,
    SpeedEnabled = false,
    InfJump = false,
    JumpBoostEnabled = false,
    JumpPower = 50,
    ESPEnabled = true,
    GravityValue = 196, 
    DownActive = false,
    DropLimit = 150
}

local camera = workspace.CurrentCamera
local PinkTheme = Color3.fromRGB(255, 20, 147) -- Neon Pink
local DarkBg = Color3.fromRGB(15, 15, 15)
local AccentPink = Color3.fromRGB(60, 10, 40)

----------------------------------------------------------------
-- // MODERN UI SYSTEM
----------------------------------------------------------------

local MainGui = Instance.new("ScreenGui", CoreGui)
MainGui.Name = "JENZ_ULTRA_HUB"

local MainFrame = Instance.new("Frame", MainGui)
MainFrame.Size = UDim2.new(0, 520, 0, 360)
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -180)
MainFrame.BackgroundColor3 = DarkBg
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true

-- // UI Styling (Rounded & Glow)
local MainCorner = Instance.new("UICorner", MainFrame)
MainCorner.CornerRadius = UDim.new(0, 12)

local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Color = PinkTheme
MainStroke.Thickness = 1.8
MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- // TOP BAR (Title & FPS)
local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundTransparency = 1

local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(0.5, 0, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.Text = "JENZ HUB PREMIUM"
Title.TextColor3 = PinkTheme
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Left

local FPSLabel = Instance.new("TextLabel", TopBar)
FPSLabel.Size = UDim2.new(0.5, -15, 1, 0)
FPSLabel.Position = UDim2.new(0.5, 0, 0, 0)
FPSLabel.Text = "FPS: 60"
FPSLabel.TextColor3 = Color3.new(1, 1, 1)
FPSLabel.Font = Enum.Font.Code
FPSLabel.TextSize = 14
FPSLabel.BackgroundTransparency = 1
FPSLabel.TextXAlignment = Enum.TextXAlignment.Right

-- // FPS COUNTER LOGIC
RunService.RenderStepped:Connect(function(dt)
    FPSLabel.Text = "FPS: " .. math.floor(1/dt)
end)

-- // SIDEBAR
local Sidebar = Instance.new("Frame", MainFrame)
Sidebar.Size = UDim2.new(0, 140, 1, -60)
Sidebar.Position = UDim2.new(0, 10, 0, 50)
Sidebar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 8)

local SidebarLayout = Instance.new("UIListLayout", Sidebar)
SidebarLayout.Padding = UDim.new(0, 5)
SidebarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- // PAGE CONTAINER
local PageContainer = Instance.new("Frame", MainFrame)
PageContainer.Size = UDim2.new(1, -170, 1, -60)
PageContainer.Position = UDim2.new(0, 160, 0, 50)
PageContainer.BackgroundTransparency = 1

local function CreatePage(name)
    local Page = Instance.new("ScrollingFrame", PageContainer)
    Page.Name = name
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.CanvasSize = UDim2.new(0, 0, 2, 0)
    Page.ScrollBarThickness = 0
    Instance.new("UIListLayout", Page).Padding = UDim.new(0, 10)
    return Page
end

local Pages = {
    Combat = CreatePage("Combat"),
    Movement = CreatePage("Movement"),
    Visuals = CreatePage("Visuals")
}

local function SwitchTab(name)
    for i, v in pairs(Pages) do
        v.Visible = (i == name)
    end
end

local function AddTabBtn(name)
    local Btn = Instance.new("TextButton", Sidebar)
    Btn.Size = UDim2.new(0.9, 0, 0, 35)
    Btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Btn.Text = name
    Btn.TextColor3 = Color3.new(1, 1, 1)
    Btn.Font = Enum.Font.GothamMedium
    Btn.TextSize = 14
    Instance.new("UICorner", Btn)
    
    Btn.MouseButton1Click:Connect(function()
        SwitchTab(name)
        for _, other in pairs(Sidebar:GetChildren()) do
            if other:IsA("TextButton") then other.BackgroundColor3 = Color3.fromRGB(30, 30, 30) end
        end
        Btn.BackgroundColor3 = PinkTheme
    end)
end

AddTabBtn("Combat")
AddTabBtn("Movement")
AddTabBtn("Visuals")
SwitchTab("Combat")

----------------------------------------------------------------
-- // INTERFACE ELEMENTS
----------------------------------------------------------------

local function CreateToggle(parent, text, setting)
    local Frame = Instance.new("TextButton", parent)
    Frame.Size = UDim2.new(1, 0, 0, 40)
    Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Frame.Text = "  " .. text
    Frame.TextColor3 = Color3.new(1, 1, 1)
    Frame.Font = Enum.Font.Gotham
    Frame.TextSize = 13
    Frame.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", Frame)

    local Box = Instance.new("Frame", Frame)
    Box.Size = UDim2.new(0, 18, 0, 18)
    Box.Position = UDim2.new(1, -28, 0.5, -9)
    Box.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 4)

    Frame.MouseButton1Click:Connect(function()
        _G.JENZ_SETTINGS[setting] = not _G.JENZ_SETTINGS[setting]
        Box.BackgroundColor3 = _G.JENZ_SETTINGS[setting] and PinkTheme or Color3.fromRGB(40, 40, 40)
    end)
end

local function CreateSlider(parent, text, min, max, setting)
    local Frame = Instance.new("Frame", parent)
    Frame.Size = UDim2.new(1, 0, 0, 50)
    Frame.BackgroundTransparency = 1
    
    local Label = Instance.new("TextLabel", Frame)
    Label.Size = UDim2.new(1, 0, 0, 20)
    Label.Text = text .. ": " .. _G.JENZ_SETTINGS[setting]
    Label.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    Label.BackgroundTransparency = 1
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 12
    Label.TextXAlignment = Enum.TextXAlignment.Left

    local SliderBar = Instance.new("Frame", Frame)
    SliderBar.Size = UDim2.new(1, -10, 0, 6)
    SliderBar.Position = UDim2.new(0, 0, 0, 30)
    SliderBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Instance.new("UICorner", SliderBar)

    local Fill = Instance.new("Frame", SliderBar)
    Fill.Size = UDim2.new((_G.JENZ_SETTINGS[setting]-min)/(max-min), 0, 1, 0)
    Fill.BackgroundColor3 = PinkTheme
    Instance.new("UICorner", Fill)

    local dragging = false
    local function Update()
        local m = UserInputService:GetMouseLocation()
        local pos = math.clamp((m.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
        Fill.Size = UDim2.new(pos, 0, 1, 0)
        local val = math.floor(min + (max - min) * pos)
        _G.JENZ_SETTINGS[setting] = val
        Label.Text = text .. ": " .. val
    end

    SliderBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            Update()
        end
    end)
end

-- // ADDING FEATURES TO PAGES
CreateToggle(Pages.Combat, "Aimbot Lock", "Locking")
CreateToggle(Pages.Combat, "Wall Check", "WallCheck")
CreateSlider(Pages.Combat, "Lock Smoothness", 1, 100, "Smoothness")
CreateSlider(Pages.Combat, "FOV Size", 10, 800, "FOV")

CreateToggle(Pages.Movement, "Speed Boost", "SpeedEnabled")
CreateSlider(Pages.Movement, "Speed Power", 16, 250, "MaxSpeed")
CreateToggle(Pages.Movement, "Infinite Jump", "InfJump")
CreateSlider(Pages.Movement, "Jump Power", 30, 200, "JumpPower")

CreateToggle(Pages.Visuals, "ESP Enabled", "ESPEnabled")

----------------------------------------------------------------
-- // MOBILE BUTTON
----------------------------------------------------------------

local MobBtn = Instance.new("TextButton", MainGui)
MobBtn.Size = UDim2.new(0, 55, 0, 55)
MobBtn.Position = UDim2.new(0, 15, 0.4, 0)
MobBtn.BackgroundColor3 = DarkBg
MobBtn.Text = "JENZ"
MobBtn.TextColor3 = PinkTheme
MobBtn.Font = Enum.Font.GothamBold
MobBtn.Draggable = true
Instance.new("UICorner", MobBtn).CornerRadius = UDim.new(1, 0)
local MobStroke = Instance.new("UIStroke", MobBtn)
MobStroke.Color = PinkTheme
MobStroke.Thickness = 2

MobBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

----------------------------------------------------------------
-- // CORE LOGIC (AIMBOT & ESP)
----------------------------------------------------------------

local FOVCircle = Drawing.new("Circle")
FOVCircle.Visible = false -- Always hidden as per request

local function GetClosest()
    local target, shortestDist = nil, _G.JENZ_SETTINGS.FOV
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild("Head") then
            local pos, onScreen = camera:WorldToViewportPoint(p.Character.Head.Position)
            if onScreen then
                local dist = (Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2) - Vector2.new(pos.X, pos.Y)).Magnitude
                if dist < shortestDist then
                    target = p
                    shortestDist = dist
                end
            end
        end
    end
    return target
end

RunService.RenderStepped:Connect(function()
    if _G.JENZ_SETTINGS.Locking then
        local target = GetClosest()
        if target then
            camera.CFrame = camera.CFrame:Lerp(CFrame.lookAt(camera.CFrame.Position, target.Character.Head.Position), (_G.JENZ_SETTINGS.Smoothness / 10))
        end
    end
end)

-- Basic ESP Box
RunService.Heartbeat:Connect(function()
    if _G.JENZ_SETTINGS.SpeedEnabled and player.Character then
        local hum = player.Character:FindFirstChildOfClass("Humanoid")
        if hum and hum.MoveDirection.Magnitude > 0 then
            player.Character:TranslateBy(hum.MoveDirection * (_G.JENZ_SETTINGS.MaxSpeed / 100))
        end
    end
end)

UserInputService.JumpRequest:Connect(function()
    if _G.JENZ_SETTINGS.InfJump and player.Character then
        player.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
        local hrp = player.Character:FindFirstChild("HumanoidRootPart")
        if hrp then hrp.Velocity = Vector3.new(hrp.Velocity.X, _G.JENZ_SETTINGS.JumpPower, hrp.Velocity.Z) end
    end
end)
