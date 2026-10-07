-- Coal Hub | [FPS] Флик
-- 20 функций | Mobile UI

if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Config = {
    AimAssist = false,
    AimFOV = 120,
    AimSmooth = 0.18,
    TeamCheck = true,
    TriggerBot = false,
    Hitbox = false,
    HitboxSize = 8,
    ESP = false,
    BoxESP = false,
    Tracers = false,
    HealthESP = false,
    DistanceESP = false,
    Crosshair = true,
    Speed = false,
    SpeedValue = 28,
    InfiniteJump = false,
    Fly = false,
    FlySpeed = 60,
    Noclip = false,
    Fullbright = false,
    FPSBoost = false,
    AntiAFK = false
}

local Connections = {}
local Destroyed = false

local function Connect(signal, callback)
    local c = signal:Connect(callback)
    table.insert(Connections, c)
    return c
end

local function Alive(player)
    if not player or not player.Character then
        return false
    end

    local humanoid =
        player.Character:FindFirstChildOfClass("Humanoid")

    local root =
        player.Character:FindFirstChild("HumanoidRootPart")

    return humanoid
        and humanoid.Health > 0
        and root ~= nil
end

local function GetRoot(player)
    return player.Character
        and player.Character:FindFirstChild("HumanoidRootPart")
end

local function GetHumanoid(player)
    return player.Character
        and player.Character:FindFirstChildOfClass("Humanoid")
end

local function IsEnemy(player)
    if player == LocalPlayer then
        return false
    end

    if not Config.TeamCheck then
        return true
    end

    if LocalPlayer.Team and player.Team then
        return LocalPlayer.Team ~= player.Team
    end

    return true
end

local function GetAimPart(player)
    if not player.Character then
        return nil
    end

    return player.Character:FindFirstChild("Head")
        or player.Character:FindFirstChild("HumanoidRootPart")
end

local function GetNearestTarget()
    local best = nil
    local bestDistance = math.huge

    local center = Vector2.new(
        Camera.ViewportSize.X / 2,
        Camera.ViewportSize.Y / 2
    )

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer
            and IsEnemy(player)
            and Alive(player) then

            local part = GetAimPart(player)

            if part then
                local position, visible =
                    Camera:WorldToViewportPoint(part.Position)

                if visible and position.Z > 0 then
                    local distance =
                        (
                            Vector2.new(
                                position.X,
                                position.Y
                            ) - center
                        ).Magnitude

                    if distance <= Config.AimFOV
                        and distance < bestDistance then

                        best = part
                        bestDistance = distance
                    end
                end
            end
        end
    end

    return best
end

--------------------------------------------------
-- GUI
--------------------------------------------------

local Gui = Instance.new("ScreenGui")
Gui.Name = "CoalHub"
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true

pcall(function()
    Gui.Parent = game:GetService("CoreGui")
end)

if not Gui.Parent then
    Gui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

local Main = Instance.new("Frame")
Main.AnchorPoint = Vector2.new(0.5,0.5)
Main.Position = UDim2.fromScale(0.5,0.5)
Main.Size = UDim2.new(0.86,0,0.76,0)
Main.BackgroundColor3 = Color3.fromRGB(17,17,20)
Main.BorderSizePixel = 0
Main.Parent = Gui

Instance.new("UICorner",Main).CornerRadius = UDim.new(0,16)

local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(52,52,60)
Stroke.Thickness = 1
Stroke.Parent = Main

--------------------------------------------------
-- HEADER
--------------------------------------------------

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1,0,0,65)
Header.BackgroundColor3 = Color3.fromRGB(23,23,28)
Header.BorderSizePixel = 0
Header.Parent = Main

Instance.new("UICorner",Header).CornerRadius = UDim.new(0,16)

local Title = Instance.new("TextLabel")
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0,18,0,7)
Title.Size = UDim2.new(0,220,0,28)
Title.Font = Enum.Font.GothamBold
Title.Text = "Coal Hub"
Title.TextColor3 = Color3.fromRGB(245,245,248)
Title.TextSize = 22
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local GameName = Instance.new("TextLabel")
GameName.BackgroundTransparency = 1
GameName.Position = UDim2.new(0,19,0,36)
GameName.Size = UDim2.new(0,250,0,18)
GameName.Font = Enum.Font.Gotham
GameName.Text = "[FPS] Флик"
GameName.TextColor3 = Color3.fromRGB(145,145,155)
GameName.TextSize = 11
GameName.TextXAlignment = Enum.TextXAlignment.Left
GameName.Parent = Header

