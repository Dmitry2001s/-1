-- DEV CHEAT MENU WITH FLY MODES, CATEGORIES, SETTINGS AND FULL CLOSE
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "DevCheats"
gui.Parent = player:WaitForChild("PlayerGui")

-- OPEN BUTTON
local openBtn = Instance.new("TextButton", gui)
openBtn.Size = UDim2.new(0, 50, 0, 50)
openBtn.Position = UDim2.new(0, 10, 0.5, -25)
openBtn.Text = "≡"
openBtn.BackgroundColor3 = Color3.fromRGB(20,20,20)
openBtn.TextColor3 = Color3.new(1,1,1)
openBtn.TextScaled = true
openBtn.Active = true
openBtn.Draggable = true

-- MAIN FRAME
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 450, 0, 380)
frame.Position = UDim2.new(0.5, -225, 0.5, -190)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.Visible = false
frame.Active = true
frame.Draggable = true

-- PLAYER NAME
local nameLabel = Instance.new("TextLabel", frame)
nameLabel.Size = UDim2.new(1, -20, 0, 30)
nameLabel.Position = UDim2.new(0,10,0,10)
nameLabel.Text = "Player: "..player.Name
nameLabel.TextColor3 = Color3.new(1,1,1)
nameLabel.BackgroundTransparency = 1
nameLabel.TextScaled = true

-- BUTTON FULL CLOSE
local closeBtn = Instance.new("TextButton", frame)
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.BackgroundColor3 = Color3.fromRGB(180,50,50)
closeBtn.TextScaled = true
closeBtn.AutoButtonColor = false
closeBtn.MouseEnter:Connect(function()
	closeBtn.BackgroundColor3 = Color3.fromRGB(255,80,80)
end)
closeBtn.MouseLeave:Connect(function()
	closeBtn.BackgroundColor3 = Color3.fromRGB(180,50,50)
end)
closeBtn.MouseButton1Click:Connect(function()
	gui:Destroy() -- полностью удаляем меню
end)

-- CATEGORY BUTTONS
local categories = {"Функции","Настройки"}
local currentCategory = "Функции"
local categoryButtons = {}

for i, cat in ipairs(categories) do
	local btn = Instance.new("TextButton", frame)
	btn.Size = UDim2.new(0.5, -5, 0, 30)
	btn.Position = UDim2.new((i-1)*0.5, 5, 0, 50)
	btn.Text = cat
	btn.TextColor3 = Color3.new(1,1,1)
	btn.BackgroundColor3 = Color3.fromRGB(45,45,45)
	btn.TextScaled = true
	btn.AutoButtonColor = false
	btn.MouseButton1Click:Connect(function()
		currentCategory = cat
		updateCategory()
	end)
	categoryButtons[cat] = btn
end

-- PANELS
local panels = {}
local funcsPanel = Instance.new("Frame", frame)
funcsPanel.Size = UDim2.new(1, -20, 1, -100)
funcsPanel.Position = UDim2.new(0,10,0,90)
funcsPanel.BackgroundTransparency = 1
panels["Функции"] = funcsPanel

local settingsPanel = Instance.new("Frame", frame)
settingsPanel.Size = UDim2.new(1, -20, 1, -100)
settingsPanel.Position = UDim2.new(0,10,0,90)
settingsPanel.BackgroundTransparency = 1
panels["Настройки"] = settingsPanel

-- SWITCH PANEL
local function updateCategory()
	for name, p in pairs(panels) do
		p.Visible = (name==currentCategory)
	end
end
updateCategory()

-- BUTTON MAKER
local function makeButton(parent, text, y)
	local b = Instance.new("TextButton", parent)
	b.Size = UDim2.new(0.6, -10, 0, 35)
	b.Position = UDim2.new(0,10,0,y)
	b.Text = text
	b.BackgroundColor3 = Color3.fromRGB(45,45,45)
	b.TextColor3 = Color3.new(1,1,1)
	b.AutoButtonColor = false
	b.Active = false
	b.MouseEnter:Connect(function()
		if not b.Active then
			b.BackgroundColor3 = Color3.fromRGB(70,70,70)
		end
	end)
	b.MouseLeave:Connect(function()
		if not b.Active then
			b.BackgroundColor3 = Color3.fromRGB(45,45,45)
		end
	end)
	return b
end

-- SPEED TEXTBOX
local function makeSpeedBox(parent, y)
	local box = Instance.new("TextBox", parent)
	box.Size = UDim2.new(0.3, -10, 0, 35)
	box.Position = UDim2.new(0.65, 0, 0, y)
	box.PlaceholderText = "16"
	box.Text = "16"
	box.ClearTextOnFocus = false
	box.TextScaled = true
	return box
