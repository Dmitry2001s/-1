-- DEV CHEAT MENU (SHOW PLAYER NAME)

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
frame.Size = UDim2.new(0, 260, 0, 260)
frame.Position = UDim2.new(0.5, -130, 0.5, -130)
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

local function makeButton(text, y)
	local b = Instance.new("TextButton", frame)
	b.Size = UDim2.new(1, -20, 0, 35)
	b.Position = UDim2.new(0, 10, 0, y)
	b.Text = text
	b.BackgroundColor3 = Color3.fromRGB(45,45,45)
	b.TextColor3 = Color3.new(1,1,1)
	return b
end

local flyBtn    = makeButton("Fly: OFF", 50)
local speedBtn  = makeButton("Speed: OFF", 90)
local godBtn    = makeButton("God: OFF", 130)
local noclipBtn = makeButton("Noclip: OFF", 170)

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
	flyBtn.Text = flying and "Fly: ON" or "Fly: OFF"

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
	hum.WalkSpeed = speedOn and 50 or 16
	speedBtn.Text = speedOn and "Speed: ON" or "Speed: OFF"
end)

-- GOD
local godOn = false
godBtn.MouseButton1Click:Connect(function()
	godOn = not godOn
	hum.MaxHealth = godOn and math.huge or 100
	hum.Health = hum.MaxHealth
	godBtn.Text = godOn and "God: ON" or "God: OFF"
end)

-- NOCLIP
local noclip = false
noclipBtn.MouseButton1Click:Connect(function()
	noclip = not noclip
	noclipBtn.Text = noclip and "Noclip: ON" or "Noclip: OFF"
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

-- TOGGLE MENU
openBtn.MouseButton1Click:Connect(function()
	frame.Visible = not frame.Visible
end)
