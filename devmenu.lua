local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local screenGui = script.Parent

-- 1. СОЗДАНИЕ ИНТЕРФЕЙСА
local greeting = Instance.new("TextLabel", screenGui)
greeting.Size = UDim2.new(1, 0, 1, 0)
greeting.Text = "Dmitry2001s"
greeting.TextSize = 60
greeting.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
greeting.TextColor3 = Color3.fromRGB(255, 255, 255)
greeting.ZIndex = 10

local menu = Instance.new("Frame", screenGui)
menu.Size = UDim2.new(0, 250, 0, 350)
menu.Position = UDim2.new(0.5, -125, 0.5, -175)
menu.BackgroundColor3 = Color3.fromRGB(30, 30, 30) -- Темная тема по умолчанию
menu.BorderSizePixel = 2
menu.Visible = false

local uiCorner = Instance.new("UICorner", menu) -- Скругление углов

-- Функция для создания кнопок
local function createBtn(text, pos)
    local btn = Instance.new("TextButton", menu)
    btn.Size = UDim2.new(0.9, 0, 0.15, 0)
    btn.Position = pos
    btn.Text = text
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 18
    Instance.new("UICorner", btn)
    return btn
end

local speedBtn = createBtn("Скорость: 50", UDim2.new(0.05, 0, 0.1, 0))
local jumpBtn = createBtn("Прыжок: 100", UDim2.new(0.05, 0, 0.3, 0))
local themeBtn = createBtn("Сменить тему", UDim2.new(0.05, 0, 0.7, 0))

-- 2. ЛОГИКА ТЕМ
local isDarkTheme = true
themeBtn.MouseButton1Click:Connect(function()
    isDarkTheme = not isDarkTheme
    if isDarkTheme then
        menu.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        themeBtn.Text = "Тема: Темная"
        -- Меняем цвета всех кнопок
        for _, obj in pairs(menu:GetChildren()) do
            if obj:IsA("TextButton") then
                obj.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                obj.TextColor3 = Color3.new(1, 1, 1)
            end
        end
    else
        menu.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
        themeBtn.Text = "Тема: Светлая"
        for _, obj in pairs(menu:GetChildren()) do
            if obj:IsA("TextButton") then
                obj.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
                obj.TextColor3 = Color3.new(0, 0, 0)
            end
        end
    end
end)

-- 3. ТАЙМЕР И АКТИВАЦИЯ
task.delay(5, function()
    greeting.Visible = false
    menu.Visible = true
end)

-- 4. ТЕСТОВЫЕ ФУНКЦИИ
speedBtn.MouseButton1Click:Connect(function()
    humanoid.WalkSpeed = 50
end)

jumpBtn.MouseButton1Click:Connect(function()
    humanoid.JumpPower = 100
    humanoid.UseJumpPower = true
end)