end

-- CHARACTER
local char, hum, root
local function loadChar()
	char = player.Character or player.CharacterAdded:Wait()
	hum = char:WaitForChild("Humanoid")
	root = char:WaitForChild("HumanoidRootPart")
end
loadChar()
player.CharacterAdded:Connect(loadChar)

-- ===========================
-- ФУНКЦИИ (ЧИТЫ)
-- ===========================

local flyBtn = makeButton(funcsPanel,"Fly",10)
local vflyBtn = makeButton(funcsPanel,"V Fly",60)
local cflyBtn = makeButton(funcsPanel,"C Fly",110)
local speedBtn = makeButton(funcsPanel,"Speed",160)
local godBtn = makeButton(funcsPanel,"God",210)
local noclipBtn = makeButton(funcsPanel,"Noclip",260)
local speedBox = makeSpeedBox(funcsPanel,160)

-- VARIABLES
local flying=false
local vFlying=false
local cFlying=false
local bv,bg

-- FLY
flyBtn.MouseButton1Click:Connect(function()
	flying = not flying
	flyBtn.Active=flying
	flyBtn.BackgroundColor3 = flying and Color3.fromRGB(0,255,0) or Color3.fromRGB(45,45,45)
	if flying then
		bv = Instance.new("BodyVelocity", root)
		bg = Instance.new("BodyGyro", root)
		bv.MaxForce=Vector3.new(1e5,1e5,1e5)
		bg.MaxTorque=Vector3.new(1e5,1e5,1e5)
		RunService.RenderStepped:Connect(function()
			if not flying then return end
			local cam = workspace.CurrentCamera
			bv.Velocity = cam.CFrame.LookVector * 60
			bg.CFrame = cam.CFrame
		end)
	else
		if bv then bv:Destroy() end
		if bg then bg:Destroy() end
	end
end)

-- V FLY
vflyBtn.MouseButton1Click:Connect(function()
	vFlying = not vFlying
	vflyBtn.Active=vFlying
	vflyBtn.BackgroundColor3 = vFlying and Color3.fromRGB(0,255,0) or Color3.fromRGB(45,45,45)
	if vFlying then
		bv = Instance.new("BodyVelocity", root)
		bv.MaxForce=Vector3.new(1e5,1e5,1e5)
		RunService.RenderStepped:Connect(function()
			if not vFlying then return end
			local vel = Vector3.new(0,0,0)
			if UIS:IsKeyDown(Enum.KeyCode.W) then vel = vel + Vector3.new(0,50,0) end
			if UIS:IsKeyDown(Enum.KeyCode.S) then vel = vel + Vector3.new(0,-50,0) end
			bv.Velocity = vel
		end)
	else
		if bv then bv:Destroy() end
	end
end)

-- C FLY
cflyBtn.MouseButton1Click:Connect(function()
	cFlying = not cFlying
	cflyBtn.Active=cFlying
	cflyBtn.BackgroundColor3 = cFlying and Color3.fromRGB(0,255,0) or Color3.fromRGB(45,45,45)
	if cFlying then
		bv = Instance.new("BodyVelocity", root)
		bg = Instance.new("BodyGyro", root)
		bv.MaxForce = Vector3.new(1e5,1e5,1e5)
		bg.MaxTorque = Vector3.new(1e5,1e5,1e5)
		RunService.RenderStepped:Connect(function()
			if not cFlying then return end
			local cam = workspace.CurrentCamera
			local vel = Vector3.new(0,0,0)
			if UIS:IsKeyDown(Enum.KeyCode.W) then vel = vel + cam.CFrame.LookVector*60 end
			if UIS:IsKeyDown(Enum.KeyCode.S) then vel = vel - cam.CFrame.LookVector*60 end
			if UIS:IsKeyDown(Enum.KeyCode.A) then vel = vel - cam.CFrame.RightVector*60 end
			if UIS:IsKeyDown(Enum.KeyCode.D) then vel = vel + cam.CFrame.RightVector*60 end
			if UIS:IsKeyDown(Enum.KeyCode.Space) then vel = vel + Vector3.new(0,60,0) end
			if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then vel = vel - Vector3.new(0,60,0) end
			bv.Velocity = vel
			bg.CFrame = cam.CFrame
		end)
	else
		if bv then bv:Destroy() end
		if bg then bg:Destroy() end
	end
end)

