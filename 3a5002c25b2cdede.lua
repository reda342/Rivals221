cloneref = cloneref or function(x) return x end
hookfunction = hookfunction or (getgenv() and getgenv().hookfunction) or function(f, r) return f end
newcclosure = newcclosure or function(f) return f end
getgc = getgc or function() return {} end

local old; old = hookfunction(getrenv().setmetatable, newcclosure(function(t, mt)
    if mt and typeof(mt) == "table" and rawget(mt, "__mode") == "kv" then
    local trace = debug.traceback()
    if trace:find("LocalScript3") or trace:find("MiscellaneousController") then
            return old({1, 2, 3}, {}) 
        end
    end
    return old(t, mt)
end))

task.wait(3)
print("VAR-FORGEHUB")

if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Players = cloneref(game:GetService("Players"))
local LocalPlayer = Players.LocalPlayer
local playerGui = LocalPlayer.PlayerGui
local executor = identifyexecutor and identifyexecutor() or "Unknown"

local shit = {
    "Xeno",
    "Solara"
}

local supo = {
    "Potassium",
    "Ronix",
    "Wave"
}

for _, v in ipairs(shit) do
    if executor == v then
        LocalPlayer:Kick("Executor Not supported")
        return
    end
end

for _, v in ipairs(supo) do
    if executor == v then
        LocalPlayer:Kick("Might be detected with this executor")
    end
end

local function waitForMainGui()
    local gui = playerGui:FindFirstChild("MainGui")
    while not gui do
        task.wait(1)
        gui = playerGui:FindFirstChild("MainGui")
    end
    return gui
end

waitForMainGui()

local LastUpdate = 19

local patchNotesChecked = false
local scriptCanLoad = false

local function sendNotif(title, text, duration)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = duration
        })
    end)
end

task.spawn(function()
    local pages = playerGui.MainGui.MainFrame:WaitForChild("Pages", 60)
    if not pages then return end

    local function checkPatchNotes(patchNotes)
        task.wait(1)
        local check, container = pcall(function()
            return patchNotes:WaitForChild("Container", 10)
                :WaitForChild("List", 10)
                :WaitForChild("Container", 10)
        end)
        if not check or not container then return end

        for _, slot in ipairs(container:GetChildren()) do
            pcall(function()
                local title = slot:FindFirstChild("Container")
                    and slot.Container:FindFirstChild("Details")
                    and slot.Container.Details:FindFirstChild("Title")

                if title and title.Text then
                    local num = tonumber(title.Text:match("UPDATE%s+(%d+)"))
                    if num and num > LastUpdate then
                        LocalPlayer:Kick("The game has updated. Please wait for Forge Hub to update to avoid detection")
                    end
                end
            end)
        end

        patchNotesChecked = true
        scriptCanLoad = true
    end

    local existing = pages:FindFirstChild("PatchNotes")
    if existing then
        checkPatchNotes(existing)
    else
        task.spawn(function()
            while not patchNotesChecked do
                sendNotif("Forge Hub", "Please open lastest new in the top right corner to load the script", 2)
                task.wait(10)
            end
        end)

        pages.ChildAdded:Connect(function(child)
            if child.Name == "PatchNotes" then
                checkPatchNotes(child)
            end
        end)
    end
end)

task.wait(3)
repeat task.wait() until scriptCanLoad

-- sht var
local RunService = cloneref(game:GetService("RunService"))
local Lighting = cloneref(game:GetService("Lighting"))
local UIS = cloneref(game:GetService("UserInputService"))
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()
local ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))

local FighterController = require(LocalPlayer.PlayerScripts.Controllers.FighterController)
local Utility = require(ReplicatedStorage.Modules.Utility)
local Enums = require(ReplicatedStorage.Modules.EnumLibrary)

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

print("Loading the script....")

local Window = Fluent:CreateWindow({
    Title = "Rivals BETA",
    SubTitle = "by r3da09",
    Search = true,
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.RightShift,

    UserInfo = true,
    UserInfoTop = false,
    UserInfoTitle = LocalPlayer.Name,
    UserInfoSubtitle = "Developer",
    UserInfoSubtitleColor = Color3.fromRGB(71, 123, 255)
})

local Tabs = {
    Aimbot = Window:AddTab({ Title = "Combat", Icon = "crosshair" }),
    Misc = Window:AddTab({ Title = "Misc", Icon = "shield" }),
    Trigger = Window:AddTab({ Title = "TriggerBot", Icon = "bot" }),
    Player = Window:AddTab({ Title = "Player", Icon = "user" }),
    Visual = Window:AddTab({ Title = "Visual", Icon = "eye" }),
    HvH = Window:AddTab({ Title = "HvH", Icon = "skull" }),
    Other = Window:AddTab({ Title = "Other", Icon = "settings" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "wrench" })
}

local Options = Fluent.Options

local AimSection = Tabs.Aimbot:AddSection("Aimbot", "crosshair")

AimSection:AddToggle("AimbotEnabled", { Title = "Enable Aimbot", Default = false })
AimSection:AddToggle("ShowFOV", { Title = "Show Aimbot FOV", Default = false })

AimSection:AddDropdown("AimMode", {
    Title = "Aim Mode",
    Values = { "Legit", "Rage" },
    Default = "Legit"
})

AimSection:AddKeybind("AimbotHotkey", {
    Title = "Aimbot Hotkey",
    Default = "MB2",
    Mode = "Hold"
})

AimSection:AddSlider("AimbotFOV", {
    Title = "Aimbot FOV",
    Min = 50,
    Max = 600,
    Default = 200,
    Rounding = 0
})

AimSection:AddSlider("SmoothValue", {
    Title = "Legit Smoothness",
    Min = 1,
    Max = 50,
    Default = 15,
    Rounding = 0
})

AimSection:AddToggle("FOVFilled", {
    Title = "Filled FOV",
    Default = false
})

AimSection:AddColorpicker("FOVFillColor", {
    Title = "Filled Color",
    Default = Color3.fromRGB(255, 0, 0)
})

AimSection:AddColorpicker("FOVOutlineColor", {
    Title = "Border Color",
    Default = Color3.fromRGB(107, 1, 1)
})

-- silent sect
local SilentSection = Tabs.Aimbot:AddSection("Silent Aim", "crosshair")

SilentSection:AddToggle("SilentAim", {
    Title = "Enable Silent Aim",
    Default = false
})

SilentSection:AddToggle("SilentFOVEnabled", {
    Title = "Show Silent FOV",
    Default = false
})

SilentSection:AddSlider("SilentFOV", {
    Title = "Silent Aim FOV",
    Min = 50,
    Max = 600,
    Default = 150,
    Rounding = 0
})

SilentSection:AddToggle("SilentFOVFilled", {
    Title = "Filled FOV",
    Default = false
})

SilentSection:AddColorpicker("SilentFOVFillColor", {
    Title = "Filled Color",
    Default = Color3.fromRGB(255, 0, 0)
})

SilentSection:AddColorpicker("SilentFOVOutlineColor", {
    Title = "Border Color",
    Default = Color3.fromRGB(107, 1, 1)
})


local FOVGui = Instance.new("ScreenGui")
FOVGui.Name = "FOVGradientGUI"
FOVGui.IgnoreGuiInset = true
FOVGui.ResetOnSpawn = false
FOVGui.Parent = game:GetService("CoreGui")

local FOVFrame = Instance.new("Frame")
FOVFrame.AnchorPoint = Vector2.new(0.5, 0.5)
FOVFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
FOVFrame.Size = UDim2.new(0, Options.AimbotFOV.Value * 2, 0, Options.AimbotFOV.Value * 2)
FOVFrame.BackgroundTransparency = 0
FOVFrame.Visible = false
FOVFrame.Parent = FOVGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(1, 0)
Corner.Parent = FOVFrame

local Grad = Instance.new("UIGradient")
Grad.Color = ColorSequence.new(
    Options.FOVFillColor.Value,
    Options.FOVFillColor.Value
)
Grad.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0.00, 0.44),
    NumberSequenceKeypoint.new(0.41, 0.59),
    NumberSequenceKeypoint.new(0.94, 1.00),
    NumberSequenceKeypoint.new(1.00, 0.83),
    NumberSequenceKeypoint.new(1.00, 0.00),
    NumberSequenceKeypoint.new(1.00, 0.53)
})
Grad.Rotation = -55
Grad.Parent = FOVFrame

local Circle_Fill = Drawing.new("Circle")
Circle_Fill.Visible = false
Circle_Fill.Filled = false
Circle_Fill.Color = Options.FOVFillColor.Value
Circle_Fill.Thickness = 1
Circle_Fill.NumSides = 64
Circle_Fill.Radius = Options.AimbotFOV.Value
Circle_Fill.Transparency = 0.25
Circle_Fill.ZIndex = 49

local Circle_Outline = Drawing.new("Circle")
Circle_Outline.Visible = false
Circle_Outline.Filled = false
Circle_Outline.Color = Options.FOVOutlineColor.Value
Circle_Outline.Thickness = 2
Circle_Outline.NumSides = 64
Circle_Outline.Radius = Options.AimbotFOV.Value
Circle_Outline.Transparency = 1
Circle_Outline.ZIndex = 50

