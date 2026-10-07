if game.PlaceId ~= 136801880565837 then
    warn("FlickHub: wrong game")
end

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

local LP = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local mouse1press = mouse1press
local mouse1release = mouse1release
local keypress = keypress
local keyrelease = keyrelease

local Settings = {
    Aimbot = false,
    Flickbot = false,
    Triggerbot = false,
    ESP = false,
    Boxes = true,
    Names = true,
    Distance = true,
    Health = true,
    FOV = true,
    FOVRadius = 180,
    Smoothness = 7,
    AutoReload = false,
    NoRecoil = false,
    Speed = false,
    SpeedValue = 24,
    Fly = false,
    FlySpeed = 50,
    Fullbright = false,
    TeamCheck = true,
    WallCheck = true
}

local function Character()
    return LP.Character
end

local function Root()
    local c = Character()
    return c and c:FindFirstChild("HumanoidRootPart")
end

local function Humanoid()
    local c = Character()
    return c and c:FindFirstChildOfClass("Humanoid")
end

local function Alive(plr)
    local c = plr.Character
    local h = c and c:FindFirstChildOfClass("Humanoid")
    return h and h.Health > 0
end

local function IsEnemy(plr)
    if plr == LP or not Alive(plr) then
        return false
    end

    if Settings.TeamCheck and LP.Team and plr.Team then
        if LP.Team == plr.Team then
            return false
        end
    end

    return true
end

local function GetTargetPart(plr)
    local c = plr.Character
    if not c then return nil end

    return c:FindFirstChild("Head")
        or c:FindFirstChild("UpperTorso")
        or c:FindFirstChild("HumanoidRootPart")
end

local function Visible(part)
    if not Settings.WallCheck then
        return true
    end

    if not part then
        return false
    end

    local origin = Camera.CFrame.Position
    local direction = part.Position - origin

    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = {
        LP.Character,
        Camera
    }

    local result = workspace:Raycast(origin, direction, params)

    if not result then
        return true
    end

    return result.Instance:IsDescendantOf(part.Parent)
end

local function GetClosestTarget()
    local mousePos = UIS:GetMouseLocation()
    local best = nil
    local bestDistance = math.huge

    for _, plr in ipairs(Players:GetPlayers()) do
        if IsEnemy(plr) then
            local part = GetTargetPart(plr)

            if part and Visible(part) then
                local screen, onScreen =
                    Camera:WorldToViewportPoint(part.Position)

                if onScreen then
                    local distance =
                        (Vector2.new(screen.X, screen.Y) - mousePos).Magnitude

                    if distance <= Settings.FOVRadius
                    and distance < bestDistance then
                        bestDistance = distance
                        best = part
                    end
                end
            end
        end
    end

    return best
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FlickUltimateHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

pcall(function()
    ScreenGui.Parent = game:GetService("CoreGui")
end)

if not ScreenGui.Parent then
    ScreenGui.Parent = LP:WaitForChild("PlayerGui")
end

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0,620,0,430)
Main.Position = UDim2.new(0.5,-310,0.5,-215)
Main.BackgroundColor3 = Color3.fromRGB(10,11,17)
Main.BorderSizePixel = 0
Main.Parent = ScreenGui

Instance.new("UICorner",Main).CornerRadius = UDim.new(0,16)

local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(75,80,110)
Stroke.Thickness = 1.5
Stroke.Transparency = 0.2
Stroke.Parent = Main

local Top = Instance.new("Frame")
Top.Size = UDim2.new(1,0,0,65)
Top.BackgroundColor3 = Color3.fromRGB(15,16,25)
Top.BorderSizePixel = 0
Top.Parent = Main

Instance.new("UICorner",Top).CornerRadius = UDim.new(0,16)

local Title = Instance.new("TextLabel")
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0,22,0,8)
Title.Size = UDim2.new(0,400,0,30)
Title.Font = Enum.Font.GothamBold
Title.Text = "FLICK"
Title.TextSize = 24
Title.TextColor3 = Color3.fromRGB(245,245,255)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Top

local SubTitle = Instance.new("TextLabel")
SubTitle.BackgroundTransparency = 1
SubTitle.Position = UDim2.new(0,23,0,37)
SubTitle.Size = UDim2.new(0,400,0,18)
SubTitle.Font = Enum.Font.Gotham
SubTitle.Text = "ULTIMATE  •  [FPS] FLICK"
SubTitle.TextSize = 10
SubTitle.TextColor3 = Color3.fromRGB(130,135,160)
SubTitle.TextXAlignment = Enum.TextXAlignment.Left
SubTitle.Parent = Top

