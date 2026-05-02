-- // JENZ HUB V1.0 | PINK EDITION
-- // Optimized for Delta, Fluxus, & Hydrogen
-- // Updated Physics & Aesthetic UI

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- // GLOBAL SETTINGS
_G.JENZ_SETTINGS = {
    Locking = false,
    HardLock = false, 
    WallCheck = false,
    Smoothness = 1,
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
local PinkTheme = Color3.fromRGB(255, 20, 147)
local DarkBg = Color3.fromRGB(15, 10, 12)

----------------------------------------------------------------
-- // UTILITIES
----------------------------------------------------------------

local function IsVisible(targetPart)
    if not _G.JENZ_SETTINGS.WallCheck then return true end
    local parts = camera:GetPartsObscuringTarget({targetPart.Position}, {player.Character, targetPart.Parent})
    return #parts == 0
end

local function SendTaunt()
    local message = "/JENZ HUB ON TOP"
    local TextChatService = game:GetService("TextChatService")
    if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
        local channel = TextChatService.TextChannels.RBXGeneral
        if channel then channel:SendAsync(message) end
    else
        pcall(function()
            ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(message, "All")
        end)
    end
end

----------------------------------------------------------------
-- // MODERN PINK UI SYSTEM
----------------------------------------------------------------

local MainGui = Instance.new("ScreenGui", CoreGui)
MainGui.Name = "JENZ_HUB_V1"

-- // Minimized Bar
local MinimizedBar = Instance.new("TextButton", MainGui)
MinimizedBar.Size = UDim2.new(0, 160, 0, 40)
MinimizedBar.Position = UDim2.new(0.5, -80, 0, 20)
MinimizedBar.BackgroundColor3 = DarkBg
MinimizedBar.Text = "JENZ HUB (OPEN)"
MinimizedBar.TextColor3 = PinkTheme
MinimizedBar.Font = Enum.Font.GothamBold
MinimizedBar.TextSize = 14
MinimizedBar.Visible = false
local MCorner = Instance.new("UICorner", MinimizedBar)
local MStroke = Instance.new("UIStroke", MinimizedBar)
MStroke.Color = PinkTheme
MStroke.Thickness = 2

-- // Main Frame
local MainFrame = Instance.new("Frame", MainGui)
MainFrame.Size = UDim2.new(0, 450, 0, 420)
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -210)
MainFrame.BackgroundColor3 = DarkBg
MainFrame.Active, MainFrame.Draggable = true, true 
local MainCorner = Instance.new("UICorner", MainFrame)
local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Color = PinkTheme
MainStroke.Thickness = 1.5

-- // Title Bar
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Text = "  JENZ HUB | Premium"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundColor3 = Color3.fromRGB(30, 10, 20)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left
local TCorner = Instance.new("UICorner", Title)

local CloseBtn = Instance.new("TextButton", MainFrame)
CloseBtn.Size, CloseBtn.Position = UDim2.new(0, 30, 0, 30), UDim2.new(1, -40, 0, 10)
CloseBtn.BackgroundColor3, CloseBtn.Text = PinkTheme, "X"
CloseBtn.TextColor3, CloseBtn.Font = Color3.new(1, 1, 1), Enum.Font.GothamBold
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(1, 0)

CloseBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false MinimizedBar.Visible = true end)
MinimizedBar.MouseButton1Click:Connect(function() MainFrame.Visible = true MinimizedBar.Visible = false end)

-- // Container
local Container = Instance.new("ScrollingFrame", MainFrame)
Container.Size, Container.Position = UDim2.new(1, -20, 1, -70), UDim2.new(0, 10, 0, 60)
Container.BackgroundTransparency, Container.CanvasSize = 1, UDim2.new(0, 0, 2.5, 0)
Container.ScrollBarThickness = 2
Container.ScrollBarImageColor3 = PinkTheme
local Layout = Instance.new("UIListLayout", Container)
Layout.Padding = UDim.new(0, 10)