-- SPEED
local speedOn=false
speedBtn.MouseButton1Click:Connect(function()
	speedOn = not speedOn
	speedBtn.Active=speedOn
	speedBtn.BackgroundColor3 = speedOn and Color3.fromRGB(0,255,0) or Color3.fromRGB(45,45,45)
	local val = tonumber(speedBox.Text)
	hum.WalkSpeed = speedOn and (val or 16) or 16
end)
speedBox.FocusLost:Connect(function()
	if speedBtn.Active then
		local val = tonumber(speedBox.Text)
		if val then hum.WalkSpeed=val end
	end
end)

-- GOD
local godOn=false
godBtn.MouseButton1Click:Connect(function()
	godOn = not godOn
	godBtn.Active=godOn
	godBtn.BackgroundColor3 = godOn and Color3.fromRGB(0,255,0) or Color3.fromRGB(45,45,45)
	hum.MaxHealth = godOn and math.huge or 100
	hum.Health = hum.MaxHealth
end)

-- NOCLIP
local noclip=false
noclipBtn.MouseButton1Click:Connect(function()
	noclip = not noclip
	noclipBtn.Active=noclip
	noclipBtn.BackgroundColor3 = noclip and Color3.fromRGB(0,255,0) or Color3.fromRGB(45,45,45)
end)
RunService.Stepped:Connect(function()
	if noclip and char then
		for _,v in ipairs(char:GetDescendants()) do
			if v:IsA("BasePart") then v.CanCollide=false end
		end
	end
end)

-- OPEN MENU BUTTON
openBtn.MouseButton1Click:Connect(function()
	frame.Visible = not frame.Visible
end)

-- ===========================
-- SETTINGS
-- ===========================
local bgLabel = Instance.new("TextLabel", settingsPanel)
bgLabel.Text="Фон меню:"
bgLabel.Position=UDim2.new(0,10,0,10)
bgLabel.Size=UDim2.new(0,100,0,30)
bgLabel.BackgroundTransparency=1
bgLabel.TextColor3=Color3.new(1,1,1)
bgLabel.TextScaled=true

local bgColorBox = Instance.new("TextBox", settingsPanel)
bgColorBox.PlaceholderText="30,30,30"
bgColorBox.Text="30,30,30"
bgColorBox.Position=UDim2.new(0,120,0,10)
bgColorBox.Size=UDim2.new(0,100,0,30)
bgColorBox.TextScaled=true

local bgBtn = makeButton(settingsPanel,"Применить фон",50)
bgBtn.MouseButton1Click:Connect(function()
	local r,g,b = bgColorBox.Text:match("(%d+),(%d+),(%d+)")
	r,g,b = tonumber(r), tonumber(g), tonumber(b)
	if r and g and b then frame.BackgroundColor3=Color3.fromRGB(r,g,b) end
end)

-- LANGUAGE
local langLabel = Instance.new("TextLabel", settingsPanel)
langLabel.Text="Язык:"
langLabel.Position=UDim2.new(0,10,0,100)
langLabel.Size=UDim2.new(0,100,0,30)
langLabel.BackgroundTransparency=1
langLabel.TextColor3=Color3.new(1,1,1)
langLabel.TextScaled=true

local langBtn = makeButton(settingsPanel,"Русский / English",140)
local lang="Русский"
langBtn.MouseButton1Click:Connect(function()
	lang=(lang=="Русский") and "English" or "Русский"
	if lang=="Русский" then
		flyBtn.Text="Fly"
		vflyBtn.Text="V Fly"
		cflyBtn.Text="C Fly"
		speedBtn.Text="Скорость"
		godBtn.Text="God"
		noclipBtn.Text="Noclip"
	else
		flyBtn.Text="Fly"
		vflyBtn.Text="V Fly"
		cflyBtn.Text="C Fly"
		speedBtn.Text="Speed"
		godBtn.Text="God"
		noclipBtn.Text="Noclip"
	end
end)

-- ===========================
-- RAINBOW EFFECT
-- ===========================
local hue=0
RunService.RenderStepped:Connect(function()
	hue=(hue+0.005)%1
	if currentCategory=="Функции" then
		frame.BackgroundColor3 = Color3.fromHSV(hue,0.7,0.8)
	end
	for _,btn in ipairs({flyBtn,vflyBtn,cflyBtn,speedBtn,godBtn,noclipBtn}) do
		if not btn.Active then
			btn.BackgroundColor3 = Color3.fromHSV((hue+0.1)%1,0.7,0.8)
		end
	end
	nameLabel.TextColor3 = Color3.fromHSV((hue+0.2)%1,0.9,1)
end)