local Close = Instance.new("TextButton")
Close.Size = UDim2.new(0,36,0,36)
Close.Position = UDim2.new(1,-48,0,14)
Close.BackgroundColor3 = Color3.fromRGB(35,36,48)
Close.Text = "×"
Close.TextSize = 24
Close.Font = Enum.Font.GothamBold
Close.TextColor3 = Color3.fromRGB(230,230,240)
Close.AutoButtonColor = false
Close.Parent = Top

Instance.new("UICorner",Close).CornerRadius = UDim.new(0,10)

Close.MouseButton1Click:Connect(function()
    Main.Visible = false
end)

local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0,145,1,-80)
Sidebar.Position = UDim2.new(0,12,0,75)
Sidebar.BackgroundColor3 = Color3.fromRGB(14,15,23)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = Main

Instance.new("UICorner",Sidebar).CornerRadius = UDim.new(0,12)

local SideLayout = Instance.new("UIListLayout")
SideLayout.Padding = UDim.new(0,7)
SideLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
SideLayout.SortOrder = Enum.SortOrder.LayoutOrder
SideLayout.Parent = Sidebar

local SidePadding = Instance.new("UIPadding")
SidePadding.PaddingTop = UDim.new(0,10)
SidePadding.Parent = Sidebar

local Pages = {}

local function CreateTab(name,icon)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1,-16,0,42)
    Button.BackgroundColor3 = Color3.fromRGB(20,21,31)
    Button.Text = icon.."   "..name
    Button.Font = Enum.Font.GothamMedium
    Button.TextSize = 13
    Button.TextColor3 = Color3.fromRGB(150,155,180)
    Button.AutoButtonColor = false
    Button.Parent = Sidebar

    Instance.new("UICorner",Button).CornerRadius = UDim.new(0,9)

    local Page = Instance.new("ScrollingFrame")
    Page.Size = UDim2.new(1,-175,1,-85)
    Page.Position = UDim2.new(0,163,0,75)
    Page.BackgroundTransparency = 1
    Page.BorderSizePixel = 0
    Page.ScrollBarThickness = 3
    Page.ScrollBarImageTransparency = 0.4
    Page.Visible = false
    Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Page.Parent = Main

    local Layout = Instance.new("UIListLayout")
    Layout.Padding = UDim.new(0,8)
    Layout.SortOrder = Enum.SortOrder.LayoutOrder
    Layout.Parent = Page

    Pages[name] = {
        Button = Button,
        Page = Page
    }

    Button.MouseButton1Click:Connect(function()
        for _,data in pairs(Pages) do
            data.Page.Visible = false
            data.Button.BackgroundColor3 = Color3.fromRGB(20,21,31)
            data.Button.TextColor3 = Color3.fromRGB(150,155,180)
        end

        Page.Visible = true
        Button.BackgroundColor3 = Color3.fromRGB(70,75,115)
        Button.TextColor3 = Color3.fromRGB(255,255,255)
    end)

    return Page
end

local Combat = CreateTab("Combat","◈")
local Visuals = CreateTab("Visuals","◉")
local Player = CreateTab("Player","◇")
local Misc = CreateTab("Misc","⚙")

Pages.Combat.Page.Visible = true
Pages.Combat.Button.BackgroundColor3 = Color3.fromRGB(70,75,115)
Pages.Combat.Button.TextColor3 = Color3.fromRGB(255,255,255)