Options.FOVOutlineColor:OnChanged(function(v)
    Circle_Outline.Color = v
end)

Options.FOVFilled:OnChanged(function(v)
    Circle_Fill.Visible = not v
    Circle_Outline.Visible = true
    FOVFrame.Visible = v and Options.ShowFOV.Value and Options.AimbotEnabled.Value
end)

Options.AimbotFOV:OnChanged(function(v)
    Circle_Fill.Radius = v
    Circle_Outline.Radius = v
    FOVFrame.Size = UDim2.new(0, v * 2, 0, v * 2)
    Corner.CornerRadius = UDim.new(1, 0)
end)

Options.FOVFillColor:OnChanged(function(v)
    Grad.Color = ColorSequence.new(v, v)
end)

local SilentCircle = Drawing.new("Circle")
SilentCircle.Visible = false
SilentCircle.Filled = false
SilentCircle.Color = Options.SilentFOVOutlineColor.Value
SilentCircle.Thickness = 2
SilentCircle.NumSides = 64
SilentCircle.Radius = Options.SilentFOV.Value
SilentCircle.Transparency = 1
SilentCircle.ZIndex = 50

local SilentFOVFrame = Instance.new("Frame")
SilentFOVFrame.AnchorPoint = Vector2.new(0.5, 0.5)
SilentFOVFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
SilentFOVFrame.Size = UDim2.new(0, Options.SilentFOV.Value * 2, 0, Options.SilentFOV.Value * 2)
SilentFOVFrame.BackgroundTransparency = 0
SilentFOVFrame.Visible = false
SilentFOVFrame.Parent = FOVGui

local SilentCorner = Instance.new("UICorner")
SilentCorner.CornerRadius = UDim.new(1, 0)
SilentCorner.Parent = SilentFOVFrame

local SilentGrad = Instance.new("UIGradient")
SilentGrad.Color = ColorSequence.new(
    Options.SilentFOVFillColor.Value,
    Options.SilentFOVFillColor.Value
)
SilentGrad.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0.00, 0.44),
    NumberSequenceKeypoint.new(0.41, 0.59),
    NumberSequenceKeypoint.new(0.94, 1.00),
    NumberSequenceKeypoint.new(1.00, 0.83),
    NumberSequenceKeypoint.new(1.00, 0.00),
    NumberSequenceKeypoint.new(1.00, 0.53)
})
SilentGrad.Rotation = -55
SilentGrad.Parent = SilentFOVFrame

Options.SilentFOV:OnChanged(function(v)
    SilentCircle.Radius = v
    SilentFOVFrame.Size = UDim2.new(0, v * 2, 0, v * 2)
    SilentCorner.CornerRadius = UDim.new(1, 0)
end)

Options.SilentFOVOutlineColor:OnChanged(function(v)
    SilentCircle.Color = v
end)

Options.SilentFOVFillColor:OnChanged(function(v)
    SilentGrad.Color = ColorSequence.new(v, v)
end)

Options.SilentFOVFilled:OnChanged(function(v)
    SilentCircle.Filled = false
    SilentFOVFrame.Visible = v and Options.SilentFOVEnabled.Value
end)

-- trigger
local TriggerSection = Tabs.Trigger:AddSection("TriggerBot", "target")

TriggerSection:AddParagraph({
    Title = "How it works???",
    Content = [[
    [NOTICE] Use it with Wall Check
    Normal: shoot when the target is in the fov
    Rage: Active No Recoil, No Spread, and No Cooldown
    Advanced: Auto shoot only while aiming
    ]]
})

TriggerSection:AddToggle("TriggerBotEnabled", {
    Title = "Enable TriggerBot",
    Default = false
})

TriggerSection:AddDropdown("TriggerBotMode", {
    Title = "TriggerBot Mode",
    Values = { "Normal", "Rage" },
    Default = "Normal"
})

TriggerSection:AddToggle("AdvancedTriggerBot", {
    Title = "Advanced TriggerBot",
    Default = false
})

TriggerSection:AddKeybind("TriggerHotkey", {
    Title = "Activate Hotkey",
    Default = "B",
    Mode = "Toggle"
})

local PlayerSection = Tabs.Player:AddSection("Slide", "maximize")

PlayerSection:AddToggle("SlideBoostEnabled", {
    Title = "Slide Speed",
    Default = false
})

PlayerSection:AddSlider("SlideBoostAmount", {
    Title = "Slide Speed Multiplier",
    Min = 0,
    Max = 10,
    Default = 0,
    Rounding = 1
})

local FlySection = Tabs.Player:AddSection("Fly", "feather")

FlySection:AddToggle("FlyEnabled", {
    Title = "Enable Fly",
    Default = false
})

FlySection:AddSlider("FlySpeed", {
    Title = "Fly Speed",
    Min = 10,
    Max = 200,
    Default = 100,
    Rounding = 0
})

FlySection:AddKeybind("FlyHotkey", {
    Title = "Fly Hotkey",
    Default = "E",
    Mode = "Toggle"
})

local MusicSection = Tabs.Player:AddSection("Music", "music-4")

MusicSection:AddToggle("MusicEnabled", {
    Title = "Enable Music",
    Default = false
})

MusicSection:AddDropdown("MusicSong", {
    Title = "Select Song",
    Values = {
        "Song 1",
        "Song 2",
        "Song 3",
        "Song 4",
        "Song 5",
        "Song 6",
        "Song 7"
    },
    Default = "Song 1"
})

MusicSection:AddSlider("MusicVolume", {
    Title = "Volume",
    Min = 1,
    Max = 10,
    Default = 5,
    Rounding = 0
})

local RewardsSection = Tabs.Player:AddSection("Game", "gift")

RewardsSection:AddButton({
    Title = "Claim All Rewards",
    Description = "Collects all unlocked rewards",
    Callback = function()
        local data = ReplicatedStorage.Remotes.Data
        data.ClaimLikeReward:FireServer()
        data.ClaimFavoriteReward:FireServer()
        data.ClaimNotificationsReward:FireServer()
        data.ClaimWelcomeBackGift:FireServer()
        Fluent:Notify({
            Title = "Rewards",
            Content = "All rewards successfully claimed!",
            Duration = 3
        })
    end
})

RewardsSection:AddButton({
    Title = "Claim All Codes",
    Description = "Redeems all available codes",
    Callback = function()
        local data = ReplicatedStorage.Remotes.Data
        local codes = {
            "5B_VISITS_WHATTTTTT",
            "FREE83",
            "COMMUNITY18",
            "HAPPYRIVALSWEEN",
            "COMMUNITY19",
            "MERRYMERRYXMAS<3",
            "COMMUNITY20",
            "TEN_BILLION_VISITS_OMG",
            "COMMUNITY21",
            "COMMUNITY22"
        }
        for _, code in ipairs(codes) do
            pcall(function()
                data.RedeemCode:InvokeServer(code)
            end)
        end
        Fluent:Notify({
            Title = "Codes",
            Content = "All codes redeemed!",
            Duration = 3
        })
    end
})

local songIds = {
    ["Song 1"] = 134939857094956,
    ["Song 2"] = 135961890969954,
    ["Song 3"] = 140667339171815,
    ["Song 4"] = 139959590610806,
    ["Song 5"] = 130973511966646,
    ["Song 6"] = 132626387576589,
    ["Song 7"] = 96912787019630
}

local musicSound = Instance.new("Sound")
musicSound.Name = "RivalsMusicPlayer"
musicSound.SoundId = "rbxassetid://"..songIds["Song 1"]
musicSound.Volume = Options.MusicVolume.Value / 10
musicSound.Looped = true
musicSound.Parent = workspace

Options.MusicEnabled:OnChanged(function(v)
    if v then
        musicSound:Play()
    else
        musicSound:Pause()
    end
end)

Options.MusicSong:OnChanged(function(v)
    local id = songIds[v]
    if id then
        musicSound.SoundId = "rbxassetid://" .. id
        if Options.MusicEnabled.Value then
            musicSound:Play()
        end
    end
end)

Options.MusicVolume:OnChanged(function(v)
    musicSound.Volume = v / 10
end)

-- fly
local flyControl = {F=0,B=0,L=0,R=0,U=0,D=0}
local flying = false
local BV, BG = nil, nil

local function StopFly()
    flying = false
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildWhichIsA("Humanoid")
    if hum then hum.PlatformStand = false end
    if BV then BV:Destroy() end
    if BG then BG:Destroy() end
    BV, BG = nil, nil
end

local function StartFly()
    if flying then return end
    if not Options.FlyEnabled.Value then return end
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildWhichIsA("Humanoid")
    if not hrp or not hum then return end
    flying = true
    BV = Instance.new("BodyVelocity")
    BV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    BV.Parent = hrp
    BG = Instance.new("BodyGyro")
    BG.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    BG.P = 9e9
    BG.Parent = hrp
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            task.spawn(function()
                local con
                con = RunService.Stepped:Connect(function()
                    if not flying then
                        con:Disconnect()
                        part.CanCollide = true
                    else
                        part.CanCollide = false
                    end
                end)
            end)
        end
    end
    task.spawn(function()
        while flying and Options.FlyEnabled.Value do
            local speed = Options.FlySpeed.Value
            hum.PlatformStand = true
            local cam = workspace.CurrentCamera.CFrame
            BV.Velocity =
                cam.LookVector * ((flyControl.F - flyControl.B) * speed)
                + cam.RightVector * ((flyControl.R - flyControl.L) * speed)
                + cam.UpVector * ((flyControl.U - flyControl.D) * speed)
            BG.CFrame = cam
            RunService.Stepped:Wait()
        end
        StopFly()
    end)
