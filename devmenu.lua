local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "DevCheatsMenu"

local openBtn = Instance.new("TextButton", gui)
openBtn.Size = UDim2.new(0,50,0,50)
openBtn.Position = UDim2.new(0,10,0.5,-25)
openBtn.Text = "≡"
openBtn.BackgroundColor3 = Color3.fromRGB(20,20,20)
openBtn.TextColor3 = Color3.new(1,1,1)
openBtn.TextScaled = true
openBtn.Draggable = true

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,500,0,500)
frame.Position = UDim2.new(0.5,-250,0.5,-250)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.Visible = false
frame.Active = true
frame.Draggable = true
frame.ClipsDescendants = true
frame.AnchorPoint = Vector2.new(0.5,0.5)

local nameLabel = Instance.new("TextLabel", frame)
nameLabel.Size = UDim2.new(1,-20,0,30)
nameLabel.Position = UDim2.new(0,10,0,10)
nameLabel.Text = "Player: "..player.Name
nameLabel.TextColor3 = Color3.new(1,1,1)
nameLabel.BackgroundTransparency = 1
nameLabel.TextScaled = true

local closeBtn = Instance.new("TextButton", frame)
closeBtn.Size = UDim2.new(0,30,0,30)
closeBtn.Position = UDim2.new(1,-35,0,5)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.BackgroundColor3 = Color3.fromRGB(180,50,50)
closeBtn.TextScaled = true
closeBtn.MouseEnter:Connect(function() closeBtn.BackgroundColor3 = Color3.fromRGB(255,80,80) end)
closeBtn.MouseLeave:Connect(function() closeBtn.BackgroundColor3 = Color3.fromRGB(180,50,50) end)
closeBtn.MouseButton1Click:Connect(function() gui:Destroy() end)

local categories = {"Функции","Настройки"}
local currentCategory = "Функции"
local categoryButtons = {}
local panels = {}

local function createPanel(parent)
	local panel = Instance.new("ScrollingFrame", parent)
	panel.Size = UDim2.new(1,-20,1,-120)
	panel.Position = UDim2.new(0,10,0,90)
	panel.BackgroundTransparency = 1
	panel.ScrollBarThickness = 6
	panel.CanvasSize = UDim2.new(0,0,0,0)
	panel.ScrollBarImageColor3 = Color3.fromRGB(200,200,200)
	return panel
end

for i,cat in ipairs(categories) do
	local btn = Instance.new("TextButton",frame)
	btn.Size = UDim2.new(0.5,-5,0,30)
	btn.Position = UDim2.new((i-1)*0.5,5,0,50)
	btn.Text = cat
	btn.TextColor3 = Color3.new(1,1,1)
	btn.BackgroundColor3 = Color3.fromRGB(45,45,45)
	btn.TextScaled = true
	btn.AutoButtonColor = false
	categoryButtons[cat] = btn

	local panel = createPanel(frame)
	panel.Visible = (cat=="Функции")
	panels[cat] = panel

	btn.MouseButton1Click:Connect(function()
		currentCategory = cat
		for name,p in pairs(panels) do
			p.Visible = (name==cat)
		end
	end)
end

local funcsPanel = panels["Функции"]
local settingsPanel = panels["Настройки"]

local function makeButton(parent,text,y)
	local b = Instance.new("TextButton",parent)
	b.Size = UDim2.new(0.6,-10,0,35)
	b.Position = UDim2.new(0,10,0,y)
	b.Text = text
	b.TextColor3 = Color3.new(1,1,1)
	b.BackgroundColor3 = Color3.fromRGB(45,45,45)
	b.TextScaled = true
	b.AutoButtonColor = false
	b.Active = false
	local g = Instance.new("UIGradient",b)
	g.Rotation = 0
	g.Color = ColorSequence.new(Color3.fromRGB(60,60,60),Color3.fromRGB(80,80,80))
	RunService.RenderStepped:Connect(function()
		if b.Active then
			local hue = tick()%5/5
			g.Color = ColorSequence.new(Color3.fromHSV(hue,0.8,0.9),Color3.fromHSV((hue+0.1)%1,0.8,0.9))
		end
	end)
	return b
end

local function makeSpeedBox(parent,y)
	local box = Instance.new("TextBox",parent)
	box.Size = UDim2.new(0.3,-10,0,35)
	box.Position = UDim2.new(0.65,0,0,y)
	box.PlaceholderText = "16"
	box.Text = "16"
	box.ClearTextOnFocus = false
	box.TextScaled = true
	return box
end

local char,hum,root
local function loadChar()
	char = player.Character or player.CharacterAdded:Wait()
	hum = char:WaitForChild("Humanoid")
	root = char:WaitForChild("HumanoidRootPart")
end
loadChar()
player.CharacterAdded:Connect(loadChar)

local flying,vFlying,cFlying=false,false,false
local bv,bg
local noclip=false

local flyBtn = makeButton(funcsPanel,"Fly",10)
local vflyBtn = makeButton(funcsPanel,"V Fly",60)
local cflyBtn = makeButton(funcsPanel,"C Fly",110)
local speedBtn = makeButton(funcsPanel,"Speed",160)
local godBtn = makeButton(funcsPanel,"God",210)
local noclipBtn = makeButton(funcsPanel,"Noclip",260)
local jumpBtn = makeButton(funcsPanel,"JumpBoost",310)
local invisBtn = makeButton(funcsPanel,"Invisible",360)
local teleportBtn = makeButton(funcsPanel,"Teleport",410)
local speedBoostBtn = makeButton(funcsPanel,"SpeedBoost",460)
local antiFallBtn = makeButton(funcsPanel,"AntiFall",510)
local speedBox = makeSpeedBox(funcsPanel,160)

