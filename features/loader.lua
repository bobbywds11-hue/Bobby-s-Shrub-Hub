local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
    Name = "Bobby's Shrub Hub",
    Icon = 0,
    LoadingTitle = "Shrub Hub Loading..",
    LoadingSubtitle = "by Bobby",
    Theme = "Green",
    ToggleUIKeybind = "K",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "Bobby's Shrub Hub",
        FileName = "Shrub Hub"
    }
})

local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local plr = game.Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local hum = char:FindFirstChildOfClass("Humanoid")
local hrp = char:FindFirstChild("HumanoidRootPart")

-- VARIABLES
local flying, flySpeed = false, 50
local infJump = false
local noclipOn = false
local walkSpeed, jumpPower = 16, 50

-- ==================== MOVEMENT HACKS ====================
local MovementTab = Window:CreateTab("Movement Hacks", "airplay")

MovementTab:CreateButton({
    Name = "Fly",
    Callback = function()
        flying = not flying
        hum.PlatformStand = flying
        if not flying then return end
        local bv = Instance.new("BodyVelocity", hrp)
        local bg = Instance.new("BodyGyro", hrp)
        bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        task.spawn(function()
            while flying do
                local cam = workspace.CurrentCamera
                local dir = Vector3.zero
                if UIS:IsKeyDown(Enum.KeyCode.W) then dir += cam.CFrame.LookVector end
                if UIS:IsKeyDown(Enum.KeyCode.S) then dir -= cam.CFrame.LookVector end
                if UIS:IsKeyDown(Enum.KeyCode.A) then dir -= cam.CFrame.RightVector end
                if UIS:IsKeyDown(Enum.KeyCode.D) then dir += cam.CFrame.RightVector end
                if UIS:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.yAxis end
                if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then dir -= Vector3.yAxis end
                bv.Velocity = dir.Magnitude > 0 and dir.Unit * flySpeed or Vector3.zero
                bg.CFrame = cam.CFrame
                RunService.RenderStepped:Wait()
            end
            bv:Destroy()
            bg:Destroy()
            hum.PlatformStand = false
        end)
    end
})

MovementTab:CreateButton({
    Name = "Infinite Jump",
    Callback = function()
        infJump = not infJump
        print("Infinite Jump: "..(infJump and "ON" or "OFF"))
    end
})

UIS.JumpRequest:Connect(function()
    if infJump and hum then
        hum:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

MovementTab:CreateSlider({
    Name = "WalkSpeed",
    Range = {16, 500},
    Increment = 5,
    Suffix = "speed",
    CurrentValue = walkSpeed,
    Callback = function(val)
        walkSpeed = val
        if hum then hum.WalkSpeed = walkSpeed end
    end
})


MovementTab:CreateButton({
    Name = "Noclip",
    Callback = function()
        noclipOn = not noclipOn
        print("Noclip: "..(noclipOn and "ON" or "OFF"))
    end
})

RunService.Stepped:Connect(function()
    if noclipOn and char then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- ==================== COMBAT TOOLS ====================
local CombatTab = Window:CreateTab("Combat Tools", "sword")

-- simple ESP toggle for players
local espOn = false
CombatTab:CreateButton({
    Name = "Player ESP",
    Callback = function()
        espOn = not espOn
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= plr and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                if espOn then
                    local box = Instance.new("BoxHandleAdornment")
                    box.Adornee = p.Character.HumanoidRootPart
                    box.Size = Vector3.new(2,3,1)
                    box.Color3 = Color3.new(1,0,0)
                    box.Transparency = 0.5
                    box.AlwaysOnTop = true
                    box.Parent = p.Character
                else
                    local adorns = p.Character:GetChildren()
                    for _, a in pairs(adorns) do
                        if a:IsA("BoxHandleAdornment") then a:Destroy() end
                    end
                end
            end
        end
    end
})

CombatTab:CreateButton({
    Name = "Hitbox Extender",
    Callback = function()
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= plr and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                p.Character.HumanoidRootPart.Size = Vector3.new(5,5,5)
            end
        end
    end
})

-- ==================== VISUALS ====================
local VisualsTab = Window:CreateTab("Visuals / ESP", "eye")

VisualsTab:CreateSlider({
    Name = "FOV Changer",
    Range = {70, 200},
    Increment = 5,
    Suffix = "°",
    CurrentValue = workspace.CurrentCamera.FieldOfView,
    Callback = function(val)
        workspace.CurrentCamera.FieldOfView = val
    end
})

VisualsTab:CreateButton({
    Name = "Third-Person Camera",
    Callback = function()
        workspace.CurrentCamera.CameraSubject = hrp
    end
})

VisualsTab:CreateButton({
    Name = "Particle Trails",
    Callback = function()
        local trail = Instance.new("Trail", hrp)
        trail.Attachment0 = Instance.new("Attachment", hrp)
        trail.Attachment1 = Instance.new("Attachment", hrp)
        trail.Lifetime = 0.5
        trail.Color = ColorSequence.new(Color3.new(0,1,0))
    end
})

-- ==================== FUN / COSMETICS ====================
local FunTab = Window:CreateTab("Fun / Cosmetics", "smile")

FunTab:CreateButton({
    Name = "Jetpack",
    Callback = function()
        local bv = Instance.new("BodyVelocity", hrp)
        bv.Velocity = Vector3.new(0,50,0)
        bv.MaxForce = Vector3.new(0,9e9,0)
        task.delay(2, function() bv:Destroy() end)
    end
})

FunTab:CreateButton({
    Name = "Trampoline",
    Callback = function()
        local part = Instance.new("Part", workspace)
        part.Size = Vector3.new(10,1,10)
        part.Position = hrp.Position - Vector3.new(0,3,0)
        part.Anchored = true
        part.Touched:Connect(function(hit)
            local h = hit.Parent:FindFirstChildOfClass("Humanoid")
            if h then
                h:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    end
})

-- ==================== SCRIPT HUB ====================
local ScriptTab = Window:CreateTab("Script Hub", "code")

local Scripts = {
    {
        name = "AirHub",
        run = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Exunys/AirHub/main/AirHub.lua"))()
        end
    },
    {
        name = "Nameless Admin",
        run = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/FilteringEnabled/NamelessAdmin/main/Source"))()
        end
    },
    {
        name = "Orca",
        run = function()
            loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/richie0866/orca/master/public/latest.lua"))()
        end
    },
    {
        name = "PSHade Ultimate",
        run = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/randomstring0/pshade-ultimate/refs/heads/main/src/cd.lua"))()
        end
    }
}

for _, s in ipairs(Scripts) do
    ScriptTab:CreateButton({
        Name = s.name,
        Callback = s.run
    })
end
