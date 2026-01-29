-- DEV CHEAT MENU (RAINBOW + ACTIVE COLORS + SPEED CONTROL)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

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
frame.Size = UDim2.new(0, 300, 0, 300)
frame.Position = UDim2.new(0.5, -150, 0.5, -150)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.Visible = false
frame.Active = true
frame.Draggable = true

-- PLAYER NAME LABEL
local nameLabel = Instance.new("TextLabel", frame)
nameLabel.Size = UDim2.new(1, -20, 0, 30)
nameLabel.Position = UDim2.new(0, 10, 0, 10)
nameLabel.Text = "Player: " .. player.Name
nameLabel.TextColor3 = Color3.new(1,1,1)
nameLabel.BackgroundTransparency = 1
nameLabel.TextScaled = true

-- BUTTON CREATOR
local function makeButton(text, y)
	local b = Instance.new("TextButton", frame)
	b.Size = UDim2.new(0.6, -10, 0, 35)
	b.Position = UDim2.new(0, 10, 0, y)
	b.Text = text
	b.BackgroundColor3 = Color3.fromRGB(45,45,45)
	b.TextColor3 = Color3.new(1,1,1)
	b.AutoButtonColor = false

	-- hover effect
	b.MouseEnter:Connect(function()
		b.BackgroundColor3 = Color3.fromRGB(70,70,70)
	end)
	b.MouseLeave:Connect(function()
		if not b.Active then
			b.BackgroundColor3 = Color3.fromRGB(45,45,45)
		end
	end)

	b.Active = false -- custom flag for active state
	return b
end

-- SPEED TEXTBOX
local function makeSpeedBox(y)
	local box = Instance.new("TextBox", frame)
	box.Size = UDim2.new(0.3, -10, 0, 35)
	box.Position = UDim2.new(0.65, 0, 0, y)
	box.PlaceholderText = "16"
	box.Text = "16"
	box.ClearTextOnFocus = false
	box.TextScaled = true
	return box
end

-- Buttons
local flyBtn    = makeButton("Fly", 50)
local speedBtn  = makeButton("Speed", 90)
local godBtn    = makeButton("God", 130)
local noclipBtn = makeButton("Noclip", 170)

local speedBox = makeSpeedBox(90) -- рядом с Speed кнопкой

-- CHARACTER
local char, hum, root
local function loadChar()
	char = player.Character or player.CharacterAdded:Wait()
	hum = char:WaitForChild("Humanoid")
	root = char:WaitForChild("HumanoidRootPart")
end
loadChar()
player.CharacterAdded:Connect(loadChar)

-- FLY
local flying = false
local bv, bg
flyBtn.MouseButton1Click:Connect(function()
	flying = not flying
	flyBtn.Active = flying
	flyBtn.BackgroundColor3 = flying and Color3.fromRGB(0,255,0) or Color3.fromRGB(45,45,45)

	if flying then
		bv = Instance.new("BodyVelocity", root)
		bg = Instance.new("BodyGyro", root)
		bv.MaxForce = Vector3.new(1e5,1e5,1e5)
		bg.MaxTorque = Vector3.new(1e5,1e5,1e5)

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

-- SPEED
local speedOn = false
speedBtn.MouseButton1Click:Connect(function()
	speedOn = not speedOn
	speedBtn.Active = speedOn
	speedBtn.BackgroundColor3 = speedOn and Color3.fromRGB(0,255,0) or Color3.fromRGB(45,45,45)
	local val = tonumber(speedBox.Text)
	hum.WalkSpeed = speedOn and (val or 16) or 16
end)

speedBox.FocusLost:Connect(function()
	if speedBtn.Active then
		local val = tonumber(speedBox.Text)
		if val then
			hum.WalkSpeed = val
		end
	end
end)

-- GOD
local godOn = false
godBtn.MouseButton1Click:Connect(function()
	godOn = not godOn
	godBtn.Active = godOn
	godBtn.BackgroundColor3 = godOn and Color3.fromRGB(0,255,0) or Color3.fromRGB(45,45,45)
	hum.MaxHealth = godOn and math.huge or 100
	hum.Health = hum.MaxHealth
end)

-- NOCLIP
local noclip = false
noclipBtn.MouseButton1Click:Connect(function()
	noclip = not noclip
	noclipBtn.Active = noclip
	noclipBtn.BackgroundColor3 = noclip and Color3.fromRGB(0,255,0) or Color3.fromRGB(45,45,45)
end)

RunService.Stepped:Connect(function()
	if noclip and char then
		for _, v in ipairs(char:GetDescendants()) do
			if v:IsA("BasePart") then
				v.CanCollide = false
			end
		end
	end
end)

-- BUTTON TOGGLE
openBtn.MouseButton1Click:Connect(function()
	frame.Visible = not frame.Visible
end)

-- 🌈 RAINBOW EFFECT
local hue = 0
RunService.RenderStepped:Connect(function()
	hue = (hue + 0.005) % 1
	frame.BackgroundColor3 = Color3.fromHSV(hue, 0.7, 0.8)
	for _, btn in ipairs({flyBtn, speedBtn, godBtn, noclipBtn}) do
		if not btn.Active then
			btn.BackgroundColor3 = Color3.fromHSV((hue + 0.1) % 1, 0.7, 0.8)
		end
	end
	nameLabel.TextColor3 = Color3.fromHSV((hue + 0.2) % 1, 0.9, 1)
end)