end

RunService.RenderStepped:Connect(function()
    if not Options.FlyEnabled.Value then
        if flying then StopFly() end
        return
    end
    local hk = Options.FlyHotkey:GetState()
    if hk and not flying then
        StartFly()
    elseif not hk and flying then
        StopFly()
    end
end)

UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    local key = input.KeyCode
    if key == Enum.KeyCode.W then flyControl.F = 1
    elseif key == Enum.KeyCode.S then flyControl.B = 1
    elseif key == Enum.KeyCode.A then flyControl.L = 1
    elseif key == Enum.KeyCode.D then flyControl.R = 1
    elseif key == Enum.KeyCode.Space then flyControl.U = 1
    elseif key == Enum.KeyCode.Q then flyControl.D = 1
    end
end)

UIS.InputEnded:Connect(function(input)
    local key = input.KeyCode
    if key == Enum.KeyCode.W then flyControl.F = 0
    elseif key == Enum.KeyCode.S then flyControl.B = 0
    elseif key == Enum.KeyCode.A then flyControl.L = 0
    elseif key == Enum.KeyCode.D then flyControl.R = 0
    elseif key == Enum.KeyCode.Space then flyControl.U = 0
    elseif key == Enum.KeyCode.Q then flyControl.D = 0
    end
end)

LocalPlayer.CharacterAdded:Connect(function()
    StopFly()
end)

-- slide
do
    local hrp = nil
    local activeConnections = {}

    local function cleanup()
        for _, c in ipairs(activeConnections) do
            c:Disconnect()
        end
        table.clear(activeConnections)
    end

    local function applyBoost(bv, boost)
        local v = bv.Velocity
        bv.Velocity = Vector3.new(v.X * boost, v.Y, v.Z * boost)
        bv.MaxForce = Vector3.new(1e7, 0, 1e7)
    end

    local function setupCharacter(char)
        cleanup()
        hrp = char:WaitForChild("HumanoidRootPart", 3)
        if not hrp then return end
        local childConn
        childConn = hrp.ChildAdded:Connect(function(obj)
            if not obj:IsA("BodyVelocity") then return end
            if not Options.SlideBoostEnabled.Value then return end
            local slider = Options.SlideBoostAmount.Value
            local boost = math.clamp(1 + slider * 0.2, 1, 3)
            local renderConn
            renderConn = RunService.RenderStepped:Connect(function()
                if not obj.Parent or obj == nil then
                    renderConn:Disconnect()
                    return
                end
                applyBoost(obj, boost)
            end)
            table.insert(activeConnections, renderConn)
        end)
        table.insert(activeConnections, childConn)
    end

    if LocalPlayer.Character then
        setupCharacter(LocalPlayer.Character)
    end

    LocalPlayer.CharacterAdded:Connect(setupCharacter)
end

-- util func
local function HoldingHotkey()
    local key = Options.AimbotHotkey.Value
    if key == "MB1" or key == "Mouse1" or key == "MouseLeft" then
        return UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
    end
    if key == "MB2" or key == "Mouse2" or key == "MouseRight" then
        return UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
    end
    if Enum.KeyCode[key] ~= nil then
        return UIS:IsKeyDown(Enum.KeyCode[key])
    end
    return false
end

local function WallCheck(character)
    if not Options.WallCheck.Value then return true end
    if not character then return false end
    local head = character:FindFirstChild("Head")
    if not head then return false end
    local myChar = LocalPlayer.Character
    if not myChar then return false end
    local myHead = myChar:FindFirstChild("Head")
    if not myHead then return false end
    local origin = myHead.Position
    local direction = (head.Position - origin)
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = { myChar }
    local result = workspace:Raycast(origin, direction, params)
    if not result then return true end
    if result.Instance:IsDescendantOf(character) then return true end
    return false
end

local function TeamCheck(player)
    if not player or player == LocalPlayer then return false end
    local char = player.Character
    if not char then return true end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return true end
    local tag = hrp:FindFirstChild("TeammateLabel")
    if tag then return false end
    return true
end

local function IsValidTarget(plr)
    if plr == LocalPlayer then return false end
    if not plr.Character then return false end
    local hum = plr.Character:FindFirstChild("Humanoid")
    if not hum or hum.Health <= 0 then return false end
    if Options.TeamCheck.Value and not TeamCheck(plr) then return false end
    return true
end

local function GetClosest(FOV)
    local closest = nil
    local bestDist = math.huge
    local center = Camera.ViewportSize / 2
    for _, plr in ipairs(Players:GetPlayers()) do
        if IsValidTarget(plr) then
            local head = plr.Character:FindFirstChild("Head")
            if head then
                local pos, visible = Camera:WorldToViewportPoint(head.Position)
                if visible then
                    local dist = (Vector2.new(center.X, center.Y) - Vector2.new(pos.X, pos.Y)).Magnitude
                    if dist < bestDist and dist < FOV then
                        if WallCheck(plr.Character) then
                            bestDist = dist
                            closest = head
                        end
                    end
                end
            end
        end
    end
    return closest
end

local function GetClosestAnyFOV()
    local targetAimbot = GetClosest(Options.AimbotFOV.Value)
    local targetSilent = GetClosest(Options.SilentFOV.Value)
    if Options.AimbotEnabled.Value and targetAimbot then return targetAimbot end
    if Options.SilentAim.Value and targetSilent then return targetSilent end
    return nil
end

-- aimbot
local function Aim(target)
    local pos, visible = Camera:WorldToViewportPoint(target.Position)
    if not visible then return end
    local mousePos = UIS:GetMouseLocation()
    local dx = pos.X - mousePos.X
    local dy = pos.Y - mousePos.Y
    if Options.AimMode.Value == "Rage" then
        mousemoverel(dx, dy)
        return
    end
    local smooth = Options.SmoothValue.Value * 2
    mousemoverel(dx / smooth, dy / smooth)
end

-- und hook oth
local utility = require(ReplicatedStorage.Modules.Utility)

local oldRay
pcall(function()
    oldRay = hookfunction(utility.Raycast, newcclosure(function(...)
        local args = {...}
        if Options.SilentAim.Value and args[4] == 999 then
            local target = GetClosest(Options.SilentFOV.Value)
            if target then
                args[3] = target.Position
            end
        end
        return oldRay(table.unpack(args))
    end))
end)

local function Shoot()
    if getgenv().IsDeflecting then return end
    local lf = FighterController.LocalFighter
    if not lf then return end
    local item = lf.EquippedItem
    if not item then return end
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local target = GetClosestAnyFOV()
    if not target then return end
    local shootCF = CFrame.new(root.Position, target.Position)
    local relative = target.CFrame:ToObjectSpace(target.CFrame)
    local data = {
        [utf8.char(1)] = {
            [utf8.char(0)] = Utility:EncodeCFrame(shootCF),
            [utf8.char(1)] = Utility:EncodeCFrame(shootCF),
            [utf8.char(2)] = target,
            [utf8.char(3)] = Utility:EncodeCFrame(relative),
        }
    }
    ReplicatedStorage.Remotes.Replication.Fighter.UseItem:FireServer(
        item:Get("ObjectID"),
        Enums:ToEnum("StartShooting"),
        data,
        nil
    )
end

local function TriggerBotLogic()
    if not Options.TriggerBotEnabled.Value then return end
    if not Options.TriggerHotkey:GetState() then return end
    local target = GetClosestAnyFOV()
    if not target then
        if Options.TriggerBotMode.Value == "Normal" then
            if Options.NoRecoil.Value then Options.NoRecoil:SetValue(false) end
            if Options.NoSpread.Value then Options.NoSpread:SetValue(false) end
            if Options.NoCooldown.Value then Options.NoCooldown:SetValue(false) end
        end
        return
    end
    if Options.AdvancedTriggerBot.Value and not HoldingHotkey() then return end
    if Options.TriggerBotMode.Value == "Normal" then
        if Options.NoRecoil.Value then Options.NoRecoil:SetValue(false) end
        if Options.NoSpread.Value then Options.NoSpread:SetValue(false) end
        if Options.NoCooldown.Value then Options.NoCooldown:SetValue(false) end
        Shoot()
        return
    end
    if Options.TriggerBotMode.Value == "Rage" then
        if not Options.NoRecoil.Value then Options.NoRecoil:SetValue(true) end
        if not Options.NoSpread.Value then Options.NoSpread:SetValue(true) end
        if not Options.NoCooldown.Value then Options.NoCooldown:SetValue(true) end
        Shoot()
    end
end