-- // UI Creation Functions
local function CreateSlider(name, min, max, setting)
    local sliderDragging = false
    local SliderFrame = Instance.new("Frame", Container)
    SliderFrame.Size, SliderFrame.BackgroundTransparency = UDim2.new(1, -10, 0, 55), 1
    
    local Label = Instance.new("TextLabel", SliderFrame)
    Label.Size, Label.Text, Label.TextColor3 = UDim2.new(1, 0, 0, 20), name .. ": " .. (_G.JENZ_SETTINGS[setting]), Color3.new(1, 1, 1)
    Label.BackgroundTransparency, Label.Font, Label.TextSize = 1, Enum.Font.GothamMedium, 13
    Label.TextXAlignment = Enum.TextXAlignment.Left

    local Background = Instance.new("Frame", SliderFrame)
    Background.Size, Background.Position, Background.BackgroundColor3 = UDim2.new(1, 0, 0, 8), UDim2.new(0, 0, 0, 35), Color3.fromRGB(40, 40, 45)
    Instance.new("UICorner", Background)

    local Fill = Instance.new("Frame", Background)
    Fill.BackgroundColor3, Fill.Size = PinkTheme, UDim2.new((_G.JENZ_SETTINGS[setting] - min) / (max - min), 0, 1, 0)
    Instance.new("UICorner", Fill)
    
    local function UpdateSlider(input)
        local pos = math.clamp((input.Position.X - Background.AbsolutePosition.X) / Background.AbsoluteSize.X, 0, 1)
        Fill.Size = UDim2.new(pos, 0, 1, 0)
        local val = math.floor(min + (max - min) * pos)
        _G.JENZ_SETTINGS[setting] = (setting == "Smoothness" and val/100 or val)
        Label.Text = name .. ": " .. val
    end
    
    Background.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then sliderDragging = true UpdateSlider(input) end end)
    UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then sliderDragging = false end end)
    UserInputService.InputChanged:Connect(function(input) if sliderDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then UpdateSlider(input) end end)
end

local function CreateToggle(name, setting)
    local Btn = Instance.new("TextButton", Container)
    Btn.Size, Btn.TextColor3 = UDim2.new(1, -10, 0, 40), Color3.new(1, 1, 1)
    Btn.Text, Btn.TextXAlignment = "  " .. name, Enum.TextXAlignment.Left
    Btn.Font, Btn.TextSize = Enum.Font.GothamMedium, 14
    Btn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    local bCorner = Instance.new("UICorner", Btn)
    local bStroke = Instance.new("UIStroke", Btn)
    bStroke.Thickness = 1
    bStroke.Color = Color3.fromRGB(60, 60, 65)

    Btn.MouseButton1Click:Connect(function() _G.JENZ_SETTINGS[setting] = not _G.JENZ_SETTINGS[setting] end)
    
    RunService.RenderStepped:Connect(function() 
        if _G.JENZ_SETTINGS[setting] then
            Btn.BackgroundColor3 = Color3.fromRGB(60, 10, 40)
            bStroke.Color = PinkTheme
        else
            Btn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
            bStroke.Color = Color3.fromRGB(60, 60, 65)
        end
    end)
end

-- // ASSEMBLE UI ELEMENTS
CreateToggle("Aimbot Lock", "Locking")
CreateToggle("Wall Check", "WallCheck")
CreateToggle("Stick to Enemies", "HardLock")
CreateSlider("Lock Smoothness", 1, 100, "Smoothness")
CreateSlider("FOV Radius", 10, 800, "FOV")
CreateToggle("Full ESP (Pink)", "ESPEnabled")
CreateToggle("Fast Speed", "SpeedEnabled")
CreateSlider("Speed Power", 16, 250, "MaxSpeed")
CreateToggle("Jump Boost", "JumpBoostEnabled")
CreateSlider("Jump Power", 30, 200, "JumpPower")
CreateToggle("Infinite Jump", "InfJump")
CreateSlider("Gravity", 0, 196, "GravityValue")

----------------------------------------------------------------
-- // MOBILE TOGGLE BUTTON
----------------------------------------------------------------

