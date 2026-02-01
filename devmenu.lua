-- [[ DMITRY258 v71.0 - ULTRA STABILITY ]]

local player = game:GetService("Players").LocalPlayer
local runService = game:GetService("RunService")
local uis = game:GetService("UserInputService")
local tweenService = game:GetService("TweenService")

local states = {
    flying = false,
    noclip = false,
    infJump = false,
    visible = true,
    lang = "RU",
    theme = "Rainbow",
    flySpeed = 75,
    walkSpeed = 16,
    hideMode = "Icon",
    espNames = false,
    espBoxes = false,
    espColor = Color3.fromRGB(0, 255, 120),
    espRainbow = false
}

local function getThemeColor()
    if states.theme == "Rainbow" then return Color3.fromHSV(tick() % 5 / 5, 0.8, 1) end
    if states.theme == "Neon" then return Color3.fromRGB(0, 255, 255) end
    return Color3.fromRGB(255, 0, 0)
end

local function sync(obj)
    task.spawn(function()
        while obj and obj.Parent do
            local c = getThemeColor()
            if obj:IsA("UIStroke") then obj.Color = c
            elseif obj:IsA("TextLabel") or obj:IsA("TextButton") then 
                if obj.Name ~= "CloseBtn" then obj.TextColor3 = c end 
            end
            task.wait(0.1)
        end
    end)
end

-- [[ НОВЫЙ СТАБИЛЬНЫЙ ESP ]]
local function createESP(p)
    if p == player then return end
    
    local function apply()
        local char = p.Character
        if not char then return end
        
        -- Удаляем старые элементы если они есть
        if char:FindFirstChild("D_Hi") then char.D_Hi:Destroy() end
        local head = char:WaitForChild("Head", 5)
        if head and head:FindFirstChild("D_Name") then head.D_Name:Destroy() end

        -- Highlight (Боксы)
        local hi = Instance.new("Highlight", char)
        hi.Name = "D_Hi"
        hi.FillTransparency = 0.5
        hi.OutlineTransparency = 0

        -- Billboard (Ники)
        local bg = Instance.new("BillboardGui", head)
        bg.Name = "D_Name"
        bg.Size = UDim2.new(0, 100, 0, 20)
        bg.AlwaysOnTop = true
        bg.StudsOffset = Vector3.new(0, 3, 0)
        
        local tl = Instance.new("TextLabel", bg)
        tl.Size = UDim2.new(1, 0, 1, 0)
        tl.BackgroundTransparency = 1
        tl.Font = "GothamBold"
        tl.TextSize = 14

        -- Постоянное обновление
        task.spawn(function()
            while char and char.Parent and hi and hi.Parent do
                local c = states.espRainbow and Color3.fromHSV(tick() % 5 / 5, 0.8, 1) or states.espColor
                hi.Enabled = states.espBoxes
                hi.FillColor = c
                hi.OutlineColor = c
                tl.Visible = states.espNames
                tl.TextColor3 = c
                tl.Text = p.DisplayName
                task.wait(0.1)
            end
        end)
    end

    p.CharacterAdded:Connect(apply)
    if p.Character then apply() end
end

for _, v in pairs(game.Players:GetPlayers()) do createESP(v) end
game.Players.PlayerAdded:Connect(createESP)

