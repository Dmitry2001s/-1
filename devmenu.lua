-- [[ DMITRY258 v71.0 - FINAL STABLE UPDATED ]]

local player = game:GetService("Players").LocalPlayer
local runService = game:GetService("RunService")
local uis = game:GetService("UserInputService")
local camera = workspace.CurrentCamera
local tweenService = game:GetService("TweenService")

local states = {
    flying = false,
    noclip = false,
    infJump = false,
    camlock = false,
    visible = true,
    lang = "RU",
    theme = "Rainbow",
    flySpeed = 75,
    walkSpeed = 16,
    hideMode = "Icon",
    espNames = false,
    espBoxes = false, 
    espColor = Color3.fromRGB(0, 255, 120),
    espRainbow = false,
    langOpen = false,
    themeOpen = false
}

-- [[ ИНТРО "Dmitry258" ]]
local function playIntro()
    local introGui = Instance.new("ScreenGui", player.PlayerGui)
    introGui.DisplayOrder = 999
    
    local frame = Instance.new("Frame", introGui)
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    frame.BackgroundTransparency = 0
    
    local text = Instance.new("TextLabel", frame)
    text.Size = UDim2.new(1, 0, 1, 0)
    text.BackgroundTransparency = 1
    text.Text = "Dmitry258"
    text.TextColor3 = Color3.fromRGB(255, 255, 255)
    text.Font = Enum.Font.GothamBold
    text.TextSize = 1
    text.TextTransparency = 1

    -- Анимация появления текста
    tweenService:Create(text, TweenInfo.new(1.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {TextSize = 60, TextTransparency = 0}):Play()
    task.wait(2)
    -- Анимация исчезновения всего интро
    tweenService:Create(text, TweenInfo.new(1, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {TextTransparency = 1}):Play()
    tweenService:Create(frame, TweenInfo.new(1, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {BackgroundTransparency = 1}):Play()
    task.wait(1)
    introGui:Destroy()
end

local langMap = {
    RU = {
        cheats = "ЧИТЫ", visual = "ВИЗУАЛ", settings = "НАСТРОЙКИ", view = "ВИД", tp = "ТЕЛЕПОРТ",
        fly = "Полет", noclip = "Сквозь стены", infJump = "Беск. Прыжок", camlock = "Авто фокус",
        walk = "Бег", flyS = "Скор. Полета", espN = "Ники", espB = "Обводка", on = "ВКЛ", off = "ВЫКЛ",
        welcome = "Загружено!", setLang = "Язык", setTheme = "Тема", modeH = "Шапка", modeI = "Кошка"
    },
    EN = {
        cheats = "CHEATS", visual = "VISUAL", settings = "SETTINGS", view = "VIEW", tp = "TELEPORT",
        fly = "Fly", noclip = "Noclip", infJump = "Inf. Jump", camlock = "CamLock",
        walk = "WalkSpeed", flyS = "Fly Speed", espN = "Names", espB = "Highlight", on = "ON", off = "OFF",
        welcome = "Loaded!", setLang = "Language", setTheme = "Theme", modeH = "Header", modeI = "Icon"
    }
}

local function getL(k) return langMap[states.lang][k] or k end

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

local function notify(text)
    task.spawn(function()
        local sg = player.PlayerGui:FindFirstChild("DmitryV71")
        if not sg then return end
        local n = Instance.new("Frame", sg); n.Size = UDim2.new(0, 220, 0, 40); n.Position = UDim2.new(1, 20, 1, -60); n.BackgroundColor3 = Color3.fromRGB(25, 25, 25); Instance.new("UICorner", n)
        local s = Instance.new("UIStroke", n); s.Thickness = 2; sync(s)
        local l = Instance.new("TextLabel", n); l.Size = UDim2.new(1, -10, 1, 0); l.Position = UDim2.new(0, 10, 0, 0); l.BackgroundTransparency = 1; l.Text = text; l.Font = "GothamBold"; l.TextSize = 14; l.TextXAlignment = "Left"; sync(l)
        n:TweenPosition(UDim2.new(1, -240, 1, -60), "Out", "Quart", 0.5, true)
        task.wait(2.5); n:TweenPosition(UDim2.new(1, 20, 1, -60), "In", "Quart", 0.5, true); task.wait(0.5); n:Destroy()
    end)
end

local function getClosestPlayer()
    local closest, dist = nil, math.huge
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            local d = (player.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude
            if d < dist then dist = d; closest = v end
        end
    end
    return closest
end

runService.RenderStepped:Connect(function()
    local char = player.Character
    if char and char:FindFirstChild("Humanoid") then
        local hum, root = char.Humanoid, char:FindFirstChild("HumanoidRootPart")
        hum.WalkSpeed = states.walkSpeed
        
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") then
                if states.noclip or states.flying then v.CanCollide = false
                else if v.Name == "HumanoidRootPart" or v.Name == "Torso" then v.CanCollide = true end end
            end
        end

        if states.flying and root then
            root.Velocity = (hum.MoveDirection.Magnitude > 0) and (camera.CFrame.LookVector * states.flySpeed) or Vector3.new(0, 0.1, 0)
        end

        if states.camlock then
            local target = getClosestPlayer()
            if target and target.Character and target.Character:FindFirstChild("Head") then
                camera.CFrame = CFrame.new(camera.CFrame.Position, target.Character.Head.Position)
            end
        end
    end
end)

uis.JumpRequest:Connect(function()
    if states.infJump and player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
        player.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

local function createESP(p)
    if p == player then return end
    local function apply()
        local char = p.Character or p.CharacterAdded:Wait()
        local head = char:WaitForChild("Head", 10)
        if char:FindFirstChild("D_Hi") then char.D_Hi:Destroy() end
        local hi = Instance.new("Highlight", char); hi.Name = "D_Hi"; hi.DepthMode = "AlwaysOnTop"; hi.FillTransparency = 0.5
        local bg = Instance.new("BillboardGui", head); bg.Name = "D_Name"; bg.Size = UDim2.new(0, 100, 0, 20); bg.AlwaysOnTop = true; bg.StudsOffset = Vector3.new(0, 3, 0)
        local tl = Instance.new("TextLabel", bg); tl.Size = UDim2.new(1, 0, 1, 0); tl.BackgroundTransparency = 1; tl.Font = "GothamBold"; tl.TextSize = 14
        task.spawn(function()
            while char and char.Parent and hi and hi.Parent do
                local c = states.espRainbow and Color3.fromHSV(tick() % 5 / 5, 0.8, 1) or states.espColor
                hi.Enabled = states.espBoxes; hi.FillColor = c; hi.OutlineColor = c
                tl.Visible = states.espNames; tl.TextColor3 = c; tl.Text = p.DisplayName; task.wait(0.1)
            end
        end)
    end
    p.CharacterAdded:Connect(apply); if p.Character then apply() end
end
for _, v in pairs(game.Players:GetPlayers()) do createESP(v) end
game.Players.PlayerAdded:Connect(createESP)

local function build()
    local sg = Instance.new("ScreenGui", player.PlayerGui); sg.Name = "DmitryV71"; sg.ResetOnSpawn = false
    local main = Instance.new("Frame", sg); main.Size = UDim2.new(0, 700, 0, 520); main.Position = UDim2.new(0.5, -350, 0.5, -260); main.BackgroundColor3 = Color3.fromRGB(12,12,12); main.Active = true; main.Draggable = true; main.ClipsDescendants = true; Instance.new("UICorner", main)
    sync(Instance.new("UIStroke", main))

    local icon = Instance.new("TextButton", sg); icon.Size = UDim2.new(0,65,0,65); icon.Position = UDim2.new(0,-100,0.5,-32); icon.BackgroundColor3 = Color3.fromRGB(20,20,20); icon.Text = "(=^·^=)"; icon.Font = "Code"; icon.TextSize = 22; Instance.new("UICorner", icon); icon.Draggable = true; sync(icon)

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
    
    local close = Instance.new("TextButton", head); close.Name = "CloseBtn"; close.Size = UDim2.new(0,40,0,40); close.Position = UDim2.new(1,-50,0,12); close.Text = "X"; close.BackgroundColor3 = Color3.fromRGB(150,0,0); close.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", close); close.MouseButton1Click:Connect(function() sg:Destroy() end)
    local min = Instance.new("TextButton", head); min.Size = UDim2.new(0,40,0,40); min.Position = UDim2.new(1,-95,0,12); min.Text = "_"; min.BackgroundColor3 = Color3.fromRGB(30,30,30); min.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", min); min.MouseButton1Click:Connect(toggle); sync(min)

    local function clear() for _,v in pairs(cont:GetChildren()) do if not v:IsA("UIListLayout") then v:Destroy() end end end

    local function addBtn(n_key, k)
        local b = Instance.new("TextButton", cont); b.Size = UDim2.new(0.95,0,0,45); b.BackgroundColor3 = states[k] and Color3.fromRGB(0,80,40) or Color3.fromRGB(30,30,30); Instance.new("UICorner", b); sync(b)
        local function upd() b.Text = getL(n_key)..": "..(states[k] and getL("on") or getL("off")) end
        upd(); b.MouseButton1Click:Connect(function() states[k] = not states[k]; upd(); b.BackgroundColor3 = states[k] and Color3.fromRGB(0,80,40) or Color3.fromRGB(30,30,30); notify(getL(n_key).." -> "..(states[k] and getL("on") or getL("off"))) end)
    end

    local function addSlider(n_key, minV, maxV, cur, k)
        local f = Instance.new("Frame", cont); f.Size = UDim2.new(0.95,0,0,65); f.BackgroundColor3 = Color3.fromRGB(20,20,20); Instance.new("UICorner", f)
        local l = Instance.new("TextLabel", f); l.Size = UDim2.new(1,0,0,25); l.Text = getL(n_key)..": "..states[k]; l.BackgroundTransparency = 1; sync(l)
        local bar = Instance.new("Frame", f); bar.Size = UDim2.new(0.8,0,0,4); bar.Position = UDim2.new(0.1,0,0.7,0); bar.BackgroundColor3 = Color3.fromRGB(50,50,50)
        local dot = Instance.new("TextButton", bar); dot.Size = UDim2.new(0,18,0,18); dot.Position = UDim2.new((states[k]-minV)/(maxV-minV),-9,-7,0); dot.Text = ""; Instance.new("UICorner", dot); sync(dot)
        local drag = false
        dot.MouseButton1Down:Connect(function() drag = true end)
        uis.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then drag = false end end)
        runService.RenderStepped:Connect(function() if drag then local p = math.clamp((uis:GetMouseLocation().X - bar.AbsolutePosition.X)/bar.AbsoluteSize.X, 0, 1); dot.Position = UDim2.new(p,-9,-7,0); local v = math.floor(minV+(maxV-minV)*p); l.Text = getL(n_key)..": "..v; states[k] = v end end)
    end

    local function tab(n_k, cb)
        local b = Instance.new("TextButton", side); b.Size = UDim2.new(1,0,0,45); b.Text = getL(n_k); b.BackgroundColor3 = Color3.fromRGB(25,25,25); b.Font = "GothamBold"; Instance.new("UICorner", b); sync(b)
        b.MouseButton1Click:Connect(function() clear(); cb() end)
    end

    local function showCheats() 
        addBtn("fly", "flying"); 
        addBtn("noclip", "noclip"); 
        addBtn("infJump", "infJump"); 
        addBtn("camlock", "camlock"); 
        addSlider("walk", 16, 1000, states.walkSpeed, "walkSpeed"); -- До 1000
        addSlider("flyS", 10, 1000, states.flySpeed, "flySpeed")    -- До 1000
    end
    
    local function showVisuals() 
        addBtn("espN", "espNames"); addBtn("espB", "espBoxes") 
        local function cBtn(n, c, rb)
            local b = Instance.new("TextButton", cont); b.Size = UDim2.new(0.95,0,0,35); b.Text = n; b.BackgroundColor3 = Color3.fromRGB(35,35,35); b.TextColor3 = c; Instance.new("UICorner", b)
            b.MouseButton1Click:Connect(function() states.espColor = c; states.espRainbow = rb; notify("ESP: "..n) end)
        end
        cBtn("Rainbow", Color3.new(1,1,1), true); cBtn("Green", Color3.new(0,1,0), false); cBtn("Red", Color3.new(1,0,0), false)
    end
    local function showView()
        local function opt(n_k, v)
            local b = Instance.new("TextButton", cont); b.Size = UDim2.new(0.95,0,0,45); b.Text = getL(n_k); b.BackgroundColor3 = (states.hideMode == v and Color3.fromRGB(70,70,70) or Color3.fromRGB(30,30,30)); Instance.new("UICorner", b); sync(b)
            b.MouseButton1Click:Connect(function() states.hideMode = v; notify(getL(n_k)); clear(); showView() end)
        end
        opt("modeH", "Header"); opt("modeI", "Icon")
    end
    local function showSettings()
        local langBtn = Instance.new("TextButton", cont); langBtn.Size = UDim2.new(0.95,0,0,40); langBtn.BackgroundColor3 = Color3.fromRGB(30,30,30); langBtn.Text = getL("setLang") .. (states.langOpen and " ⏬" or " ⏫"); Instance.new("UICorner", langBtn); sync(langBtn)
        langBtn.MouseButton1Click:Connect(function() states.langOpen = not states.langOpen; clear(); showSettings() end)
        if states.langOpen then
            for _, l in pairs({"RU", "EN"}) do
                local b = Instance.new("TextButton", cont); b.Size = UDim2.new(0.85,0,0,35); b.Text = l; b.BackgroundColor3 = (states.lang == l and Color3.fromRGB(60,60,60) or Color3.fromRGB(40,40,40)); Instance.new("UICorner", b); sync(b)
                b.MouseButton1Click:Connect(function() states.lang = l; notify("Lang: "..l); clear(); showSettings() end)
            end
        end
        local themeBtn = Instance.new("TextButton", cont); themeBtn.Size = UDim2.new(0.95,0,0,40); themeBtn.BackgroundColor3 = Color3.fromRGB(30,30,30); themeBtn.Text = getL("setTheme") .. (states.themeOpen and " ⏬" or " ⏫"); Instance.new("UICorner", themeBtn); sync(themeBtn)
        themeBtn.MouseButton1Click:Connect(function() states.themeOpen = not states.themeOpen; clear(); showSettings() end)
        if states.themeOpen then
            for _, t in pairs({"Rainbow", "Neon", "Dark Red"}) do
                local b = Instance.new("TextButton", cont); b.Size = UDim2.new(0.85,0,0,35); b.Text = t; b.BackgroundColor3 = (states.theme == t and Color3.fromRGB(60,60,60) or Color3.fromRGB(40,40,40)); Instance.new("UICorner", b); sync(b)
                b.MouseButton1Click:Connect(function() states.theme = t; notify("Theme: "..t); clear(); showSettings() end)
            end
        end
    end

    tab("cheats", showCheats); tab("visual", showVisuals); tab("tp", function() 
        for _,p in pairs(game.Players:GetPlayers()) do if p ~= player then 
            local b = Instance.new("TextButton", cont); b.Size = UDim2.new(0.95,0,0,35); b.Text = p.DisplayName; b.BackgroundColor3 = Color3.fromRGB(25,25,25); Instance.new("UICorner", b); sync(b)
            b.MouseButton1Click:Connect(function() if p.Character then player.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame; notify("TP -> "..p.DisplayName) end end) 
        end end 
    end)
    tab("view", showView); tab("settings", showSettings)
    
    notify(getL("welcome")); showCheats()
end

-- Запуск
task.spawn(playIntro)
build()