local Search = Instance.new("TextBox")
Search.AnchorPoint = Vector2.new(1,0.5)
Search.Position = UDim2.new(1,-62,0.5,0)
Search.Size = UDim2.fromOffset(145,36)
Search.BackgroundColor3 = Color3.fromRGB(35,35,41)
Search.PlaceholderText = "Search..."
Search.PlaceholderColor3 = Color3.fromRGB(120,120,130)
Search.Text = ""
Search.TextColor3 = Color3.fromRGB(240,240,245)
Search.Font = Enum.Font.Gotham
Search.TextSize = 12
Search.ClearTextOnFocus = false
Search.Parent = Header

Instance.new("UICorner",Search).CornerRadius = UDim.new(0,9)

--------------------------------------------------
-- SIDEBAR
--------------------------------------------------

local Sidebar = Instance.new("Frame")
Sidebar.Position = UDim2.new(0,10,0,75)
Sidebar.Size = UDim2.new(0,145,1,-85)
Sidebar.BackgroundTransparency = 1
Sidebar.Parent = Main

local SideLayout = Instance.new("UIListLayout")
SideLayout.Padding = UDim.new(0,7)
SideLayout.Parent = Sidebar

local Content = Instance.new("ScrollingFrame")
Content.Position = UDim2.new(0,165,0,75)
Content.Size = UDim2.new(1,-175,1,-85)
Content.BackgroundTransparency = 1
Content.BorderSizePixel = 0
Content.ScrollBarThickness = 4
Content.ScrollBarImageColor3 =
    Color3.fromRGB(80,80,90)
Content.Parent = Main

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0,9)
Layout.Parent = Content

local Padding = Instance.new("UIPadding")
Padding.PaddingBottom = UDim.new(0,15)
Padding.Parent = Content

Connect(
    Layout:GetPropertyChangedSignal("AbsoluteContentSize"),
    function()
        Content.CanvasSize =
            UDim2.new(
                0,
                0,
                0,
                Layout.AbsoluteContentSize.Y + 20
            )
    end
)

--------------------------------------------------
-- UI HELPERS
--------------------------------------------------

local function Clear()
    for _, child in ipairs(Content:GetChildren()) do
        if not child:IsA("UIListLayout")
            and not child:IsA("UIPadding") then
            child:Destroy()
        end
    end
end

local function Section(text)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1,-5,0,34)
    frame.BackgroundColor3 =
        Color3.fromRGB(25,25,30)
    frame.BorderSizePixel = 0
    frame.Parent = Content

    Instance.new("UICorner",frame).CornerRadius =
        UDim.new(0,9)

    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0,13,0,0)
    label.Size = UDim2.new(1,-20,1,0)
    label.Font = Enum.Font.GothamBold
    label.Text = "▌  "..text
    label.TextColor3 =
        Color3.fromRGB(240,240,245)
    label.TextSize = 13
    label.TextXAlignment =
        Enum.TextXAlignment.Left
    label.Parent = frame
end