RunService.RenderStepped:Connect(function()
    local center = Camera.ViewportSize / 2
    local pos = Vector2.new(center.X, center.Y)
    local showFOV = Options.ShowFOV.Value and Options.AimbotEnabled.Value
    local filled = Options.FOVFilled.Value

    Circle_Outline.Position = pos
    Circle_Fill.Position = pos
    FOVFrame.Position = UDim2.new(0.5,0,0.5,0)

    if filled then
        Circle_Outline.Visible = showFOV
        Circle_Fill.Visible = false
        FOVFrame.Visible = showFOV
    else
        Circle_Outline.Visible = showFOV
        Circle_Fill.Visible = showFOV
        FOVFrame.Visible = false
    end

    local showSilent = Options.SilentFOVEnabled.Value and Options.SilentAim.Value
    SilentCircle.Visible = showSilent
    SilentFOVFrame.Visible = showSilent and Options.SilentFOVFilled.Value
    SilentFOVFrame.Position = UDim2.new(0.5,0,0.5,0)
    SilentCircle.Position = pos

    if Options.AimbotEnabled.Value and HoldingHotkey() then
        if getgenv().IsDeflecting then return end
        local target = GetClosest(Options.AimbotFOV.Value)
        if target then Aim(target) end
    end

    TriggerBotLogic()
end)

-- guns mod
local gunOriginal = {
    ShootCooldown = {},
    ShootSpread = {},
    ShootRecoil = {}
}

local function SetGunAttribute(attr, enable)
    for _, obj in pairs(getgc(true)) do
        if type(obj) == "table" then
            local val = rawget(obj, attr)
            if type(val) == "number" then
                if enable then
                    if not gunOriginal[attr][obj] then
                        gunOriginal[attr][obj] = val
                    end
                    obj[attr] = 0
                else
                    local original = gunOriginal[attr][obj]
                    if original then
                        obj[attr] = original
                    end
                end
            end
        end
    end
end

local GunsSection = Tabs.Misc:AddSection("Guns Mod", "crosshair")

GunsSection:AddToggle("NoCooldown", { Title = "[RISKY] No Cooldown", Default = false })
:OnChanged(function()
    SetGunAttribute("ShootCooldown", Options.NoCooldown.Value)
end)

GunsSection:AddToggle("NoSpread", { Title = "[RISKY] No Spread", Default = false })
:OnChanged(function()
    SetGunAttribute("ShootSpread", Options.NoSpread.Value)
end)

GunsSection:AddToggle("NoRecoil", { Title = "[RISKY] No Recoil", Default = false })
:OnChanged(function()
    SetGunAttribute("ShootRecoil", Options.NoRecoil.Value)
end)

local MiscSection = Tabs.Misc:AddSection("Checks", "activity")
MiscSection:AddToggle("TeamCheck", { Title = "Team Check", Default = false })
MiscSection:AddToggle("WallCheck", {
    Title = "Wall Check",
    Description = "Might impact aimbot/silent detection",
    Default = false
})

local AntiSection = Tabs.Misc:AddSection("Anti", "shield")

AntiSection:AddToggle("AntiFlash", {
    Title = "Anti Flash",
    Default = false
})

AntiSection:AddToggle("AntiKatana", {
    Title = "Anti Katana",
    Default = false
})

AntiSection:AddToggle("AntiSmoke", {
    Title = "Anti Smoke 1 [Better]",
    Default = false
})

AntiSection:AddButton({
    Title = "Anti Smoke 2",
    Description = "Remove Smoke forever (It's better to use Smoke 2 with Smoke 1)",
    Callback = function()
        Options.NoSmokeButtonCallback()
        Fluent:Notify({
            Title = "ForgeHub",
            Content = "Smoke has been removed forever",
            Duration = 3
        })
    end
})

AntiSection:AddToggle("AntiStaff", {
    Title = "Anti Staff",
    Default = false
})

AntiSection:AddDropdown("AntiStaffMode", {
    Title = "Anti Staff Action",
    Values = { "Notify", "Kick" },
    Default = "Kick"
})

do
    local function ClearSmokes()
        for _, obj in ipairs(workspace:GetChildren()) do
            if obj.Name == "Smoke Grenade" or obj.Name == "SmokeGrenade" then
                obj:Destroy()
            end
        end
    end

    workspace.ChildAdded:Connect(function(obj)
        if Options.AntiSmoke.Value then
            if obj.Name == "Smoke Grenade" or obj.Name == "SmokeGrenade" then
                obj:Destroy()
            end
        end
    end)

    task.spawn(function()
        while true do
            task.wait(0.05)
            if Options.AntiSmoke.Value then
                ClearSmokes()
            end
        end
    end)

    Options.NoSmokeButtonCallback = function()
        local Misc = LocalPlayer.PlayerScripts.Assets.Misc
        local SmokeClouds = Misc:FindFirstChild("SmokeClouds")
        if SmokeClouds then
            SmokeClouds:Destroy()
        end
    end
end

getgenv().IsDeflecting = false

--kat
do
    local DeflectSound = nil
    local LastTick = 0
    local ActiveDeflect = false

    local ok, KatanaModule = pcall(function()
        return require(LocalPlayer.PlayerScripts.Modules.Items.Katana)
    end)

    if ok and type(KatanaModule) == "table" then
        for name, func in pairs(KatanaModule) do
            if type(func) == "function" and (name == "StartAiming" or name == "StartDeflecting") then
                local old_KatanaHook
                pcall(function()
                    old_KatanaHook = hookfunction(func, newcclosure(function(self, ...)
                        if Options.AntiKatana.Value then
                            LastTick = tick()
                            ActiveDeflect = true
                            getgenv().IsDeflecting = true
                            if not DeflectSound then
                                DeflectSound = Instance.new("Sound")
                                DeflectSound.SoundId = "rbxassetid://9118823109"
                                DeflectSound.Volume = 1
                                DeflectSound.Looped = false
                                DeflectSound.Parent = workspace
                                DeflectSound:Play()
                            end
                        end
                        return old_KatanaHook(self, ...)
                    end))
                end)
            end
        end
    end

    task.spawn(function()
        while true do
            task.wait(0.01)
            if not Options.AntiKatana.Value then
                ActiveDeflect = false
                getgenv().IsDeflecting = false
                if DeflectSound then
                    DeflectSound:Destroy()
                    DeflectSound = nil
                end
                continue
            end
            if ActiveDeflect and tick() - LastTick > 0.40 then
                ActiveDeflect = false
                getgenv().IsDeflecting = false
                if DeflectSound then
                    DeflectSound:Destroy()
                    DeflectSound = nil
                end
            end
        end
    end)
end 

local GameGroup = 3461453

local StaffRoles = {
    ["Community Staff"] = true,
    ["Tester"] = true,
    ["Moderator"] = true,
    ["Contributor"] = true,
    ["Scripter"] = true,
    ["Builder"] = true
}

local function CheckPlayerStaff(plr)
    if not plr.Parent then
        repeat task.wait() until plr.Parent
    end
    local success, role = pcall(function()
        return plr:GetRoleInGroup(GameGroup)
    end)
    if not success then return nil end
    if StaffRoles[role] then return role end
    return nil
end

local function AlertStaff(plr, role)
    if not Options.AntiStaff.Value then return end
    local mode = Options.AntiStaffMode.Value
    if mode == "Notify" then
        Fluent:Notify({
            Title = "[ALERT]",
            Content = plr.Name .. " (" .. role .. ") has joined the server",
            Duration = 15
        })
    elseif mode == "Kick" then
        LocalPlayer:Kick("[ANTI STAFF]: A " .. role .. " has joined the server")
    end
end

task.spawn(function()
    task.wait(1)
    if not Options.AntiStaff.Value then return end
    for _, p in ipairs(Players:GetPlayers()) do
        local role = CheckPlayerStaff(p)
        if role then AlertStaff(p, role) end
    end
end)

Players.PlayerAdded:Connect(function(plr)
    if not Options.AntiStaff.Value then return end
    local role = CheckPlayerStaff(plr)
    if role then AlertStaff(plr, role) end
end)

-- anti flash
do
    local function isFlashObject(obj)
        local name = obj.Name:lower()
        for _, key in ipairs({"flash", "bang", "blind"}) do
            if name:find(key) then return true end
        end
        return false
    end

    Lighting.ChildAdded:Connect(function(child)
        if not Options.AntiFlash.Value then return end
        if (child:IsA("ColorCorrectionEffect") or child:IsA("BloomEffect"))
            and isFlashObject(child) then
            child:Destroy()
        end
    end)

    LocalPlayer.CharacterAdded:Connect(function()
        task.wait(1)
        local gui = LocalPlayer:WaitForChild("PlayerGui")
        gui.ChildAdded:Connect(function(child)
            if not Options.AntiFlash.Value then return end
            if child:IsA("ScreenGui") and isFlashObject(child) then
                child:Destroy()
            end
        end)
    end)

    workspace.ChildAdded:Connect(function(child)
        if not Options.AntiFlash.Value then return end
        if isFlashObject(child) then
            child:Destroy()
            return
        end
        task.defer(function()
            for _, d in ipairs(child:GetDescendants()) do
                if not Options.AntiFlash.Value then return end
                if d:IsA("PointLight") and d.Brightness >= 20 then
                    d.Enabled = false
                    d.Brightness = 0
                end
                if d:IsA("ParticleEmitter") and isFlashObject(d) then
                    d.Enabled = false
                end
            end
        end)
    end)
