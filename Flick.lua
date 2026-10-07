-- Ультра-красивое кастомное меню для [FPS] Флик
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Удаляем старое меню, если оно уже было запущено
if CoreGui:FindFirstChild("FlickUltimateGui") then
    CoreGui.FlickUltimateGui:Destroy()
end

-- Создание главного контейнера
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FlickUltimateGui"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Главное окно (Карточка с градиентом и тенью)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 480, 0, 340)
MainFrame.Position = UDim2.new(0.5, -240, 0.5, -170)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local UICornerMain = Instance.new("UICorner")
UICornerMain.CornerRadius = UDim.new(0, 16)
UICornerMain.Parent = MainFrame

-- Неоновая обводка окна
local UIStrokeMain = Instance.new("UIStroke")
UIStrokeMain.Color = Color3.fromRGB(138, 43, 226)
UIStrokeMain.Thickness = 2
UIStrokeMain.Parent = MainFrame

-- Верхняя панель (Шапка)
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 50)
TopBar.BackgroundColor3 = Color3.fromRGB(22, 22, 32)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local UICornerTop = Instance.new("UICorner")
UICornerTop.CornerRadius = UDim.new(0, 16)
UICornerTop.Parent = TopBar

-- Заголовок
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -60, 1, 0)
Title.Position = UDim2.new(0, 20, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "⚡ FLICK ULTIMATE HUB"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

-- Кнопка закрытия/сворачивания
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 36, 0, 36)
CloseButton.Position = UDim2.new(1, -44, 0.5, -18)
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
CloseButton.Text = "✕"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 16
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Parent = TopBar

local UICornerClose = Instance.new("UICorner")
UICornerClose.CornerRadius = UDim.new(0, 10)
UICornerClose.Parent = CloseButton

-- Контейнер для кнопок (ScrollingFrame)
local Container = Instance.new("ScrollingFrame")
Container.Size = UDim2.new(1, -20, 1, -70)
Container.Position = UDim2.new(0, 10, 0, 60)
Container.BackgroundTransparency = 1
Container.BorderSizePixel = 0
Container.CanvasSize = UDim2.new(0, 0, 0, 320)
Container.ScrollBarThickness = 4
Container.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 12)
UIListLayout.Parent = Container

-- Функция создания красивых переключателей (Toggle)
local function createToggle(name, callback)
    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Size = UDim2.new(1, -10, 0, 48)
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 38)
    ToggleBtn.AutoButtonColor = false
    ToggleBtn.Text = ""
    ToggleBtn.Parent = Container

    local UICornerT = Instance.new("UICorner")
    UICornerT.CornerRadius = UDim.new(0, 12)
    UICornerT.Parent = ToggleBtn

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -70, 1, 0)
    Label.Position = UDim2.new(0, 16, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Color3.fromRGB(210, 210, 225)
    Label.TextSize = 15
    Label.Font = Enum.Font.GothamMedium
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = ToggleBtn

    local StatusIndicator = Instance.new("Frame")
    StatusIndicator.Size = UDim2.new(0, 36, 0, 20)
    StatusIndicator.Position = UDim2.new(1, -46, 0.5, -10)
    StatusIndicator.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
    StatusIndicator.Parent = ToggleBtn

    local UICornerInd = Instance.new("UICorner")
    UICornerInd.CornerRadius = UDim.new(1, 0)
    UICornerInd.Parent = StatusIndicator

    local Circle = Instance.new("Frame")
    Circle.Size = UDim2.new(0, 16, 0, 16)
    Circle.Position = UDim2.new(0, 2, 0.5, -8)
    Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Circle.Parent = StatusIndicator

    local UICornerCirc = Instance.new("UICorner")
    UICornerCirc.CornerRadius = UDim.new(1, 0)
    UICornerCirc.Parent = Circle

    local enabled = false
    ToggleBtn.MouseButton1Click:Connect(function()
        enabled = not enabled
        
        local goalStatusBg = enabled and Color3.fromRGB(0, 220, 130) or Color3.fromRGB(50, 50, 65)
        local goalCirclePos = enabled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
        
        TweenService:Create(StatusIndicator, TweenInfo.new(0.2), {BackgroundColor3 = goalStatusBg}):Play()
        TweenService:Create(Circle, TweenInfo.new(0.2), {Position = goalCirclePos}):Play()
        
        callback(enabled)
    end)
end

-- ================= ФУНКЦИИ ЧИТА =================

-- 1. ESP (Подсветка)
createToggle("Включить ESP (Подсветка игроков)", function(state)
    getgenv().ESPEnabled = state
    
    local function applyESP(player)
        if player == LocalPlayer then return end
        
        local function setup(char)
            if char:FindFirstChild("Highlight_Custom") then
                char.Highlight_Custom:Destroy()
            end
            local hl = Instance.new("Highlight")
            hl.Name = "Highlight_Custom"
            hl.Adornee = char
            hl.Parent = char
            hl.FillColor = Color3.fromRGB(138, 43, 226)
            hl.OutlineColor = Color3.fromRGB(255, 255, 255)
            hl.FillTransparency = 0.4
            
            task.spawn(function()
                while task.wait(0.5) do
                    if not getgenv().ESPEnabled or not char or not char.Parent then
                        hl.Enabled = false
                    else
                        hl.Enabled = true
                    end
                end
            end)
        end
        
        player.CharacterAdded:Connect(setup)
        if player.Character then setup(player.Character) end
    end

    for _, p in ipairs(Players:GetPlayers()) do
        applyESP(p)
    end
    Players.PlayerAdded:Connect(applyESP)
end)

-- 2. Aimbot (Автоприцел)
createToggle("Aimbot (Наведение на голову)", function(state)
    getgenv().AimbotEnabled = state
    
    local function getClosest()
        local target = nil
        local shortest = math.huge
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") and p.Character:FindFirstChild("Humanoid") then
                if p.Character.Humanoid.Health > 0 then
                    local pos, onScreen = Camera:WorldToViewportPoint(p.Character.Head.Position)
                    if onScreen then
                        local dist = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                        if dist < shortest then
                            shortest = dist
                            target = p.Character.Head
                        end
                    end
                end
            end
        end
        return target
    end

    RunService.RenderStepped:Connect(function()
        if getgenv().AimbotEnabled then
            local t = getClosest()
            if t then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, t.Position)
            end
        end
    end)
end)

-- 3. Быстрый бег
createToggle("Ускорение бега (Speed Hack)", function(state)
    getgenv().SpeedEnabled = state
    task.spawn(function()
        while task.wait(0.3) do
            if getgenv().SpeedEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.WalkSpeed = 32
            elseif LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.WalkSpeed = 16
            end
        end
    end)
end)

-- Кнопка закрытия интерфейса
local uiVisible = true
CloseButton.MouseButton1Click:Connect(function()
    uiVisible = not uiVisible
    MainFrame.Visible = uiVisible
end)

-- Перетаскивание меню пальцем по экрану телефона
local dragging, dragInput, dragStart, startPos
TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

TopBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

print("Ультра-красивое меню успешно загружено!")