local function Toggle(
    text,
    key,
    description
)

    local frame = Instance.new("Frame")
    frame.Size =
        UDim2.new(
            1,-5,
            0,
            description and 60 or 48
        )

    frame.BackgroundColor3 =
        Color3.fromRGB(32,32,38)

    frame.BorderSizePixel = 0
    frame.Parent = Content

    Instance.new("UICorner",frame).CornerRadius =
        UDim.new(0,10)

    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Position =
        UDim2.new(0,13,0,description and 6 or 0)
    label.Size =
        UDim2.new(1,-82,0,24)
    label.Font = Enum.Font.GothamSemibold
    label.Text = text
    label.TextColor3 =
        Color3.fromRGB(240,240,245)
    label.TextSize = 13
    label.TextXAlignment =
        Enum.TextXAlignment.Left
    label.Parent = frame

    if description then
        local desc = Instance.new("TextLabel")
        desc.BackgroundTransparency = 1
        desc.Position = UDim2.new(0,13,0,31)
        desc.Size = UDim2.new(1,-90,0,18)
        desc.Font = Enum.Font.Gotham
        desc.Text = description
        desc.TextColor3 =
            Color3.fromRGB(140,140,150)
        desc.TextSize = 9
        desc.TextXAlignment =
            Enum.TextXAlignment.Left
        desc.TextTruncate =
            Enum.TextTruncate.AtEnd
        desc.Parent = frame
    end

    local button = Instance.new("TextButton")
    button.AnchorPoint =
        Vector2.new(1,0.5)
    button.Position =
        UDim2.new(1,-12,0.5,0)
    button.Size =
        UDim2.fromOffset(52,28)
    button.Text = ""
    button.BorderSizePixel = 0
    button.Parent = frame

    Instance.new("UICorner",button).CornerRadius =
        UDim.new(1,0)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.fromOffset(22,22)
    knob.AnchorPoint =
        Vector2.new(0.5,0.5)
    knob.BackgroundColor3 =
        Color3.fromRGB(245,245,248)
    knob.BorderSizePixel = 0
    knob.Parent = button

    Instance.new("UICorner",knob).CornerRadius =
        UDim.new(1,0)

    local function Refresh()
        local enabled = Config[key]

        button.BackgroundColor3 =
            enabled
            and Color3.fromRGB(78,175,110)
            or Color3.fromRGB(65,65,75)

        knob.Position =
            enabled
            and UDim2.new(1,-14,0.5,0)
            or UDim2.new(0,14,0.5,0)
    end

    Refresh()

    Connect(
        button.MouseButton1Click,
        function()
            Config[key] = not Config[key]
            Refresh()

            if key == "Speed" then
                local hum = GetHumanoid(LocalPlayer)
                if hum then
                    hum.WalkSpeed =
                        Config.Speed
                        and Config.SpeedValue
                        or 16
                end
            end

            if key == "Fullbright" then
                if Config.Fullbright then
                    Lighting.Brightness = 3
                    Lighting.ClockTime = 14
                    Lighting.FogEnd = 100000
                    Lighting.GlobalShadows = false
                    Lighting.Ambient =
                        Color3.new(1,1,1)
                    Lighting.OutdoorAmbient =
                        Color3.new(1,1,1)
                end
            end

            if key == "Fly" then
                if not Config.Fly then
                    local root = GetRoot(LocalPlayer)

                    if root then
                        local velocity =
                            root:FindFirstChild(
                                "CoalFlyVelocity"
                            )

                        if velocity then
                            velocity:Destroy()
                        end
                    end
                end
            end
        end
    )
end

local function Button(text, callback)
    local button = Instance.new("TextButton")
    button.Size =
        UDim2.new(1,-5,0,44)

    button.BackgroundColor3 =
        Color3.fromRGB(32,32,38)

    button.BorderSizePixel = 0
    button.Text = text
    button.TextColor3 =
        Color3.fromRGB(240,240,245)
    button.Font = Enum.Font.GothamSemibold
    button.TextSize = 12
    button.Parent = Content

    Instance.new("UICorner",button).CornerRadius =
        UDim.new(0,10)

    Connect(
        button.MouseButton1Click,
        callback
    )
end