end

local DeviceSection = Tabs.Misc:AddSection("Device Spoofer", "monitor")

DeviceSection:AddDropdown("DeviceMode", {
    Title = "Spoof Device",
    Values = { "None", "PC", "Console", "Phone", "VR" },
    Default = "None"
})

local ControlRemote = ReplicatedStorage.Remotes.Replication.Fighter.SetControls

local spoofMap = {
    ["PC"] = "MouseKeyboard",
    ["Console"] = "Gamepad",
    ["Phone"] = "Touch",
    ["VR"] = "VR"
}

local function SpoofingShit(device)
    if device == "None" then return end
    local internal = spoofMap[device]
    if internal then
        ControlRemote:FireServer(internal)
    end
end

Options.DeviceMode:OnChanged(function(v)
    SpoofingShit(v)
end)

local ViewmodelSection = Tabs.Visual:AddSection("Viewmodel FX", "Palette")

ViewmodelSection:AddToggle("RainbowViewmodel", {
    Title = "Rainbow Weapons",
    Default = false
})

ViewmodelSection:AddToggle("RainbowHands", {
    Title = "Rainbow Hands",
    Default = false
})

ViewmodelSection:AddToggle("HandsForceField", {
    Title = "ForceField Hands",
    Default = false
})

ViewmodelSection:AddToggle("WeaponForceField", {
    Title = "ForceField Weapon",
    Default = false
})

local CursorSection = Tabs.Visual:AddSection("Cursor", "mouse-pointer")

CursorSection:AddToggle("CursorSpin", {
    Title = "Cursor Spin",
    Default = false
})

CursorSection:AddSlider("CursorSpinSpeed", {
    Title = "Spin Speed",
    Min = 0,
    Max = 10,
    Default = 3,
    Rounding = 1
})

local VisualSection = Tabs.Visual:AddSection("ESP", "eye")

VisualSection:AddToggle("ESPEnabled", { Title = "Enable ESP", Default = false })
VisualSection:AddToggle("ESPBox", { Title = "Box", Default = true })
VisualSection:AddToggle("ESPName", { Title = "Name", Default = true })
VisualSection:AddToggle("ESPTracer", { Title = "Tracer", Default = true })
VisualSection:AddToggle("ESPDistance", { Title = "Distance", Default = true })
VisualSection:AddToggle("ESPHealth", { Title = "Health Bar", Default = true })

VisualSection:AddColorpicker("ESPColor", {
    Title = "ESP Color",
    Default = Color3.fromRGB(255, 60, 60)
})

VisualSection:AddSlider("ESPThickness", {
    Title = "Line Thickness",
    Min = 1,
    Max = 5,
    Default = 2,
    Rounding = 0
})

local function GetCrosshairBackgrounds()
    local list = {}
    local ok, interfaces = pcall(function()
        return LocalPlayer.PlayerGui.MainGui.MainFrame.ItemInterfaces
    end)
    if not ok or not interfaces then return list end
    for _, wep in ipairs(interfaces:GetChildren()) do
        if wep:IsA("Frame") then
            local mouse = wep:FindFirstChild("Mouse")
            if not mouse then continue end
            local cross = mouse:FindFirstChild("Crosshair")
            if not cross then continue end
            local bg = cross:FindFirstChild("Background")
            if bg then table.insert(list, bg) end
        end
    end
    return list
end

local function ProtectBackground(bg)
    bg.Visible = false
    bg:GetPropertyChangedSignal("Visible"):Connect(function()
        if bg.Visible == true then
            bg.Visible = false
        end
    end)
end

task.spawn(function()
    while task.wait(0.5) do
        for _, bg in ipairs(GetCrosshairBackgrounds()) do
            if not bg:GetAttribute("ProtectedBG") then
                bg:SetAttribute("ProtectedBG", true)
                ProtectBackground(bg)
            end
        end
    end
end)

local function GetCrosshairFrames()
    local frames = {}
    local ok, interfaces = pcall(function()
        return LocalPlayer.PlayerGui.MainGui.MainFrame.ItemInterfaces
    end)
    if not ok or not interfaces then return frames end
    for _, weaponFrame in ipairs(interfaces:GetChildren()) do
        if weaponFrame:IsA("Frame") then
            local mouse = weaponFrame:FindFirstChild("Mouse")
            if not mouse then continue end
            local cross = mouse:FindFirstChild("Crosshair")
            if not cross then continue end
            local fg = cross:FindFirstChild("Foreground")
            local bg = cross:FindFirstChild("Background")
            table.insert(frames, {FG = fg, BG = bg})
        end
    end
    return frames
end

local currentRotation = 0

RunService.RenderStepped:Connect(function(dt)
    if not Options.CursorSpin.Value then return end
    local speed = tonumber(Options.CursorSpinSpeed.Value) or 0
    if speed <= 0 then return end
    currentRotation = (currentRotation + speed * 180 * dt) % 360
    for _, data in ipairs(GetCrosshairFrames()) do
        local fg = data.FG
        local bg = data.BG
        if bg then bg.Visible = false end
        if fg then fg.Rotation = currentRotation end
    end
end)

local function GetViewmodelModel()
    local vmFolder = workspace:FindFirstChild("ViewModels")
    if not vmFolder then return nil end
    local fps = vmFolder:FindFirstChild("FirstPerson")
    if not fps then return nil end
    for _, mdl in ipairs(fps:GetChildren()) do
        if mdl.Name:find(LocalPlayer.Name) then return mdl end
    end
    return nil
end

-- hands ff
local originalHandData = {}

local function SaveHandsOriginal(model)
    table.clear(originalHandData)
    for _, limb in ipairs({"LeftArm", "RightArm"}) do
        local part = model:FindFirstChild(limb)
        if part then
            originalHandData[part] = { Material = part.Material }
        end
    end
end

local function RestoreHandsOriginal()
    for part, data in pairs(originalHandData) do
        if part and part.Parent then
            part.Material = data.Material
        end
    end
end

task.spawn(function()
    while task.wait() do
        local model = GetViewmodelModel()
        if not model then continue end
        if not Options.HandsForceField.Value then
            RestoreHandsOriginal()
            continue
        end
        if next(originalHandData) == nil then SaveHandsOriginal(model) end
        for _, limb in ipairs({"LeftArm", "RightArm"}) do
            local part = model:FindFirstChild(limb)
            if part then part.Material = Enum.Material.ForceField end
        end
    end
end)

-- weapon ff
local originalWeaponData = {}

local function GetItemVisual()
    local mdl = GetViewmodelModel()
    if not mdl then return nil end
    return mdl:FindFirstChild("ItemVisual")
end

local function SaveWeaponOriginal(itemVisual)
    table.clear(originalWeaponData)
    for _, part in ipairs(itemVisual:GetDescendants()) do
        if part:IsA("MeshPart") then
            originalWeaponData[part] = { Material = part.Material }
        end
    end
end

local function RestoreWeaponOriginal()
    for part, data in pairs(originalWeaponData) do
        if part and part.Parent then
            part.Material = data.Material
        end
    end
end

task.spawn(function()
    while task.wait() do
        local itemVisual = GetItemVisual()
        if not itemVisual then continue end
        if not Options.WeaponForceField.Value then
            RestoreWeaponOriginal()
            continue
        end
        if next(originalWeaponData) == nil then SaveWeaponOriginal(itemVisual) end
        for _, part in ipairs(itemVisual:GetDescendants()) do
            if part:IsA("MeshPart") then
                part.Material = Enum.Material.ForceField
            end
        end
    end
end)

-- rgb
local originalHandColors = {}

local function SaveHandColors(model)
    table.clear(originalHandColors)
    local left = model:FindFirstChild("LeftArm")
    local right = model:FindFirstChild("RightArm")
    if left then originalHandColors[left] = left.Color end
    if right then originalHandColors[right] = right.Color end
end

local function RestoreHandColors()
    for part, col in pairs(originalHandColors) do
        if part and part.Parent then part.Color = col end
    end
end

task.spawn(function()
    while task.wait() do
        local model = GetViewmodelModel()
        if not model then continue end
        if not Options.RainbowHands.Value then
            RestoreHandColors()
            continue
        end
        if next(originalHandColors) == nil then SaveHandColors(model) end
        local hue = (tick() * 0.25) % 1
        local left = model:FindFirstChild("LeftArm")
        local right = model:FindFirstChild("RightArm")
        if left then left.Color = Color3.fromHSV(hue, 1, 1) end
        if right then right.Color = Color3.fromHSV(hue, 1, 1) end
    end
end)

local originalColors = {}

local function GetViewmodelItemVisual()
    local mdl = GetViewmodelModel()
    if not mdl then return nil end
    return mdl:FindFirstChild("ItemVisual")
end

local function SaveOriginalColors(itemVisual)
    table.clear(originalColors)
    for _, part in ipairs(itemVisual:GetDescendants()) do
        if part:IsA("MeshPart") then
            originalColors[part] = part.Color
        end
    end
end

local function RestoreOriginalColors()
    for part, col in pairs(originalColors) do
        if part and part.Parent then part.Color = col end
    end
end