local function Toggle(parent,name,description,key,callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1,-8,0,58)
    Frame.BackgroundColor3 = Color3.fromRGB(17,18,27)
    Frame.BorderSizePixel = 0
    Frame.Parent = parent

    Instance.new("UICorner",Frame).CornerRadius = UDim.new(0,10)

    local Label = Instance.new("TextLabel")
    Label.BackgroundTransparency = 1
    Label.Position = UDim2.new(0,14,0,7)
    Label.Size = UDim2.new(1,-80,0,20)
    Label.Text = name
    Label.Font = Enum.Font.GothamMedium
    Label.TextSize = 13
    Label.TextColor3 = Color3.fromRGB(235,235,245)
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame

    local Desc = Instance.new("TextLabel")
    Desc.BackgroundTransparency = 1
    Desc.Position = UDim2.new(0,14,0,29)
    Desc.Size = UDim2.new(1,-80,0,18)
    Desc.Text = description
    Desc.Font = Enum.Font.Gotham
    Desc.TextSize = 9
    Desc.TextColor3 = Color3.fromRGB(115,120,145)
    Desc.TextXAlignment = Enum.TextXAlignment.Left
    Desc.Parent = Frame

    local Switch = Instance.new("TextButton")
    Switch.Size = UDim2.new(0,45,0,24)
    Switch.Position = UDim2.new(1,-58,0.5,-12)
    Switch.BackgroundColor3 = Color3.fromRGB(38,39,52)
    Switch.Text = ""
    Switch.AutoButtonColor = false
    Switch.Parent = Frame

    Instance.new("UICorner",Switch).CornerRadius = UDim.new(1,0)

    local Circle = Instance.new("Frame")
    Circle.Size = UDim2.new(0,18,0,18)
    Circle.Position = UDim2.new(0,3,0.5,-9)
    Circle.BackgroundColor3 = Color3.fromRGB(170,175,195)
    Circle.BorderSizePixel = 0
    Circle.Parent = Switch

    Instance.new("UICorner",Circle).CornerRadius = UDim.new(1,0)

    local function Update()
        local on = Settings[key]

        TweenService:Create(
            Switch,
            TweenInfo.new(0.18),
            {
                BackgroundColor3 = on
                and Color3.fromRGB(85,90,150)
                or Color3.fromRGB(38,39,52)
            }
        ):Play()

        TweenService:Create(
            Circle,
            TweenInfo.new(0.18),
            {
                Position = on
                and UDim2.new(1,-21,0.5,-9)
                or UDim2.new(0,3,0.5,-9)
            }
        ):Play()

        Circle.BackgroundColor3 =
            on
            and Color3.fromRGB(255,255,255)
            or Color3.fromRGB(170,175,195)
    end

    Switch.MouseButton1Click:Connect(function()
        Settings[key] = not Settings[key]
        Update()

        if callback then
            callback(Settings[key])
        end
    end)

    Update()
end

local function Slider(parent,name,min,max,key)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1,-8,0,65)
    Frame.BackgroundColor3 = Color3.fromRGB(17,18,27)
    Frame.BorderSizePixel = 0
    Frame.Parent = parent

    Instance.new("UICorner",Frame).CornerRadius = UDim.new(0,10)

    local Label = Instance.new("TextLabel")
    Label.BackgroundTransparency = 1
    Label.Position = UDim2.new(0,14,0,8)
    Label.Size = UDim2.new(0.7,0,0,20)
    Label.Text = name
    Label.Font = Enum.Font.GothamMedium
    Label.TextSize = 13
    Label.TextColor3 = Color3.fromRGB(235,235,245)
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame

    local Value = Instance.new("TextLabel")
    Value.BackgroundTransparency = 1
    Value.Position = UDim2.new(0.75,0,0,8)
    Value.Size = UDim2.new(0.2,0,0,20)
    Value.Text = tostring(Settings[key])
    Value.Font = Enum.Font.GothamBold
    Value.TextSize = 12
    Value.TextColor3 = Color3.fromRGB(150,155,230)
    Value.TextXAlignment = Enum.TextXAlignment.Right
    Value.Parent = Frame

    local Bar = Instance.new("Frame")
    Bar.Size = UDim2.new(1,-28,0,5)
    Bar.Position = UDim2.new(0,14,0,43)
    Bar.BackgroundColor3 = Color3.fromRGB(35,36,49)
    Bar.BorderSizePixel = 0
    Bar.Parent = Frame

    Instance.new("UICorner",Bar).CornerRadius = UDim.new(1,0)

    local Fill = Instance.new("Frame")
    Fill.BackgroundColor3 = Color3.fromRGB(105,110,190)
    Fill.BorderSizePixel = 0
    Fill.Parent = Bar

    Instance.new("UICorner",Fill).CornerRadius = UDim.new(1,0)

    local dragging = false

    local function Set(x)
        local pct = math.clamp(
            (x-Bar.AbsolutePosition.X)/Bar.AbsoluteSize.X,
            0,1
        )

        local val = math.floor(min+(max-min)*pct)

        Settings[key] = val
        Value.Text = tostring(val)
        Fill.Size = UDim2.new(pct,0,1,0)
    end

    Bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            Set(input.Position.X)
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if dragging and (
            input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch
        ) then
            Set(input.Position.X)
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    local pct = (Settings[key]-min)/(max-min)
    Fill.Size = UDim2.new(pct,0,1,0)