local function Slider(
    text,
    key,
    min,
    max
)

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1,-5,0,65)
    frame.BackgroundColor3 =
        Color3.fromRGB(32,32,38)
    frame.BorderSizePixel = 0
    frame.Parent = Content

    Instance.new("UICorner",frame).CornerRadius =
        UDim.new(0,10)

    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0,13,0,6)
    label.Size = UDim2.new(0.7,0,0,22)
    label.Text = text
    label.Font = Enum.Font.GothamSemibold
    label.TextColor3 =
        Color3.fromRGB(240,240,245)
    label.TextSize = 12
    label.TextXAlignment =
        Enum.TextXAlignment.Left
    label.Parent = frame

    local value = Instance.new("TextLabel")
    value.BackgroundTransparency = 1
    value.Position = UDim2.new(0.7,0,0,6)
    value.Size = UDim2.new(0.27,0,0,22)
    value.Font = Enum.Font.GothamBold
    value.TextColor3 =
        Color3.fromRGB(90,145,255)
    value.TextSize = 11
    value.TextXAlignment =
        Enum.TextXAlignment.Right
    value.Parent = frame

    local bar = Instance.new("Frame")
    bar.Position = UDim2.new(0,13,0,40)
    bar.Size = UDim2.new(1,-26,0,7)
    bar.BackgroundColor3 =
        Color3.fromRGB(60,60,70)
    bar.BorderSizePixel = 0
    bar.Parent = frame

    Instance.new("UICorner",bar).CornerRadius =
        UDim.new(1,0)

    local fill = Instance.new("Frame")
    fill.BackgroundColor3 =
        Color3.fromRGB(90,145,255)
    fill.BorderSizePixel = 0
    fill.Parent = bar

    Instance.new("UICorner",fill).CornerRadius =
        UDim.new(1,0)

    local dragging = false

    local function Refresh()
        local current = Config[key]

        local percent =
            math.clamp(
                (current-min)/(max-min),
                0,
                1
            )

        fill.Size =
            UDim2.new(percent,0,1,0)

        value.Text =
            tostring(math.floor(current*100)/100)
    end

    local function Change(x)
        local percent =
            math.clamp(
                (x-bar.AbsolutePosition.X)
                /bar.AbsoluteSize.X,
                0,
                1
            )

        Config[key] =
            min+(max-min)*percent

        Refresh()
    end

    Connect(
        bar.InputBegan,
        function(input)
            if input.UserInputType ==
                Enum.UserInputType.Touch
                or input.UserInputType ==
                Enum.UserInputType.MouseButton1 then

                dragging = true
                Change(input.Position.X)
            end
        end
    )

    Connect(
        UIS.InputChanged,
        function(input)
            if dragging and (
                input.UserInputType ==
                    Enum.UserInputType.Touch
                or input.UserInputType ==
                    Enum.UserInputType.MouseMovement
            ) then
                Change(input.Position.X)
            end
        end
    )

    Connect(
        UIS.InputEnded,
        function(input)
            if input.UserInputType ==
                Enum.UserInputType.Touch
                or input.UserInputType ==
                Enum.UserInputType.MouseButton1 then

                dragging = false
            end
        end
    )

    Refresh()
end

--------------------------------------------------
-- TABS
--------------------------------------------------

local Tabs = {}
local CurrentTab = "Combat"

local function CreateTab(name,icon)
    local button = Instance.new("TextButton")
    button.Size =
        UDim2.new(1,0,0,43)
    button.BackgroundColor3 =
        Color3.fromRGB(25,25,29)
    button.BorderSizePixel = 0
    button.Text =
        icon.."  "..name
    button.TextColor3 =
        Color3.fromRGB(145,145,155)
    button.Font =
        Enum.Font.GothamSemibold
    button.TextSize = 12
    button.Parent = Sidebar

    Instance.new("UICorner",button).CornerRadius =
        UDim.new(0,10)

    Tabs[name] = button

    Connect(
        button.MouseButton1Click,
        function()
            CurrentTab = name

            for _,tab in pairs(Tabs) do
                tab.BackgroundColor3 =
                    Color3.fromRGB(25,25,29)

                tab.TextColor3 =
                    Color3.fromRGB(145,145,155)
            end

            button.BackgroundColor3 =
                Color3.fromRGB(49,57,78)

            button.TextColor3 =
                Color3.fromRGB(245,245,248)

            LoadTab(name)
        end
    )
end