task.spawn(function()
    while task.wait() do
        local itemVisual = GetViewmodelItemVisual()
        if not itemVisual then continue end
        if not Options.RainbowViewmodel.Value then
            RestoreOriginalColors()
            continue
        end
        if next(originalColors) == nil then SaveOriginalColors(itemVisual) end
        local hue = (tick() * 0.25) % 1
        for _, part in ipairs(itemVisual:GetDescendants()) do
            if part:IsA("MeshPart") then
                part.Color = Color3.fromHSV(hue, 1, 1)
            end
        end
    end
end)

-- esp
local ESP = {}

local function newDrawing(type)
    local d = Drawing.new(type)
    d.Visible = false
    d.Color = Options.ESPColor.Value
    if type == "Square" then d.Filled = false end
    if type == "Line" or type == "Square" then d.Thickness = Options.ESPThickness.Value end
    if type == "Text" then
        d.Size = 16
        d.Center = true
        d.Outline = true
        d.Color = Color3.new(1,1,1)
    end
    return d
end

Options.ESPColor:OnChanged(function(v)
    for _, objs in pairs(ESP) do
        objs.Box.Color = v
        objs.Tracer.Color = v
        objs.Name.Color = Color3.new(1,1,1)
        objs.Distance.Color = Color3.new(1,1,1)
        objs.Health.Color = Color3.new(0,1,0)
    end
end)

Options.ESPThickness:OnChanged(function(v)
    for _, objs in pairs(ESP) do
        objs.Box.Thickness = v
        objs.Tracer.Thickness = v
        objs.Health.Thickness = v
    end
end)

local function createESP(plr)
    if plr == LocalPlayer then return end
    if ESP[plr] then return end
    ESP[plr] = {
        Box = newDrawing("Square"),
        Name = newDrawing("Text"),
        Health = newDrawing("Line"),
        Tracer = newDrawing("Line"),
        Distance = newDrawing("Text")
    }
end

local function removeESP(plr)
    if not ESP[plr] then return end
    for _, obj in pairs(ESP[plr]) do obj:Remove() end
    ESP[plr] = nil
end

for _, p in pairs(Players:GetPlayers()) do createESP(p) end
Players.PlayerAdded:Connect(createESP)
Players.PlayerRemoving:Connect(removeESP)

RunService.RenderStepped:Connect(function()
    if not Options.ESPEnabled.Value then
        for _, objs in pairs(ESP) do
            for _, o in pairs(objs) do o.Visible = false end
        end
        return
    end

    for plr, objs in pairs(ESP) do
        local char = plr.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChild("Humanoid")
        if not hrp or not hum or hum.Health <= 0 then
            for _, o in pairs(objs) do o.Visible = false end
            continue
        end
        local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
        if not onScreen then
            for _, o in pairs(objs) do o.Visible = false end
            continue
        end
        local height = 2600 / pos.Z
        local width = height / 1.8
        local top = Vector2.new(pos.X - width/2, pos.Y - height/2)

        objs.Box.Visible = Options.ESPBox.Value
        if Options.ESPBox.Value then
            objs.Box.Position = top
            objs.Box.Size = Vector2.new(width, height)
        end

        objs.Name.Visible = Options.ESPName.Value
        if Options.ESPName.Value then
            objs.Name.Position = Vector2.new(pos.X, top.Y - 15)
            objs.Name.Text = plr.Name
        end

        objs.Health.Visible = Options.ESPHealth.Value
        if Options.ESPHealth.Value then
            local hp = hum.Health / hum.MaxHealth
            objs.Health.From = Vector2.new(top.X - 4, top.Y + height)
            objs.Health.To = Vector2.new(top.X - 4, top.Y + height * (1 - hp))
            objs.Health.Color = Color3.new(0,1,0)
        end

        objs.Tracer.Visible = Options.ESPTracer.Value
        if Options.ESPTracer.Value then
            local bottom = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
            objs.Tracer.From = bottom
            objs.Tracer.To = Vector2.new(pos.X, pos.Y)
        end

        objs.Distance.Visible = Options.ESPDistance.Value
        if Options.ESPDistance.Value then
            local studs = math.floor((Camera.CFrame.Position - hrp.Position).Magnitude)
            objs.Distance.Position = Vector2.new(pos.X, pos.Y + 15)
            objs.Distance.Text = studs.."s"
        end
    end
end)

local HvHSection = Tabs.HvH:AddSection("SpinBot", "rotate-ccw")

HvHSection:AddToggle("SpinBotEnabled", {
    Title = "Enable SpinBot",
    Default = false
})

HvHSection:AddSlider("SpinSpeed", {
    Title = "Spin Speed",
    Min = 0,
    Max = 100,
    Default = 50,
    Rounding = 0
})

do
    local spinAngle = 0
    LocalPlayer.CharacterAdded:Connect(function()
        spinAngle = 0
    end)
    RunService.Heartbeat:Connect(function(deltaTime)
        if not Options.SpinBotEnabled.Value then return end
        local char = LocalPlayer.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        local speed = Options.SpinSpeed.Value
        spinAngle = (spinAngle + speed * deltaTime * 360) % 360
        local base = CFrame.new(root.Position)
        root.CFrame = base * CFrame.Angles(0, math.rad(spinAngle), 0)
    end)
end

local RageSection = Tabs.HvH:AddSection("RageBot [RISKY]", "swords")

RageSection:AddToggle("HvHRagebot", {
    Title = "Enable RageBot",
    Default = false
})

RageSection:AddSlider("RageHeight", {
    Title = "Height Offset",
    Min = 1,
    Max = 20,
    Default = 18,
    Rounding = 0
})

RageSection:AddSlider("RageBehind", {
    Title = "Behind Distance",
    Min = 1,
    Max = 10,
    Default = 4,
    Rounding = 0
})

RageSection:AddSlider("RageMaxDist", {
    Title = "Target Max Distance",
    Min = 50,
    Max = 300,
    Default = 200,
    Rounding = 0
})

local function GetClosestEnemy200()
    local myChar = LocalPlayer.Character
    if not myChar then return end
    local myHRP = myChar:FindFirstChild("HumanoidRootPart")
    if not myHRP then return end
    local maxDist = Options.RageMaxDist.Value or 200
    local bestHead, bestChar, bestDist = nil, nil, maxDist
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local char = plr.Character
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local head = char:FindFirstChild("Head")
            local hum = char:FindFirstChild("Humanoid")
            if hrp and head and hum and hum.Health > 0 then
                if not hrp:FindFirstChild("TeammateLabel") then
                    local dist = (myHRP.Position - hrp.Position).Magnitude
                    if dist < bestDist then
                        bestDist = dist
                        bestHead = head
                        bestChar = char
                    end
                end
            end
        end
    end
    return bestHead, bestChar
end

local function TeleportBehindEnemy(char)
    local myChar = LocalPlayer.Character
        if not myChar then return end
            local myHRP = myChar:FindFirstChild("HumanoidRootPart")
                 if not myHRP then return end
        local enemyHRP = char:FindFirstChild("HumanoidRootPart")
            if not enemyHRP then return end
                local height = Options.RageHeight.Value
                local behindDist = Options.RageBehind.Value
                local backPos = enemyHRP.Position - enemyHRP.CFrame.LookVector * behindDist + Vector3.new(0, height, 0)
    local finalCF = CFrame.lookAt(backPos, enemyHRP.Position)
    myHRP.AssemblyLinearVelocity = Vector3.zero
    myHRP.CFrame = finalCF
end

local function ShootAtTarget(head)
    local lf = FighterController.LocalFighter
    if not lf then return end
    local item = lf.EquippedItem
    if not item then return end
    local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local pos = root.Position
    local shootCF = CFrame.new(pos, head.Position)
    local relative = head.CFrame:ToObjectSpace(head.CFrame)
    local data = {
        [utf8.char(1)] = {
            [utf8.char(0)] = Utility:EncodeCFrame(shootCF),
            [utf8.char(1)] = Utility:EncodeCFrame(shootCF),
            [utf8.char(2)] = head,
            [utf8.char(3)] = Utility:EncodeCFrame(relative),
        }
    }
    ReplicatedStorage.Remotes.Replication.Fighter.UseItem:FireServer(
        item:Get("ObjectID"),
        Enums:ToEnum("StartShooting"),
        data,
        nil
    )
end

RunService.Heartbeat:Connect(function()
    if not Options.HvHRagebot.Value then return end
    if getgenv().IsDeflecting then return end
    local head, char = GetClosestEnemy200()
    if not head then return end
    TeleportBehindEnemy(char)
    RunService.RenderStepped:Wait()
    ShootAtTarget(head)
end)

local backupFolder = ReplicatedStorage:FindFirstChild("OriginalSkyBackup")
if not backupFolder then
    backupFolder = Instance.new("Folder")
    backupFolder.Name = "OriginalSkyBackup"
    backupFolder.Parent = ReplicatedStorage
end

local function SaveOriginalSky()
    if backupFolder:FindFirstChild("SkySaved") then return end
    local originalSky = Lighting:FindFirstChildOfClass("Sky")
    if originalSky then
        local clone = originalSky:Clone()
        clone.Name = "SkySaved"
        clone.Parent = backupFolder
    end
