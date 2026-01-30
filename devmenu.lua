-- Dmitry2001s Ultimate Menu v5.0 (Final Fix)
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
local flySpeedVal = 50
local flying, noclip = false, false
local noclipConn

-- ТЕМЫ
local themes = {
    Dark = Color3.fromRGB(25, 25, 25),
    Cyberpunk = Color3.fromRGB(40, 0, 60),
    Neon = Color3.fromRGB(0, 45, 45),
    White = Color3.fromRGB(240, 240, 240)
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
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", btn)
end
styleTab(FunctionsTabBtn, "Functions", UDim2.new(0, 0, 0, 0))
styleTab(SettingsTabBtn, "Settings", UDim2.new(0.5, 5, 0, 0))

local function setupPage(page)
    page.Size = UDim2.new(1, -20, 1, -100)
    page.Position = UDim2.new(0, 10, 0, 85)
    page.BackgroundTransparency = 1
    page.ScrollBarThickness = 2
    Instance.new("UIListLayout", page).Padding = UDim.new(0, 10)
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
    btn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    btn.Text = text
    btn.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", btn)
    btn.MouseButton1Click:Connect(function() callback(btn) end)
    return btn
end

-- СЛАЙДЕР
function createSlider(parent, labelText, min, max, default, callback)
    local container = Instance.new("Frame", parent)
    container.Size = UDim2.new(1, 0, 0, 45)
    container.BackgroundTransparency = 1
    local lab = Instance.new("TextLabel", container); lab.Size = UDim2.new(1,0,0,15); lab.Text = labelText..": "..default; lab.TextColor3 = Color3.new(1,1,1); lab.BackgroundTransparency = 1
    local bar = Instance.new("TextButton", container); bar.Size = UDim2.new(1,0,0,8); bar.Position = UDim2.new(0,0,0,20); bar.Text = ""; bar.BackgroundColor3 = Color3.new(0.3,0.3,0.3); Instance.new("UICorner", bar)
    local fill = Instance.new("Frame", bar); fill.Size = UDim2.new((default-min)/(max-min),0,1,0); fill.BackgroundColor3 = Color3.new(0,1,0.5); Instance.new("UICorner", fill)
    bar.MouseButton1Down:Connect(function()
        local move = RunService.RenderStepped:Connect(function()
            local p = math.clamp((UserInputService:GetMouseLocation().X - bar.AbsolutePosition.X)/bar.AbsoluteSize.X, 0, 1)
            fill.Size = UDim2.new(p,0,1,0)
            local v = math.floor(min + (p*(max-min)))
            lab.Text = labelText..": "..v
            callback(v)
        end)
        UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then move:Disconnect() end end)
    end)
end

-- ФУНКЦИИ
createBtn(FunctionsPage, "Fly: OFF", function(b)
    flying = not flying
    b.Text = "Fly: "..(flying and "ON" or "OFF")
    b.BackgroundColor3 = flying and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(70, 70, 70)
    
    if flying then
        local char = player.Character
        local root = char:FindFirstChild("HumanoidRootPart")
        local camera = workspace.CurrentCamera
        local bv = Instance.new("BodyVelocity", root)
        bv.MaxForce = Vector3.new(1e6, 1e6, 1e6)
        bv.Velocity = Vector3.new(0,0,0)
        
        task.spawn(function()
            while flying do
                local dir = camera.CFrame.LookVector
                local move = char.Humanoid.MoveDirection
                if move.Magnitude > 0 then
                    bv.Velocity = dir * flySpeedVal
                else
                    bv.Velocity = Vector3.new(0, 0.1, 0)
                end
                task.wait()
            end
            bv:Destroy()
        end)
    end
end)

createBtn(FunctionsPage, "Noclip: OFF", function(b)
    noclip = not noclip
    b.Text = "Noclip: "..(noclip and "ON" or "OFF")
    b.BackgroundColor3 = noclip and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(70, 70, 70)
    
    if noclip then
        noclipConn = RunService.Stepped:Connect(function()
            if not noclip then noclipConn:Disconnect() return end
            if player.Character then
                for _, p in pairs(player.Character:GetDescendants()) do
                    if p:IsA("BasePart") then p.CanCollide = false end
                end
            end
        end)
    else
        if noclipConn then noclipConn:Disconnect() end
    end
end)

createSlider(FunctionsPage, "Walk Speed", 16, 300, 16, function(v) if player.Character then player.Character.Humanoid.WalkSpeed = v end end)
createSlider(FunctionsPage, "Fly Speed", 10, 500, 50, function(v) flySpeedVal = v end)

-- НАСТРОЙКИ (Тема и Язык)
createBtn(SettingsPage, "Theme: Change", function(b)
    if MainFrame.BackgroundColor3 == themes.Dark then MainFrame.BackgroundColor3 = themes.Cyberpunk
    elseif MainFrame.BackgroundColor3 == themes.Cyberpunk then MainFrame.BackgroundColor3 = themes.Neon
    elseif MainFrame.BackgroundColor3 == themes.Neon then MainFrame.BackgroundColor3 = themes.White
        CreditsLabel.TextColor3 = Color3.new(0,0,0) -- Чтобы было видно на белом
    else MainFrame.BackgroundColor3 = themes.Dark end
end)

createBtn(SettingsPage, "Lang: RU/EN", function(b)
    lang = (lang == "RU" and "EN" or "RU")
    FunctionsTabBtn.Text = (lang == "RU" and "Функции" or "Functions")
    SettingsTabBtn.Text = (lang == "RU" and "Настройки" or "Settings")
end)