function LoadTab(name)

    Clear()

    if name == "Combat" then

        Section("AIM")

        Toggle(
            "Aim Assist",
            "AimAssist",
            "Smooth target assistance"
        )

        Slider(
            "Aim FOV",
            "AimFOV",
            30,
            500
        )

        Slider(
            "Aim Smooth",
            "AimSmooth",
            0.05,
            1
        )

        Toggle(
            "Team Check",
            "TeamCheck"
        )

        Section("COMBAT")

        Toggle(
            "Trigger Bot",
            "TriggerBot",
            "Activate equipped tool on target"
        )

        Toggle(
            "Hitbox",
            "Hitbox"
        )

        Slider(
            "Hitbox Size",
            "HitboxSize",
            2,
            18
        )

    elseif name == "Visuals" then

        Section("ESP")

        Toggle(
            "Player ESP",
            "ESP"
        )

        Toggle(
            "Box ESP",
            "BoxESP"
        )

        Toggle(
            "Tracers",
            "Tracers"
        )

        Toggle(
            "Health ESP",
            "HealthESP"
        )

        Toggle(
            "Distance ESP",
            "DistanceESP"
        )

        Section("HUD")

        Toggle(
            "Crosshair",
            "Crosshair"
        )

    elseif name == "Movement" then

        Section("MOVEMENT")

        Toggle(
            "Speed",
            "Speed"
        )

        Slider(
            "Speed Value",
            "SpeedValue",
            16,
            100
        )

        Toggle(
            "Infinite Jump",
            "InfiniteJump"
        )

        Toggle(
            "Fly",
            "Fly"
        )

        Slider(
            "Fly Speed",
            "FlySpeed",
            10,
            300
        )

        Toggle(
            "Noclip",
            "Noclip"
        )

    elseif name == "Misc" then

        Section("PERFORMANCE")

        Toggle(
            "Fullbright",
            "Fullbright"
        )

        Toggle(
            "FPS Boost",
            "FPSBoost"
        )

        Section("UTILITY")

        Toggle(
            "Anti AFK",
            "AntiAFK"
        )

        Button(
            "Rejoin Server",
            function()
                TeleportService:Teleport(
                    game.PlaceId,
                    LocalPlayer
                )
            end
        )

        Button(
            "Reset Character",
            function()
                local hum =
                    GetHumanoid(LocalPlayer)

                if hum then
                    hum.Health = 0
                end
            end
        )

    elseif name == "Settings" then

        Section("COAL HUB")

        Button(
            "Hide Menu",
            function()
                Main.Visible = false
            end
        )

        Button(
            "Reset Settings",
            function()
                for key,value in pairs(Config) do
                    if typeof(value) == "boolean" then
                        Config[key] = false
                    end
                end

                Config.TeamCheck = true
                Config.Crosshair = true
                Config.AimFOV = 120
                Config.AimSmooth = 0.18
                Config.SpeedValue = 28
                Config.FlySpeed = 60

                LoadTab(CurrentTab)
            end
        )

        Button(
            "Destroy Coal Hub",
            function()
                Destroyed = true

                for _,connection in ipairs(Connections) do
                    pcall(function()
                        connection:Disconnect()
                    end)
                end

                Gui:Destroy()
            end
        )

        Section("ABOUT")

        local info = Instance.new("TextLabel")
        info.Size = UDim2.new(1,-5,0,85)
        info.BackgroundColor3 =
            Color3.fromRGB(32,32,38)
        info.BorderSizePixel = 0
        info.Text =
            "Coal Hub\n"
            .."[FPS] Флик\n\n"
            .."Mobile Edition"
        info.TextColor3 =
            Color3.fromRGB(150,150,160)
        info.Font = Enum.Font.Gotham
        info.TextSize = 12
        info.TextWrapped = true
        info.Parent = Content

        Instance.new("UICorner",info).CornerRadius =
            UDim.new(0,10)
    end
end

CreateTab("Combat","⚔")
CreateTab("Visuals","◉")
CreateTab("Movement","↗")
CreateTab("Misc","⚙")
CreateTab("Settings","☷")

Tabs["Combat"].BackgroundColor3 =
    Color3.fromRGB(49,57,78)

Tabs["Combat"].TextColor3 =
    Color3.fromRGB(245,245,248)

LoadTab("Combat")

--------------------------------------------------
-- CROSSHAIR
--------------------------------------------------

local Crosshair = Instance.new("Frame")
Crosshair.AnchorPoint =
    Vector2.new(0.5,0.5)
Crosshair.Position =
    UDim2.fromScale(0.5,0.5)
Crosshair.Size =
    UDim2.fromOffset(30,30)
Crosshair.BackgroundTransparency = 1
Crosshair.Parent = Gui

local function CrossPart(x,y,w,h)
    local p = Instance.new("Frame")
    p.Position =
        UDim2.fromOffset(x,y)
    p.Size =
        UDim2.fromOffset(w,h)
    p.BackgroundColor3 =
        Color3.fromRGB(255,255,255)
    p.BorderSizePixel = 0
    p.Parent = Crosshair
end

CrossPart(14,0,2,10)
CrossPart(14,20,2,10)
CrossPart(0,14,10,2)
CrossPart(20,14,10,2)

--------------------------------------------------
-- MOVEMENT
--------------------------------------------------

Connect(
    UIS.JumpRequest,
    function()
        if Config.InfiniteJump then
            local hum =
                GetHumanoid(LocalPlayer)

            if hum then
                hum:ChangeState(
                    Enum.HumanoidStateType.Jumping
                )
            end
        end
    end
)

local FlyVelocity

local function StopFly()
    if FlyVelocity then
        pcall(function()
            FlyVelocity:Destroy()
        end)

        FlyVelocity = nil
    end
end