end

SaveOriginalSky()

local function ClearSky()
    for _, v in ipairs(Lighting:GetChildren()) do
        if v:IsA("Sky") then v:Destroy() end
    end
end

local function ClearAtmosphere()
    for _, v in ipairs(Lighting:GetChildren()) do
        if v:IsA("Atmosphere") or v:IsA("BloomEffect") or v:IsA("ColorCorrectionEffect") then
            v:Destroy()
        end
    end
end

local function ApplySky(data)
    ClearSky()
    local sky = Instance.new("Sky")
    for prop, value in pairs(data) do sky[prop] = value end
    sky.Parent = Lighting
end

local function RestoreOriginal()
    ClearSky()
    local saved = backupFolder:FindFirstChild("SkySaved")
    if saved then
        local clone = saved:Clone()
        clone.Parent = Lighting
    end
end

local SkyPresets = {
    Galaxy = {
        SkyboxBk = "rbxassetid://15983968922",
        SkyboxDn = "rbxassetid://15983966825",
        SkyboxFt = "rbxassetid://15983965025",
        SkyboxLf = "rbxassetid://15983967420",
        SkyboxRt = "rbxassetid://15983966246",
        SkyboxUp = "rbxassetid://15983964246",
        StarCount = 3000
    },
    Night = {
        SkyboxBk = "rbxassetid://48020371",
        SkyboxDn = "rbxassetid://48020144",
        SkyboxFt = "rbxassetid://48020234",
        SkyboxLf = "rbxassetid://48020211",
        SkyboxRt = "rbxassetid://48020254",
        SkyboxUp = "rbxassetid://48020383",
        StarCount = 3000
    },
    City = {
        SkyboxBk = "rbxassetid://163897885",
        SkyboxDn = "rbxassetid://163898013",
        SkyboxFt = "rbxassetid://163899342",
        SkyboxLf = "rbxassetid://163897886",
        SkyboxRt = "rbxassetid://163897887",
        SkyboxUp = "rbxassetid://163898013",
        StarCount = 3000
    },
    Pink = {
        SkyboxBk = "rbxassetid://271042516",
        SkyboxDn = "rbxassetid://271077243",
        SkyboxFt = "rbxassetid://271042556",
        SkyboxLf = "rbxassetid://271042310",
        SkyboxRt = "rbxassetid://271042467",
        SkyboxUp = "rbxassetid://271077958",
        StarCount = 1334
    }
}

local function ApplyAtmosphere(theme)
    ClearAtmosphere()
    local fog, bloom, color = nil, nil, nil
    if theme == "Pink" then
        fog = Color3.fromRGB(243, 128, 168)
        bloom = {Intensity = 2, Size = 80, Threshold = 1}
        color = {Tint = Color3.fromRGB(255,160,200), Sat = 0.40, Con = 0.05}
    elseif theme == "Blue" then
        fog = Color3.fromRGB(90, 140, 255)
        bloom = {Intensity = 1.6, Size = 70, Threshold = 1}
        color = {Tint = Color3.fromRGB(120,170,255), Sat = 0.35, Con = 0.05}
    elseif theme == "Blood" then
        fog = Color3.fromRGB(255, 80, 80)
        bloom = {Intensity = 2.5, Size = 90, Threshold = 0.8}
        color = {Tint = Color3.fromRGB(255,120,120), Sat = 0.5, Con = 0.1}
    elseif theme == "White" then
        fog = Color3.fromRGB(255, 255, 255)
        bloom = {Intensity = 1.4, Size = 65, Threshold = 1}
        color = {Tint = Color3.fromRGB(255,255,255), Sat = 0, Con = 0}
    end
    local atm = Instance.new("Atmosphere")
        atm.Density = 0.35
    atm.Offset = 0.25
    atm.Color = fog
    atm.Decay = fog
    atm.Parent = Lighting
    local b = Instance.new("BloomEffect")
    b.Intensity = bloom.Intensity
    b.Size = bloom.Size
    b.Threshold = bloom.Threshold
    b.Parent = Lighting
    local cc = Instance.new("ColorCorrectionEffect")
    cc.TintColor = color.Tint
    cc.Saturation = color.Sat
    cc.Contrast = color.Con
    cc.Parent = Lighting
end

local OtherSection = Tabs.Other:AddSection("Sky & Atmosphere", "cloud")

OtherSection:AddDropdown("SkySelect", {
    Title = "Skybox",
    Values = { "Original", "Galaxy", "Night", "City", "Pink" },
    Default = "Original"
})

Options.SkySelect:OnChanged(function(v)
    if v == "Original" then RestoreOriginal() return end
    ApplySky(SkyPresets[v])
end)

OtherSection:AddDropdown("AtmosphereSelect", {
    Title = "Atmosphere Theme",
    Values = { "Off", "Pink", "Blue", "Blood", "White" },
    Default = "Off"
})

Options.AtmosphereSelect:OnChanged(function(v)
    if v == "Off" then
        for _, e in ipairs(Lighting:GetChildren()) do
            if e:IsA("Atmosphere") or e:IsA("BloomEffect") or e:IsA("ColorCorrectionEffect") then
                e:Destroy()
            end
        end
        return
    end
    ApplyAtmosphere(v)
end)

local FogSection = Tabs.Other:AddSection("Custom Fog", "cloud")

FogSection:AddToggle("CustomFogEnabled", {
    Title = "Fog",
    Default = false
})

FogSection:AddSlider("FogDensity", {
    Title = "Fog Density",
    Min = 0,
    Max = 10,
    Default = 3,
    Rounding = 1
})

local customFog = nil

local function UpdateCustomFog()
    if Options.CustomFogEnabled.Value then
        if not customFog then
            customFog = Instance.new("Atmosphere")
            customFog.Name = "CustomFog"
            customFog.Density = Options.FogDensity.Value / 10
            customFog.Haze = 7
            customFog.Color = Color3.fromRGB(255, 255, 255)
            customFog.Decay = Color3.fromRGB(255, 255, 255)
            customFog.Parent = Lighting
        else
            customFog.Density = Options.FogDensity.Value / 10
        end
    else
        if customFog then
            customFog:Destroy()
            customFog = nil
        end
    end
end

Options.CustomFogEnabled:OnChanged(UpdateCustomFog)
Options.FogDensity:OnChanged(UpdateCustomFog)