local MobileBtnMain = Instance.new("TextButton", MainGui)
MobileBtnMain.Size, MobileBtnMain.Position = UDim2.new(0, 65, 0, 65), UDim2.new(0, 15, 0.45, 0)
MobileBtnMain.Text, MobileBtnMain.BackgroundColor3, MobileBtnMain.Draggable = "JENZ", DarkBg, true
MobileBtnMain.TextColor3, MobileBtnMain.Font = PinkTheme, Enum.Font.GothamBold
local MobCorner = Instance.new("UICorner", MobileBtnMain)
MobCorner.CornerRadius = UDim.new(1, 0)
local MobStroke = Instance.new("UIStroke", MobileBtnMain)
MobStroke.Color = PinkTheme
MobStroke.Thickness = 2

local MobContainer = Instance.new("Frame", MobileBtnMain)
MobContainer.Size, MobContainer.Position, MobContainer.Visible = UDim2.new(0, 110, 0, 380), UDim2.new(1.2, 0, -2, 0), false
MobContainer.BackgroundColor3, MobContainer.BackgroundTransparency = Color3.new(0,0,0), 0.4
Instance.new("UIListLayout", MobContainer).Padding = UDim.new(0, 5)

local function createMobileBtn(txt, setting)
    local b = Instance.new("TextButton", MobContainer)
    b.Size, b.TextColor3, b.Font = UDim2.new(1, 0, 0, 38), Color3.new(1,1,1), Enum.Font.GothamMedium
    Instance.new("UICorner", b)
    if setting then
        b.MouseButton1Click:Connect(function() _G.JENZ_SETTINGS[setting] = not _G.JENZ_SETTINGS[setting] end)
        RunService.RenderStepped:Connect(function()
            b.Text = txt..(_G.JENZ_SETTINGS[setting] and ": ON" or ": OFF")
            b.BackgroundColor3 = _G.JENZ_SETTINGS[setting] and PinkTheme or Color3.fromRGB(40,40,40)
        end)
    else
        b.Text = txt
        b.BackgroundColor3 = Color3.fromRGB(100, 20, 60)
    end
    return b
end

MobileBtnMain.MouseButton1Click:Connect(function() MobContainer.Visible = not MobContainer.Visible end)

createMobileBtn("AIM", "Locking")
createMobileBtn("ESP", "ESPEnabled")
createMobileBtn("TAUNT").MouseButton1Click:Connect(function() SendTaunt() end)
createMobileBtn("JUMP", "InfJump")
createMobileBtn("SPD", "SpeedEnabled")
createMobileBtn("DOWN").MouseButton1Click:Connect(function() _G.JENZ_SETTINGS.DownActive = true end)

----------------------------------------------------------------
-- // CORE LOGIC & ESP
----------------------------------------------------------------

local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness, FOVCircle.Color, FOVCircle.Filled, FOVCircle.Visible = 1.5, PinkTheme, false, true

local ESP_Table = {}
local function CreateESP(p)
    if p == player then return end
    local objects = {
        Box = Drawing.new("Square"), HealthBar = Drawing.new("Square"), Name = Drawing.new("Text"), Distance = Drawing.new("Text")
    }
    objects.Box.Color, objects.Box.Thickness, objects.Box.Filled = PinkTheme, 1.5, false
    objects.HealthBar.Thickness, objects.HealthBar.Filled = 1, true
    objects.Name.Center, objects.Name.Outline, objects.Name.Size, objects.Name.Color = true, true, 14, Color3.new(1,1,1)
    objects.Distance.Center, objects.Distance.Outline, objects.Distance.Size, objects.Distance.Color = true, true, 13, Color3.new(0.8,0.8,0.8)
    ESP_Table[p] = objects
end
for _, p in pairs(Players:GetPlayers()) do CreateESP(p) end
Players.PlayerAdded:Connect(CreateESP)