local function FlyStep()

    if not Config.Fly then
        StopFly()
        return
    end

    local root =
        GetRoot(LocalPlayer)

    if not root then
        return
    end

    if not FlyVelocity then
        FlyVelocity =
            Instance.new("BodyVelocity")

        FlyVelocity.Name =
            "CoalFlyVelocity"

        FlyVelocity.MaxForce =
            Vector3.new(
                math.huge,
                math.huge,
                math.huge
            )

        FlyVelocity.Parent = root
    end

    local direction = Vector3.zero

    if UIS:IsKeyDown(Enum.KeyCode.W) then
        direction += Camera.CFrame.LookVector
    end

    if UIS:IsKeyDown(Enum.KeyCode.S) then
        direction -= Camera.CFrame.LookVector
    end

    if UIS:IsKeyDown(Enum.KeyCode.A) then
        direction -= Camera.CFrame.RightVector
    end

    if UIS:IsKeyDown(Enum.KeyCode.D) then
        direction += Camera.CFrame.RightVector
    end

    if UIS:IsKeyDown(Enum.KeyCode.Space) then
        direction += Vector3.yAxis
    end

    if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then
        direction -= Vector3.yAxis
    end

    if direction.Magnitude > 0 then
        FlyVelocity.Velocity =
            direction.Unit *
            Config.FlySpeed
    else
        FlyVelocity.Velocity =
            Vector3.zero
    end
end

Connect(
    RunService.Heartbeat,
    function()
        if Destroyed then
            return
        end

        if Config.Speed then
            local hum =
                GetHumanoid(LocalPlayer)

            if hum then
                hum.WalkSpeed =
                    Config.SpeedValue
            end
        end

        if Config.Noclip then
            local char = LocalPlayer.Character

            if char then
                for _,part in ipairs(
                    char:GetDescendants()
                ) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end

        FlyStep()
    end
)

--------------------------------------------------
-- AIM
--------------------------------------------------

Connect(
    RunService.RenderStepped,
    function()

        if Destroyed then
            return
        end

        if Config.AimAssist then
            local target =
                GetNearestTarget()

            if target then

                local wanted =
                    CFrame.lookAt(
                        Camera.CFrame.Position,
                        target.Position
                    )

                Camera.CFrame =
                    Camera.CFrame:Lerp(
                        wanted,
                        Config.AimSmooth
                    )
            end
        end

        Crosshair.Visible =
            Config.Crosshair

    end
)

--------------------------------------------------
-- FULLBRIGHT
--------------------------------------------------

local oldLighting = {
    Brightness = Lighting.Brightness,
    ClockTime = Lighting.ClockTime,
    FogEnd = Lighting.FogEnd,
    GlobalShadows = Lighting.GlobalShadows,
    Ambient = Lighting.Ambient,
    OutdoorAmbient =
        Lighting.OutdoorAmbient
}

Connect(
    RunService.RenderStepped,
    function()

        if Config.Fullbright then
            Lighting.Brightness = 3
            Lighting.ClockTime = 14
            Lighting.FogEnd = 100000
            Lighting.GlobalShadows = false
            Lighting.Ambient =
                Color3.new(1,1,1)
            Lighting.OutdoorAmbient =
                Color3.new(1,1,1)
        end

    end
)

--------------------------------------------------
-- FPS BOOST
--------------------------------------------------

local function FPSBoost()

    if not Config.FPSBoost then
        return
    end

    for _,object in ipairs(
        workspace:GetDescendants()
    ) do

        if object:IsA("ParticleEmitter")
            or object:IsA("Trail")
            or object:IsA("Smoke")
            or object:IsA("Fire") then

            object.Enabled = false

        elseif object:IsA("BasePart") then

            pcall(function()
                object.Material =
                    Enum.Material.SmoothPlastic
            end)

        end
    end
end

Connect(
    RunService.Heartbeat,
    function()
        if Config.FPSBoost then
            FPSBoost()
        end
    end
)

--------------------------------------------------
-- ANTI AFK
--------------------------------------------------

local AFKConnection

local function AntiAFK()

    if Config.AntiAFK then

        if AFKConnection then
            return
        end

        AFKConnection =
            LocalPlayer.Idled:Connect(
                function()

                    local VirtualUser =
                        game:GetService(
                            "VirtualUser"
                        )

                    VirtualUser:CaptureController()

                    VirtualUser:ClickButton2(
                        Vector2.new()
                    )
                end
            )

    else

        if AFKConnection then
            AFKConnection:Disconnect()
            AFKConnection = nil
        end
    end
end