local SkinLists = {
    ["Assault Rifle"] = {"Default","AK-47","AUG","Tommy Gun","Boneclaw Rifle","Gingerbread AUG","AKEY-47","10B Visits","Phoenix Rifle","Glorious Assault Rifle"},
    ["Bow"] = {"Default","Compound Bow","Raven Bow","Dream Bow","Bat Bow","Frostbite Bow","Beloved Bow","Balloon Bow","Glorious Bow","Key Bow"},
    ["Burst Rifle"] = {"Default","Electro Rifle","Aqua Burst","FAMAS","Spectral Burst","Pine Burst","Pixel Burst","Keyst Rifle","Glorious Burst Rifle"},
    ["Crossbow"] = {"Default","Pixel Crossbow","Harpoon Crossbow","Violin Crossbow","Crossbone","Frostbite Crossbow","Arch Crossbow","Glorious Crossbow"},
    ["Distortion"] = {"Default","Plasma Distortion","Magma Distortion","Cyber Distortion","Experiment D15","Sleighstortion","Electropunk Distortion","Glorious Distortion"},
    ["Energy Rifle"] = {"Default","Hacker Rifle","Hydro Rifle","Void Rifle","Soul Rifle","New Year Energy Rifle","Apex Rifle","Glorious Energy Rifle"},
    ["Flamethrower"] = {"Default","Pixel Flamethrower","Lamethrower","Glitterthrower","Jack O'Thrower","Snowblower","Keythrower","Glorious Flamethrower"},
    ["Grenade Launcher"] = {"Default","Swashbuckler","Uranium Launcher","Gearnade Launcher","Skull Launcher","Snowball Launcher","Balloon Launcher","Glorious Grenade Launcher"},
    ["Gunblade"] = {"Default","Hyper Gunblade","Crude Gunblade","Gunsaw","Boneblade","Elf's Gunblade","Glorious Gunblade"},
    ["Minigun"] = {"Default","Lasergun 3000","Pixel Minigun","Fighter Jet","Pumpkin Minigun","Wrapped Minigun","Glorious Minigun"},
    ["Paintball Gun"] = {"Default","Slime Gun","Boba Gun","Ketchup Gun","Brain Gun","Snowball Gun","Paintballoon Gun","Glorious Paintball Gun"},
    ["Shotgun"] = {"Default","Balloon Shotgun","Hyper Shotgun","Cactus Shotgun","Broomstick","Wrapped Shotgun","Shotkey","Glorious Shotgun"},
    ["Sniper"] = {"Default","Pixel Sniper","Hyper Sniper","Event Horizon","Eyething Sniper","Gingerbread Sniper","Keyper","Glorious Sniper"},
    ["Daggers"] = {"Default","Aces","Paper Planes","Shurikens","Bat Daggers","Cookies","Crystal Daggers","Broken Hearts","Keynais","Glorious Daggers"},
    ["Energy Pistols"] = {"Default","Void Pistols","Hydro Pistols","Soul Pistols","New Year Energy Pistols","Apex Pistols","Hacker Pistols","Hyperlaser Guns","Keyzi","Glorious Energy Pistols"},
    ["Exogun"] = {"Default","Singularity","Ray Gun","Repulsor","Exogourd","Midnight Festive Exogun","Wondergun","Glorious Exogun"},
    ["Flare Gun"] = {"Default","Firework Gun","Dynamite Gun","Banana Flare","Vexed Flare Gun","Wrapped Flare Gun","Glorious Flare Gun"},
    ["Handgun"] = {"Default","Blaster","Hand Gun","Gumball Handgun","Pumpkin Handgun","Gingerbread Handgun","Warp Handgun","Towerstone Handgun","Pixel Handgun","Glorious Handgun"},
    ["Revolver"] = {"Default","Desert Eagle","Sheriff","Peppergun","Boneclaw Revolver","Peppermint Sheriff","Keyvolver","Glorious Revolver"},
    ["Shorty"] = {"Default","Not So Shorty","Lovely Shorty","Balloon Shorty","Demon Shorty","Wrapped Shorty","Too Shorty","Glorious Shorty"},
    ["Slingshot"] = {"Default","Stick","Goalpost","Harp","Boneshot","Reindeer Slingshot","Glorious Slingshot"},
    ["Spray"] = {"Default","Lovely Spray","Nail Gun","Boneclaw Spray","Pine Spray","Key Spray","Spray Bottle","Glorious Spray"},
    ["Uzi"] = {"Default","Water Uzi","Electro Uzi","Money Gun","Demon Uzi","Pine Uzi","Keyzi","Glorious Uzi"},
    ["Warper"] = {"Default","Glitter Warper","Arcane Warper","Hotel Bell","Experiment W4","Frost Warper","Electropunk Warper","Glorious Warper"},
    ["Battle Axe"] = {"Default","The Shred","Ban Axe","Cerulean Axe","Mimic Axe","Nordic Axe","Balloon Axe","Keyttle Axe","Glorious Battle Axe"},
    ["Chainsaw"] = {"Default","Blobsaw","Handsaws","Mega Drill","Buzzsaw","Festive Buzzsaw","Glorious Chainsaw"},
    ["Fists"] = {"Default","Boxing Gloves","Brass Knuckles","Pumpkin Claws","Festive Fists","Fists of Hurt","Glorious Fists"},
    ["Katana"] = {"Default","Saber","Lightning Bolt","Stellar Katana","Devil's Trident","New Year Katana","Keytana","Arch Katana","Crystal Katana","Pixel Katana","Linked Sword","Glorious Katana"},
    ["Knife"] = {"Default","Chancla","Karambit","Balisong","Machete","Candy Cane","Keylisong","Keyrambit","Glorious Knife"},
    ["Riot Shield"] = {"Default","Door","Energy Shield","Masterpiece","Tombstone Shield","Sled","Glorious Riot Shield"},
    ["Scythe"] = {"Default","Scythe of Death","Anchor","Sakura Scythe","Bat Scythe","Cryo Scythe","Crystal Scythe","Keythe","Bug Net","Glorious Scythe"},
    ["Trowel"] = {"Default","Plastic Shovel","Garden Shovel","Paintbrush","Pumpkin Carver","Snow Shovel","Glorious Trowel"},
    ["Flashbang"] = {"Default","Disco Ball","Camera","Lightbulb","Skullbang","Shining Star","Pixel Flashbang","Glorious Flashbang"},
    ["Freeze Ray"] = {"Default","Temporal Ray","Bubble Ray","Gum Ray","Spider Ray","Wrapped Freeze Ray","Glorious Freeze Ray"},
    ["Grenade"] = {"Default","Whoopee Cushion","Water Balloon","Dynamite","Soul Grenade","Jingle Grenade","Cuddle Bomb","Keynade","Frozen Grenade","Glorious Grenade"},
    ["Jump Pad"] = {"Default","Trampoline","Bounce House","Shady Chicken Sandwich","Spider Web","Jolly Man","Glorious Jump Pad"},
    ["Medkit"] = {"Default","Sandwich","Laptop","Medkitty","Bucket of Candy","Milk & Cookies","Box of Chocolates","Briefcase","Glorious Medkit"},
    ["Molotov"] = {"Default","Coffee","Torch","Lava Lamp","Vexed Candle","Hot Coals","Glorious Molotov"},
    ["Satchel"] = {"Default","Advanced Satchel","Notebook Satchel","Bag o' Money","Potion Satchel","Suspicious Gift","Glorious Satchel"},
    ["Smoke Grenade"] = {"Default","Emoji Cloud","Balance","Hourglass","Eyeball","Snowglobe","Glorious Smoke Grenade"},
    ["Subspace Tripmine"] = {"Default","Don't Press","Spring","DIY Tripmine","Trick or Treat","Dev-in-the-Box","Glorious Subspace Tripmine"},
    ["War Horn"] = {"Default","Trumpet","Megaphone","Air Horn","Boneclaw Horn","Mammoth Horn","Glorious War Horn"},
    ["Warpstone"] = {"Default","Cyber Warpstone","Teleport Disc","Electropunk Warpstone","Warpbone","Warpstar","Unstable Warpstone","Warpeye","Glorious Warpstone"},
    ["Permafrost"] = {"Default","Snowman Permafrost","Ice Permafrost","Glorious Permafrost"},
    ["Maul"] = {"Default","Ban Hammer","Ice Maul","Sleigh Maul","Glorious Maul"},
}

_G.EquippedData = _G.EquippedData or {}
for weapon in pairs(SkinLists) do
    if not _G.EquippedData[weapon] then
        _G.EquippedData[weapon] = { Skin = "Default" }
    end
end

local CosmeticLibrary = require(ReplicatedStorage:WaitForChild("Modules", 5):WaitForChild("CosmeticLibrary", 5))
local ReplicatedClass = require(ReplicatedStorage.Modules:WaitForChild("ReplicatedClass", 5))
local ClientViewModel = require(
    LocalPlayer.PlayerScripts:WaitForChild("Modules", 5):WaitForChild("ClientReplicatedClasses", 5):WaitForChild("ClientFighter", 5):WaitForChild("ClientItem", 5):WaitForChild("ClientViewModel", 5))

local function getCosmeticData(name, cType)
    local base = CosmeticLibrary.Cosmetics[name]
    if not base then return nil end
    local data = table.clone(base)
    data.Name = name
    data.Type = cType
    if name == "AKEY-47" then
        data.IsMythical = true
        data.BundlePath = "Bundles"
    elseif name:find("Gingerbread") then
        data.BundlePath = "Festive Skin Case"
    end
    return data
end

local oldVMNew = ClientViewModel.new
ClientViewModel.new = function(replicatedData, clientItem)
    local weaponName = clientItem.Name
    if _G.EquippedData[weaponName] and clientItem.ClientFighter.Player == LocalPlayer then
        local dataKey = ReplicatedClass:ToEnum("Data")
        local skinKey = ReplicatedClass:ToEnum("Skin")
        local nameKey = ReplicatedClass:ToEnum("Name")
        replicatedData[dataKey] = replicatedData[dataKey] or {}
        local selectedSkin = _G.EquippedData[weaponName].Skin
        if selectedSkin ~= "Default" then
            replicatedData[dataKey][skinKey] = getCosmeticData(selectedSkin, "Skin")
            replicatedData[dataKey][nameKey] = selectedSkin
        end
    end
    local vm = oldVMNew(replicatedData, clientItem)
    task.delay(0.1, function()
        if vm and vm._UpdateWrap then vm:_UpdateWrap() end
    end)
    return vm
end

local function EquipSkin(weapon, skin)
    _G.EquippedData[weapon].Skin = skin
    pcall(function() CosmeticLibrary.Equip(weapon, "Skin", skin) end)
end

local SkinTab = Window:AddTab({ Title = "Skins", Icon = "shirt" })
local SkinSection = SkinTab:AddSection("Weapon Skins", "shirt")

SkinSection:AddParagraph({
    Title = "Info",
    Content = "Skins apply automatically next time you equip the weapon."
})

local weaponList = {}
for weapon in pairs(SkinLists) do table.insert(weaponList, weapon) end
table.sort(weaponList)

for _, weapon in ipairs(weaponList) do
    local dropId = "Skin_" .. weapon:gsub("[^%w]", "_")
    SkinSection:AddDropdown(dropId, {
        Title = weapon,
        Values = SkinLists[weapon],
        Default = "Default"
    })
    Options[dropId]:OnChanged(function(v)
        EquipSkin(weapon, v)
        Fluent:Notify({
            Title = "Skin Changer",
            Content = weapon .. " to " .. v,
            Duration = 2
        })
    end)
end

-- Save
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:SetFolder("FluentPlusHub")
InterfaceManager:SetFolder("FluentPlusUI")
SaveManager:SetFolder("FluentPlusHub/Config")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

SaveManager:LoadAutoloadConfig()

Window:SelectTab(1)

Fluent:Notify({
    Title = "Rivals BETA",
    Content = "Loaded Successfully.",
    Duration = 3
})

print("Done")