RunService.RenderStepped:Connect(function(dt)
    FOVCircle.Position = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)
    FOVCircle.Radius = _G.JENZ_SETTINGS.FOV
    
    local target, shortestDist = nil, _G.JENZ_SETTINGS.FOV
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild("Head") and p.Character.Humanoid.Health > 0 then
            local head = p.Character.Head
            local pos, onScreen = camera:WorldToViewportPoint(head.Position)
            if onScreen and IsVisible(head) then
                local dist = (Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2) - Vector2.new(pos.X, pos.Y)).Magnitude
                if dist < shortestDist then shortestDist = dist target = p end
            end
        end
    end

    if _G.JENZ_SETTINGS.Locking and target then
        local headPos = target.Character.Head.Position
        if _G.JENZ_SETTINGS.Smoothness >= 1 then
            camera.CFrame = CFrame.lookAt(camera.CFrame.Position, headPos)
        else
            camera.CFrame = camera.CFrame:Lerp(CFrame.lookAt(camera.CFrame.Position, headPos), _G.JENZ_SETTINGS.Smoothness * (dt * 60))
        end
    end
    
    if _G.JENZ_SETTINGS.HardLock and target and player.Character then
        player.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
    end

    for p, v in pairs(ESP_Table) do
        if _G.JENZ_SETTINGS.ESPEnabled and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local hrp, hum = p.Character.HumanoidRootPart, p.Character.Humanoid
            local pos, onScreen = camera:WorldToViewportPoint(hrp.Position)
            if onScreen and hum.Health > 0 then
                local s = (1 / pos.Z) * 1000
                local boxWidth, boxHeight = 2.2*s, 3.8*s
                v.Box.Visible, v.Box.Size, v.Box.Position = true, Vector2.new(boxWidth, boxHeight), Vector2.new(pos.X - boxWidth/2, pos.Y - boxHeight/2)
                
                local hpPercent = hum.Health / hum.MaxHealth
                v.HealthBar.Visible, v.HealthBar.Size = true, Vector2.new(2, boxHeight * hpPercent)
                v.HealthBar.Position = Vector2.new(pos.X - boxWidth/2 - 6, (pos.Y + boxHeight/2) - (boxHeight * hpPercent))
                v.HealthBar.Color = Color3.fromHSV(hpPercent * 0.3, 1, 1)
                
                v.Name.Visible, v.Name.Text, v.Name.Position = true, p.Name, Vector2.new(pos.X, pos.Y - boxHeight/2 - 16)
                local distVal = math.floor((player.Character.HumanoidRootPart.Position - hrp.Position).Magnitude)
                v.Distance.Visible, v.Distance.Text, v.Distance.Position = true, distVal.."m", Vector2.new(pos.X, pos.Y + boxHeight/2 + 4)
            else v.Box.Visible, v.HealthBar.Visible, v.Name.Visible, v.Distance.Visible = false, false, false, false end
        else v.Box.Visible, v.HealthBar.Visible, v.Name.Visible, v.Distance.Visible = false, false, false, false end
    end
end)

RunService.Heartbeat:Connect(function(dt)
    workspace.Gravity = _G.JENZ_SETTINGS.GravityValue 
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    
    if hrp and hum then
        if _G.JENZ_SETTINGS.DownActive then
            hrp.Velocity = Vector3.new(hrp.Velocity.X, -_G.JENZ_SETTINGS.DropLimit, hrp.Velocity.Z)
            _G.JENZ_SETTINGS.DownActive = false
        end
        if _G.JENZ_SETTINGS.SpeedEnabled and hum.MoveDirection.Magnitude > 0 then
            local move = hum.MoveDirection * (_G.JENZ_SETTINGS.MaxSpeed / 5) * dt
            hrp:PivotTo(hrp.CFrame + move)
        end
    end
end)

UserInputService.JumpRequest:Connect(function()
    if player.Character then
        local hrp = player.Character:FindFirstChild("HumanoidRootPart")
        local hum = player.Character:FindFirstChildOfClass("Humanoid")
        if hrp and hum then
            if _G.JENZ_SETTINGS.InfJump or _G.JENZ_SETTINGS.JumpBoostEnabled then
                local canJump = (_G.JENZ_SETTINGS.InfJump) or (hum:GetState() == Enum.HumanoidStateType.Running or hum:GetState() == Enum.HumanoidStateType.Landed)
                if canJump then
                    local boost = _G.JENZ_SETTINGS.JumpBoostEnabled and _G.JENZ_SETTINGS.JumpPower or 50
                    hrp.Velocity = Vector3.new(hrp.Velocity.X, boost, hrp.Velocity.Z)
                end
            end
        end
    end
end)