local function updateCanvas(panel)
	local lastY = 0
	for _,child in ipairs(panel:GetChildren()) do
		if child:IsA("TextButton") or child:IsA("TextBox") then
			lastY = math.max(lastY,child.Position.Y.Offset + child.Size.Y.Offset)
		end
	end
	panel.CanvasSize = UDim2.new(0,0,0,lastY+20)
end

flyBtn.MouseButton1Click:Connect(function()
	flying = not flying
	flyBtn.Active = flying
	if flying then
		bv = Instance.new("BodyVelocity", root)
		bg = Instance.new("BodyGyro", root)
		bv.MaxForce = Vector3.new(1e5,1e5,1e5)
		bg.MaxTorque = Vector3.new(1e5,1e5,1e5)
		local conn
		conn = RunService.RenderStepped:Connect(function()
			if not flying then conn:Disconnect() if bv then bv:Destroy() end if bg then bg:Destroy() end return end
			local cam = workspace.CurrentCamera
			bv.Velocity = cam.CFrame.LookVector * 60
			bg.CFrame = cam.CFrame
		end)
	else
		if bv then bv:Destroy() end
		if bg then bg:Destroy() end
	end
end)

vflyBtn.MouseButton1Click:Connect(function()
	vFlying = not vFlying
	vflyBtn.Active = vFlying
	if vFlying then
		bv = Instance.new("BodyVelocity", root)
		bv.MaxForce = Vector3.new(1e5,1e5,1e5)
		local conn
		conn = RunService.RenderStepped:Connect(function()
			if not vFlying then conn:Disconnect() if bv then bv:Destroy() end return end
			local vel = Vector3.new(0,0,0)
			if UIS:IsKeyDown(Enum.KeyCode.W) then vel = vel + Vector3.new(0,50,0) end
			if UIS:IsKeyDown(Enum.KeyCode.S) then vel = vel + Vector3.new(0,-50,0) end
			bv.Velocity = vel
		end)
	else
		if bv then bv:Destroy() end
	end
end)

cflyBtn.MouseButton1Click:Connect(function()
	cFlying = not cFlying
	cflyBtn.Active = cFlying
	if cFlying then
		bv = Instance.new("BodyVelocity", root)
		bg = Instance.new("BodyGyro", root)
		bv.MaxForce = Vector3.new(1e5,1e5,1e5)
		bg.MaxTorque = Vector3.new(1e5,1e5,1e5)
		local conn
		conn = RunService.RenderStepped:Connect(function()
			if not cFlying then conn:Disconnect() if bv then bv:Destroy() end if bg then bg:Destroy() end return end
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

speedBtn.MouseButton1Click:Connect(function()
	local val = tonumber(speedBox.Text) or 16
	if hum.WalkSpeed ~= val then
		hum.WalkSpeed = val
		speedBtn.Active = true
	else
		hum.WalkSpeed = 16
		speedBtn.Active = false
	end
end)

godBtn.MouseButton1Click:Connect(function()
	if hum.MaxHealth ~= math.huge then
		hum.MaxHealth = math.huge
		hum.Health = hum.MaxHealth
		godBtn.Active = true
	else
		hum.MaxHealth = 100
		hum.Health = 100
		godBtn.Active = false
	end
end)

noclipBtn.MouseButton1Click:Connect(function()
	noclip = not noclip
	noclipBtn.Active = noclip
end)

RunService.Stepped:Connect(function()
	if noclip and char then
		for _,v in ipairs(char:GetDescendants()) do
			if v:IsA("BasePart") then v.CanCollide=false end
		end
	end
end)

jumpBtn.MouseButton1Click:Connect(function()
	if hum.JumpPower ~= 150 then
		hum.JumpPower = 150
		jumpBtn.Active = true
	else
		hum.JumpPower = 50
		jumpBtn.Active = false
	end
end)

invisBtn.MouseButton1Click:Connect(function()
	for _,v in ipairs(char:GetDescendants()) do
		if v:IsA("BasePart") then
			if v.Transparency ~= 1 then
				v.Transparency = 1
				invisBtn.Active = true
			else
				v.Transparency = 0
				invisBtn.Active = false
			end
		end
	end
end)

teleportBtn.MouseButton1Click:Connect(function()
	if char and workspace:FindFirstChild("Spawn") then
		root.CFrame = workspace.Spawn.CFrame + Vector3.new(0,5,0)
		teleportBtn.Active = true
	else
		teleportBtn.Active = false
	end
end)

speedBoostBtn.MouseButton1Click:Connect(function()
	if hum.WalkSpeed < 200 then
		hum.WalkSpeed = hum.WalkSpeed + 50
		speedBoostBtn.Active = true
	else
		hum.WalkSpeed = 16
		speedBoostBtn.Active = false
	end
end)

antiFallBtn.MouseButton1Click:Connect(function()
	hum.FloorMaterial = hum.FloorMaterial==Enum.Material.SmoothPlastic and Enum.Material.Wood or Enum.Material.SmoothPlastic
	antiFallBtn.Active = hum.FloorMaterial==Enum.Material.SmoothPlastic
end)

openBtn.MouseButton1Click:Connect(function()
	frame.Visible = not frame.Visible
end)

updateCanvas(funcsPanel)
updateCanvas(settingsPanel)

local hue=0
RunService.RenderStepped:Connect(function()
	hue=(hue+0.005)%1
	frame.BackgroundColor3 = Color3.fromHSV(hue,0.7,0.8)
	nameLabel.TextColor3 = Color3.fromHSV((hue+0.2)%1,0.9,1)
end)
