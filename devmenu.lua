-- ГЛАВНЫЙ СКРИПТ ОТ Dmitry2001s
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local CreditsLabel = Instance.new("TextLabel")
local ScrollingFrame = Instance.new("ScrollingFrame")
local UIListLayout = Instance.new("UIListLayout")

-- Настройка GUI
ScreenGui.Parent = game:GetService("CoreGui") -- Чтобы не удалялось при смерти
ScreenGui.ResetOnSpawn = false

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
MainFrame.Size = UDim2.new(0, 300, 0, 400)
MainFrame.Active = true
MainFrame.Draggable = true -- Можно двигать мышкой

UICorner.CornerRadius = UDim.new(0, 15)
UICorner.Parent = MainFrame

-- Надпись Dmitry2001s
CreditsLabel.Name = "CreditsLabel"
CreditsLabel.Parent = MainFrame
CreditsLabel.BackgroundTransparency = 1
CreditsLabel.Position = UDim2.new(0, 0, 0, 10)
CreditsLabel.Size = UDim2.new(1, 0, 0, 30)
CreditsLabel.Font = Enum.Font.GothamBold
CreditsLabel.Text = "Dmitry2001s"
CreditsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
CreditsLabel.TextSize = 20
CreditsLabel.TextTransparency = 1 -- Изначально скрыта

-- Контейнер для кнопок
ScrollingFrame.Parent = MainFrame
ScrollingFrame.BackgroundTransparency = 1
ScrollingFrame.Position = UDim2.new(0, 10, 0, 50)
ScrollingFrame.Size = UDim2.new(1, -20, 1, -60)
ScrollingFrame.ScrollBarThickness = 2

UIListLayout.Parent = ScrollingFrame
UIListLayout.Padding = UDim.new(0, 10)
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- ФУНКЦИЯ СОЗДАНИЯ КНОПОК
local function createButton(name, text)
	local btn = Instance.new("TextButton")
	btn.Name = name
	btn.Parent = ScrollingFrame
	btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	btn.Size = UDim2.new(1, -10, 0, 40)
	btn.Font = Enum.Font.Gotham
	btn.Text = text
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.TextSize = 16
	local cl = Instance.new("UICorner")
	cl.CornerRadius = UDim.new(0, 8)
	cl.Parent = btn
	return btn
end

local SpeedBtn = createButton("SpeedBtn", "Speed: 100")
local FlyBtn = createButton("FlyBtn", "Fly: OFF")
local NoclipBtn = createButton("NoclipBtn", "Noclip: OFF")

-- ПЕРЕМЕННЫЕ
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local flying = false
local noclip = false
local speedActive = false

-- 1. ЭФФЕКТ Dmitry2001s (RGB + 5 секунд)
task.spawn(function()
	TweenService:Create(CreditsLabel, TweenInfo.new(1), {TextTransparency = 0}):Play()
	local start = tick()
	while tick() - start < 5 do
		CreditsLabel.TextColor3 = Color3.fromHSV(tick() % 5 / 5, 1, 1)
		task.wait()
	end
	TweenService:Create(CreditsLabel, TweenInfo.new(1), {TextTransparency = 1}):Play()
end)

-- 2. ЛОГИКА SPEED
SpeedBtn.MouseButton1Click:Connect(function()
	speedActive = not speedActive
	local hum = player.Character:FindFirstChild("Humanoid")
	if hum then
		hum.WalkSpeed = speedActive and 100 or 16
		SpeedBtn.BackgroundColor3 = speedActive and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(50, 50, 50)
	end
end)

-- 3. ЛОГИКА NOCLIP
NoclipBtn.MouseButton1Click:Connect(function()
	noclip = not noclip
	NoclipBtn.BackgroundColor3 = noclip and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(50, 50, 50)
end)

RunService.Stepped:Connect(function()
	if noclip and player.Character then
		for _, part in pairs(player.Character:GetDescendants()) do
			if part:IsA("BasePart") then part.CanCollide = false end
		end
	end
end)

-- 4. ЛОГИКА FLY
FlyBtn.MouseButton1Click:Connect(function()
	flying = not flying
	FlyBtn.BackgroundColor3 = flying and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(50, 50, 50)
	
	local root = player.Character:FindFirstChild("HumanoidRootPart")
	if flying and root then
		local bv = Instance.new("BodyVelocity", root)
		local bg = Instance.new("BodyGyro", root)
		bv.Name = "FlyVelocity"
		bg.Name = "FlyGyro"
		bv.MaxForce = Vector3.new(1e6, 1e6, 1e6)
		bg.MaxTorque = Vector3.new(1e6, 1e6, 1e6)
		
		task.spawn(function()
			while flying do
				bg.CFrame = workspace.CurrentCamera.CFrame
				bv.Velocity = workspace.CurrentCamera.CFrame.LookVector * 100
				task.wait()
			end
			bv:Destroy()
			bg:Destroy()
		end)
	end
end)
