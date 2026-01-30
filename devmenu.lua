-- Dmitry2001s Ultimate Menu v4.0 (Fly Speed Update)
local player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local MainFrame = Instance.new("Frame", ScreenGui)
local UICorner = Instance.new("UICorner", MainFrame)
local CloseBtn = Instance.new("TextButton", MainFrame)
local CreditsLabel = Instance.new("TextLabel", MainFrame)

local TabButtons = Instance.new("Frame", MainFrame)
local FunctionsTabBtn = Instance.new("TextButton", TabButtons)
local SettingsTabBtn = Instance.new("TextButton", TabButtons)

local FunctionsPage = Instance.new("ScrollingFrame", MainFrame)
local SettingsPage = Instance.new("ScrollingFrame", MainFrame)

-- СОСТОЯНИЕ
local lang = "RU"
local walkSpeedVal = 16
local flySpeedVal = 50
local flying, noclip = false, false

-- ТЕМЫ
local themes = {
    Dark = Color3.fromRGB(25, 25, 25),
    Cyberpunk = Color3.fromRGB(40, 0, 60),
    Neon = Color3.fromRGB(0, 45, 45)
}

-- ЛОКАЛИЗАЦИЯ
local langData = {
    RU = {func = "Функции", sett = "Настройки", fly = "Полет", noclip = "Сквозь стены", lang = "Язык: RU", theme = "Тема: ", fspeed = "Скорость полета: ", wspeed = "Скорость ходьбы: "},
    EN = {func = "Functions", sett = "Settings", fly = "Fly Mode", noclip = "Noclip", lang = "Lang: EN", theme = "Theme: ", fspeed = "Fly Speed: ", wspeed = "Walk Speed: "}
}

-- НАСТРОЙКА GUI
MainFrame.Size = UDim2.new(0, 300, 0, 450)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -225)
MainFrame.BackgroundColor3 = themes.Dark
MainFrame.Active = true
MainFrame.Draggable = true
UICorner.CornerRadius = UDim.new(0, 15)

CloseBtn.Text = "X"
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", CloseBtn)
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

-- ВЕЧНЫЙ RGB НИК
CreditsLabel.Size = UDim2.new(1, 0, 0, 40)
CreditsLabel.BackgroundTransparency = 1
CreditsLabel.Text = "Dmitry2001s"
CreditsLabel.TextSize = 24
CreditsLabel.Font = Enum.Font.GothamBold
task.spawn(function()
    while task.wait() do
        CreditsLabel.TextColor3 = Color3.fromHSV(tick() % 5 / 5, 0.8, 1)
    end
end)

-- НАВИГАЦИЯ
TabButtons.Size = UDim2.new(1, -20, 0, 30)
TabButtons.Position = UDim2.new(0, 10, 0, 45)
TabButtons.BackgroundTransparency = 1

local function styleTab(btn, text, pos)
    btn.Size = UDim2.new(0.5, -5, 1, 0)
    btn.Position = pos
    btn.Text = text
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamMedium
    Instance.new("UICorner", btn)
end
styleTab(FunctionsTabBtn, "Функции", UDim2.new(0, 0, 0, 0))
styleTab(SettingsTabBtn, "Настройки", UDim2.new(0.5, 5, 0, 0))

local function setupPage(page)
    page.Size = UDim2.new(1, -20, 1, -100)
    page.Position = UDim2.new(0, 10, 0, 85)
    page.BackgroundTransparency = 1
    page.CanvasSize = UDim2.new(0, 0, 1.2, 0)
    page.ScrollBarThickness = 2
    local list = Instance.new("UIListLayout", page)
    list.Padding = UDim.new(0, 10)
end
setupPage(FunctionsPage)
setupPage(SettingsPage)
SettingsPage.Visible = false

FunctionsTabBtn.MouseButton1Click:Connect(function() FunctionsPage.Visible = true SettingsPage.Visible = false end)
SettingsTabBtn.MouseButton1Click:Connect(function() FunctionsPage.Visible = false SettingsPage.Visible = true end)

-- ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ
function createBtn(parent, text, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
    btn.Text = text
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.Gotham
    Instance.new("UICorner", btn)
    btn.MouseButton1Click:Connect(function() callback(btn) end)
    return btn
end

function createSlider(parent, labelText, min, max, default, callback)
    local container = Instance.new("Frame", parent)
    container.Size = UDim2.new(1, 0, 0, 50)
    container.BackgroundTransparency = 1
    
    local lab = Instance.new("TextLabel", container)
    lab.Size = UDim2.new(1, 0, 0, 20)
    lab.Text = labelText .. ": " .. default
    lab.TextColor3 = Color3.new(1,1,1)
    lab.BackgroundTransparency = 1
    lab.Font = Enum.Font.Gotham
    
    local bar = Instance.new("TextButton", container)
    bar.Size = UDim2.new(1, 0, 0, 10)
    bar.Position = UDim2.new(0, 0, 0, 25)
    bar.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    bar.Text = ""
    Instance.new("UICorner", bar)
    
    local fill = Instance.new("Frame", bar)
    fill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
    Instance.new("UICorner", fill)

    local function update(input)
        local pos = math.clamp((input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
        fill.Size = UDim2.new(pos, 0, 1, 0)
        local val = math.floor(min + (pos * (max - min)))
        lab.Text = labelText .. ": " .. val
        callback(val)
    end

    bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            local move = UserInputService.InputChanged:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then
                    update(i)
                end
            end)
            UserInputService.InputEnded:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                    move:Disconnect()
                end
            end)
            update(input)
        end
    end)
end

-- ВКЛАДКА: ФУНКЦИИ
createToggle = function(text, callback)
    local btn = createBtn(FunctionsPage, text .. ": OFF", function(b)
        local s = not b:GetAttribute("Active")
        b:SetAttribute("Active", s)
        b.Text = text .. ": " .. (s and "ON" or "OFF")
        b.BackgroundColor3 = s and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(55, 55, 55)
        callback(s)
    end)
end

createToggle(langData[lang].fly, function(v)
    flying = v
    if flying and player.Character then
        local root = player.Character:FindFirstChild("HumanoidRootPart")
        local bv = Instance.new("BodyVelocity", root)
        bv.Name = "FlyV"
        bv.MaxForce = Vector3.new(1e6, 1e6, 1e6)
        task.spawn(function()
            while flying do
                bv.Velocity = player.Character.Humanoid.MoveDirection * flySpeedVal + Vector3.new(0, 0.1, 0)
                task.wait()
            end
            if bv then bv:Destroy() end
        end)
    end
end)

createToggle(langData[lang].noclip, function(v) noclip = v end)

createSlider(FunctionsPage, "Speed", 16, 300, 16, function(v)
    walkSpeedVal = v
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = v
    end
end)

createSlider(FunctionsPage, "Fly Speed", 10, 500, 50, function(v)
    flySpeedVal = v
end)

-- ВКЛАДКА: НАСТРОЙКИ
local langBtn = createBtn(SettingsPage, "Language: RU", function(b)
    lang = (lang == "RU" and "EN" or "RU")
    b.Text = langData[lang].lang
    FunctionsTabBtn.Text = langData[lang].func
    SettingsTabBtn.Text = langData[lang].sett
end)

local themeBtn = createBtn(SettingsPage, "Theme: Dark", function(b)
    if MainFrame.BackgroundColor3 == themes.Dark then
        MainFrame.BackgroundColor3 = themes.Cyberpunk
        b.Text = langData[lang].theme .. "Cyberpunk"
    elseif MainFrame.BackgroundColor3 == themes.Cyberpunk then
        MainFrame.BackgroundColor3 = themes.Neon
        b.Text = langData[lang].theme .. "Neon"
    else
        MainFrame.BackgroundColor3 = themes.Dark
        b.Text = langData[lang].theme .. "Dark"
    end
end)

-- ЦИКЛЫ
RunService.Stepped:Connect(function()
    if noclip and player.Character then
        for _, p in pairs(player.Character:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = false end
        end
    end
end)
