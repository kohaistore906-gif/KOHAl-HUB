
--====================================================
-- KOHΛI HUB v2.0
-- Roblox Studio | Mobile + PC
--====================================================

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- Remove interface antiga
local Old = PlayerGui:FindFirstChild("KOHΛI_HUB")
if Old then Old:Destroy() end

-- CONFIGURAÇÕES
local DEFAULT_SPEED = 16
local MAX_SPEED = 100000000

local BLUE = Color3.fromRGB(35, 110, 245)
local DARK = Color3.fromRGB(10, 17, 30)
local CARD = Color3.fromRGB(22, 34, 53)
local WHITE = Color3.fromRGB(245, 248, 255)
local GRAY = Color3.fromRGB(150, 170, 200)

local InfiniteJump = false
local CurrentSpeed = DEFAULT_SPEED
local CurrentHumanoid = nil

-- FUNÇÕES VISUAIS
local function Corner(object, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius)
    c.Parent = object
end

local function Create(class, properties, parent)
    local object = Instance.new(class)

    for key, value in pairs(properties) do
        object[key] = value
    end

    object.Parent = parent
    return object
end

local function Notify(message)
    print("[KOHΛI HUB] " .. message)
end

-- INTERFACE
local GUI = Create("ScreenGui", {
    Name = "KOHΛI_HUB",
    ResetOnSpawn = false,
    DisplayOrder = 100,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling
}, PlayerGui)

-- BOLINHA FLUTUANTE
local Ball = Create("TextButton", {
    Name = "FloatingBall",
    Size = UDim2.fromOffset(55, 55),
    Position = UDim2.new(0, 20, 0.5, -27),
    BackgroundColor3 = BLUE,
    Text = "K",
    TextColor3 = WHITE,
    TextSize = 25,
    Font = Enum.Font.GothamBold,
    AutoButtonColor = false
}, GUI)

Corner(Ball, 100)

local BallStroke = Create("UIStroke", {
    Color = Color3.fromRGB(120, 180, 255),
    Thickness = 2
}, Ball)

-- PAINEL
local Panel = Create("Frame", {
    Name = "MainPanel",
    Size = UDim2.new(0.88, 0, 0, 310),
    Position = UDim2.new(0.5, 0, 0.5, 0),
    AnchorPoint = Vector2.new(0.5, 0.5),
    BackgroundColor3 = DARK,
    Visible = false,
    BorderSizePixel = 0
}, GUI)

Corner(Panel, 15)

Create("UISizeConstraint", {
    MinSize = Vector2.new(280, 300),
    MaxSize = Vector2.new(420, 310)
}, Panel)

Create("UIStroke", {
    Color = BLUE,
    Thickness = 1.5,
    Transparency = 0.25
}, Panel)

-- CABEÇALHO
local Header = Create("Frame", {
    Size = UDim2.new(1, 0, 0, 58),
    BackgroundColor3 = CARD,
    BorderSizePixel = 0
}, Panel)

Corner(Header, 15)

Create("TextLabel", {
    Size = UDim2.new(1, -65, 1, 0),
    Position = UDim2.fromOffset(15, 0),
    BackgroundTransparency = 1,
    Text = "⚡ KOHΛI HUB",
    TextColor3 = WHITE,
    TextSize = 19,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left
}, Header)

local Close = Create("TextButton", {
    Size = UDim2.fromOffset(36, 36),
    Position = UDim2.new(1, -45, 0.5, -18),
    BackgroundColor3 = DARK,
    Text = "×",
    TextColor3 = WHITE,
    TextSize = 23,
    Font = Enum.Font.GothamBold
}, Header)

Corner(Close, 9)

-- CONTEÚDO
local Content = Create("Frame", {
    Position = UDim2.fromOffset(14, 70),
    Size = UDim2.new(1, -28, 1, -82),
    BackgroundTransparency = 1
}, Panel)

-- CARD DO PULO
local JumpCard = Create("Frame", {
    Size = UDim2.new(1, 0, 0, 75),
    BackgroundColor3 = CARD,
    BorderSizePixel = 0
}, Content)

Corner(JumpCard, 11)

Create("TextLabel", {
    Position = UDim2.fromOffset(13, 8),
    Size = UDim2.new(1, -90, 0, 23),
    BackgroundTransparency = 1,
    Text = "Infinite Jump",
    TextColor3 = WHITE,
    TextSize = 14,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left
}, JumpCard)

Create("TextLabel", {
    Position = UDim2.fromOffset(13, 35),
    Size = UDim2.new(1, -90, 0, 22),
    BackgroundTransparency = 1,
    Text = "Permite pular repetidamente no ar",
    TextColor3 = GRAY,
    TextSize = 10,
    Font = Enum.Font.Gotham,
    TextXAlignment = Enum.TextXAlignment.Left
}, JumpCard)

local JumpButton = Create("TextButton", {
    Size = UDim2.fromOffset(48, 27),
    Position = UDim2.new(1, -60, 0.5, -13),
    BackgroundColor3 = CARD,
    Text = "OFF",
    TextColor3 = WHITE,
    TextSize = 10,
    Font = Enum.Font.GothamBold
}, JumpCard)

Corner(JumpButton, 8)

-- CARD DA VELOCIDADE
local SpeedCard = Create("Frame", {
    Position = UDim2.fromOffset(0, 86),
    Size = UDim2.new(1, 0, 0, 105),
    BackgroundColor3 = CARD,
    BorderSizePixel = 0
}, Content)

Corner(SpeedCard, 11)