end

Toggle(Combat,"Aimbot","Плавное наведение на цель","Aimbot")
Toggle(Combat,"Flickbot","Мгновенный flick на голову","Flickbot")
Toggle(Combat,"Triggerbot","Автоматическая стрельба по цели","Triggerbot")
Toggle(Combat,"Auto Reload","Автоматическая перезарядка","AutoReload")
Toggle(Combat,"No Recoil","Компенсация отдачи","NoRecoil")
Slider(Combat,"Aimbot Smoothness",1,20,"Smoothness")
Slider(Combat,"FOV Radius",50,500,"FOVRadius")
Toggle(Combat,"Team Check","Игнорировать свою команду","TeamCheck")
Toggle(Combat,"Wall Check","Проверять стены","WallCheck")

Toggle(Visuals,"Player ESP","Показывать игроков","ESP")
Toggle(Visuals,"ESP Boxes","Рамки игроков","Boxes")
Toggle(Visuals,"ESP Names","Имена игроков","Names")
Toggle(Visuals,"ESP Distance","Расстояние","Distance")
Toggle(Visuals,"ESP Health","Здоровье","Health")
Toggle(Visuals,"FOV Circle","Круг FOV","FOV")

Toggle(Player,"Speed","Увеличенная скорость","Speed")
Slider(Player,"Speed Value",16,100,"SpeedValue")
Toggle(Player,"Fly","Свободный полёт","Fly")
Slider(Player,"Fly Speed",10,150,"FlySpeed")

Toggle(Misc,"Fullbright","Максимальная яркость","Fullbright")

local FOVCircle = Instance.new("Frame")
FOVCircle.BackgroundTransparency = 1
FOVCircle.AnchorPoint = Vector2.new(0.5,0.5)
FOVCircle.Parent = ScreenGui

local FOVStroke = Instance.new("UIStroke")
FOVStroke.Color = Color3.fromRGB(120,125,230)
FOVStroke.Thickness = 2
FOVStroke.Transparency = 0.15
FOVStroke.Parent = FOVCircle

Instance.new("UICorner",FOVCircle).CornerRadius = UDim.new(1,0)

RunService.RenderStepped:Connect(function()
    local pos = UIS:GetMouseLocation()

    FOVCircle.Position = UDim2.fromOffset(pos.X,pos.Y)
    FOVCircle.Size = UDim2.fromOffset(
        Settings.FOVRadius*2,
        Settings.FOVRadius*2
    )

    FOVCircle.Visible = Settings.FOV
end)

local ESPObjects = {}

local function RemoveESP(plr)
    if ESPObjects[plr] then
        pcall(function()
            ESPObjects[plr].Gui:Destroy()
        end)

        if ESPObjects[plr].Connection then
            ESPObjects[plr].Connection:Disconnect()
        end

        ESPObjects[plr] = nil
    end
end