-- [[ ИНТЕРФЕЙС ]]
local function build()
    local sg = Instance.new("ScreenGui", player.PlayerGui); sg.Name = "DmitryV71"; sg.ResetOnSpawn = false
    
    -- ИНТРО (ТОЛЬКО ТЕКСТ)
    local loadL = Instance.new("TextLabel", sg); loadL.Size = UDim2.new(1,0,1,0); loadL.Text = ""; loadL.TextColor3 = Color3.new(1,1,1); loadL.Font = "Code"; loadL.TextSize = 45; loadL.BackgroundTransparency = 1; sync(loadL)
    
    task.spawn(function()
        for i=1, 6 do 
            loadL.Text = "(=^·^=) LOADING" .. string.rep(".", (i % 3) + 1)
            task.wait(0.4) 
        end
        tweenService:Create(loadL, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
        task.wait(0.5); loadL:Destroy()
    end)

    local main = Instance.new("Frame", sg); main.Size = UDim2.new(0, 700, 0, 520); main.Position = UDim2.new(0.5, -350, 0.5, -260); main.BackgroundColor3 = Color3.fromRGB(12,12,12); main.Active = true; main.Draggable = true; main.ClipsDescendants = true; Instance.new("UICorner", main)
    sync(Instance.new("UIStroke", main))

    local icon = Instance.new("TextButton", sg); icon.Size = UDim2.new(0,65,0,65); icon.Position = UDim2.new(0,-100,0.5,-32); icon.BackgroundColor3 = Color3.fromRGB(20,20,20); icon.Text = "(=^·^=)"; icon.Font = "Code"; icon.TextSize = 22; Instance.new("UICorner", icon); sync(icon); icon.Draggable = true

    local head = Instance.new("Frame", main); head.Size = UDim2.new(1,0,0,65); head.BackgroundTransparency = 1
    local title = Instance.new("TextLabel", head); title.Size = UDim2.new(0,400,1,0); title.Position = UDim2.new(0,25,0,0); title.Text = "DMITRY MASTER V71"; title.Font = "GothamBold"; title.TextSize = 24; title.BackgroundTransparency = 1; title.TextXAlignment = "Left"; sync(title)

    local body = Instance.new("Frame", main); body.Size = UDim2.new(1,0,1,-65); body.Position = UDim2.new(0,0,0,65); body.BackgroundTransparency = 1
    local side = Instance.new("Frame", body); side.Size = UDim2.new(0, 180, 1, -20); side.Position = UDim2.new(0, 15, 0, 10); side.BackgroundTransparency = 1; Instance.new("UIListLayout", side).Padding = UDim.new(0, 8)
    local cont = Instance.new("ScrollingFrame", body); cont.Size = UDim2.new(1, -230, 1, -30); cont.Position = UDim2.new(0, 215, 0, 10); cont.BackgroundTransparency = 1; Instance.new("UIListLayout", cont).Padding = UDim.new(0, 10); cont.ScrollBarThickness = 2; cont.AutomaticCanvasSize = "Y"

    local function toggle()
        states.visible = not states.visible
        if states.hideMode == "Header" then
            main:TweenSize(states.visible and UDim2.new(0, 700, 0, 520) or UDim2.new(0, 700, 0, 65), "Out", "Quart", 0.4, true)
            body.Visible = states.visible
        else
            main.Visible = states.visible
            icon:TweenPosition(states.visible and UDim2.new(0, -100, 0.5, -32) or UDim2.new(0, 20, 0.5, -32), "Out", "Back", 0.5)
        end
    end
    icon.MouseButton1Click:Connect(toggle)
    
    local close = Instance.new("TextButton", head); close.Size = UDim2.new(0,40,0,40); close.Position = UDim2.new(1,-50,0,12); close.Text = "X"; close.BackgroundColor3 = Color3.fromRGB(150,0,0); close.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", close); close.MouseButton1Click:Connect(function() sg:Destroy() end)
    local min = Instance.new("TextButton", head); min.Size = UDim2.new(0,40,0,40); min.Position = UDim2.new(1,-95,0,12); min.Text = "_"; min.BackgroundColor3 = Color3.fromRGB(30,30,30); min.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", min); min.MouseButton1Click:Connect(toggle)

    local function clear() for _,v in pairs(cont:GetChildren()) do if not v:IsA("UIListLayout") then v:Destroy() end end end

    local function addBtn(n, k)
        local b = Instance.new("TextButton", cont); b.Size = UDim2.new(0.95,0,0,45); b.Text = n..": "..(states[k] and "ВКЛ" or "ВЫКЛ"); b.BackgroundColor3 = states[k] and Color3.fromRGB(0,80,40) or Color3.fromRGB(30,30,30); b.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", b)
        b.MouseButton1Click:Connect(function() states[k] = not states[k]; b.Text = n..": "..(states[k] and "ВКЛ" or "ВЫКЛ"); b.BackgroundColor3 = states[k] and Color3.fromRGB(0,80,40) or Color3.fromRGB(30,30,30) end)
    end

    local function addSlider(n, minV, maxV, cur, k)
        local f = Instance.new("Frame", cont); f.Size = UDim2.new(0.95,0,0,65); f.BackgroundColor3 = Color3.fromRGB(20,20,20); Instance.new("UICorner", f)
        local l = Instance.new("TextLabel", f); l.Size = UDim2.new(1,0,0,25); l.Text = n..": "..states[k]; l.TextColor3 = Color3.new(1,1,1); l.BackgroundTransparency = 1
        local bar = Instance.new("Frame", f); bar.Size = UDim2.new(0.8,0,0,4); bar.Position = UDim2.new(0.1,0,0.7,0); bar.BackgroundColor3 = Color3.fromRGB(50,50,50)
        local dot = Instance.new("TextButton", bar); dot.Size = UDim2.new(0,18,0,18); dot.Position = UDim2.new((states[k]-minV)/(maxV-minV),-9,-7,0); dot.Text = ""; Instance.new("UICorner", dot); sync(dot)
        local drag = false
        dot.MouseButton1Down:Connect(function() drag = true end)
        uis.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then drag = false end end)
        runService.RenderStepped:Connect(function() if drag then local p = math.clamp((uis:GetMouseLocation().X - bar.AbsolutePosition.X)/bar.AbsoluteSize.X, 0, 1); dot.Position = UDim2.new(p,-9,-7,0); local v = math.floor(minV+(maxV-minV)*p); l.Text = n..": "..v; states[k] = v end end)
    end

    local function tab(n, cb)
        local b = Instance.new("TextButton", side); b.Size = UDim2.new(1,0,0,45); b.Text = n; b.BackgroundColor3 = Color3.fromRGB(25,25,25); b.TextColor3 = Color3.new(1,1,1); b.Font = "GothamBold"; Instance.new("UICorner", b); sync(b)
        b.MouseButton1Click:Connect(function() clear(); cb() end)
    end

    -- ВКЛАДКИ
    tab("ЧИТЫ", function()
        addBtn("Fly", "flying"); addBtn("Noclip", "noclip"); addBtn("InfJump", "infJump")
        addSlider("Бег", 16, 300, states.walkSpeed, "walkSpeed")
        addSlider("Полет", 10, 500, states.flySpeed, "flySpeed")
    end)
    tab("ВИЗУАЛ", function()
        addBtn("Names", "espNames"); addBtn("Boxes", "espBoxes")
        local function cBtn(n, c, rb)
            local b = Instance.new("TextButton", cont); b.Size = UDim2.new(0.95,0,0,35); b.Text = n; b.BackgroundColor3 = Color3.fromRGB(35,35,35); b.TextColor3 = c; Instance.new("UICorner", b); b.MouseButton1Click:Connect(function() states.espColor = c; states.espRainbow = rb end)
        end
        cBtn("Rainbow", Color3.new(1,1,1), true); cBtn("Green", Color3.new(0,1,0), false); cBtn("Red", Color3.new(1,0,0), false)
    end)
    tab("ТЕЛЕПОРТ", function()
        for _,p in pairs(game.Players:GetPlayers()) do
            if p ~= player then
                local b = Instance.new("TextButton", cont); b.Size = UDim2.new(0.95,0,0,35); b.Text = p.DisplayName; b.BackgroundColor3 = Color3.fromRGB(25,25,25); b.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", b); b.MouseButton1Click:Connect(function() if p.Character then player.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame end end)
            end
        end
    end)
    tab("ВИД", function()
        local function opt(n, v)
            local b = Instance.new("TextButton", cont); b.Size = UDim2.new(0.95,0,0,40); b.Text = n; b.BackgroundColor3 = (states.hideMode == v and Color3.fromRGB(70,70,70) or Color3.fromRGB(30,30,30)); b.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", b)
            b.MouseButton1Click:Connect(function() states.hideMode = v; clear(); opt("Шапка", "Header"); opt("Кошка", "Icon") end)
        end
        opt("Шапка", "Header"); opt("Кошка", "Icon")
    end)

    clear(); addBtn("Fly", "flying"); addBtn("Noclip", "noclip"); addBtn("InfJump", "infJump"); addSlider("Бег", 16, 300, states.walkSpeed, "walkSpeed"); addSlider("Полет", 10, 500, states.flySpeed, "flySpeed")
end

runService.Stepped:Connect(function()
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = states.walkSpeed
        if states.noclip or states.flying then for _, v in pairs(player.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end
        if states.flying then player.Character.HumanoidRootPart.Velocity = (player.Character.Humanoid.MoveDirection.Magnitude > 0) and (workspace.CurrentCamera.CFrame.LookVector * states.flySpeed) or Vector3.new(0, 0.1, 0) end
    end
end)
uis.JumpRequest:Connect(function() if states.infJump and player.Character then player.Character.Humanoid:ChangeState(3) end end)

build()