Create("TextLabel", {
    Position = UDim2.fromOffset(13, 7),
    Size = UDim2.new(1, -26, 0, 22),
    BackgroundTransparency = 1,
    Text = "Walk Speed",
    TextColor3 = WHITE,
    TextSize = 14,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left
}, SpeedCard)

local SpeedInput = Create("TextBox", {
    Position = UDim2.fromOffset(12, 35),
    Size = UDim2.new(1, -24, 0, 35),
    BackgroundColor3 = DARK,
    Text = tostring(DEFAULT_SPEED),
    PlaceholderText = "Digite a velocidade",
    PlaceholderColor3 = GRAY,
    TextColor3 = WHITE,
    TextSize = 13,
    Font = Enum.Font.Gotham,
    ClearTextOnFocus = false
}, SpeedCard)

Corner(SpeedInput, 8)

local ApplyButton = Create("TextButton", {
    Position = UDim2.fromOffset(0, 199),
    Size = UDim2.new(0.48, 0, 0, 38),
    BackgroundColor3 = BLUE,
    Text = "APPLY SPEED",
    TextColor3 = WHITE,
    TextSize = 11,
    Font = Enum.Font.GothamBold
}, Content)

Corner(ApplyButton, 9)

local ResetButton = Create("TextButton", {
    Position = UDim2.new(0.52, 0, 0, 199),
    Size = UDim2.new(0.48, 0, 0, 38),
    BackgroundColor3 = Color3.fromRGB(150, 48, 55),
    Text = "RESET ALL",
    TextColor3 = WHITE,
    TextSize = 11,
    Font = Enum.Font.GothamBold
}, Content)

Corner(ResetButton, 9)

Create("TextLabel", {
    Position = UDim2.fromOffset(0, 244),
    Size = UDim2.new(1, 0, 0, 18),
    BackgroundTransparency = 1,
    Text = "KOHΛI HUB • CARD EDITION v2.0",
    TextColor3 = GRAY,
    TextSize = 9,
    Font = Enum.Font.Gotham,
    TextXAlignment = Enum.TextXAlignment.Center
}, Content)

-- PERSONAGEM
local function SetCharacter(character)
    CurrentHumanoid = character:WaitForChild("Humanoid")

    CurrentHumanoid.WalkSpeed = CurrentSpeed
end

if Player.Character then
    SetCharacter(Player.Character)
end

Player.CharacterAdded:Connect(function(character)
    SetCharacter(character)
end)

-- PULO INFINITO
JumpButton.MouseButton1Click:Connect(function()
    InfiniteJump = not InfiniteJump

    JumpButton.Text = InfiniteJump and "ON" or "OFF"

    JumpButton.BackgroundColor3 =
        InfiniteJump and BLUE or CARD

    Notify("Infinite Jump: " ..
        (InfiniteJump and "ON" or "OFF"))
end)

UIS.JumpRequest:Connect(function()
    if not InfiniteJump then return end

    local character = Player.Character
    local humanoid = character and
        character:FindFirstChildOfClass("Humanoid")

    if not humanoid then return end
    if humanoid.Health <= 0 then return end
    if humanoid.Sit then return end

    humanoid:ChangeState(
        Enum.HumanoidStateType.Jumping
    )
end)

-- VELOCIDADE
ApplyButton.MouseButton1Click:Connect(function()
    local value = tonumber(SpeedInput.Text)

    if not value then
        Notify("Digite um número válido!")
        return
    end

    value = math.clamp(value, 1, MAX_SPEED)

    CurrentSpeed = value
    SpeedInput.Text = tostring(value)

    if CurrentHumanoid and CurrentHumanoid.Parent then
        CurrentHumanoid.WalkSpeed = value
    end

    Notify("Velocidade configurada: " .. tostring(value))
end)

-- RESET COMPLETO
local InitialBallPosition = Ball.Position

ResetButton.MouseButton1Click:Connect(function()
    InfiniteJump = false
    CurrentSpeed = DEFAULT_SPEED

    JumpButton.Text = "OFF"
    JumpButton.BackgroundColor3 = CARD

    SpeedInput.Text = tostring(DEFAULT_SPEED)

    if CurrentHumanoid and CurrentHumanoid.Parent then
        CurrentHumanoid.WalkSpeed = DEFAULT_SPEED
    end

    Ball.Position = InitialBallPosition

    Notify("Painel restaurado para o padrão!")
end)

-- ABRIR / FECHAR PAINEL
Close.MouseButton1Click:Connect(function()
    Panel.Visible = false
end)

-- BOLINHA ARRASTÁVEL
local dragging = false
local moved = false
local dragStart
local startPosition
local activeInput
local DRAG_THRESHOLD = 8

Ball.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

        dragging = true
        moved = false
        activeInput = input

        dragStart = input.Position
        startPosition = Ball.Position
    end
end)

UIS.InputChanged:Connect(function(input)
    if not dragging then return end

    local valid =
        input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch

    if not valid then return end

    local delta = input.Position - dragStart

    if delta.Magnitude > DRAG_THRESHOLD then
        moved = true
    end

    if moved then
        Ball.Position = UDim2.new(
            startPosition.X.Scale,
            startPosition.X.Offset + delta.X,
            startPosition.Y.Scale,
            startPosition.Y.Offset + delta.Y
        )
    end
end)

UIS.InputEnded:Connect(function(input)
    if not dragging then return end

    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

        dragging = false

        if not moved then
            Panel.Visible = not Panel.Visible
        end

        activeInput = nil
    end
end)

print("[KOHΛI HUB] v2.0 carregado!")