local function CreateESP(plr)
    if plr == LP then
        return
    end

    RemoveESP(plr)

    local Gui = Instance.new("BillboardGui")
    Gui.Name = "FlickESP"
    Gui.Size = UDim2.new(0,150,0,65)
    Gui.StudsOffset = Vector3.new(0,3,0)
    Gui.AlwaysOnTop = true
    Gui.Enabled = false

    local Holder = Instance.new("Frame")
    Holder.Size = UDim2.new(1,0,1,0)
    Holder.BackgroundTransparency = 1
    Holder.Parent = Gui

    local Name = Instance.new("TextLabel")
    Name.BackgroundTransparency = 1
    Name.Size = UDim2.new(1,0,0,20)
    Name.Font = Enum.Font.GothamBold
    Name.TextSize = 12
    Name.TextColor3 = Color3.fromRGB(255,255,255)
    Name.Parent = Holder

    local Distance = Instance.new("TextLabel")
    Distance.BackgroundTransparency = 1
    Distance.Position = UDim2.new(0,0,0,19)
    Distance.Size = UDim2.new(1,0,0,16)
    Distance.Font = Enum.Font.Gotham
    Distance.TextSize = 10
    Distance.TextColor3 = Color3.fromRGB(190,195,215)
    Distance.Parent = Holder

    local HealthBG = Instance.new("Frame")
    HealthBG.Size = UDim2.new(0,70,0,5)
    HealthBG.Position = UDim2.new(0.5,-35,0,38)
    HealthBG.BackgroundColor3 = Color3.fromRGB(40,40,45)
    HealthBG.BorderSizePixel = 0
    HealthBG.Parent = Holder

    Instance.new("UICorner",HealthBG).CornerRadius = UDim.new(1,0)

    local HealthFill = Instance.new("Frame")
    HealthFill.BackgroundColor3 = Color3.fromRGB(100,220,120)
    HealthFill.BorderSizePixel = 0
    HealthFill.Size = UDim2.new(1,0,1,0)
    HealthFill.Parent = HealthBG

    Instance.new("UICorner",HealthFill).CornerRadius = UDim.new(1,0)

    local function Update()
        if not Settings.ESP or not IsEnemy(plr) then
            Gui.Enabled = false
            return
        end

        local char = plr.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")

        if not root or not hum or hum.Health <= 0 then
            Gui.Enabled = false
            return
        end

        Gui.Adornee = root
        Gui.Enabled = true

        Name.Visible = Settings.Names
        Distance.Visible = Settings.Distance
        HealthBG.Visible = Settings.Health

        Name.Text = plr.DisplayName

        local myRoot = Root()

        if myRoot then
            Distance.Text =
                math.floor(
                    (myRoot.Position-root.Position).Magnitude
                ).." studs"
        end

        local hp = math.clamp(
            hum.Health/math.max(hum.MaxHealth,1),
            0,1
        )

        HealthFill.Size = UDim2.new(hp,0,1,0)
    end

    local connection = RunService.RenderStepped:Connect(function()
        if not plr.Parent then
            RemoveESP(plr)
            return
        end

        Update()
    end)

    ESPObjects[plr] = {
        Gui = Gui,
        Connection = connection
    }

    task.spawn(function()
        local char = plr.Character

        if char then
            local root = char:FindFirstChild("HumanoidRootPart")

            if root then
                Gui.Parent = root
            end
        end

        plr.CharacterAdded:Connect(function(char)
            task.wait(0.5)

            local root =
                char:WaitForChild(
                    "HumanoidRootPart",
                    5
                )

            if root then
                Gui.Parent = root
            end
        end)
    end)
end

for _,plr in ipairs(Players:GetPlayers()) do
    CreateESP(plr)
end

Players.PlayerAdded:Connect(CreateESP)
Players.PlayerRemoving:Connect(RemoveESP)

RunService.RenderStepped:Connect(function()
    if not Settings.Aimbot and not Settings.Flickbot then
        return
    end

    local target = GetClosestTarget()

    if not target then
        return
    end

    local targetCF =
        CFrame.lookAt(
            Camera.CFrame.Position,
            target.Position
        )

    if Settings.Flickbot then
        Camera.CFrame = targetCF
    else
        local alpha =
            math.clamp(
                1/Settings.Smoothness,
                0.03,
                1
            )

        Camera.CFrame =
            Camera.CFrame:Lerp(
                targetCF,
                alpha
            )
    end
end)

local TriggerCooldown = false

RunService.RenderStepped:Connect(function()
    if not Settings.Triggerbot or TriggerCooldown then
        return
    end

    local target = GetClosestTarget()

    if target then
        TriggerCooldown = true

        if mouse1press then
            pcall(mouse1press)
            task.wait(0.05)

            if mouse1release then
                pcall(mouse1release)
            end
        end

        task.delay(0.15,function()
            TriggerCooldown = false
        end)
    end
end)

task.spawn(function()
    while task.wait(0.25) do
        if Settings.AutoReload and keypress then
            local char = Character()
            local tool = char and char:FindFirstChildOfClass("Tool")

            if tool then
                local ammo =
                    tool:FindFirstChild("Ammo")
                    or tool:FindFirstChild("Clip")
                    or tool:FindFirstChild("Magazine")

                if ammo and ammo:IsA("IntValue")
                and ammo.Value <= 0 then
                    pcall(function()
                        keypress(0x52)
                        task.wait(0.05)

                        if keyrelease then
                            keyrelease(0x52)
                        end
                    end)
                end
            end
        end
    end
end)