Connect(
    RunService.Heartbeat,
    function()
        AntiAFK()
    end
)

--------------------------------------------------
-- SEARCH
--------------------------------------------------

Connect(
    Search:GetPropertyChangedSignal("Text"),
    function()

        local query =
            string.lower(
                Search.Text or ""
            )

        for _,child in ipairs(
            Content:GetChildren()
        ) do

            if child:IsA("Frame")
                or child:IsA("TextButton")
                or child:IsA("TextLabel") then

                local text = ""

                pcall(function()
                    text =
                        string.lower(
                            child.Text or ""
                        )
                end)

                if query == "" then
                    child.Visible = true
                else
                    child.Visible =
                        string.find(
                            text,
                            query,
                            1,
                            true
                        ) ~= nil
                end
            end
        end
    end
)

--------------------------------------------------
-- OPEN / CLOSE
--------------------------------------------------

local OpenButton = Instance.new("TextButton")
OpenButton.AnchorPoint =
    Vector2.new(0,1)
OpenButton.Position =
    UDim2.new(0,12,1,-12)
OpenButton.Size =
    UDim2.fromOffset(52,52)
OpenButton.BackgroundColor3 =
    Color3.fromRGB(25,25,30)
OpenButton.Text = "C"
OpenButton.TextColor3 =
    Color3.fromRGB(245,245,248)
OpenButton.Font =
    Enum.Font.GothamBold
OpenButton.TextSize = 18
OpenButton.Visible = false
OpenButton.Parent = Gui

Instance.new("UICorner",OpenButton).CornerRadius =
    UDim.new(1,0)

Connect(
    OpenButton.MouseButton1Click,
    function()
        Main.Visible = true
        OpenButton.Visible = false
    end
)

local CloseButton = Instance.new("TextButton")
CloseButton.AnchorPoint =
    Vector2.new(1,0)
CloseButton.Position =
    UDim2.new(1,-12,0,12)
CloseButton.Size =
    UDim2.fromOffset(38,38)
CloseButton.BackgroundColor3 =
    Color3.fromRGB(42,42,48)
CloseButton.Text = "×"
CloseButton.TextColor3 =
    Color3.fromRGB(245,245,248)
CloseButton.Font =
    Enum.Font.GothamBold
CloseButton.TextSize = 22
CloseButton.Parent = Header

Instance.new("UICorner",CloseButton).CornerRadius =
    UDim.new(0,10)

Connect(
    CloseButton.MouseButton1Click,
    function()
        Main.Visible = false
        OpenButton.Visible = true
    end
)

--------------------------------------------------
-- DRAG
--------------------------------------------------

local dragging = false
local dragStart
local startPosition

Connect(
    Header.InputBegan,
    function(input)

        if input.UserInputType ==
            Enum.UserInputType.Touch
            or input.UserInputType ==
            Enum.UserInputType.MouseButton1 then

            dragging = true
            dragStart = input.Position
            startPosition = Main.Position
        end

    end
)

Connect(
    UIS.InputChanged,
    function(input)

        if not dragging then
            return
        end

        if input.UserInputType ==
            Enum.UserInputType.Touch
            or input.UserInputType ==
            Enum.UserInputType.MouseMovement then

            local delta =
                input.Position - dragStart

            Main.Position =
                UDim2.new(
                    startPosition.X.Scale,
                    startPosition.X.Offset + delta.X,
                    startPosition.Y.Scale,
                    startPosition.Y.Offset + delta.Y
                )
        end
    end
)

Connect(
    UIS.InputEnded,
    function(input)

        if input.UserInputType ==
            Enum.UserInputType.Touch
            or input.UserInputType ==
            Enum.UserInputType.MouseButton1 then

            dragging = false
        end

    end
)

--------------------------------------------------
-- KEYBIND
--------------------------------------------------

Connect(
    UIS.InputBegan,
    function(input,processed)

        if processed then
            return
        end

        if input.KeyCode ==
            Enum.KeyCode.RightShift then

            Main.Visible =
                not Main.Visible

            OpenButton.Visible =
                not Main.Visible
        end

    end
)

_G.CoalHub = {
    Config = Config,

    GetTarget = GetNearestTarget,

    Toggle = function(name)
        if Config[name] ~= nil then
            Config[name] =
                not Config[name]

            return Config[name]
        end
    end,

    Set = function(name,value)
        if Config[name] ~= nil then
            Config[name] = value
            return true
        end

        return false
    end
}

-- END