RunService.Heartbeat:Connect(function()
    if Settings.Speed then
        local hum = Humanoid()

        if hum then
            hum.WalkSpeed = Settings.SpeedValue
        end
    end
end)

local FlyConnection

FlyConnection = RunService.RenderStepped:Connect(function()
    if not Settings.Fly then
        return
    end

    local root = Root()

    if not root then
        return
    end

    local move = Vector3.zero

    if UIS:IsKeyDown(Enum.KeyCode.W) then
        move += Camera.CFrame.LookVector
    end

    if UIS:IsKeyDown(Enum.KeyCode.S) then
        move -= Camera.CFrame.LookVector
    end

    if UIS:IsKeyDown(Enum.KeyCode.A) then
        move -= Camera.CFrame.RightVector
    end

    if UIS:IsKeyDown(Enum.KeyCode.D) then
        move += Camera.CFrame.RightVector
    end

    if UIS:IsKeyDown(Enum.KeyCode.Space) then
        move += Vector3.yAxis
    end

    if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then
        move -= Vector3.yAxis
    end

    if move.Magnitude > 0 then
        root.AssemblyLinearVelocity =
            move.Unit*Settings.FlySpeed
    else
        root.AssemblyLinearVelocity = Vector3.zero
    end
end)

local OriginalLighting = {
    Brightness = Lighting.Brightness,
    ClockTime = Lighting.ClockTime,
    FogEnd = Lighting.FogEnd,
    GlobalShadows = Lighting.GlobalShadows
}

RunService.RenderStepped:Connect(function()
    if Settings.Fullbright then
        Lighting.Brightness = 3
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = false
    else
        Lighting.Brightness = OriginalLighting.Brightness
        Lighting.ClockTime = OriginalLighting.ClockTime
        Lighting.FogEnd = OriginalLighting.FogEnd
        Lighting.GlobalShadows = OriginalLighting.GlobalShadows
    end
end)

local LastCameraCF

RunService.RenderStepped:Connect(function()
    if not Settings.NoRecoil then
        LastCameraCF = Camera.CFrame
        return
    end

    if LastCameraCF then
        local current = Camera.CFrame

        local rx,ry,rz = current:ToOrientation()
        local lx,ly,lz = LastCameraCF:ToOrientation()

        local deltaX = rx-lx
        local deltaY = ry-ly

        if math.abs(deltaX) > 0.01
        or math.abs(deltaY) > 0.01 then
            Camera.CFrame =
                current*CFrame.Angles(
                    -deltaX,
                    -deltaY,
                    0
                )
        end
    end

    LastCameraCF = Camera.CFrame
end)

local dragging = false
local dragStart
local startPos

Top.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Main.Position
    end
end)

Top.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

UIS.InputChanged:Connect(function(input)
    if not dragging then
        return
    end

    if input.UserInputType == Enum.UserInputType.MouseMovement
    or input.UserInputType == Enum.UserInputType.Touch then
        local delta = input.Position-dragStart

        Main.Position =
            UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset+delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset+delta.Y
            )
    end
end)

UIS.InputBegan:Connect(function(input,gp)
    if gp then
        return
    end

    if input.KeyCode == Enum.KeyCode.RightShift then
        Main.Visible = not Main.Visible
    end
end)

if UIS.TouchEnabled then
    local Open = Instance.new("TextButton")
    Open.Size = UDim2.new(0,55,0,55)
    Open.Position = UDim2.new(1,-75,0,100)
    Open.BackgroundColor3 = Color3.fromRGB(35,37,60)
    Open.Text = "F"
    Open.TextColor3 = Color3.fromRGB(255,255,255)
    Open.TextSize = 22
    Open.Font = Enum.Font.GothamBold
    Open.AutoButtonColor = false
    Open.Parent = ScreenGui

    Instance.new("UICorner",Open).CornerRadius = UDim.new(1,0)

    local OpenStroke = Instance.new("UIStroke")
    OpenStroke.Color = Color3.fromRGB(110,115,210)
    OpenStroke.Thickness = 2
    OpenStroke.Parent = Open

    Open.MouseButton1Click:Connect(function()
        Main.Visible = not Main.Visible
    end)
end

Main.Size = UDim2.new(0,560,0,390)

TweenService:Create(
    Main,
    TweenInfo.new(
        0.45,
        Enum.EasingStyle.Quint,
        Enum.EasingDirection.Out
    ),
    {
        Size = UDim2.new(0,620,0,430)
    }
):Play()
