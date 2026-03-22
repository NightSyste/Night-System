local OrionLib = loadstring(game:HttpGet('https://raw.githubusercontent.com/NightSyste/orion.lua/refs/heads/main/night.lua'))()
local HttpService = game:GetService("HttpService")
local CONFIG_FILE = "NightSystem"

local DefaultConfig = {
    Aimbot = {
        Enabled = false,
        MobileButton = false,
        Keybind = "L",
        WallCheck = true,
        ShowFOV = true,
        FOVRadius = 60,
        TargetPart = "Head",
        Prediction = false,
        Smoothing = 2
    },
    SilentAim = {
        Enabled = false,
        Keybind = "K",
        ShootSpeed = 0.1,
        ShowFOV = true,
        FOVSize = 50,
        FOVColor = {255, 0, 0},
        KnockedCheck = true,
        TeamCheck = false,
        WallCheck = true,
        HitParts = {"Head", "HumanoidRootPart"}
    },
    GunMods = {
        AutoReload = false,
        RapidFire = false,
        NoRecoil = false,
        GunSound = "Default",
        CrosshairSize = 25,
        AimFOV = 20,
        WeaponColor = {255, 255, 255},
        RainbowMode = false
    },
    CarMods = {
        GodMode = false,
        InfiniteFuel = false,
        GripBoost = false,
        AntiCrashDamage = false,
        EnterLockedCars = false,
        NumberplateText = "NightHub",
        CarFly = false,
        MobileCarfly = false,
        VehicleFling = false,
        CarFlyKeybind = "X",
        CarFlySpeed = 100,
        VehicleSound = "Default",
        SuspensionHeight = 1.5,
        JumpHeight = 100,
        ForwardPower = 60,
        JumpKeybind = "F2",
        InstantBoostStrength = 2.5,
        AccelerationMultiplier = 2,
        Armor = 0,
        Brakes = 0,
        Engine = 0,
        WheelColor = {255, 255, 255},
        BodyColor = {255, 255, 255}
    },
    Visuals = {
        ShowNames = false,
        ShowTeam = false,
        ShowHealth = false,
        ShowWanted = false,
        SkeletonESP = false,
        SkeletonColor = {220, 220, 220},
        TextFont = "Cartoon",
        TextSize = 16,
        MaxRange = 1400
    },
    Movement = {
        NoClip = false,
        WalkspeedBoost = 0,
        Spinbot = false,
        PlayerFly = false,
        DoubleTapFly = false,
        FlyKeybind = "V",
        FlySpeed = 70,
        InfJump = false,
        CameraZoom = 100
    },
    Graphics = {
        XRay = false,
        Fullbright = false,
        RemoveAtmosphere = false,
        GhostMode = false,
        RainbowGhost = false,
        GhostColor = {255, 255, 255},
        PlayerTrail = false,
        TrailColor = {255, 255, 255},
        RandomSkinLoop = false
    },
    Teleports = {
        ClickTeleport = false,
        TeleportSpeed = 120
    },
    Animations = {
        FakeCuffed = false,
        FakeDead = false,
        JerkOff = false,
        SelectedAnimation = "Default Dance",
        AnimationEnabled = false
    },
    Police = {
        RadarFarm = false,
        AutoStopStick = false,
        AutoTaser = false,
        AntiTaser = false
    },
    Bypass = {
        AntiCheatActive = false
    },
    Misc = {
        AutoRejoin = false,
        AntiFall = false,
        AutoPunch = false,
        AutoCollect = false,
        AntiDowned = false,
        SpeedCameraWarning = false,
        CameraRadius = 300
    }
}

local UserConfig = {}
local function LoadConfig()
    if isfile and isfile(CONFIG_FILE) then
        local success, data = pcall(function()
            return HttpService:JSONDecode(readfile(CONFIG_FILE))
        end)
        if success and data then
            UserConfig = data
        else
            UserConfig = DefaultConfig
        end
    else
        UserConfig = DefaultConfig
    end
end

local function SaveConfig()
    if not writefile then return end
    pcall(function()
        writefile(CONFIG_FILE, HttpService:JSONEncode(UserConfig))
    end)
end

LoadConfig()

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local MiscSettings = {
    isFlying = false,
    flyingSpeed = UserConfig.Movement.FlySpeed,
    doubleTapFlyEnabled = UserConfig.Movement.DoubleTapFly,
    bypassActive = UserConfig.Bypass.AntiCheatActive,
    attachment = nil,
    alignPos = nil,
    alignOri = nil,
}

local Window = OrionLib:MakeWindow({
    Name = "Scripts・ https://discord.gg/BkQf3H8RZz",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "Night System Config",
    
    IntroEnabled = true,
    IntroText = "Loading Night System...",
})

local MainTab = Window:MakeTab({Name = "Main", Icon = "rbxassetid://117875071229221"})
local GunModsTab = Window:MakeTab({Name = "Gun Mods", Icon = "rbxassetid://137176652595915"})
local VehicleTab = Window:MakeTab({Name = "Car Mods", Icon = "rbxassetid://114187792807811"})
local FlingTab = Window:MakeTab({Name = "Fling", Icon = "rbxassetid://13050670424"})
local ESPTab = Window:MakeTab({Name = "Visuals", Icon = "rbxassetid://140499484856973"})
local AimbotTab = Window:MakeTab({Name = "Aimbot", Icon = "rbxassetid://10734977012"})
local SilentAimTab = Window:MakeTab({Name = "SilentAim", Icon = "rbxassetid://10709818534"})
local MovementTab = Window:MakeTab({Name = "Movement", Icon = "rbxassetid://108847548157772"})
local AnimTab = Window:MakeTab({Name = "Animations", Icon = "rbxassetid://96515971322700"})
local GraphicsTab = Window:MakeTab({Name = "Graphics", Icon = "rbxassetid://126907380304420"})
local TeleportsTab = Window:MakeTab({Name = "Teleport", Icon = "rbxassetid://104446884075626"})
local PoliceTab = Window:MakeTab({Name = "Police", Icon = "rbxassetid://73598603304502"})
local StatsTab = Window:MakeTab({Name = "Server Stats", Icon = "rbxassetid://112146535967855"})
local SafetyTab = Window:MakeTab({Name = "Misc", Icon = "rbxassetid://10734950309"})
local BypassTab = Window:MakeTab({Name = "Bypass", Icon = "rbxassetid://76562583558887"})

AimbotTab:AddParagraph("Aimbot Tab","Automatically lock onto targets with precision!")
SilentAimTab:AddParagraph("Silent Aim Tab","Hit targets without visible aim movement!")
VehicleTab:AddParagraph("Vehicle Tab","Customize vehicle performance and behavior!")
ESPTab:AddParagraph("Visuals Tab","Highlight players and objects through walls!")
MovementTab:AddParagraph("Movement Tab","Enhance your movement abilities and speed!")
GunModsTab:AddParagraph("Gun Mods Tab","Modify weapon stats and shooting mechanics!")
GraphicsTab:AddParagraph("Graphics Tab","Adjust visual settings and rendering options!")
TeleportsTab:AddParagraph("Teleport Tab","Instantly travel to key locations!")
AnimTab:AddParagraph("Animations Tab","Perform custom emotes and animations!")
PoliceTab:AddParagraph("Police Tab","Tools for police gameplay and evasion!")
StatsTab:AddParagraph("Server Stats Tab","Monitor real time server information!")
BypassTab:AddParagraph("Bypass Tab","Bypass game security and anti cheat measures!")
SafetyTab:AddParagraph("Misc Tab","Additional utilities and safety features!")


OrionLib:MakeNotification({
    Name = "NightHub",
    Content = "thx for use by Night System",
    Image = "rbxassetid://79390235538362",
    Time = 5
})

MainTab:AddSection({
    Name = "Game Information"
})
MainTab:AddParagraph("Game Information","Game Name: Emergency Hamburg\nGame ID: "..game.GameId)

MainTab:AddSection({
    Name = "Night Community"
})
MainTab:AddParagraph("NightHub Discord.","Join our Discord.")

MainTab:AddButton({
    Name = "Join Discord",
    Callback = function()
        local success = pcall(function()
            if request then
                request({
                    Url = "http://127.0.0.1:6463/rpc?v=1",
                    Method = "POST",
                    Headers = {
                        ["Content-Type"] = "application/json",
                        ["Origin"] = "https://discord.com"
                    },
                    Body = game:GetService("HttpService"):JSONEncode({
                        cmd = "INVITE_BROWSER",
                        args = {
                            code = "Night hub"
                        },
                        nonce = tostring(math.random(1, 1000000))
                    })
                })
            end
        end)
        
        if not success then
            setclipboard("https://discord.gg/BkQf3H8RZz")
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Discord Invite";
                Text = "Link copied. Please paste it in your browser.";
                Duration = 5;
            })
        end
    end
})

SafetyTab:AddSection({
    Name = "Player"
})
SafetyTab:AddButton({
    Name = "Respawn [You will Lose your Weapons etc.]",
    Callback = function()
        LocalPlayer.Character.Head:Destroy()
    end
})

SafetyTab:AddButton({
	Name = "Remove Signs",
	Callback = function()
        for _, obj in pairs(game.Workspace:GetDescendants()) do
            if obj.Name:lower():find("sign") or obj.Name:lower():find("schild") then
                obj:Destroy()
            end
        end
  	end    
})

VehicleTab:AddSection({
    Name = "Vehicle Mods"
})

local VehicleFeatures = {
    godMode = false,
    infiniteFuel = false,
    lastVehicle = nil,
    player = game:GetService("Players").LocalPlayer,
    
    getVehicle = function(self)
        if not self.lastVehicle or not self.lastVehicle.Parent then
            local vehiclesFolder = workspace:FindFirstChild("Vehicles")
            self.lastVehicle = vehiclesFolder and vehiclesFolder:FindFirstChild(self.player.Name)
        end
        return self.lastVehicle
    end,
    
    update = function(self)
        if not (self.godMode or self.infiniteFuel) then return end
        
        local vehicle = self:getVehicle()
        if not vehicle then return end
        
        vehicle:SetAttribute("IsOn", true)
        
        if self.godMode then
            vehicle:SetAttribute("currentHealth", 500)
        end
        
        if self.infiniteFuel then
            vehicle:SetAttribute("currentFuel", 99999)
        end
    end,
    
    reset = function(self)
        if self.lastVehicle then
            if not self.godMode then
                self.lastVehicle:SetAttribute("currentHealth", 100)
            end
            if not self.infiniteFuel then
                self.lastVehicle:SetAttribute("currentFuel", 100)
            end
        end
        
        if not self.godMode and not self.infiniteFuel then
            self.lastVehicle = nil
        end
    end
}

local lastUpdate = 0
getgenv().VehicleConnection = game:GetService("RunService").Heartbeat:Connect(function()
    if tick() - lastUpdate >= 0.1 then
        VehicleFeatures:update()
        lastUpdate = tick()
    end
end)

VehicleTab:AddToggle({
    Name = "Vehicle Godmode",
    CurrentValue = UserConfig.CarMods.GodMode,
    Flag = "CarGodModeToggle",
    Callback = function(Value)
        UserConfig.CarMods.GodMode = Value
        VehicleFeatures.godMode = Value
        if not Value then
            VehicleFeatures:reset()
        end
        SaveConfig()
    end
})

VehicleTab:AddToggle({
    Name = "Infinite Fuel",
    CurrentValue = UserConfig.CarMods.InfiniteFuel,
    Flag = "InfiniteFuelToggle",
    Callback = function(Value)
        UserConfig.CarMods.InfiniteFuel = Value
        VehicleFeatures.infiniteFuel = Value
        if not Value then
            VehicleFeatures:reset()
        end
        SaveConfig()
    end
})

VehicleTab:AddToggle({
    Name = "Grip Boost",
    CurrentValue = UserConfig.CarMods.GripBoost,
    Save = true,
    Flag = "GripBoostToggle",
    Callback = function(Value)
        UserConfig.CarMods.GripBoost = Value
        local success, err = pcall(function()
            if not getgenv().GripBoost then
                getgenv().GripBoost = {
                    configured = false,
                    originalValues = {},
                    configTable = nil
                }
            end

            local config = getgenv().GripBoost

            if not config.configured then
                local targetFunction = nil
                
                for _, v in pairs(getgc()) do
                    local success, info = pcall(function() return getinfo(v) end)
                     if success and info and info.name == "handleSteering" then
                        for i = 1, 100 do
                            local upSuccess, upValue = pcall(debug.getupvalue, v, i)
                            if upSuccess and type(upValue) == "table" and upValue.maxSteeringAngle then
                                targetFunction = v
                                config.configTable = upValue
                                break
                            end
                            if not upSuccess then break end
                        end
                    end
                    if targetFunction then break end
                end

                if config.configTable then
                    local value = config.configTable
                    config.originalValues = {
                        maxSteeringAngle = value.maxSteeringAngle,
                        steeringModifierSpeed = value.steeringModifierSpeed,
                        steeringSpeed = value.steeringSpeed,
                        steerBackMultiplier = value.steerBackMultiplier,
                        minSteer = value.minSteer
                    }
                    config.configured = true
                end
            end

            if config.configured and config.configTable then
                if Value then
                    config.configTable.maxSteeringAngle = 25
                    config.configTable.steeringModifierSpeed = 10
                    config.configTable.steeringSpeed = 6
                    config.configTable.steerBackMultiplier = 1.2
                    config.configTable.minSteer = 0.03
                else
                    config.configTable.maxSteeringAngle = config.originalValues.maxSteeringAngle or 8
                    config.configTable.steeringModifierSpeed = config.originalValues.steeringModifierSpeed or 35
                    config.configTable.steeringSpeed = config.originalValues.steeringSpeed or 1.5
                    config.configTable.steerBackMultiplier = config.originalValues.steerBackMultiplier or 3
                    config.configTable.minSteer = config.originalValues.minSteer or 0.15
                end
            end
        end)
        
        if not success then
            warn("Grip Boost Error: " .. tostring(err))
        end
        SaveConfig()
    end
})

local antiDamageEnabled = UserConfig.CarMods.AntiCrashDamage
local currentVehicle = nil

local function findPlayerVehicle()
    local player = game.Players.LocalPlayer
    local character = player.Character
    
    if not character then return nil end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid and humanoid.SeatPart then
        return humanoid.SeatPart.Parent
    end
    
    return nil
end

if not game:IsLoaded() then
    game.Loaded:Wait()
end

VehicleTab:AddToggle({
    Name = "Anti Crash Damage",
    Default = UserConfig.CarMods.AntiCrashDamage,
    Callback = function(Value)
        UserConfig.CarMods.AntiCrashDamage = Value
        antiDamageEnabled = Value
        
        if Value then
            task.spawn(function()
                while antiDamageEnabled do
                    local vehicle = findPlayerVehicle()
                    
                    if vehicle ~= currentVehicle then
                        if currentVehicle then
                            pcall(function()
                                currentVehicle:SetAttribute("IsBeingTowed", false)
                            end)
                        end
                        currentVehicle = vehicle
                    end
                    
                    if currentVehicle then
                        pcall(function()
                            currentVehicle:SetAttribute("IsBeingTowed", true)
                        end)
                    end
                    
                    task.wait(0.5)
                end
            end)
        else
            antiDamageEnabled = false
            
            if currentVehicle then
                pcall(function()
                    currentVehicle:SetAttribute("IsBeingTowed", false)
                end)
                currentVehicle = nil
            end
        end
        SaveConfig()
    end    
})

local mouse = Players.LocalPlayer:GetMouse()
local aktiv = UserConfig.CarMods.EnterLockedCars

VehicleTab:AddToggle({
    Name = "Enter Locked Cars [Left Mouse click]",
    Default = UserConfig.CarMods.EnterLockedCars,
    Callback = function(val)
        UserConfig.CarMods.EnterLockedCars = val
        aktiv = val
        SaveConfig()
    end
})

mouse.Button1Down:Connect(function()
    if not aktiv then return end
    local target = mouse.Target
    if not target then return end
    local character = Players.LocalPlayer.Character  
    if not character then return end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not humanoid or not hrp then return end
    local model = target:FindFirstAncestorOfClass("Model") or target.Parent
    if not model then return end
    local foundSeat = nil
    for _, obj in ipairs(model:GetDescendants()) do
        if obj:IsA("Seat") or obj:IsA("VehicleSeat") then
            local name = obj.Name:lower()
            if name:find("beifahrer") or name:find("passenger") or name:find("copilot") then
                foundSeat = obj
                break
            end
        end
    end
    if not foundSeat then
        for _, obj in ipairs(model:GetDescendants()) do
            if obj:IsA("Seat") or obj:IsA("VehicleSeat") then
                foundSeat = obj
                break
            end
        end
    end
    if foundSeat then
        foundSeat.Locked = false
        hrp.CFrame = foundSeat.CFrame + Vector3.new(0, 3, 0)
        task.wait(0.1)
        foundSeat:Sit(humanoid)
    end
end)


local savedPlates = {}

VehicleTab:AddToggle({
    Name = "Invisible Numberplate",
    Default = false,
    Save = true,
    Flag = "InvisibleNumberplate",
    Callback = function(state)
        local character = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
        local root = character:WaitForChild("HumanoidRootPart", 5)
        
        if not root then 
            warn("HumanoidRootPart not found.")
            return 
        end
        
        local vehiclesFolder = workspace:FindFirstChild("Vehicles")
        if vehiclesFolder then
            for _, part in ipairs(vehiclesFolder:GetDescendants()) do
                if part:IsA("SurfaceGui") and part.Parent and part.Parent:IsA("BasePart") then
                    local dist = (part.Parent.Position - root.Position).Magnitude
                    if dist < 200 then
                        local label = part:FindFirstChildWhichIsA("TextLabel")
                        if label then
                            if state then
                                if not savedPlates[label] then
                                    savedPlates[label] = label.Text
                                end
                                label.Text = ""
                            else
                                if savedPlates[label] then
                                    label.Text = savedPlates[label]
                                    savedPlates[label] = nil
                                end
                            end
                        end
                    end
                end
            end
        end
    end
})

VehicleTab:AddTextbox({
    Name = "Numberplate Text",
    Default = UserConfig.CarMods.NumberplateText,
    PressEnter = false,
    Save = true,
    Flag = "NumberplateText",
    Callback = function(txt)
        UserConfig.CarMods.NumberplateText = txt
        local character = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
        local root = character:WaitForChild("HumanoidRootPart", 5)
        
        if not root then 
            warn("HumanoidRootPart not found.")
            return 
        end
        
        local vehiclesFolder = workspace:FindFirstChild("Vehicles")
        if vehiclesFolder then
            for _, part in ipairs(vehiclesFolder:GetDescendants()) do
                if part:IsA("SurfaceGui") and part.Parent and part.Parent:IsA("BasePart") then
                    local dist = (part.Parent.Position - root.Position).Magnitude
                    if dist < 200 then
                        local label = part:FindFirstChildWhichIsA("TextLabel")
                        if label then 
                            label.Text = txt 
                        end
                    end
                end
            end
        end
        SaveConfig()
    end
})

getgenv().CarFly = getgenv().CarFly or {}
local CF = getgenv().CarFly

local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local vehicles = workspace:WaitForChild("Vehicles")

CF.enabled = UserConfig.CarMods.CarFly
CF.speed = UserConfig.CarMods.CarFlySpeed * 7.77
CF.lastPos = nil
CF.lastLook = nil
CF.flingEnabled = UserConfig.CarMods.VehicleFling
CF.flingActive = false
CF.flingStart = 0
CF.mobileEnabled = UserConfig.CarMods.MobileCarfly
CF.mobileGui = nil
CF.moveU, CF.moveD, CF.moveL, CF.moveR = false, false, false, false

local singleExitDone = false
local safeFlyConn, autoEnterConn
local lastEnterTime = 0

local function enterVehicle()
	if not CF.enabled then return false end
	local vehicle = vehicles:FindFirstChild(LocalPlayer.Name)
	if vehicle and char:FindFirstChild("Humanoid") then
		local seat = vehicle:FindFirstChild("DriveSeat")
		if seat then
			seat:Sit(char.Humanoid)
			return true
		end
	end
	return false
end

local function performSingleExit()
	if singleExitDone or not CF.enabled or CF.flingEnabled then return end
	local hum = char and char:FindFirstChild("Humanoid")
	if hum and hum.SeatPart and hum.SeatPart.Name == "DriveSeat" then
		hum.Sit = false
		hum:ChangeState(Enum.HumanoidStateType.Jumping)
		task.delay(0.2, function()
			if CF.enabled and not CF.flingEnabled then
				enterVehicle()
				singleExitDone = true
			end
		end)
	end
end

local function startSafeFly()
	if safeFlyConn then return end
	singleExitDone = false
	local singleExitTimer = false
	safeFlyConn = RunService.Heartbeat:Connect(function()
		if CF.enabled and not CF.flingEnabled then
			local hum = char and char:FindFirstChild("Humanoid")
			local currentTime = tick()
			if hum then
				if not singleExitTimer then
					singleExitTimer = true
					task.delay(3, performSingleExit)
				end
				if not hum.SeatPart or hum.SeatPart.Name ~= "DriveSeat" then
					if (currentTime - lastEnterTime) > 0.5 then
						lastEnterTime = currentTime
						local success = enterVehicle()
						if not success then
							task.wait(0.1)
							enterVehicle()
						end
					end
				end
			end
		end
	end)
end

local function stopSafeFly()
	if safeFlyConn then
		safeFlyConn:Disconnect()
		safeFlyConn = nil
	end
	singleExitDone = false
end

local function turnCarOff()
	local vehiclesFolder = workspace:FindFirstChild("Vehicles")
	if vehiclesFolder then
		local pVehicle = vehiclesFolder:FindFirstChild(LocalPlayer.Name)
		if pVehicle and pVehicle:IsA("Model") then
			pVehicle:SetAttribute("IsOn", false)
			local hum = pVehicle:FindFirstChildOfClass("Humanoid")
			if hum then
				hum.MaxHealth = 500
				hum.Health = 500
			end
		end
	end
end

local function createMobileControls()
	if CF.mobileGui then CF.mobileGui:Destroy() end
	local sg = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
	CF.mobileGui = sg
	sg.Name = "MobileCarFlyControls"
	sg.ResetOnSpawn = false
	sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	local f = Instance.new("Frame", sg)
	f.Size = UDim2.new(0, 150, 0, 180)
	f.Position = UDim2.new(0.5, -75, 0.5, -90)
	f.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	f.BackgroundTransparency = 0.3
	f.Active = true
	f.Draggable = true
	f.AnchorPoint = Vector2.new(0.5, 0.5)
	local c1 = Instance.new("UICorner", f)
	c1.CornerRadius = UDim.new(0, 8)
	local tog = Instance.new("TextButton", f)
	tog.Size = UDim2.new(1, -20, 0, 35)
	tog.Position = UDim2.new(0, 10, 0, 10)
	tog.BackgroundColor3 = CF.mobileEnabled and Color3.fromRGB(0,180,0) or Color3.fromRGB(180,0,0)
	tog.Text = CF.mobileEnabled and "Mobile Controls ON" or "Mobile Controls OFF"
	tog.TextColor3 = Color3.new(1,1,1)
	tog.Font = Enum.Font.SourceSansBold
	tog.TextSize = 16
	tog.AutoButtonColor = false
	local c2 = Instance.new("UICorner", tog)
	c2.CornerRadius = UDim.new(0, 6)
	tog.MouseButton1Click:Connect(function()
		CF.mobileEnabled = not CF.mobileEnabled
		UserConfig.CarMods.MobileCarfly = CF.mobileEnabled
		tog.Text = CF.mobileEnabled and "Mobile Controls ON" or "Mobile Controls OFF"
		tog.BackgroundColor3 = CF.mobileEnabled and Color3.fromRGB(0,180,0) or Color3.fromRGB(180,0,0)
		if CF.mobileEnabled then
			if not CF.enabled then
				CF.enabled = true
				UserConfig.CarMods.CarFly = true
				startSafeFly()
				startAutoEnter()
			end
		else
			CF.enabled = false
			UserConfig.CarMods.CarFly = false
			stopSafeFly()
			stopAutoEnter()
		end
		SaveConfig()
	end)
	local function createArrow(txt, pos)
		local btn = Instance.new("TextButton", f)
		btn.Size = UDim2.new(0, 40, 0, 40)
		btn.Position = pos
		btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
		btn.TextColor3 = Color3.new(1,1,1)
		btn.Font = Enum.Font.SourceSansBold
		btn.TextSize = 28
		btn.Text = txt
		btn.AutoButtonColor = false
		local c = Instance.new("UICorner", btn)
		c.CornerRadius = UDim.new(0, 6)
		return btn
	end
	local bU = createArrow("↑", UDim2.new(0.5, -20, 0, 55))
	local bD = createArrow("↓", UDim2.new(0.5, -20, 0, 110))
	local bL = createArrow("←", UDim2.new(0.22, -20, 0, 82))
	local bR = createArrow("→", UDim2.new(0.78, -20, 0, 82))
	bU.MouseButton1Down:Connect(function() CF.moveU = true end)
	bU.MouseButton1Up:Connect(function() CF.moveU = false end)
	bU.MouseLeave:Connect(function() CF.moveU = false end)
	bD.MouseButton1Down:Connect(function() CF.moveD = true end)
	bD.MouseButton1Up:Connect(function() CF.moveD = false end)
	bD.MouseLeave:Connect(function() CF.moveD = false end)
	bL.MouseButton1Down:Connect(function() CF.moveL = true end)
	bL.MouseButton1Up:Connect(function() CF.moveL = false end)
	bL.MouseLeave:Connect(function() CF.moveL = false end)
	bR.MouseButton1Down:Connect(function() CF.moveR = true end)
	bR.MouseButton1Up:Connect(function() CF.moveR = false end)
	bR.MouseLeave:Connect(function() CF.moveR = false end)
end

local function destroyMobileControls()
	if CF.mobileGui then
		CF.mobileGui:Destroy()
		CF.mobileGui = nil
	end
	CF.moveU, CF.moveD, CF.moveL, CF.moveR = false, false, false, false
	CF.mobileEnabled = false
end

RunService.Heartbeat:Connect(function()
	if CF.flingEnabled then
		local c = LocalPlayer.Character
		if c then
			local h = c:FindFirstChildOfClass("Humanoid")
			if h and h.SeatPart and h:GetState() == Enum.HumanoidStateType.Seated then
				CF.flingActive = true
				local currentTime = tick()
				if (currentTime - CF.flingStart) >= 0.6 then
					local fhrp = c:FindFirstChild("HumanoidRootPart")
					if fhrp then
						for _, part in pairs(fhrp:GetTouchingParts()) do
							if part:IsA("BasePart") and part:IsDescendantOf(workspace) and not part:IsDescendantOf(LocalPlayer) then
								fhrp.AssemblyLinearVelocity = -(part.Position - fhrp.Position).Unit * 9999999
								turnCarOff()
								break
							end
						end
					end
				end
			else
				CF.flingActive = false
			end
		else
			CF.flingActive = false
		end
	else
		CF.flingActive = false
	end
end)

local function startAutoEnter()
	if autoEnterConn then return end
	autoEnterConn = RunService.Heartbeat:Connect(function()
		if CF.enabled then
			local c = LocalPlayer.Character
			if not c then return end
			local h = c:FindFirstChildOfClass("Humanoid")
			if not h then return end
			if not h.SeatPart or h.SeatPart.Name ~= "DriveSeat" then
				CF.flingActive = false
				local vehicle = workspace:FindFirstChild("Vehicles") and workspace.Vehicles:FindFirstChild(LocalPlayer.Name)
				if not vehicle then
					for _, m in ipairs(workspace:GetDescendants()) do
						if m:IsA("Model") and m.Name:lower():find(LocalPlayer.Name:lower()) then
							vehicle = m
							break
						end
					end
				end
				if vehicle then
					local seat = vehicle:FindFirstChild("DriveSeat") or vehicle:FindFirstChildWhichIsA("VehicleSeat")
					if seat then
						local ahrp = c:FindFirstChild("HumanoidRootPart")
						if ahrp then ahrp.CFrame = seat.CFrame + Vector3.new(0, 3, 0) end
						h.Sit = false
						task.wait(0.0)
						seat:Sit(h)
						task.wait(0.0)
						if not h.SeatPart then seat:Sit(h) end
					end
				end
			else
				CF.flingActive = true
			end
		end
	end)
end

local function stopAutoEnter()
	if autoEnterConn then
		autoEnterConn:Disconnect()
		autoEnterConn = nil
	end
end

local straightStart, hasShifted = nil, false

RunService.RenderStepped:Connect(function(dt)
	local character = LocalPlayer.Character
	if CF.flingEnabled then CF.enabled = true end
	if CF.enabled and character then
		local hum = character:FindFirstChildOfClass("Humanoid")
		if hum and hum.SeatPart and hum.SeatPart.Name == "DriveSeat" then
			local seat = hum.SeatPart
			local vehicle = seat.Parent
			if not vehicle.PrimaryPart then vehicle.PrimaryPart = seat end
			local lookVec = workspace.CurrentCamera.CFrame.LookVector
			if not CF.lastPos then CF.lastPos = vehicle.PrimaryPart.Position end
			if not CF.lastLook then CF.lastLook = lookVec end
			local mY, mZ, mX = 0, 0, 0
			if CF.mobileEnabled then
				if CF.moveU then mZ = 1 end
				if CF.moveD then mZ = -1 end
				if CF.moveL then mX = -1 end
				if CF.moveR then mX = 1 end
			else
				if UserInputService:IsKeyDown(Enum.KeyCode.W) then mZ = 1
				elseif UserInputService:IsKeyDown(Enum.KeyCode.S) then mZ = -1 end
				if UserInputService:IsKeyDown(Enum.KeyCode.E) then mY = 1
				elseif UserInputService:IsKeyDown(Enum.KeyCode.Q) then mY = -1 end
				if UserInputService:IsKeyDown(Enum.KeyCode.A) then mX = -1
				elseif UserInputService:IsKeyDown(Enum.KeyCode.D) then mX = 1 end
			end
			local isStraight = false
			if not CF.mobileEnabled then
				isStraight = UserInputService:IsKeyDown(Enum.KeyCode.W) and not UserInputService:IsKeyDown(Enum.KeyCode.S) and not UserInputService:IsKeyDown(Enum.KeyCode.E) and not UserInputService:IsKeyDown(Enum.KeyCode.Q) and not UserInputService:IsKeyDown(Enum.KeyCode.A) and not UserInputService:IsKeyDown(Enum.KeyCode.D)
			else
				isStraight = CF.moveU and not CF.moveD and not CF.moveL and not CF.moveR
			end
			local currentTime = tick()
			if isStraight then
				if not straightStart then straightStart = currentTime end
				if not hasShifted and (currentTime - straightStart) >= 1 then
					local rightVec = lookVec:Cross(Vector3.new(0, 1, 0)).Unit
					local shiftPos = vehicle.PrimaryPart.Position + (rightVec * 10)
					local shiftCF = CFrame.new(shiftPos, shiftPos + lookVec)
					vehicle:SetPrimaryPartCFrame(shiftCF)
					CF.lastPos = shiftPos
					hasShifted = true
				end
			else
				straightStart = nil
				hasShifted = false
			end
			local speedMult = CF.speed / 100
			local rightVec = lookVec:Cross(Vector3.new(0, 1, 0)).Unit
			local targetPos = vehicle.PrimaryPart.Position + (lookVec * mZ * speedMult) + (Vector3.new(0, 1, 0) * mY * speedMult) + (rightVec * mX * speedMult)
			local newPos = CF.lastPos:Lerp(targetPos, 0.3)
			local smoothLook = CF.lastLook:Lerp(lookVec, 0.2)
			if mZ ~= 0 or mY ~= 0 or mX ~= 0 then
				vehicle:SetPrimaryPartCFrame(CFrame.new(newPos, newPos + smoothLook))
			else
				vehicle:SetPrimaryPartCFrame(CFrame.new(vehicle.PrimaryPart.Position, vehicle.PrimaryPart.Position + smoothLook))
			end
			CF.lastPos = newPos
			CF.lastLook = smoothLook
			for _, part in pairs(vehicle:GetDescendants()) do
				if part:IsA("BasePart") then
					part.AssemblyLinearVelocity = Vector3.zero
					part.AssemblyAngularVelocity = Vector3.zero
					part.Velocity = Vector3.zero
					part.RotVelocity = Vector3.zero
				end
			end
		else
			CF.lastPos = nil
			CF.lastLook = nil
			straightStart = nil
			hasShifted = false
		end
	else
		CF.lastPos = nil
		CF.lastLook = nil
		straightStart = nil
		hasShifted = false
	end
end)

VehicleTab:AddSection({Name = "CarFly Options"})
VehicleTab:AddToggle({
	Name = "Car Fly",
	Default = UserConfig.CarMods.CarFly,
	Callback = function(Value)
		UserConfig.CarMods.CarFly = Value
		if CF.flingEnabled then CF.enabled = true else CF.enabled = Value end
		if CF.enabled then startSafeFly(); startAutoEnter()
		else stopSafeFly(); stopAutoEnter() end
		SaveConfig()
	end
})

VehicleTab:AddToggle({
	Name = "Mobile Carfly",
	Default = UserConfig.CarMods.MobileCarfly,
	Callback = function(Value)
		UserConfig.CarMods.MobileCarfly = Value
		if Value then
			createMobileControls()
			if not CF.enabled then
				CF.enabled = true
				UserConfig.CarMods.CarFly = true
				startSafeFly()
				startAutoEnter()
			end
		else
			destroyMobileControls()
		end
		SaveConfig()
	end
})

VehicleTab:AddToggle({
	Name = "Vehicle Fling",
	Default = UserConfig.CarMods.VehicleFling,
	Callback = function(value)
		UserConfig.CarMods.VehicleFling = value
		CF.flingEnabled = value
		if value then
			CF.enabled = true
			UserConfig.CarMods.CarFly = true
			CF.flingStart = tick()
			startSafeFly()
			startAutoEnter()
		else
			stopAutoEnter()
		end
		SaveConfig()
	end
})

VehicleTab:AddBind({
	Name = "Car Fly Keybind",
	Default = Enum.KeyCode[UserConfig.CarMods.CarFlyKeybind],
	Save = true,
	Flag = "CarFlyKeybind",
	Hold = false,
	Callback = function()
		if not CF.flingEnabled then
			CF.enabled = not CF.enabled
			UserConfig.CarMods.CarFly = CF.enabled
			if CF.enabled then startSafeFly(); startAutoEnter()
			else stopSafeFly(); stopAutoEnter() end
			SaveConfig()
		end
	end
})

VehicleTab:AddSlider({
	Name = "Car Fly Speed",
	Min = 50, Max = 300,
	Default = UserConfig.CarMods.CarFlySpeed,
	Save = true, Flag = "CarFlySpeed",
	Color = Color3.fromRGB(137, 207, 240),
	Increment = 1, ValueName = "Speed",
	Callback = function(kmhValue)
		UserConfig.CarMods.CarFlySpeed = kmhValue
		CF.speed = kmhValue * 7.77
		SaveConfig()
	end
})

LocalPlayer.CharacterAdded:Connect(function(character)
	char = character
	hrp = character:WaitForChild("HumanoidRootPart")
	CF.enabled = UserConfig.CarMods.CarFly
	CF.flingActive = false
	CF.lastPos = nil
	CF.lastLook = nil
	singleExitDone = false
	destroyMobileControls()
	task.wait(1)
	if CF.enabled then
		startSafeFly()
		startAutoEnter()
	end
end)

VehicleTab:AddSection({Name = "Extras"})
VehicleTab:AddButton({
    Name = "Jump Out Of Vehicle",
    Callback = function()
        local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
        if humanoid and humanoid.SeatPart then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        elseif humanoid and not humanoid.SeatPart then
            OrionLib:MakeNotification({
                Name = "Error",
                Content = "You are not in a vehicle!",
                Image = "rbxassetid://79390235538362",
                Time = 2
            })
        end
    end
})

VehicleTab:AddButton({
    Name = "Enter Own Car",
    Callback = function()
        local car = Workspace.Vehicles:FindFirstChild(LocalPlayer.Name)
        if car and car:FindFirstChild("DriverSeat") and LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
            if humanoid then
                if humanoid.Sit then
                    humanoid.Sit = false
                    task.wait(0.1)
                end
                car.DriveSeat:Sit(humanoid)
            end
        end
    end
})

VehicleTab:AddButton({
    Name = "Bring Own Car",
    Callback = function()
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local hrp = character:WaitForChild("HumanoidRootPart")
        local humanoid = character:FindFirstChildWhichIsA("Humanoid")

        local car
        local vehiclesFolder = workspace:FindFirstChild("Vehicles")
        if vehiclesFolder then
            car = vehiclesFolder:FindFirstChild(player.Name)
        end
        if not car then
            for _, descendant in ipairs(workspace:GetDescendants()) do
                if descendant:IsA("Model") and descendant.Name:lower():find(player.Name:lower()) then
                    car = descendant
                    break
                end
            end
        end

        if car and car:IsA("Model") then
            local seat = car:FindFirstChild("DriveSeat") or car:FindFirstChildWhichIsA("VehicleSeat")
            if seat then
                if not car.PrimaryPart then
                    car.PrimaryPart = seat
                end
                car:SetPrimaryPartCFrame(hrp.CFrame * CFrame.new(0, 3, -8))
                task.wait(0.2)
                if humanoid and not humanoid.SeatPart then
                    seat:Sit(humanoid)
                end
            end
        end
    end
})

local function getWheelColor()
    local vehiclesFolder = workspace:FindFirstChild("Vehicles")
    if not vehiclesFolder then return Color3.fromRGB(255, 255, 255) end
    local car = vehiclesFolder:FindFirstChild(LocalPlayer.Name)
    if not car then return Color3.fromRGB(255, 255, 255) end

    for _, part in pairs(car:GetDescendants()) do
        if part.Name == "FL" or part.Name == "FR" or part.Name == "RL" or part.Name == "RR" then
            local rim = part:FindFirstChild("Rim")
            if rim then
                local main = rim:FindFirstChild("Main")
                if main and main:IsA("BasePart") then
                    return main.Color
                end
            end
        end
    end
    return Color3.fromRGB(255, 255, 255)
end

local function getBodyColor()
    local vehiclesFolder = workspace:FindFirstChild("Vehicles")
    if not vehiclesFolder then return Color3.fromRGB(255, 255, 255) end
    local car = vehiclesFolder:FindFirstChild(LocalPlayer.Name)
    if not car then return Color3.fromRGB(255, 255, 255) end

    for _, part in pairs(car:GetDescendants()) do
        if part.Name == "Body" and part:IsA("BasePart") then
            return part.Color
        end
    end
    return Color3.fromRGB(255, 255, 255)
end

local soundOptions = {
	"Default",
	"Turbo Engine", 
	"Power Engine",
	"Street Racer"
}

local soundIds = {
	["Turbo Engine"] = "rbxassetid://92387486484055",
	["Power Engine"] = "rbxassetid://91912342333180", 
	["Street Racer"] = "rbxassetid://75247492673971"
}

local originalSounds = {}
local soundObjects = {}

local function initializeSounds1()
	for _, sound in pairs(game:GetDescendants()) do
		if sound:IsA("Sound") then
			local currentId = sound.SoundId
			if currentId == "rbxassetid://358130654" or currentId == "rbxassetid://358130655" then
				originalSounds[sound] = currentId
				soundObjects[sound] = true
			end
		end
	end
end

local function changeSounds1(selectedSound)
	local newSoundId = soundIds[selectedSound]

	for sound, originalId in pairs(originalSounds) do
		if sound and sound.Parent then
			if selectedSound == "Default" then
				sound.SoundId = originalId
			else
				sound.SoundId = newSoundId
			end
		end
	end
end

initializeSounds1()

VehicleTab:AddSection({Name = "Misc Options"})
VehicleTab:AddDropdown({
	Name = "Vehicle Sound",
	Default = UserConfig.CarMods.VehicleSound,
	Save = true,
	Flag = "VehicleSound",
	Options = soundOptions,
	Callback = function(selectedSound)
		UserConfig.CarMods.VehicleSound = selectedSound
		changeSounds1(selectedSound)
		SaveConfig()
	end    
})

local VehiclesFolder = workspace:WaitForChild("Vehicles") 

local function getCurrentSpringLength()
	local vehicle = VehiclesFolder:FindFirstChild(LocalPlayer.Name)
	if not vehicle then return nil end 

	local driveSeat = vehicle:FindFirstChild("DriveSeat", true)
	if not driveSeat then return nil end

	local spring = driveSeat:FindFirstChildWhichIsA("SpringConstraint")
	if not spring then return nil end

	return spring.CurrentLength
end

local sliderMoved = false

VehicleTab:AddSlider({ 
	Name = "Suspension Height",
	Min = 0.5,
	Max = 13,
	Default = UserConfig.CarMods.SuspensionHeight, 
	Color = Color3.fromRGB(137, 207, 240),
	Increment = 0.1,
	ValueName = "",
	Callback = function(Value)
		UserConfig.CarMods.SuspensionHeight = Value
		if not sliderMoved then
			sliderMoved = true
			return
		end

		pcall(function()
			local vehicle = VehiclesFolder:FindFirstChild(LocalPlayer.Name)
			if not vehicle then return end

			local driveSeat = vehicle:FindFirstChild("DriveSeat", true)
			if not driveSeat then return end

			for _, v in pairs(driveSeat:GetChildren()) do
				if v:IsA("SpringConstraint") then
					v.LimitsEnabled = true
					v.MinLength = Value
					v.MaxLength = Value
				elseif v:IsA("RopeConstraint") then
					v.Length = Value
				end
			end
		end)
		SaveConfig()
	end    
})

VehicleTab:AddButton({
	Name = "Steal Nearest E-Bike",
	Callback = function()

		local player = game.Players.LocalPlayer
		local character = player.Character or player.CharacterAdded:Wait()
		local humanoidRootPart

		local function isUUID(name)
			local pattern = "^%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x$"
			return string.match(name, pattern) ~= nil
		end

		local function onCharacterAdded(newCharacter)
			character = newCharacter
			humanoidRootPart = character:WaitForChild("HumanoidRootPart")
		end

		player.CharacterAdded:Connect(onCharacterAdded)
		if player.Character then
			onCharacterAdded(player.Character)
		end

		local vehiclesFolder = workspace:WaitForChild("Vehicles")

		local function findNearestDriveSeat()
			local closestDistance = math.huge
			local closestSeat = nil

			for _, vehicle in ipairs(vehiclesFolder:GetChildren()) do
				if isUUID(vehicle.Name) then
					local driveSeat = vehicle:FindFirstChild("DriveSeat", true)
					if driveSeat and driveSeat:IsA("Seat") then
						local distance = (driveSeat.Position - humanoidRootPart.Position).Magnitude
						if distance < closestDistance then
							closestDistance = distance
							closestSeat = driveSeat
						end
					end
				end
			end

			return closestSeat
		end

		local seat = findNearestDriveSeat()
		if seat then
			seat:Sit(character:WaitForChild("Humanoid"))
		end
	end
})

VehicleTab:AddSection({Name = "Vehicle Jump"})

local jumpPower = UserConfig.CarMods.JumpHeight
local forwardPower = UserConfig.CarMods.ForwardPower

local function GetCurrentVehicle()
    local char = game.Players.LocalPlayer.Character
    if not char then return nil end
    
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum and hum.SeatPart then return hum.SeatPart end
    
    local vehFolder = workspace:FindFirstChild("Vehicles")
    if vehFolder then
        for _, v in pairs(vehFolder:GetChildren()) do
            if v:IsA("Model") and (v.Name:find(game.Players.LocalPlayer.Name) or v:FindFirstChild("Owner")) then
                return v:FindFirstChildOfClass("VehicleSeat") or v.PrimaryPart
            end
        end
    end
    
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("VehicleSeat") then
            if (v.Position - char.PrimaryPart.Position).Magnitude < 10 then
                return v
            end
        end
    end
    
    return nil
end

local function DoVehicleJump()
    local DriveSeat = GetCurrentVehicle()
    
    if DriveSeat then
        local target = DriveSeat:IsA("VehicleSeat") and DriveSeat or DriveSeat.Parent.PrimaryPart
        target.AssemblyLinearVelocity = target.AssemblyLinearVelocity + Vector3.new(0, jumpPower, 0) + (target.CFrame.LookVector * forwardPower)
    else
        OrionLib:MakeNotification({
            Name = "Error!",
            Content = "Car not found!",
            Image = "rbxassetid://79390235538362",
            Time = 3
        })
    end
end

VehicleTab:AddSlider({
    Name = "Jump Height",
    Min = 10,
    Max = 250,
    Default = UserConfig.CarMods.JumpHeight,
    Increment = 5,
    ValueName = "Power",
    Color = Color3.fromRGB(137, 207, 240),
    Callback = function(Value)
        UserConfig.CarMods.JumpHeight = Value
        jumpPower = Value
        SaveConfig()
    end    
})

VehicleTab:AddSlider({
    Name = "Forward Power",
    Min = 0,
    Max = 250,
    Default = UserConfig.CarMods.ForwardPower,
    Increment = 5,
    ValueName = "Boost",
    Color = Color3.fromRGB(137, 207, 240),
    Callback = function(Value)
        UserConfig.CarMods.ForwardPower = Value
        forwardPower = Value
        SaveConfig()
    end    
})

VehicleTab:AddButton({
    Name = "Car Jump",
    Callback = function() DoVehicleJump() end
})

VehicleTab:AddBind({
    Name = "Jump Keybind",
    Default = Enum.KeyCode[UserConfig.CarMods.JumpKeybind],
    Hold = false,
    Callback = function() DoVehicleJump() end    
})

VehicleTab:AddSection({
    Name = "Colors"
})
VehicleTab:AddColorpicker({
    Name = "Wheel Color",
    Default = Color3.fromRGB(UserConfig.CarMods.WheelColor[1], UserConfig.CarMods.WheelColor[2], UserConfig.CarMods.WheelColor[3]),
    Callback = function(color)
        UserConfig.CarMods.WheelColor = {color.R * 255, color.G * 255, color.B * 255}
        local vehiclesFolder = workspace:FindFirstChild("Vehicles")
        if not vehiclesFolder then return end
        local car = vehiclesFolder:FindFirstChild(LocalPlayer.Name)
        if not car then return end

        for _, part in pairs(car:GetDescendants()) do
            if part.Name == "FL" or part.Name == "FR" or part.Name == "RL" or part.Name == "RR" then
                local rim = part:FindFirstChild("Rim")
                if rim then
                    local main = rim:FindFirstChild("Main")
                    if main and main:IsA("BasePart") then
                        main.Color = color
                    end
                end
            end
        end
        SaveConfig()
    end
})

VehicleTab:AddColorpicker({
    Name = "Body Color",
    Default = Color3.fromRGB(UserConfig.CarMods.BodyColor[1], UserConfig.CarMods.BodyColor[2], UserConfig.CarMods.BodyColor[3]),
    Callback = function(color)
        UserConfig.CarMods.BodyColor = {color.R * 255, color.G * 255, color.B * 255}
        local vehiclesFolder = workspace:FindFirstChild("Vehicles")
        if not vehiclesFolder then return end
        local car = vehiclesFolder:FindFirstChild(LocalPlayer.Name)
        if not car then return end

        for _, part in pairs(car:GetDescendants()) do
            if part.Name == "Body" and part:IsA("BasePart") then
                part.Color = color
            end
        end
        SaveConfig()
    end
})

VehicleTab:AddSection({
    Name = "Duplicate"
})
VehicleTab:AddButton({
    Name = "Duplicate Current Car",
    Callback = function()
        local originalCar = workspace.Vehicles:FindFirstChild(LocalPlayer.Name)
        if not originalCar then
            OrionLib:MakeNotification({
                Name = "Error",
                Content = "No car found!",
                Image = "rbxassetid://79390235538362",
                Time = 3
            })
            return
        end

        local clone = originalCar:Clone()
        clone.Name = LocalPlayer.Name .. "Clone" .. math.random(1000, 9999)

        local offset = 10
        local newPosition = originalCar:GetPivot().Position + Vector3.new(offset, 0, 0)
        clone:PivotTo(CFrame.new(newPosition))

        clone.Parent = workspace.Vehicles

        OrionLib:MakeNotification({
            Name = "Success",
            Content = "Car duplicated!",
            Image = "rbxassetid://79390235538362",
            Time = 3
        })
    end
})

VehicleTab:AddButton({
    Name = "Duplicate Nearby Car",
    Callback = function()
        local playerCar = workspace.Vehicles:FindFirstChild(LocalPlayer.Name)
        if not playerCar then return end

        local playerPos = playerCar:GetPivot().Position
        local closestCar = nil
        local closestDistance = math.huge

        for _, vehicle in pairs(workspace.Vehicles:GetChildren()) do
            if vehicle:IsA("Model") and vehicle ~= playerCar then
                local distance = (vehicle:GetPivot().Position - playerPos).Magnitude
                if distance < closestDistance and distance < 50 then
                    closestDistance = distance
                    closestCar = vehicle
                end
            end
        end

        if closestCar then
            local clone = closestCar:Clone()
            clone.Name = "Stolen" .. closestCar.Name
            clone:PivotTo(playerCar:GetPivot() * CFrame.new(15, 0, 0))
            clone.Parent = workspace.Vehicles

            OrionLib:MakeNotification({
                Name = "Success",
                Content = "Nearby car duplicated!",
                Image = "rbxassetid://79390235538362",
                Time = 3
            })
        else
            OrionLib:MakeNotification({
                Name = "Error",
                Content = "No nearby car found!",
                Image = "rbxassetid://79390235538362",
                Time = 3
            })
        end
    end
})

local Player = game:GetService("Players").LocalPlayer

local instantBoostMultiplier = UserConfig.CarMods.InstantBoostStrength
local accelerationMultiplier = UserConfig.CarMods.AccelerationMultiplier
local accelerationEnabled = false
local speedLimitRemoved = false

local accelerationConnection = nil
local speedLimitConnection = nil

local function getCurrentVehicle()
    if not char then return nil end
    
    local humanoid = char:FindFirstChild("Humanoid")
    if not humanoid or not humanoid.SeatPart then return nil end
    
    local seat = humanoid.SeatPart
    if seat:IsA("VehicleSeat") or seat.Name == "DriveSeat" then
        return seat.Parent
    end
    return nil
end

local function applySmartAcceleration()
    if accelerationConnection then accelerationConnection:Disconnect() end
    
    accelerationConnection = RunService.Heartbeat:Connect(function()
        if not accelerationEnabled then return end
        
        local vehicle = getCurrentVehicle()
        if not vehicle or not vehicle.PrimaryPart then return end
        
        local root = vehicle.PrimaryPart
        local velocity = root.AssemblyLinearVelocity
        local lookVector = root.CFrame.LookVector
        
        local isW = UserInputService:IsKeyDown(Enum.KeyCode.W) or UserInputService:IsKeyDown(Enum.KeyCode.Up)
        local isS = UserInputService:IsKeyDown(Enum.KeyCode.S) or UserInputService:IsKeyDown(Enum.KeyCode.Down)
        
        if velocity.Magnitude < 0.1 then return end
        local moveDir = velocity.Unit:Dot(lookVector)
        
        if velocity.Magnitude > 1 then
            if isW and moveDir > -0.2 then
                root.AssemblyLinearVelocity = velocity * (1 + (accelerationMultiplier - 1) * 0.015)
            elseif isS and moveDir < 0.2 then
                root.AssemblyLinearVelocity = velocity * (1 + (accelerationMultiplier - 1) * 0.015)
            end
        end
        
        if (isS and moveDir > 0.3) or (isW and moveDir < -0.3) then
            root.AssemblyLinearVelocity = velocity * 0.94
        end
    end)
end

VehicleTab:AddSection({ Name = "Mods" })

VehicleTab:AddButton({
    Name = "Instant Speed Boost",
    Callback = function()
        local vehicle = getCurrentVehicle()
        if vehicle and vehicle.PrimaryPart then
            vehicle.PrimaryPart.AssemblyLinearVelocity = vehicle.PrimaryPart.AssemblyLinearVelocity * instantBoostMultiplier
        end
    end
})

VehicleTab:AddBind({
	Name = "Instant Boost Keybind",
	Default = Enum.KeyCode.F3,
	Hold = false,
	Callback = function()
		local vehicle = getCurrentVehicle()
        if vehicle and vehicle.PrimaryPart then
            vehicle.PrimaryPart.AssemblyLinearVelocity = vehicle.PrimaryPart.AssemblyLinearVelocity * instantBoostMultiplier
        end
	end    
})

VehicleTab:AddToggle({
    Name = "Acceleration Boost",
    Default = false,
    Callback = function(value)
        accelerationEnabled = value
        if value then 
            applySmartAcceleration() 
        else 
            if accelerationConnection then accelerationConnection:Disconnect() end 
        end
    end
})

VehicleTab:AddSlider({
    Name = "Instant Boost Strength",
    Min = 1, Max = 10, Increment = 0.5, 
    Default = UserConfig.CarMods.InstantBoostStrength,
    ValueName = "x",
    Color = Color3.fromRGB(137, 207, 240),
    Callback = function(value)
        UserConfig.CarMods.InstantBoostStrength = value
        instantBoostMultiplier = value
        SaveConfig()
    end
})

VehicleTab:AddSlider({
    Name = "Acceleration Multiplier",
    Min = 1, Max = 5, Increment = 0.1, 
    Default = UserConfig.CarMods.AccelerationMultiplier,
    ValueName = "x",
    Color = Color3.fromRGB(137, 207, 240),
    Callback = function(value)
        UserConfig.CarMods.AccelerationMultiplier = value
        accelerationMultiplier = value
        SaveConfig()
    end
})

VehicleTab:AddSection({
    Name = "Tuning Mods"
})

local function findCarByName(name)
    for _, v in pairs(workspace.Vehicles:GetChildren()) do
        if v.Name:find(name) then
            return v
        end
    end
    return nil
end

local function setCarAttribute(attribute, value)
    local car = workspace.Vehicles:FindFirstChild(LocalPlayer.Name) or findCarByName(LocalPlayer.Name)
    if car then
        car:SetAttribute(attribute, value)
    end
end

VehicleTab:AddSlider({
    Name = "Armor",
    Min = 0,
    Max = 6,
    Default = UserConfig.CarMods.Armor,
    Color = Color3.fromRGB(137, 207, 240),
    Increment = 1,
    ValueName = "Level",
    Callback = function(val)
        UserConfig.CarMods.Armor = val
        setCarAttribute("armorLevel", val)
        SaveConfig()
    end
})

VehicleTab:AddSlider({
    Name = "Brakes",
    Min = 0,
    Max = 6,
    Default = UserConfig.CarMods.Brakes,
    Color = Color3.fromRGB(137, 207, 240),
    Increment = 1,
    ValueName = "Level",
    Callback = function(val)
        UserConfig.CarMods.Brakes = val
        setCarAttribute("brakesLevel", val)
        SaveConfig()
    end
})

VehicleTab:AddSlider({
    Name = "Engine",
    Min = 0,
    Max = 6,
    Default = UserConfig.CarMods.Engine,
    Color = Color3.fromRGB(137, 207, 240),
    Increment = 1,
    ValueName = "Level",
    Callback = function(val)
        UserConfig.CarMods.Engine = val
        setCarAttribute("engineLevel", val)
        SaveConfig()
    end
})

local Settings = {
    MaxDist = UserConfig.Visuals.MaxRange,
    Font = Enum.Font.Cartoon,
    TextSize = UserConfig.Visuals.TextSize,
    Visuals = {
        Names = UserConfig.Visuals.ShowNames,
        Team = UserConfig.Visuals.ShowTeam,
        Wanted = UserConfig.Visuals.ShowWanted,
        Health = UserConfig.Visuals.ShowHealth,
    },
    Skeleton = {
        Enabled = UserConfig.Visuals.SkeletonESP,
        Color = Color3.fromRGB(UserConfig.Visuals.SkeletonColor[1], UserConfig.Visuals.SkeletonColor[2], UserConfig.Visuals.SkeletonColor[3]),
        Thickness = 2.1
    }
}

local Cache = {}
local SkelDraws = {}
local Connections = {}

local Bones = {
    {"Head", "UpperTorso"}, {"UpperTorso", "LowerTorso"}, {"UpperTorso", "LeftUpperArm"},
    {"LeftUpperArm", "LeftLowerArm"}, {"LeftLowerArm", "LeftHand"}, {"UpperTorso", "RightUpperArm"},
    {"RightUpperArm", "RightLowerArm"}, {"RightLowerArm", "RightHand"}, {"LowerTorso", "LeftUpperLeg"},
    {"LeftUpperLeg", "LeftLowerLeg"}, {"LeftLowerLeg", "LeftFoot"}, {"LowerTorso", "RightUpperLeg"},
    {"RightUpperLeg", "RightLowerLeg"}, {"RightLowerLeg", "RightFoot"}
}

local FontOptions = {
    ["Gotham Bold"] = Enum.Font.GothamBold,
    ["Arial"] = Enum.Font.Arial,
    ["Ubuntu"] = Enum.Font.Ubuntu,
    ["Cartoon"] = Enum.Font.Cartoon,
    ["Bangers"] = Enum.Font.Bangers,
    ["Luckiest Guy"] = Enum.Font.LuckiestGuy,
    ["Arcade"] = Enum.Font.Arcade,
    ["Highway"] = Enum.Font.Highway,
    ["Jura"] = Enum.Font.Jura,
    ["SciFi"] = Enum.Font.SciFi,
    ["Antique"] = Enum.Font.Antique
}

for name, font in pairs(FontOptions) do
    if font == Settings.Font then
        Settings.Font = font
        break
    end
end

local function GetHealthColor(hum)
    local hp = hum.Health
    if hp <= 30 then
        return Color3.fromRGB(255, 0, 0)
    end
    local percentage = math.clamp(hp / hum.MaxHealth, 0, 1)
    local r = percentage < 0.5 and 1 or 2 * (1 - percentage)
    local g = percentage > 0.5 and 1 or 2 * percentage
    return Color3.new(r, g, 0)
end

local function UpdateAllFonts()
    for _, data in pairs(Cache) do
        for _, label in pairs(data.Labels) do
            label.Font = Settings.Font
            label.TextSize = Settings.TextSize
        end
    end
end

local function ClearSkeleton(player)
    if SkelDraws[player] then
        for _, line in pairs(SkelDraws[player]) do
            line.Visible = false
            line:Remove()
        end
        SkelDraws[player] = nil
    end
end

local function CreateSkeleton(player)
    if player == LocalPlayer then return end
    ClearSkeleton(player)
    local lines = {}
    for i = 1, #Bones do
        local line = Drawing.new("Line")
        line.Color = Settings.Skeleton.Color
        line.Thickness = Settings.Skeleton.Thickness
        line.Transparency = 1
        line.Visible = false
        table.insert(lines, line)
    end
    SkelDraws[player] = lines
end

local function UpdateSkeleton()
    if not Settings.Skeleton.Enabled then
        for _, lines in pairs(SkelDraws) do
            for _, line in pairs(lines) do line.Visible = false end
        end
        return
    end
    for skelPlayer, lines in pairs(SkelDraws) do
        local skelChar = skelPlayer.Character  
        if not skelChar then
            for _, line in pairs(lines) do line.Visible = false end
            continue
        end
        local root = skelChar:FindFirstChild("HumanoidRootPart")
        local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local show = false
        if root and myRoot then
            if (root.Position - myRoot.Position).Magnitude <= Settings.MaxDist then
                show = true
            end
        end
        if not show then
            for _, line in pairs(lines) do line.Visible = false end
            continue
        end
        for i, bonePair in ipairs(Bones) do
            local part1 = skelChar:FindFirstChild(bonePair[1])
            local part2 = skelChar:FindFirstChild(bonePair[2])
            local line = lines[i]
            if part1 and part2 then
                local v1, onScreen1 = Camera:WorldToViewportPoint(part1.Position)
                local v2, onScreen2 = Camera:WorldToViewportPoint(part2.Position)
                if onScreen1 and onScreen2 and v1.Z > 0 and v2.Z > 0 then
                    line.From = Vector2.new(v1.X, v1.Y)
                    line.To = Vector2.new(v2.X, v2.Y)
                    line.Color = Settings.Skeleton.Color
                    line.Thickness = Settings.Skeleton.Thickness
                    line.Visible = true
                else
                    line.Visible = false
                end
            else
                line.Visible = false
            end
        end
    end
end

local function CreateLabel(name, parent, color, size)
    local lbl = Instance.new("TextLabel")
    lbl.Name = name
    lbl.BackgroundTransparency = 1
    lbl.Size = UDim2.new(1, 0, 0, 15)
    lbl.Font = Settings.Font
    lbl.TextSize = size or Settings.TextSize or 16
    lbl.TextColor3 = color or Color3.fromRGB(255, 255, 255)
    lbl.TextStrokeTransparency = 0.4
    lbl.TextStrokeColor3 = Color3.new(0,0,0)
    lbl.RichText = true
    lbl.Visible = false
    lbl.Parent = parent
    return lbl
end

local function AddESP(player)
    if Cache[player] or player == LocalPlayer then return end
    local bb = Instance.new("BillboardGui")
    bb.Name = "ESP_" .. player.Name
    bb.Size = UDim2.new(0, 250, 0, 100)
    bb.AlwaysOnTop = true
    bb.ExtentsOffset = Vector3.new(0, 3, 0)
    bb.Enabled = false
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundTransparency = 1
    frame.Parent = bb
    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.Parent = frame
    local labels = {
        Name = CreateLabel("1_Name", frame, Color3.new(1,1,1)),
        TeamHP = CreateLabel("2_TeamHP", frame),
        Wanted = CreateLabel("3_Wanted", frame),
    }
    Cache[player] = {Gui = bb, Labels = labels}
    if Settings.Skeleton.Enabled then CreateSkeleton(player) end
end

local function RemoveESP(player)
    if Cache[player] then
        Cache[player].Gui:Destroy()
        Cache[player] = nil
    end
    ClearSkeleton(player)
end

local function UpdateESP()
    local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    for player, data in pairs(Cache) do
        local playerChar = player.Character  
        local head = playerChar and playerChar:FindFirstChild("Head")
        local root = playerChar and playerChar:FindFirstChild("HumanoidRootPart")
        local hum = playerChar and playerChar:FindFirstChild("Humanoid")
        if playerChar and head and root and hum and myRoot then
            local dist = (root.Position - myRoot.Position).Magnitude
            data.Gui.MaxDistance = Settings.MaxDist
            if dist < Settings.MaxDist then
                data.Gui.Parent = head
                data.Gui.Enabled = true
                local vis = Settings.Visuals
                data.Labels.Name.Visible = vis.Names
                data.Labels.Name.Text = vis.Names and player.DisplayName or ""
                data.Labels.TeamHP.Visible = (vis.Team or vis.Health)
                local teamStr = vis.Team and (player.Team and player.Team.Name or "No Team") or ""
                local hpStr = ""
                if vis.Health then
                    local dynamicColor = GetHealthColor(hum)
                    local r, g, b = math.floor(dynamicColor.R * 255), math.floor(dynamicColor.G * 255), math.floor(dynamicColor.B * 255)
                    local spacing = vis.Team and " " or ""
                    hpStr = string.format("%s<font color='rgb(%d,%d,%d)'>[%d HP]</font>", spacing, r, g, b, math.floor(hum.Health))
                end
                data.Labels.TeamHP.Text = teamStr .. hpStr
                data.Labels.TeamHP.TextColor3 = player.TeamColor and player.TeamColor.Color or Color3.new(1,1,1)
                local isWanted = root:GetAttribute("IsWanted")
                data.Labels.Wanted.Visible = vis.Wanted and isWanted
                data.Labels.Wanted.Text = "<b>WANTED</b>"
                data.Labels.Wanted.TextColor3 = Color3.fromRGB(255, 215, 0)
            else
                data.Gui.Enabled = false
            end
        else
            data.Gui.Enabled = false
        end
    end
end

for _, c in pairs(getgenv().ESP_Connections or {}) do c:Disconnect() end
getgenv().ESP_Connections = Connections

for _, p in ipairs(Players:GetPlayers()) do AddESP(p) end

table.insert(Connections, Players.PlayerAdded:Connect(function(p)
    AddESP(p)
    p.CharacterAdded:Connect(function()
        if Settings.Skeleton.Enabled then CreateSkeleton(p) end
    end)
end))

table.insert(Connections, Players.PlayerRemoving:Connect(RemoveESP))
table.insert(Connections, RunService.Heartbeat:Connect(UpdateESP))
table.insert(Connections, RunService.RenderStepped:Connect(UpdateSkeleton))

ESPTab:AddSection({Name = "Visuals"})
ESPTab:AddToggle({Name = "Show Names", Default = Settings.Visuals.Names, Callback = function(v) 
    Settings.Visuals.Names = v
    UserConfig.Visuals.ShowNames = v
    SaveConfig()
end})
ESPTab:AddToggle({Name = "Show Team", Default = Settings.Visuals.Team, Callback = function(v) 
    Settings.Visuals.Team = v
    UserConfig.Visuals.ShowTeam = v
    SaveConfig()
end})
ESPTab:AddToggle({Name = "Show Health", Default = Settings.Visuals.Health, Callback = function(v) 
    Settings.Visuals.Health = v
    UserConfig.Visuals.ShowHealth = v
    SaveConfig()
end})
ESPTab:AddToggle({Name = "Show Wanted", Default = Settings.Visuals.Wanted, Callback = function(v) 
    Settings.Visuals.Wanted = v
    UserConfig.Visuals.ShowWanted = v
    SaveConfig()
end})
ESPTab:AddToggle({Name = "Skeleton ESP", Default = Settings.Skeleton.Enabled, Callback = function(v)
    Settings.Skeleton.Enabled = v
    UserConfig.Visuals.SkeletonESP = v
    if v then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then CreateSkeleton(p) end
        end
    else
        for p, _ in pairs(SkelDraws) do ClearSkeleton(p) end
    end
    SaveConfig()
end})

ESPTab:AddSection({Name = "ESP Options"})
ESPTab:AddColorpicker({
    Name = "Skeleton Color",
    Default = Settings.Skeleton.Color,
    Callback = function(v)
        Settings.Skeleton.Color = v
        UserConfig.Visuals.SkeletonColor = {v.R * 255, v.G * 255, v.B * 255}
        for _, lines in pairs(SkelDraws) do
            for _, l in pairs(lines) do l.Color = v end
        end
        SaveConfig()
    end
})

ESPTab:AddDropdown({
    Name = "Text Font",
    Default = "Cartoon",
    Options = {"Gotham Bold", "Arial", "Ubuntu", "Cartoon", "Bangers", "Luckiest Guy", "Arcade", "Highway", "Jura", "SciFi", "Antique"},
    Callback = function(v)
        if FontOptions[v] then
            Settings.Font = FontOptions[v]
            UpdateAllFonts()
            SaveConfig()
        end
    end
})

ESPTab:AddSlider({Name = "Text Size", Min = 6, Max = 30, Default = Settings.TextSize, Increment = 1, ValueName = "px", Color = Color3.fromRGB(137, 207, 240), Callback = function(v)
    Settings.TextSize = v
    UserConfig.Visuals.TextSize = v
    UpdateAllFonts()
    SaveConfig()
end})

ESPTab:AddSlider({Name = "Max Range", Min = 100, Max = 5000, Default = Settings.MaxDist, Increment = 100, ValueName = "studs", Color = Color3.fromRGB(137, 207, 240), Callback = function(v) 
    Settings.MaxDist = v
    UserConfig.Visuals.MaxRange = v
    SaveConfig()
end})

MovementTab:AddSection({
    Name = "Main Options"
})
MovementTab:AddToggle({
    Name = "NoClip",
    Default = UserConfig.Movement.NoClip,
    Callback = function(v)
        UserConfig.Movement.NoClip = v
        _G.NoClip = v
        
        if _G.NoClip then
            spawn(function()
                while _G.NoClip do
                    for _, part in ipairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                        if part:IsA("BasePart") then 
                            part.CanCollide = false 
                        end
                    end
                    task.wait()
                end
                
                for _, part in ipairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then 
                        part.CanCollide = true 
                    end
                end
            end)
        end
        SaveConfig()
    end
})

getgenv().Config = {
    aimbotEnabled = UserConfig.Aimbot.Enabled,
    mobileAimbotEnabled = UserConfig.Aimbot.MobileButton,
    predictToggle = UserConfig.Aimbot.Prediction,
    fovCircleEnabled = UserConfig.Aimbot.ShowFOV,
    wallCheckEnabled = UserConfig.Aimbot.WallCheck,
    AimFOV = UserConfig.Aimbot.FOVRadius,
    smoothing = (11 - UserConfig.Aimbot.Smoothing) / 10,
    lockPart = UserConfig.Aimbot.TargetPart,
    predictionFactor = 0.0575,
    fovColor = Color3.fromRGB(127,255,0)
}

local Config = getgenv().Config

local Vars = {
    FOVring = Drawing.new("Circle"),
    aimbotGui = nil,
    Players = game:GetService("Players"),
    RunService = game:GetService("RunService"),
    UserInputService = game:GetService("UserInputService"),
    LocalPlayer = game:GetService("Players").LocalPlayer,
    Camera = workspace.CurrentCamera
}

Vars.FOVring.Visible = Config.fovCircleEnabled and Config.aimbotEnabled
Vars.FOVring.Thickness = 2
Vars.FOVring.Radius = Config.AimFOV
Vars.FOVring.Transparency = 1
Vars.FOVring.Color = Config.fovColor

do
    local vehicleCache = {}
    local cacheTime = {}
    local CACHE_DURATION = 0.5
    
    local function getVehicle(character)
        local now = tick()
        local cached = vehicleCache[character]
        if cached and cacheTime[character] and (now - cacheTime[character]) < CACHE_DURATION then
            return cached
        end
        local hum = character:FindFirstChildOfClass("Humanoid")
        local vehicle = nil
        if hum and hum.SeatPart then
            local current = hum.SeatPart
            while current ~= workspace and current.Parent ~= nil do
                if current:IsA("Model") then 
                    vehicle = current
                    break
                end
                current = current.Parent
            end
            if not vehicle then
                vehicle = hum.SeatPart.Parent
            end
        end
        vehicleCache[character] = vehicle
        cacheTime[character] = now
        return vehicle
    end

    local function isVisible(targetPart)
        if not Config.wallCheckEnabled then return true end
        local myChar = Vars.LocalPlayer.Character
        if not myChar then return false end
        local ignoreList = {myChar, Vars.Camera}
        local targetChar = targetPart.Parent
        local vehicle = getVehicle(targetChar)
        if vehicle then table.insert(ignoreList, vehicle) end
        local params = RaycastParams.new()
        params.FilterType = Enum.RaycastFilterType.Exclude
        params.FilterDescendantsInstances = ignoreList
        params.IgnoreWater = true
        local result = workspace:Raycast(Vars.Camera.CFrame.Position, targetPart.Position - Vars.Camera.CFrame.Position, params)
        return (not result or result.Instance:IsDescendantOf(targetChar) or (vehicle and result.Instance:IsDescendantOf(vehicle)))
    end

    local function toggleAimbot(state)
        Config.aimbotEnabled = state
        UserConfig.Aimbot.Enabled = state
        Vars.FOVring.Visible = state and Config.fovCircleEnabled
        SaveConfig()
    end

    local function createMobileGui()
        if Vars.aimbotGui then return end
        Vars.aimbotGui = Instance.new("ScreenGui")
        Vars.aimbotGui.ResetOnSpawn = false
        Vars.aimbotGui.Parent = Vars.LocalPlayer:WaitForChild("PlayerGui")
        local btn = Instance.new("TextButton", Vars.aimbotGui)
        btn.Size = UDim2.new(0, 200, 0, 50)
        btn.Position = UDim2.new(0.5, -100, 0.8, 0)
        btn.Text = Config.aimbotEnabled and "Aimbot: ON" or "Aimbot: OFF"
        btn.BackgroundColor3 = Config.aimbotEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        Instance.new("UICorner", btn)
        btn.MouseButton1Click:Connect(function()
            toggleAimbot(not Config.aimbotEnabled)
            btn.Text = Config.aimbotEnabled and "Aimbot: ON" or "Aimbot: OFF"
            btn.BackgroundColor3 = Config.aimbotEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
        end)
    end

    if AimbotTab then
        AimbotTab:AddSection({ Name = "Main Settings" })

        AimbotTab:AddToggle({
            Name = "Enable Aimbot",
            Default = Config.aimbotEnabled,
            Callback = function(v)
                toggleAimbot(v)
            end
        })

        AimbotTab:AddToggle({
            Name = "Mobile Button",
            Default = Config.mobileAimbotEnabled,
            Callback = function(v)
                Config.mobileAimbotEnabled = v
                UserConfig.Aimbot.MobileButton = v
                if v then
                    createMobileGui()
                elseif Vars.aimbotGui then
                    Vars.aimbotGui:Destroy()
                    Vars.aimbotGui = nil
                end
                SaveConfig()
            end
        })

        AimbotTab:AddBind({
            Name = "Aimbot Keybind",
            Default = Enum.KeyCode[UserConfig.Aimbot.Keybind] or Enum.KeyCode.L,
            Hold = false,
            Callback = function()
                toggleAimbot(not Config.aimbotEnabled)
            end
        })

        AimbotTab:AddSection({ Name = "Visibility & Checks" })

        AimbotTab:AddToggle({
            Name = "Wall Check",
            Default = Config.wallCheckEnabled,
            Callback = function(v)
                Config.wallCheckEnabled = v
                UserConfig.Aimbot.WallCheck = v
                SaveConfig()
            end
        })

        AimbotTab:AddToggle({
            Name = "Show FOV Circle",
            Default = Config.fovCircleEnabled,
            Callback = function(v)
                Config.fovCircleEnabled = v
                UserConfig.Aimbot.ShowFOV = v
                SaveConfig()
            end
        })

        AimbotTab:AddSlider({
            Name = "FOV Radius",
            Min = 10, Max = 500,
            Default = Config.AimFOV,
            Color = Color3.fromRGB(137, 207, 240),
            Callback = function(v)
                Config.AimFOV = v
                UserConfig.Aimbot.FOVRadius = v
                SaveConfig()
            end
        })

        AimbotTab:AddSection({ Name = "Targeting" })

        AimbotTab:AddDropdown({
            Name = "Target Part",
            Options = {"Head", "HumanoidRootPart"},
            Default = Config.lockPart,
            Callback = function(v)
                Config.lockPart = v
                UserConfig.Aimbot.TargetPart = v
                SaveConfig()
            end
        })

        AimbotTab:AddToggle({
            Name = "Prediction",
            Default = Config.predictToggle,
            Callback = function(v)
                Config.predictToggle = v
                UserConfig.Aimbot.Prediction = v
                SaveConfig()
            end
        })

        AimbotTab:AddSlider({
            Name = "Smoothing",
            Min = 1, Max = 10,
            Default = UserConfig.Aimbot.Smoothing,
            Color = Color3.fromRGB(137, 207, 240),
            Callback = function(v)
                Config.smoothing = (11 - v) / 10
                UserConfig.Aimbot.Smoothing = v
                SaveConfig()
            end
        })

        if Config.mobileAimbotEnabled then
            createMobileGui()
        end
    end

    local function getClosest()
        local target, shortest = nil, math.huge
        local center = Vars.Camera.ViewportSize / 2
        local playerList = Vars.Players:GetPlayers()
        for _, p in pairs(playerList) do
            if p ~= Vars.LocalPlayer and p.Character then
                local part = p.Character:FindFirstChild(Config.lockPart)
                if part then
                    local pos, onScreen = Vars.Camera:WorldToViewportPoint(part.Position)
                    local dist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                    if onScreen and dist <= Config.AimFOV and isVisible(part) then
                        if dist < shortest then 
                            shortest = dist 
                            target = p 
                        end
                    end
                end
            end
        end
        return target
    end

    local lastFOV = Config.AimFOV
    local lastUpdate = 0
    local updateInterval = 1/60
    
    Vars.RunService.Heartbeat:Connect(function()
        local now = tick()
        local center = Vars.Camera.ViewportSize / 2
        Vars.FOVring.Position = center
        Vars.FOVring.Visible = Config.aimbotEnabled and Config.fovCircleEnabled
        
        if lastFOV ~= Config.AimFOV then
            Vars.FOVring.Radius = Config.AimFOV
            lastFOV = Config.AimFOV
        end

        if Config.aimbotEnabled and (now - lastUpdate) >= updateInterval then
            lastUpdate = now
            if Vars.UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) or Config.mobileAimbotEnabled then
                local target = getClosest()
                if target and target.Character then
                    local part = target.Character:FindFirstChild(Config.lockPart)
                    if part then
                        local aimPos = part.Position
                        if Config.predictToggle then
                            local vel = part.AssemblyLinearVelocity
                            local veh = getVehicle(target.Character)
                            if veh and veh.PrimaryPart then 
                                vel = veh.PrimaryPart.AssemblyLinearVelocity
                            end
                            aimPos = aimPos + (vel * Config.predictionFactor)
                        end
                        Vars.Camera.CFrame = Vars.Camera.CFrame:Lerp(
                            CFrame.new(Vars.Camera.CFrame.Position, aimPos), 
                            Config.smoothing
                        )
                    end
                end
            end
        end
    end)
end

local walkspeedBoost = UserConfig.Movement.WalkspeedBoost / 10

MovementTab:AddSlider({
    Name = "Walkspeed Boost",
    Min = 0,
    Max = 3,
    Default = UserConfig.Movement.WalkspeedBoost,
    Interval = 1,
    Suffix = "",
    Flag = "WalkspeedSliderBoost",
    Color = Color3.fromRGB(137, 207, 240),
    Section = MovementSection, 
    Callback = function(Value)
        UserConfig.Movement.WalkspeedBoost = Value
        walkspeedBoost = Value / 10
        SaveConfig()
    end,
    Format = function(Value)
        return tostring(Value / 10)
    end
})

RunService.Heartbeat:Connect(function()
    if not LocalPlayer or not LocalPlayer.Character then return end  
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if hrp and humanoid then
        if walkspeedBoost > 0 and humanoid.MoveDirection.Magnitude > 0 then
            hrp.CFrame = hrp.CFrame + hrp.CFrame.LookVector * walkspeedBoost
        end
    end
end)

_G.SpinbotConfig = {
    Enabled = UserConfig.Movement.Spinbot,
    Speed = 60
}

MovementTab:AddToggle({
    Name = "Spinbot",
    CurrentValue = UserConfig.Movement.Spinbot,
    Callback = function(val)
        UserConfig.Movement.Spinbot = val
        _G.SpinbotConfig.Enabled = val
        SaveConfig()
    end,
})

game:GetService("RunService").Stepped:Connect(function()
    if not _G.SpinbotConfig.Enabled then return end
    
    local char = game:GetService("Players").LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChildOfClass("Humanoid") then
        if not char:FindFirstChildOfClass("Humanoid").SeatPart then
            char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(_G.SpinbotConfig.Speed), 0)
        end
    end
end)

local AimData = {
    S = getgenv().SilentAimSettings or {
        SilentAim = UserConfig.SilentAim.Enabled,
        Prediction = true,
        KnockedCheck = UserConfig.SilentAim.KnockedCheck,
        TeamCheck = UserConfig.SilentAim.TeamCheck,
        WallCheck = UserConfig.SilentAim.WallCheck,
        Fov = UserConfig.SilentAim.ShowFOV,
        FovSize = UserConfig.SilentAim.FOVSize,
        FovColor = Color3.fromRGB(UserConfig.SilentAim.FOVColor[1], UserConfig.SilentAim.FOVColor[2], UserConfig.SilentAim.FOVColor[3]),
        HitParts = UserConfig.SilentAim.HitParts,
        UpdateInterval = 0.01,
        FireRate = UserConfig.SilentAim.ShootSpeed
    },
    Service = {
        P = game:GetService("Players"),
        LP = game:GetService("Players").LocalPlayer,
        C = workspace.CurrentCamera,
        RS = game:GetService("RunService"),
        Rep = game:GetService("ReplicatedStorage"),
        Stats = game:GetService("Stats")
    },
    Cache = {
        CurrentTarget = nil,
        LU = 0,
        LF = 0
    }
}

local FC = Drawing.new("Circle")
FC.Filled = false
FC.Thickness = 2
FC.Visible = AimData.S.Fov and AimData.S.SilentAim

local Utils = {
    GetPing = function()
        return AimData.Service.Stats.Network.ServerStatsItem["Data Ping"]:GetValue() / 1000
    end,

    IsVisible = function(sPos, ePos, ignore)
        if not AimData.S.WallCheck then return true end
        local p = RaycastParams.new()
        p.FilterType = Enum.RaycastFilterType.Blacklist
        p.FilterDescendantsInstances = {AimData.Service.LP.Character, ignore}
        return not workspace:Raycast(sPos, ePos - sPos, p)
    end,

    GetPredPos = function(part)
        local pos = part.Position
        if AimData.S.Prediction then
            local ping = AimData.Service.Stats.Network.ServerStatsItem["Data Ping"]:GetValue() / 1000
            local dist = (AimData.Service.C.CFrame.Position - pos).Magnitude
            pos = pos + (part.Velocity * (ping + (dist / 1000)))
        end
        return pos
    end
}

local Tab = SilentAimTab 
if Tab then
    local S = AimData.S
    local SliderColor = Color3.fromRGB(137, 207, 240)

    Tab:AddSection({Name = "Silent Aim"})
    Tab:AddToggle({Name = "Silent Aim", Default = S.SilentAim, Callback = function(v) 
        S.SilentAim = v
        UserConfig.SilentAim.Enabled = v
        SaveConfig()
    end})
    
    Tab:AddSlider({
        Name = "Shoot Speed [Seconds]", 
        Min = 0.05, 
        Max = 1.0, 
        Default = S.FireRate, 
        Increment = 0.05, 
        Color = SliderColor,
        Callback = function(v) 
            S.FireRate = v
            UserConfig.SilentAim.ShootSpeed = v
            SaveConfig()
        end
    })
    
    Tab:AddSection({Name = "FOV Settings"})
    Tab:AddToggle({Name = "Show FOV Circle", Default = S.Fov, Callback = function(v) 
        S.Fov = v
        UserConfig.SilentAim.ShowFOV = v
        SaveConfig()
    end})
    
    Tab:AddSlider({
        Name = "FOV Size", 
        Min = 10, 
        Max = 300, 
        Default = S.FovSize, 
        Increment = 5, 
        Color = SliderColor,
        Callback = function(v) 
            S.FovSize = v
            UserConfig.SilentAim.FOVSize = v
            SaveConfig()
        end
    })
    
    Tab:AddColorpicker({Name = "FOV Color", Default = S.FovColor, Callback = function(v) 
        S.FovColor = v
        UserConfig.SilentAim.FOVColor = {v.R * 255, v.G * 255, v.B * 255}
        SaveConfig()
    end})
    
    Tab:AddSection({Name = "Checks"})
    Tab:AddToggle({Name = "Knocked Check", Default = S.KnockedCheck, Callback = function(v) 
        S.KnockedCheck = v
        UserConfig.SilentAim.KnockedCheck = v
        SaveConfig()
    end})
    Tab:AddToggle({Name = "Team Check", Default = S.TeamCheck, Callback = function(v) 
        S.TeamCheck = v
        UserConfig.SilentAim.TeamCheck = v
        SaveConfig()
    end})
    Tab:AddToggle({Name = "Wall Check", Default = S.WallCheck, Callback = function(v) 
        S.WallCheck = v
        UserConfig.SilentAim.WallCheck = v
        SaveConfig()
    end})
    
    Tab:AddSection({Name = "Targeting"})
    Tab:AddDropdown({Name = "Hit Parts", Options = { "Head", "HumanoidRootPart", "Torso" }, Default = S.HitParts, Multi = true, Callback = function(v) 
        S.HitParts = (typeof(v) == "table") and v or { v }
        UserConfig.SilentAim.HitParts = S.HitParts
        SaveConfig()
    end})
end

local function FindTarget()
    local best, close = nil, AimData.S.FovSize
    local center = Vector2.new(AimData.Service.C.ViewportSize.X / 2, AimData.Service.C.ViewportSize.Y / 2)

    for _, pl in ipairs(AimData.Service.P:GetPlayers()) do
        if pl ~= AimData.Service.LP and pl.Character and pl.Character:FindFirstChild("Humanoid") then
            local isTeam = not AimData.S.TeamCheck or (pl.Team ~= AimData.Service.LP.Team)
            local isAlive = not AimData.S.KnockedCheck or (pl.Character.Humanoid.Health > 5)
            
            if isTeam and isAlive then
                for _, pn in ipairs(AimData.S.HitParts) do
                    local part = pl.Character:FindFirstChild(pn)
                    if part then
                        local tPos = Utils.GetPredPos(part)
                        local sPos, onS = AimData.Service.C:WorldToViewportPoint(tPos)
                        
                        if onS and sPos.Z > 0 then
                            local d = (Vector2.new(sPos.X, sPos.Y) - center).Magnitude
                            if d < close and Utils.IsVisible(AimData.Service.C.CFrame.Position, tPos, pl.Character) then
                                close = d
                                best = {p = pl, part = part}
                            end
                        end
                    end
                end
            end
        end
    end
    return best
end

local function DoFire(data)
    local char = AimData.Service.LP.Character
    if not char then return end
    
    local tool = nil
    for _, v in ipairs(char:GetChildren()) do
        if v:IsA("Tool") then tool = v break end
    end
    if not tool then return end

    local tPos = Utils.GetPredPos(data.part)
    local dir = (tPos - AimData.Service.C.CFrame.Position).Unit
    local remote = AimData.Service.Rep:FindFirstChild("EJw") and AimData.Service.Rep.EJw:FindFirstChild("7c113b14-5efb-4b43-bf60-fbc75c83d778")
    
    if remote then
        remote:FireServer(tool, tPos, dir)
    end
end

AimData.Service.RS.Heartbeat:Connect(function(dt)
    local S = AimData.S
    local V = AimData.Cache

    if S.SilentAim then
        FC.Position = Vector2.new(AimData.Service.C.ViewportSize.X / 2, AimData.Service.C.ViewportSize.Y / 2)
        FC.Radius = S.FovSize
        FC.Visible = S.Fov
        FC.Color = S.FovColor
        
        V.LU = V.LU + dt
        V.LF = V.LF + dt
        
        if V.LU >= S.UpdateInterval then
            V.CurrentTarget = FindTarget()
            V.LU = 0
        end

        if V.CurrentTarget then
            FC.Color = Color3.fromRGB(0, 255, 0)
            if V.LF >= S.FireRate then
                DoFire(V.CurrentTarget)
                V.LF = 0
            end
        end
    else
        FC.Visible = false
    end
end)

MovementTab:AddSection({Name = "Fly Settings"})

local lastSpacePress = 0
local doubleTapDelay = 0.3

local function canFly()
    local char = LocalPlayer.Character
    if not char then return false end
    local hum = char:FindFirstChild("Humanoid")
    return hum and not hum.SeatPart
end

local function startFlying()
    if not canFly() then return false end
    local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local hum = LocalPlayer.Character:FindFirstChild("Humanoid")

    if MiscSettings.attachment and MiscSettings.attachment.Parent then 
        MiscSettings.attachment:Destroy() 
    end
    if MiscSettings.alignPos and MiscSettings.alignPos.Parent then 
        MiscSettings.alignPos:Destroy() 
    end
    if MiscSettings.alignOri and MiscSettings.alignOri.Parent then 
        MiscSettings.alignOri:Destroy() 
    end

    MiscSettings.attachment = Instance.new("Attachment", hrp)
    MiscSettings.alignPos = Instance.new("AlignPosition", hrp)
    MiscSettings.alignPos.Attachment0 = MiscSettings.attachment
    MiscSettings.alignPos.Mode = Enum.PositionAlignmentMode.OneAttachment
    MiscSettings.alignPos.MaxForce = 5000
    MiscSettings.alignPos.Responsiveness = 45
    MiscSettings.alignOri = Instance.new("AlignOrientation", hrp)
    MiscSettings.alignOri.Attachment0 = MiscSettings.attachment
    MiscSettings.alignOri.Mode = Enum.OrientationAlignmentMode.OneAttachment
    MiscSettings.alignOri.MaxTorque = 5000
    MiscSettings.alignOri.Responsiveness = 45

    hum.PlatformStand = true
    MiscSettings.isFlying = true
    local pos = hrp.Position
    MiscSettings.alignPos.Position = pos

    spawn(function()
        while MiscSettings.isFlying and LocalPlayer.Character and hrp and hum do
            local move = Vector3.new()
            local cam = workspace.CurrentCamera.CFrame
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + cam.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move - cam.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move - cam.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + cam.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.E) then move = move + Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.Q) then move = move + Vector3.new(0, -1, 0) end

            if move.Magnitude > 0 then
                move = move.Unit
                local newPos = pos + move * MiscSettings.flyingSpeed * RunService.Heartbeat:Wait()
                MiscSettings.alignPos.Position = newPos
                pos = newPos
            end
            MiscSettings.alignOri.CFrame = CFrame.new(Vector3.new(), cam.LookVector)
            RunService.Heartbeat:Wait()
        end
    end)
    return true
end

local function stopFlying()
    MiscSettings.isFlying = false
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChild("Humanoid")
        if hum then hum.PlatformStand = false end
    end
    if MiscSettings.attachment and MiscSettings.attachment.Parent then 
        MiscSettings.attachment:Destroy() 
    end
    if MiscSettings.alignPos and MiscSettings.alignPos.Parent then 
        MiscSettings.alignPos:Destroy() 
    end
    if MiscSettings.alignOri and MiscSettings.alignOri.Parent then 
        MiscSettings.alignOri:Destroy() 
    end
end

local FlyToggle = MovementTab:AddToggle({
    Name = "Player Fly",
    Default = UserConfig.Movement.PlayerFly,
    Save = true,
    Flag = "FlyToggle",
    Callback = function(val)
        UserConfig.Movement.PlayerFly = val
        if not val then
            stopFlying()
        elseif not startFlying() then
            FlyToggle:Set(false)
        end
        SaveConfig()
    end
})

MovementTab:AddToggle({
    Name = "Double-Tap Space to Fly",
    Default = UserConfig.Movement.DoubleTapFly,
    Save = true,
    Flag = "DoubleTapFly",
    Callback = function(val)
        UserConfig.Movement.DoubleTapFly = val
        MiscSettings.doubleTapFlyEnabled = val
        SaveConfig()
    end
})

MovementTab:AddBind({
    Name = "Fly Bind",
    Default = Enum.KeyCode[UserConfig.Movement.FlyKeybind],
    Save = true,
    Flag = "FlyKeybind",
    Callback = function()
        if MiscSettings.isFlying then
            stopFlying()
            FlyToggle:Set(false)
            UserConfig.Movement.PlayerFly = false
        elseif not startFlying() then
            FlyToggle:Set(false)
        else
            FlyToggle:Set(true)
            UserConfig.Movement.PlayerFly = true
        end
        SaveConfig()
    end
})

MovementTab:AddSlider({
    Name = "Fly Speed",
    Min = 5,
    Max = 90,
    Default = UserConfig.Movement.FlySpeed,
    Color = Color3.fromRGB(137, 207, 240),
    Increment = 1,
    ValueName = "Speed",
    Save = true,
    Flag = "FlySpeed",
    Callback = function(val)
        UserConfig.Movement.FlySpeed = val
        MiscSettings.flyingSpeed = val
        SaveConfig()
    end
})

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed or not MiscSettings.doubleTapFlyEnabled then return end
    if input.KeyCode == Enum.KeyCode.Space then
        local now = tick()
        if now - lastSpacePress < doubleTapDelay then
            if MiscSettings.isFlying then
                stopFlying()
                FlyToggle:Set(false)
                UserConfig.Movement.PlayerFly = false
            else
                if startFlying() then
                    FlyToggle:Set(true)
                    UserConfig.Movement.PlayerFly = true
                end
            end
            lastSpacePress = 0
            SaveConfig()
        else
            lastSpacePress = now
        end
    end
end)

LocalPlayer.CharacterAdded:Connect(function()
    if MiscSettings.isFlying then
        task.wait(1)
        if FlyToggle.Value then
            startFlying()
        end
    end
end)

RunService.Heartbeat:Connect(function(deltaTime)
    if MiscSettings.spinBotEnabled then
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstFind("HumanoidRootPart")
        if hrp then
            hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(MiscSettings.spinSpeed * 360 * deltaTime), 0)
        end
    end
end)

local combatEnabled = UserConfig.Misc.AutoPunch
SafetyTab:AddToggle({
    Name = "Auto Punch",
    Default = UserConfig.Misc.AutoPunch,
    Callback = function(Value)
        UserConfig.Misc.AutoPunch = Value
        combatEnabled = Value
        
        task.spawn(function()
            while combatEnabled do
                local success, err = pcall(function()
                    local lplr = game.Players.LocalPlayer
                    local char = lplr.Character
                    if not char then return end
                    
                    local root = char:FindFirstChild("HumanoidRootPart")
                    local hum = char:FindFirstChild("Humanoid")
                    if not root or not hum or hum.Health <= 0 then return end

                    local closestTarget = nil
                    local closestDist = math.huge

                    for _, target in pairs(game.Players:GetPlayers()) do
                        if target ~= lplr and target.Character then
                            local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
                            local targetHum = target.Character:FindFirstChild("Humanoid")

                            if targetRoot and targetHum and targetHum.Health > 0 then
                                local dist = (root.Position - targetRoot.Position).Magnitude
                                if dist < closestDist then
                                    closestDist = dist
                                    closestTarget = target
                                end
                            end
                        end
                    end

                    if closestTarget and closestTarget.Character then
                        local targetRoot = closestTarget.Character:FindFirstChild("HumanoidRootPart")
                        if targetRoot then
                            local dist = (root.Position - targetRoot.Position).Magnitude
                            if dist <= 10 then
                                game:GetService("ReplicatedStorage").EJw["3f6057cb-51df-455e-bb64-6b63fdbfb6e4"]:FireServer(closestTarget.Character.Name)
                            end
                        end
                    end
                end)
                
                if not success then
                    warn("Auto Punch Error:", err)
                end

                local lplr = game.Players.LocalPlayer
                local char = lplr and lplr.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")
                local nearEnemy = false

                if root then
                    for _, target in pairs(game.Players:GetPlayers()) do
                        if target ~= lplr and target.Character then
                            local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
                            if targetRoot and (root.Position - targetRoot.Position).Magnitude <= 10 then
                                nearEnemy = true
                                break
                            end
                        end
                    end
                end

                if nearEnemy then
                    task.wait()
                else
                    task.wait(0.05)
                end
            end
        end)
        SaveConfig()
    end    
})

_G.AC = {
    Enabled = UserConfig.Misc.AutoCollect,
    Range = 30,
    Delay = 2.5,
    Rem = game:GetService("ReplicatedStorage").EJw["a3126821-130a-4135-80e1-1d28cece4007"],
}

local ws, pl = game:GetService("Workspace"), game.Players.LocalPlayer
local coll, robs = {}, {}

local function trk(d)
    if d:IsA("Folder") then
        local n = d.Name:lower()
        if n:find("robbery") or n:find("robberies") then
            if not table.find(robs, d) then table.insert(robs, d) end
        end
    end
end
for _, d in ipairs(ws:GetDescendants()) do trk(d) end
ws.DescendantAdded:Connect(trk)

local function collect(m)
    if not m or coll[m] or not pl.Character or m.Transparency ~= 0 then return end
    local hrp = pl.Character:FindFirstChild("HumanoidRootPart")
    if hrp and (hrp.Position - m.Position).Magnitude <= _G.AC.Range then
        coll[m] = true
        task.spawn(function()
            local key = (m.Parent and m.Parent.Name == "Money") and "yQL" or "Vqe"
            _G.AC.Rem:FireServer(m, key, true)
            task.wait(_G.AC.Delay)
            _G.AC.Rem:FireServer(m, key, false)
            if m and m.Parent and m.Transparency == 0 then
                coll[m] = nil
            end
        end)
    end
end

SafetyTab:AddToggle({
    Name = "Auto Collect",
    Default = UserConfig.Misc.AutoCollect,
    Callback = function(v)
        UserConfig.Misc.AutoCollect = v
        _G.AC.Enabled = v
        task.spawn(function()
            while _G.AC.Enabled do
                pcall(function()
                    for _, f in ipairs(robs) do
                        if f and f.Parent then
                            for _, m in ipairs(f:GetDescendants()) do
                                if m:IsA("MeshPart") then collect(m) end
                            end
                        end
                    end
                end)
                task.wait(0.5)
            end
        end)
        SaveConfig()
    end
})
SafetyTab:AddParagraph("Auto Collect Information!","Auto Collect only works for Cash Rob Right now. This will be fixed soon.")

SafetyTab:AddSection({
    Name = "Safety"
})

SafetyTab:AddToggle({
    Name = "Anti Fall",
    Default = UserConfig.Misc.AntiFall,
    Callback = function(val)
        UserConfig.Misc.AntiFall = val
        if val then
            getfenv().nofall = RunService.Heartbeat:Connect(function()
                local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if hrp and hrp.Velocity.Y < -30 and workspace:Raycast(hrp.Position, Vector3.new(0, -20, 0)) then
                    hrp.Velocity = Vector3.zero
                end
            end)
        elseif getfenv().nofall then
            getfenv().nofall:Disconnect()
            getfenv().nofall = nil
        end
        SaveConfig()
    end
})

local GunMods = _G.GunMods or {}
_G.GunMods = GunMods

local GunSettings = _G.GunSettings or {
    AutoRefill = UserConfig.GunMods.AutoReload,
    CrosshairSize = UserConfig.GunMods.CrosshairSize,
    RapidFire = UserConfig.GunMods.RapidFire,
    NoRecoil = UserConfig.GunMods.NoRecoil,
    AimFOV = UserConfig.GunMods.AimFOV,
    OriginalValues = {},
    TrackedWeapons = {
        "G36", "Glock 17", "MP5", "M4 Carabine", "Sniper", "M58B Shotgun"
    }
}
_G.GunSettings = GunSettings

local soundOptions = _G.soundOptions or {
    "Default",
    "Stab",
    "UwU",
    "Sniper",
    "Goofy UwU",
    "Bong",
    "Allah",
    "67",
    "P90",
    "Pixel",
    "Undertale"
}
_G.soundOptions = soundOptions

local soundIds = _G.soundIds or {
    ["Stab"] = "rbxassetid://7628283135",
    ["UwU"] = "rbxassetid://130572853112549",
    ["Sniper"] = "rbxassetid://122180189312589",
    ["Goofy UwU"] = "rbxassetid://133219911426754",
    ["Bong"] = "rbxassetid://126369856995827",
    ["Allah"] = "rbxassetid://117345851948018",
    ["67"] = "rbxassetid://137959261043235",
    ["P90"] = "rbxassetid://87534588983395",
    ["Pixel"] = "rbxassetid://7380537613",
    ["Undertale"] = "rbxassetid://438149153",
}
_G.soundIds = soundIds

local origSounds = _G.origSounds or {}
_G.origSounds = origSounds

local VirtualInputManager = game:GetService("VirtualInputManager")

for _, v in pairs(game:GetDescendants()) do
    if v:IsA("Sound") then
        local id = v.SoundId
        if id == "rbxassetid://801226154" or id == "rbxassetid://801217802" then
            origSounds[v] = id
        end
    end
end

local function SaveOriginalValues(tool)
    local toolName = tool.Name
    if not GunSettings.OriginalValues[toolName] then
        GunSettings.OriginalValues[toolName] = {
            Recoil = tool:GetAttribute("Recoil") or 1,
            Instability = tool:GetAttribute("Instability") or 1,
            ShootDelay = tool:GetAttribute("ShootDelay") or 0.1,
            Automatic = tool:GetAttribute("Automatic") or false,
            CrosshairSize = tool:GetAttribute("CrosshairSize") or 10,
            AimFieldOfView = tool:GetAttribute("AimFieldOfView") or 70
        }
    end
end

local function RestoreOriginalValues(tool, attribute)
    local toolName = tool.Name
    if GunSettings.OriginalValues[toolName] and GunSettings.OriginalValues[toolName][attribute] ~= nil then
        tool:SetAttribute(attribute, GunSettings.OriginalValues[toolName][attribute])
    end
end

task.spawn(function()
    while true do
        pcall(function()
            local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
            
            if tool then
                SaveOriginalValues(tool)

                if GunSettings.NoRecoil then
                    tool:SetAttribute("Recoil", 0)
                    tool:SetAttribute("Instability", 0)
                else
                    RestoreOriginalValues(tool, "Recoil")
                    RestoreOriginalValues(tool, "Instability")
                end
                
                if GunSettings.RapidFire then
                    tool:SetAttribute("ShootDelay", 0)
                    tool:SetAttribute("Automatic", true)
                else
                    RestoreOriginalValues(tool, "ShootDelay")
                    RestoreOriginalValues(tool, "Automatic")
                end
                
                tool:SetAttribute("CrosshairSize", GunSettings.CrosshairSize)
            end
        end)
        task.wait(0.05)
    end
end)

task.spawn(function()
    while true do
        if GunSettings.AutoRefill then
            pcall(function()
                local char = LocalPlayer.Character
                if char then
                    for _, weaponName in ipairs(GunSettings.TrackedWeapons) do
                        local weapon = char:FindFirstChild(weaponName) or workspace:FindFirstChild(weaponName)
                        if weapon then
                            local magSize = weapon:GetAttribute("MagCurrentSize") 
                                or weapon:GetAttribute("Ammo") 
                                or weapon:GetAttribute("Clip")
                                or (weapon:FindFirstChild("Ammo") and weapon.Ammo.Value)

                            if magSize and magSize == 0 then
                                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.R, false, game)
                                task.wait(0.05)
                                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.R, false, game)
                                task.wait(1) 
                            end
                        end
                    end
                end
            end)
        end
        task.wait(0.5)
    end
end)

task.spawn(function()
    while task.wait(0.05) do
        pcall(function()
            local character = LocalPlayer.Character
            if character then
                local Tool = character:FindFirstChildOfClass("Tool")
                if Tool then
                    SaveOriginalValues(Tool)
                    Tool:SetAttribute("AimFieldOfView", GunSettings.AimFOV)
                end
            end
        end)
    end
end)

if LocalPlayer.Character then
    LocalPlayer.Character.ChildAdded:Connect(function(child)
        if child:IsA("Tool") then
            task.wait(0.1)
            SaveOriginalValues(child)
        end
    end)
end

LocalPlayer.CharacterAdded:Connect(function(character)
    character.ChildAdded:Connect(function(child)
        if child:IsA("Tool") then
            task.wait(0.1)
            SaveOriginalValues(child)
        end
    end)
end)

local function InitializeUI(GunModsTab)
    if not GunModsTab then
        return false
    end

    local success, err = pcall(function()
        GunModsTab:AddSection({
            Name = "Gun Mods"
        })

        GunModsTab:AddToggle({
            Name = "Auto Reload",
            CurrentValue = GunSettings.AutoRefill,
            Flag = "AutoReload",
            Callback = function(Value)
                UserConfig.GunMods.AutoReload = Value
                GunSettings.AutoRefill = Value
                SaveConfig()
            end
        })

        GunModsTab:AddToggle({
            Name = "Rapid Fire",
            CurrentValue = GunSettings.RapidFire,
            Flag = "RapidFireToggle",
            Callback = function(Value)
                UserConfig.GunMods.RapidFire = Value
                GunSettings.RapidFire = Value
                
                if not Value then
                    local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
                    if tool then
                        task.spawn(function()
                            for i = 1, 5 do
                                RestoreOriginalValues(tool, "ShootDelay")
                                RestoreOriginalValues(tool, "Automatic")
                                task.wait(0.1)
                            end
                        end)
                    end
                end
                SaveConfig()
            end
        })

        GunModsTab:AddToggle({
            Name = "No Recoil",
            CurrentValue = GunSettings.NoRecoil,
            Flag = "NoRecoilToggle",
            Callback = function(Value)
                UserConfig.GunMods.NoRecoil = Value
                GunSettings.NoRecoil = Value
                
                if not Value then
                    local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
                    if tool then
                        task.spawn(function()
                            for i = 1, 5 do
                                RestoreOriginalValues(tool, "Recoil")
                                RestoreOriginalValues(tool, "Instability")
                                task.wait(0.1)
                            end
                        end)
                    end
                end
                SaveConfig()
            end
        })

        GunModsTab:AddDropdown({
            Name = "Gun Sound",
            Default = UserConfig.GunMods.GunSound,
            Save = true,
            Flag = "ShootSound",
            Options = soundOptions,
            Callback = function(sel)
                UserConfig.GunMods.GunSound = sel
                for s, o in pairs(origSounds) do
                    if s and s.Parent then
                        s.SoundId = sel == "Default" and o or soundIds[sel]
                    end
                end
                SaveConfig()
            end    
        })

        GunModsTab:AddSlider({
            Name = "Crosshair Size",
            Min = 1,
            Max = 30,
            Default = GunSettings.CrosshairSize,
            Color = Color3.fromRGB(137, 207, 240),
            Increment = 1,
            ValueName = "Size",
            Save = true,
            Flag = "CrosshairSize",
            Callback = function(Value)
                UserConfig.GunMods.CrosshairSize = Value
                GunSettings.CrosshairSize = Value
                SaveConfig()
            end
        })

        GunModsTab:AddSlider({
            Name = "Aim FOV",
            Min = 40,
            Max = 120,
            Default = GunSettings.AimFOV,
            Color = Color3.fromRGB(137, 207, 240),
            Increment = 1,
            ValueName = "FOV",
            Callback = function(Value)
                UserConfig.GunMods.AimFOV = Value
                GunSettings.AimFOV = Value
                SaveConfig()
            end
        })
    end)

    return success
end

GunMods.InitializeUI = InitializeUI

if GunModsTab then
    task.wait(0.5)
    local success = InitializeUI(GunModsTab)
    if not success then
        warn("Failed to initialize Gun Mods UI")
    end
end

local SelectedColor = Color3.fromRGB(UserConfig.GunMods.WeaponColor[1], UserConfig.GunMods.WeaponColor[2], UserConfig.GunMods.WeaponColor[3])
local RainbowEnabled = UserConfig.GunMods.RainbowMode
local RainbowSpeed = 5

local function ApplyColor(col)
    local tool = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
    if tool then
        for _, v in pairs(tool:GetDescendants()) do
            if v:IsA("BasePart") then v.Color = col
            elseif v:IsA("Texture") or v:IsA("Decal") then v.Color3 = col end
        end
    end
end

task.spawn(function()
    while task.wait() do
        if RainbowEnabled then
            ApplyColor(Color3.fromHSV(tick() % RainbowSpeed / RainbowSpeed, 1, 1))
        end
    end
end)

GunModsTab:AddSection({
    Name = "Weapon Color"
})
GunModsTab:AddColorpicker({
    Name = "Color",
    Default = SelectedColor,
    Callback = function(Value)
        UserConfig.GunMods.WeaponColor = {Value.R * 255, Value.G * 255, Value.B * 255}
        SelectedColor = Value
        SaveConfig()
    end
})

GunModsTab:AddButton({
    Name = "Apply Color",
    Callback = function() RainbowEnabled = false; UserConfig.GunMods.RainbowMode = false; ApplyColor(SelectedColor); SaveConfig() end
})

GunModsTab:AddToggle({
    Name = "Rainbow Mode",
    Default = UserConfig.GunMods.RainbowMode,
    Callback = function(Value)
        UserConfig.GunMods.RainbowMode = Value
        RainbowEnabled = Value
        SaveConfig()
    end
})

local antiDownedConnection = nil
SafetyTab:AddToggle({
    Name = "Anti Downed",
    Default = UserConfig.Misc.AntiDowned,
    Callback = function(val)
        UserConfig.Misc.AntiDowned = val
        if val then
            local humanoid = LocalPlayer.Character:WaitForChild("Humanoid")
            antiDownedConnection = humanoid:GetPropertyChangedSignal("Health"):Connect(function()
                humanoid.Health = 100
            end)
        elseif antiDownedConnection then
            antiDownedConnection:Disconnect()
            antiDownedConnection = nil
        end
        SaveConfig()
    end
})

GraphicsTab:AddSection({
    Name = "Graphics"
})
local xrayCache = {}
GraphicsTab:AddToggle({
    Name = "XRay",
    Default = UserConfig.Graphics.XRay,
    Flag = "xRay",
    Callback = function(val)
        UserConfig.Graphics.XRay = val
        if val then
            for _, part in pairs(workspace:GetDescendants()) do
                if part:IsA("BasePart") and part.Parent ~= LocalPlayer.Character then
                    xrayCache[part] = part.LocalTransparencyModifier
                    part.LocalTransparencyModifier = 0.5
                end
            end
        else
            for part, originalValue in pairs(xrayCache) do
                if part and part.Parent then
                    part.LocalTransparencyModifier = originalValue
                end
            end
            xrayCache = {}
        end
        SaveConfig()
    end
})

local originalLightingProps = {}
GraphicsTab:AddToggle({
    Name = "Fullbright",
    Default = UserConfig.Graphics.Fullbright,
    Callback = function(val)
        UserConfig.Graphics.Fullbright = val
        if val then
            originalLightingProps.Brightness = Lighting.Brightness
            originalLightingProps.ClockTime = Lighting.ClockTime
            originalLightingProps.FogEnd = Lighting.FogEnd
            originalLightingProps.GlobalShadows = Lighting.GlobalShadows
            originalLightingProps.OutdoorAmbient = Lighting.OutdoorAmbient
            Lighting.Brightness = 2
            Lighting.ClockTime = 12
            Lighting.FogEnd = 100000
            Lighting.GlobalShadows = false
            Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
        else
            for prop, value in pairs(originalLightingProps) do
                Lighting[prop] = value
            end
        end
        SaveConfig()
    end
})

local atmosphere = Lighting:FindFirstChildOfClass("Atmosphere")
local connection = nil

local function freezeAtmosphere()
    if atmosphere and atmosphere.Parent then
        atmosphere.Density = 0
        atmosphere.Haze = 0
        atmosphere.Glare = 0
    end
end

GraphicsTab:AddToggle({
    Name = "Remove Atmosphere",
    Default = UserConfig.Graphics.RemoveAtmosphere,
    Callback = function(val)
        UserConfig.Graphics.RemoveAtmosphere = val
        atmosphere = Lighting:FindFirstChildOfClass("Atmosphere")
        
        if val then
            if atmosphere then
                freezeAtmosphere()
                
                if connection then connection:Disconnect() end
                
                connection = atmosphere.Changed:Connect(freezeAtmosphere)
            end
        else
            if connection then
                connection:Disconnect()
                connection = nil
            end
            
            if atmosphere then
                atmosphere.Density = 0.3
                atmosphere.Haze = 0
                atmosphere.Glare = 0
            end
        end
        SaveConfig()
    end
})

GraphicsTab:AddButton({
	Name = "Remove Signs",
	Callback = function()
        for _, obj in pairs(game.Workspace:GetDescendants()) do
            if obj.Name:lower():find("sign") or obj.Name:lower():find("schild") then
                obj:Destroy()
            end
        end
  	end    
})

GraphicsTab:AddButton({
	Name = "Remove Trees",
	Callback = function()
        local count = 0

        local winterAssets = workspace:FindFirstChild("Winter Assets")
        if winterAssets then
            local treeSnow = winterAssets:FindFirstChild("Tree Snow")
            if treeSnow then
                treeSnow:Destroy()
                count = count + 1
            end
        end

        for _, obj in pairs(game.Workspace:GetDescendants()) do
            if obj:IsA("Model") and (obj.Name:find("Tree") or obj.Name:find("Baum") or obj.Name:find("Bush")) then
                obj:Destroy()
                count = count + 1
            end
        end
  	end    
})

_G.ST = {Lp = UserConfig.Graphics.RandomSkinLoop}
local P = game:GetService("Players")
local L = P.LocalPlayer

function _G.ST.C(t)
	local c, tc = L.Character, t and t.Character
	if not c or not tc then return end
	for _, v in next, c:GetChildren() do
		if v:IsA("Clothing") or v:IsA("ShirtGraphic") then v:Destroy() end
	end
	for _, v in next, tc:GetChildren() do
		if v:IsA("Clothing") or v:IsA("ShirtGraphic") then v:Clone().Parent = c end
		if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
			local p = c:FindFirstChild(v.Name)
			if p then p.BrickColor = v.BrickColor p.Material = v.Material end
		end
	end
	local h, th = c:FindFirstChild("Head"), tc:FindFirstChild("Head")
	if h and th then
		for _, d in next, h:GetChildren() do if d:IsA("Decal") then d:Destroy() end end
		local f = th:FindFirstChildOfClass("Decal")
		if f then f:Clone().Parent = h end
	end
end

function _G.ST.G()
	local t = {}
	for _, v in next, P:GetPlayers() do if v ~= L then table.insert(t, v.Name) end end
	return t
end

task.spawn(function()
	while task.wait(0.5) do
		if _G.ST.Lp then
			local pl = P:GetPlayers()
			local r = pl[math.random(1, #pl)]
			if r ~= L then _G.ST.C(r) end
		end
	end
end)

GraphicsTab:AddSection({
    Name = "Skin Changer"
})
local d = GraphicsTab:AddDropdown({
	Name = "Select Player", 
	Default = "...", 
	Options = _G.ST.G(),
	Callback = function(v) _G.ST.C(P:FindFirstChild(v)) end
})

GraphicsTab:AddToggle({
	Name = "Random Loop", 
	Default = UserConfig.Graphics.RandomSkinLoop,
	Callback = function(v)
        UserConfig.Graphics.RandomSkinLoop = v
        _G.ST.Lp = v
        SaveConfig()
    end
})

P.PlayerAdded:Connect(function() d:Refresh(_G.ST.G(), true) end)
P.PlayerRemoving:Connect(function() d:Refresh(_G.ST.G(), true) end)

MovementTab:AddSection({
    Name = "Misc"
})
MovementTab:AddButton({
    Name = "Infinite Stamina",
    Callback = function()
        if not getfenv().firsttime then
            getfenv().firsttime = true
            
            local success = false
            
            if getgc and hookfunction and getinfo then
                for _, v in pairs(getgc(true)) do
                    if type(v) == "function" and getinfo(v).name == "setStamina" then
                        local hookSuccess = pcall(function()
                            hookfunction(v, function(...) return ..., math.huge end)
                        end)
                        
                        if hookSuccess then
                            success = true
                            break
                        end
                    end
                end
            end
            
            if success then
                OrionLib:MakeNotification({
                    Name = "Infinite Stamina",
                    Content = "Success!!",
                    Image = "rbxassetid://79390235538362",
                    Time = 5
                })
            else 
                OrionLib:MakeNotification({
                    Name = "Infinite Stamina",
                    Content = "Failed. Your exploit might not be supported for that feature.",
                    Image = "rbxassetid://79390235538362",
                    Time = 5
                })
            end
        end
    end
})

MovementTab:AddToggle({
    Name = "Inf Jump",
    Default = UserConfig.Movement.InfJump,
    Callback = function(val)
        UserConfig.Movement.InfJump = val
        getgenv().InfiniteJumpEnabled = val
        SaveConfig()
    end
})

UserInputService.JumpRequest:Connect(function()
    if getgenv().InfiniteJumpEnabled then
        local character = LocalPlayer.Character
        if character and character:FindFirstChildOfClass("Humanoid") then
            character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
        end
    end
end)

MovementTab:AddSlider({
	Name = "Camera Zoom",
	Min = 20,
	Max = 1500,
	Default = UserConfig.Movement.CameraZoom,
	Color = Color3.fromRGB(137, 207, 240),
	Increment = 10,
	ValueName = "Distance",
	Callback = function(Value)
        UserConfig.Movement.CameraZoom = Value
    LocalPlayer.CameraMaxZoomDistance = Value  
    SaveConfig()
	end
})

local radarFarmRemote = game:GetService("ReplicatedStorage")["EJw"]:FindFirstChild("5eef5a85-62d5-4a20-adc7-40c93bd7219d")
_G.RadarFarmEnabled = UserConfig.Police.RadarFarm

PoliceTab:AddSection({
    Name = "Police AutoFarm"
})
PoliceTab:AddToggle({
    Name = "RadarFarm",
    Default = UserConfig.Police.RadarFarm,
    Callback = function(val)
        UserConfig.Police.RadarFarm = val
        _G.RadarFarmEnabled = val
        if val then
            task.spawn(function()
                local lastFire = 0
                while _G.RadarFarmEnabled do
                    local now = tick()
                    if now - lastFire >= 1 then
                        local character = LocalPlayer.Character
                        if character then
                            local radarGun = character:FindFirstChild("Radar Gun")
                            if radarGun and radarFarmRemote then
                                local vehicles = workspace.Vehicles:GetChildren()
                                local primaryPart = character.PrimaryPart
                                if primaryPart then
                                    for i = 1, #vehicles do
                                        if not _G.RadarFarmEnabled then break end
                                        local driveSeat = vehicles[i]:FindFirstChild("DriveSeat")
                                        if driveSeat then
                                            radarFarmRemote:FireServer(radarGun, driveSeat.Position, (driveSeat.Position - primaryPart.Position).Unit)
                                        end
                                    end
                                end
                            end
                        end
                        lastFire = now
                    end
                    task.wait(0.1)
                end
            end)
        end
        SaveConfig()
    end
})

PoliceTab:AddButton({
    Name = "Anti AFK",
    Callback = function()
        local VirtualUser = game:service("VirtualUser")
        game:service("Players").LocalPlayer.Idled:connect(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
    end
})

_G.RadarFarm = {
    Loaded = false,
    Pos = {
        ["In Church [Below]"] = CFrame.new(-887.68, 4.97, 3071.11),
        ["In Church [Above]"] = CFrame.new(-889.29, 159.74, 3145.53),
        ["Traffic Circle"] = CFrame.new(-1145.53, 5.33, 2799.00),
        ["In Christams Tree"] = CFrame.new(-1252.00, 51.26, 2938.21),
        ["Bank"] = CFrame.new(-1286.14, 4.96, 3196.85),
        ["Under Tunnel"] = CFrame.new(84.92, -118.60, 2595.75),
        ["Container Side"] = CFrame.new(642.21, 9.58, 2566.21)
    }
}

PoliceTab:AddDropdown({
    Name = "Radar Farm Locations",
    Default = "None",
    Options = {"In Church [Below]", "In Church [Above]", "Traffic Circle", "In Christams Tree" , "Bank", "Under Tunnel", "Container Side"},
    Callback = function(v)
        if not _G.RadarFarm.Loaded then 
            _G.RadarFarm.Loaded = true 
            return 
        end

        local target = _G.RadarFarm.Pos[v]
        if not target then return end

        if _G.TeleportConfig and _G.TeleportConfig.TweenTo then
            _G.TeleportConfig.TweenTo(target)
        else
            local h = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if h then h.CFrame = target end
        end
    end    
})

PoliceTab:AddButton({
    Name = "Teleport to Police Station",
    Callback = function()
        local targetCFrame = CFrame.new(-1658.55, 5.619, 2735.71)
        _G.TeleportConfig.TweenTo(targetCFrame)
    end,
})

PoliceTab:AddSection({
    Name = "Police Options"
})

local ReplicatedStorage = game:GetService("ReplicatedStorage")

getgenv().AutoTaser = getgenv().AutoTaser or {
	Toggle = UserConfig.Police.AutoTaser,
	PredictionFactor = 0.22,
	MaxTargetDistance = 20,
	Remote = ReplicatedStorage.EJw["56fd07c4-e93d-410f-a8e5-2ce7f81aab51"]
}

local function toggleAutoTaser(value)
	getgenv().AutoTaser.Toggle = value
end

PoliceTab:AddToggle({
	Name = "Auto Taser",
	Default = UserConfig.Police.AutoTaser,
	Callback = function(Value)
        UserConfig.Police.AutoTaser = Value
		toggleAutoTaser(Value)
        SaveConfig()
	end    
})

local function isPlayerOnSeat(char)
	if not char then return false end

	local humanoid = char:FindFirstChildOfClass("Humanoid")
	if humanoid and humanoid.Sit then
		return true
	end

	local hrp = char:FindFirstChild("HumanoidRootPart")
	if hrp then
		if hrp:FindFirstAncestorOfClass("VehicleSeat") or hrp:FindFirstAncestorOfClass("Seat") then
			return true
		end
	end

	return false
end

local function getBestTarget(myChar, myHRP)
    local bestTarget = nil
    local closestDistance = getgenv().AutoTaser.MaxTargetDistance
    local players = Players:GetPlayers()
    for i = 1, #players do
        local player = players[i]
        if player ~= LocalPlayer then
            local pChar = player.Character  
            if pChar then
                local pHrp = pChar:FindFirstChild("HumanoidRootPart")
                if pHrp and pHrp:GetAttribute("IsWanted") == true then
                    local humanoid = pChar:FindFirstChildOfClass("Humanoid")
                    if humanoid and humanoid.Health > 30 and not isPlayerOnSeat(pChar) then
                        local distance = (myHRP.Position - pHrp.Position).Magnitude
                        if distance < closestDistance then
                            closestDistance = distance
                            bestTarget = pHrp
                        end
                    end
                end
            end
        end
    end
    return bestTarget
end

RunService.Heartbeat:Connect(function()
	if not getgenv().AutoTaser.Toggle then return end

	local myChar = LocalPlayer.Character
	if not myChar then return end
	
	local myHRP = myChar:FindFirstChild("HumanoidRootPart")
	if not myHRP then return end

	local taser = myChar:FindFirstChild("Taser")
	if not taser then return end

	local targetHrp = getBestTarget(myChar, myHRP)
	if not targetHrp then return end

	local velocity = targetHrp.AssemblyLinearVelocity or targetHrp.Velocity or Vector3.new(0, 0, 0)
	local predictedPos = targetHrp.Position + (velocity * getgenv().AutoTaser.PredictionFactor)
	
	getgenv().AutoTaser.Remote:FireServer(taser, predictedPos, (predictedPos - myHRP.Position).Unit)
end)

GraphicsTab:AddSection({
    Name = "Player Options"
})
local LocalPlayer = game:GetService("Players").LocalPlayer
local selectedColor = Color3.fromRGB(UserConfig.Graphics.GhostColor[1], UserConfig.Graphics.GhostColor[2], UserConfig.Graphics.GhostColor[3])
local forcefieldActive = UserConfig.Graphics.GhostMode
local rainbowActive = UserConfig.Graphics.RainbowGhost
local originalColors = {}
local rainbowConnection = nil

local function applyEffect(Value)
    local character = LocalPlayer.Character
    if not character then return end

    if Value then
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                if not originalColors[part] then
                    originalColors[part] = part.Color
                end
                part.Material = Enum.Material.ForceField
                if not rainbowActive then
                    part.Color = selectedColor
                end
            end
        end
    else
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                if originalColors[part] then
                    part.Color = originalColors[part]
                end
                part.Material = Enum.Material.SmoothPlastic
            end
        end
        originalColors = {}
    end
end

local function startRainbow()
    if rainbowConnection then
        rainbowConnection:Disconnect()
    end
    
    local hue = 0
    rainbowConnection = game:GetService("RunService").Heartbeat:Connect(function()
        if not forcefieldActive or not rainbowActive then return end
        
        local character = LocalPlayer.Character
        if character then
            hue = (hue + 0.005) % 1
            local rainbowColor = Color3.fromHSV(hue, 1, 1)
            
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    part.Color = rainbowColor
                end
            end
        end
    end)
end

local function stopRainbow()
    if rainbowConnection then
        rainbowConnection:Disconnect()
        rainbowConnection = nil
    end
    
    if forcefieldActive then
        local character = LocalPlayer.Character
        if character then
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    part.Color = selectedColor
                end
            end
        end
    end
end

GraphicsTab:AddToggle({
    Name = "Ghost Mode",
    Default = UserConfig.Graphics.GhostMode,
    Callback = function(Value)
        UserConfig.Graphics.GhostMode = Value
        forcefieldActive = Value
        applyEffect(Value)
        
        if Value and rainbowActive then
            startRainbow()
        elseif not Value then
            stopRainbow()
        end
        SaveConfig()
    end    
})

GraphicsTab:AddToggle({
    Name = "Rainbow Ghost Mode",
    Default = UserConfig.Graphics.RainbowGhost,
    Callback = function(Value)
        UserConfig.Graphics.RainbowGhost = Value
        rainbowActive = Value
        
        if Value and forcefieldActive then
            startRainbow()
        else
            stopRainbow()
        end
        SaveConfig()
    end    
})

GraphicsTab:AddColorpicker({
    Name = "Ghost Color",
    Default = selectedColor,
    Callback = function(Value)
        UserConfig.Graphics.GhostColor = {Value.R * 255, Value.G * 255, Value.B * 255}
        selectedColor = Value
        if forcefieldActive and not rainbowActive then
            local character = LocalPlayer.Character
            if character then
                for _, part in pairs(character:GetDescendants()) do
                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                        part.Color = selectedColor
                    end
                end
            end
        end
        SaveConfig()
    end	  
})

local currentTrails = {}
local attachments = {}
local selectedColor = Color3.fromRGB(UserConfig.Graphics.TrailColor[1], UserConfig.Graphics.TrailColor[2], UserConfig.Graphics.TrailColor[3])

local function createTrail(arm)
    local att0 = Instance.new("Attachment", arm)
    att0.Position = Vector3.new(0, 0, 0)
    
    local att1 = Instance.new("Attachment", arm)
    att1.Position = Vector3.new(0, -1, 0)
    
    local trail = Instance.new("Trail")
    trail.Attachment0 = att0
    trail.Attachment1 = att1
    
    trail.Color = ColorSequence.new(selectedColor)
    trail.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(0.5, 0.3),
        NumberSequenceKeypoint.new(1, 1)
    })
    
    trail.Lifetime = 1.2
    trail.WidthScale = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.8),
        NumberSequenceKeypoint.new(1, 0.2)
    })
    
    trail.LightEmission = 1
    trail.LightInfluence = 0
    trail.MinLength = 0.05
    trail.TextureMode = Enum.TextureMode.Stretch
    trail.Parent = arm
    
    return trail, att0, att1
end

GraphicsTab:AddToggle({
    Name = "Player Trail",
    Default = UserConfig.Graphics.PlayerTrail,
    Callback = function(Value)
        UserConfig.Graphics.PlayerTrail = Value
        if Value then
            local char = game.Players.LocalPlayer.Character
            if char then
                if char:FindFirstChild("Left Arm") then
                    local trailLeft, att0Left, att1Left = createTrail(char["Left Arm"])
                    table.insert(currentTrails, trailLeft)
                    table.insert(attachments, att0Left)
                    table.insert(attachments, att1Left)
                elseif char:FindFirstChild("LeftUpperArm") then
                    local trailLeft, att0Left, att1Left = createTrail(char["LeftUpperArm"])
                    table.insert(currentTrails, trailLeft)
                    table.insert(attachments, att0Left)
                    table.insert(attachments, att1Left)
                end
                
                if char:FindFirstChild("Right Arm") then
                    local trailRight, att0Right, att1Right = createTrail(char["Right Arm"])
                    table.insert(currentTrails, trailRight)
                    table.insert(attachments, att0Right)
                    table.insert(attachments, att1Right)
                elseif char:FindFirstChild("RightUpperArm") then
                    local trailRight, att0Right, att1Right = createTrail(char["RightUpperArm"])
                    table.insert(currentTrails, trailRight)
                    table.insert(attachments, att0Right)
                    table.insert(attachments, att1Right)
                end
            end
        else
            for _, trail in pairs(currentTrails) do
                trail:Destroy()
            end
            for _, att in pairs(attachments) do
                att:Destroy()
            end
            currentTrails = {}
            attachments = {}
        end
        SaveConfig()
    end    
})

GraphicsTab:AddColorpicker({
	Name = "Trail Color",
	Default = selectedColor,
	Callback = function(Value)
        UserConfig.Graphics.TrailColor = {Value.R * 255, Value.G * 255, Value.B * 255}
		selectedColor = Value
        for _, trail in pairs(currentTrails) do
            trail.Color = ColorSequence.new(selectedColor)
        end
        SaveConfig()
	end	  
})

SafetyTab:AddSection({
    Name = "Prison Options"
})
SafetyTab:AddButton({
    Name = "Break Into Prison",
    Callback = function()
        local tCF = CFrame.new(-604.77, 5.10, 3054.05)
        _G.TeleportConfig.TweenTo(tCF)
    end
})

local function teleportToCoordinates()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    
    if humanoidRootPart then
        humanoidRootPart.CFrame = CFrame.new(-592.45, 10.11, 2846.63)
    end
end

SafetyTab:AddButton({
    Name = "Break Out Of Prison",
    Callback = function()
        teleportToCoordinates()
    end    
})

SafetyTab:AddParagraph("Warning!","It could come to Anti Cheat kicks if you use Break Out Of Prison. If it doesnt work, click it multiple times.")

_G.AnimMod = {
    p = game.Players.LocalPlayer,
    ids = {cuffed = 9357137817, dead = 11019608524},
    tracks = {}
}

local c = _G.AnimMod.p.Character or _G.AnimMod.p.CharacterAdded:Wait()
local h = c:WaitForChild("Humanoid")
local hrp = c:WaitForChild("HumanoidRootPart")

function _G.AnimMod:GetTrack(name)
    if not self.tracks[name] then
        local a = Instance.new("Animation")
        a.AnimationId = "rbxassetid://" .. self.ids[name]
        self.tracks[name] = h:LoadAnimation(a)
        self.tracks[name].Looped = true
    end
    return self.tracks[name]
end

function _G.AnimMod:ApplyDead(v)
    local t = self:GetTrack("dead")
    h.PlatformStand = v
    if v then
        if h.SeatPart then h.Sit = false task.wait(0.1) end
        t:Play()
        hrp.CFrame = CFrame.new(hrp.Position, hrp.Position + hrp.CFrame.LookVector) * CFrame.Angles(-math.rad(90), 0, 0)
    else
        t:Stop()
        hrp.CFrame = CFrame.new(hrp.Position)
    end
end

AnimTab:AddSection({ Name = "Pre Emotes" })
AnimTab:AddToggle({
    Name = "Fake Cuffed",
    Default = UserConfig.Animations.FakeCuffed,
    Callback = function(v)
        UserConfig.Animations.FakeCuffed = v
        local t = _G.AnimMod:GetTrack("cuffed")
        if v then t:Play() else t:Stop() end
        SaveConfig()
    end
})

AnimTab:AddToggle({
    Name = "Fake Dead",
    Default = UserConfig.Animations.FakeDead,
    Callback = function(v)
        UserConfig.Animations.FakeDead = v
        _G.AnimMod:ApplyDead(v)
        SaveConfig()
    end
})

local JerkOffActive = UserConfig.Animations.JerkOff
AnimTab:AddToggle({
    Name = "Jerk Off",
    Default = UserConfig.Animations.JerkOff,
    Save = false,
    Flag = "JerkOffToggle",
    Callback = function(Value)
        UserConfig.Animations.JerkOff = Value
        if Value then
            if JerkOffActive then
                return
            end
            JerkOffActive = true
            local animation = Instance.new("Animation")
            animation.AnimationId = "rbxassetid://698251653"
            local animationTrack = game.Players.LocalPlayer.Character.Humanoid:LoadAnimation(animation)
            task.spawn(function()
                while JerkOffActive do
                    animationTrack:Play()
                    animationTrack:AdjustSpeed(1)
                    animationTrack.TimePosition = 0.5
                    task.wait(0.1)
                    while animationTrack.TimePosition < 0.5 do
                        task.wait(0.1)
                    end
                    animationTrack:Stop()
                end
            end)
        else
            JerkOffActive = false
            if animation and animationTrack then
                animation:Destroy()
                animationTrack:Destroy()
                animation = nil
                animationTrack = nil
            end
        end
        SaveConfig()
    end
})

local animations = {
    ["Helicopter"] = 95301257497525,
    ["Default Dance"] = 88455578674030,
    ["Sit"] = 97185364700038,
    ["Take The L"] = 78653596566468,
    ["Tank"] = 94915612757079,
    ["Vehicle"] = 108747312576405,
    ["Rizz Backflip"] = 131205329995035,
    ["Snow Surfer"] = 100663712757148,
    ["Skibidi Toilet"] = 127154705636043,
    ["Beat Da Koto Nai"] = 93497729736287,
    ["Spider"] = 87025086742503,
    ["Slickback"] = 74288964113793
}

local animationList = {}
for name, _ in pairs(animations) do
    table.insert(animationList, name)
end

local currentTrack = nil
local selectedAnimation = UserConfig.Animations.SelectedAnimation
local FakeCuffed = false
local CuffedAnimation

local function LoadAnimations()
    local Character = LocalPlayer.Character
    if Character then
        local Humanoid = Character:FindFirstChildOfClass("Humanoid")
        if Humanoid then
            local Animator = Humanoid:FindFirstChildOfClass("Animator") or Instance.new("Animator", Humanoid)
            
            local CuffedAnim = Instance.new("Animation")
            CuffedAnim.AnimationId = "rbxassetid://9357137817"
            CuffedAnimation = Animator:LoadAnimation(CuffedAnim)
        end
    end
end

LoadAnimations()
LocalPlayer.CharacterAdded:Connect(LoadAnimations)

AnimTab:AddSection({
    Name = "Custom Animations"
})

AnimTab:AddDropdown({
    Name = "Select Animation",
    Default = selectedAnimation,
    Options = animationList,
    Callback = function(value)
        UserConfig.Animations.SelectedAnimation = value
        selectedAnimation = value
        SaveConfig()
    end
})

AnimTab:AddToggle({
    Name = "Play Animation",
    Default = UserConfig.Animations.AnimationEnabled,
    Callback = function(isOn)
        UserConfig.Animations.AnimationEnabled = isOn
        if isOn then
            if currentTrack then
                currentTrack:Stop()
            end
            local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
            local Humanoid = Character:WaitForChild("Humanoid")
            local Animator = Humanoid:FindFirstChildOfClass("Animator") or Instance.new("Animator", Humanoid)
            local anim = Instance.new("Animation")
            anim.AnimationId = "rbxassetid://" .. animations[selectedAnimation]
            currentTrack = Animator:LoadAnimation(anim)
            currentTrack:Play()
        else
            if currentTrack then
                currentTrack:Stop()
            end
        end
        SaveConfig()
    end
})

local labels = {}

local function countPlayers()
    local players = game:GetService("Players"):GetPlayers()
    local counts = {
        total = #players,
        citizen = 0,
        police = 0,
        fire = 0,
        prisoner = 0,
        truck = 0,
        bus = 0,
        hars = 0
    }
    
    for _, player in pairs(players) do
        if player.Team then
            local team = player.Team.Name
            
            if team:find("Citizen") or team:find("Bürger") then
                counts.citizen = counts.citizen + 1
            elseif team:find("Police") or team:find("Polizei") then
                counts.police = counts.police + 1
            elseif team:find("Fire") or team:find("Feuerwehr") then
                counts.fire = counts.fire + 1
            elseif team:find("Prisoner") or team:find("Gefangene") then
                counts.prisoner = counts.prisoner + 1
            elseif team:find("Truck") or team:find("Spedition") then
                counts.truck = counts.truck + 1
            elseif team:find("Bus") then
                counts.bus = counts.bus + 1
            elseif team:find("HARS") then
                counts.hars = counts.hars + 1
            else
                counts.citizen = counts.citizen + 1
            end
        else
            counts.citizen = counts.citizen + 1
        end
    end
    
    return counts
end

local function updateStats()
    local c = countPlayers()
    
    labels.total:Set("Total Players: " .. c.total)
    labels.citizen:Set("Citizens: " .. c.citizen)
    labels.police:Set("Police: " .. c.police)
    labels.fire:Set("Fire Department: " .. c.fire)
    labels.prisoner:Set("Prisoners: " .. c.prisoner)
    labels.truck:Set("Truck Company: " .. c.truck)
    labels.bus:Set("Bus Company: " .. c.bus)
    labels.hars:Set("HARS: " .. c.hars)
end

StatsTab:AddSection({Name = "Server Statistics"})

labels.total = StatsTab:AddLabel("Total Players: 0")
labels.citizen = StatsTab:AddLabel("Citizens: 0")
labels.police = StatsTab:AddLabel("Police: 0")
labels.fire = StatsTab:AddLabel("Fire Department: 0")
labels.prisoner = StatsTab:AddLabel("Prisoners: 0")
labels.truck = StatsTab:AddLabel("Truck Company: 0")
labels.bus = StatsTab:AddLabel("Bus Company: 0")
labels.hars = StatsTab:AddLabel("HARS: 0")

StatsTab:AddButton({
    Name = "Refresh Stats",
    Callback = function()
        updateStats()
        OrionLib:MakeNotification({
            Name = "Stats Updated",
            Content = "Player statistics refreshed successfully!",
            Image = "rbxassetid://79390235538362",
            Time = 2
        })
    end    
})

task.spawn(function()
    while task.wait(3) do
        updateStats()
    end
end)

updateStats()

_G.TeleportConfig = _G.TeleportConfig or {}

_G.TeleportConfig.Services = {
    Players = game:GetService("Players"),
    TweenService = game:GetService("TweenService"),
    Workspace = game:GetService("Workspace")
}

_G.TeleportConfig.Data = {
    LocalPlayer = game:GetService("Players").LocalPlayer,
    VehiclesFolder = game:GetService("Workspace"):WaitForChild("Vehicles"),
    TeleportActive = false,
    TeleportSpeed = 100,
    CurrentTween = nil,
    CurrentConnection = nil,
    
    Locs = {
        Work = {
            ["Police Station"] = CFrame.new(-1658.55, 5.619, 2735.71),
            ["Fire Station"] = CFrame.new(-963.32, 5.865, 3895.37),
            ["Bus Company"] = CFrame.new(-1695.8, 5.882, -1274.29),
            ["Truck Company"] = CFrame.new(652.55, 5.638, 1510.85),
        },
        Robberies = {
            ["Bank"] = CFrame.new(-1174.68, 5.87, 3209.03),
            ["Yellow Container"] = CFrame.new(1178.71, 28.696, 2321.66),
            ["Green Container"] = CFrame.new(1182.71, 28.696, 2158.84),
            ["Jewelry"] = CFrame.new(-346.63, 5.87, 3572.74),
            ["Ares Fuel"] = CFrame.new(-870.86, 5.622, 1505.16),
            ["Gas n Go Fuel"] = CFrame.new(-1544.4, 5.619, 3802.16),
            ["Osso Fuel"] = CFrame.new(-27.55, 5.622, -754.6),
            ["Erwins Club"] = CFrame.new(-1844.95, 5.872, 3211.08),
            ["Tool Shop"] = CFrame.new(-717.23, 5.654, 729.08),
            ["Farm Shop"] = CFrame.new(-911.5, 5.371, -1169.2),
            ["Clothing Store"] = CFrame.new(479.05, 3.158, -1452.59),
        },
        Usable = {
            ["Tuning Garage"] = CFrame.new(-1429.04, 5.57, 143.96),
            ["Car Dealership"] = CFrame.new(-1454.02, 5.615, 940.83),
            ["Hospital"] = CFrame.new(-293.16, 5.627, 1053.98),
            ["Prison"] = CFrame.new(-514.34, 5.615, 2795.94),
        }
    }
}

if not _G.TeleportConfig then
    _G.TeleportConfig = {
        Data = {
            LocalPlayer = game:GetService("Players").LocalPlayer,
            VehiclesFolder = workspace:FindFirstChild("Vehicles"),
            TeleportActive = false,
            TeleportSpeed = 120,
            CurrentTween = nil,
            CurrentConnection = nil,
            Locs = { 
                Work = {},
                Robberies = {},
                Usable = {}
            }
        },
        Services = {
            TweenService = game:GetService("TweenService")
        }
    }
end

local d = _G.TeleportConfig.Data

_G.TeleportConfig.StopTeleport = function()
    if d.CurrentTween then
        d.CurrentTween:Cancel()
        d.CurrentTween = nil
    end
    
    if d.CurrentConnection then
        d.CurrentConnection:Disconnect()
        d.CurrentConnection = nil
    end
    
    d.TeleportActive = false
    
    OrionLib:MakeNotification({
        Title = "Teleport Stopped", 
        Content = "Teleportation has been stopped.", 
        Image = "rbxassetid://79707149144849", 
        Duration = 2
    })
end

_G.TeleportConfig.TweenTo = function(dest)
    if d.TeleportActive then
        _G.TeleportConfig.StopTeleport()
    end
    
    d.TeleportActive = true
    
    local c = d.LocalPlayer.Character
    local h = c and c:FindFirstChild("HumanoidRootPart")
    local hm = c and c:FindFirstChildOfClass("Humanoid")
    
    local v = d.VehiclesFolder:FindFirstChild(d.LocalPlayer.Name)
    if not v then 
        d.TeleportActive = false
        OrionLib:MakeNotification({Title = "Error", Content = "No vehicle found!", Image = "rbxassetid://79707149144849", Duration = 3})
        return 
    end

    local ds = v:FindFirstChild("DriveSeat", true) or v:FindFirstChildWhichIsA("VehicleSeat", true)
    if not ds then 
        d.TeleportActive = false
        return 
    end
    v.PrimaryPart = ds

    if hm and hm.SeatPart ~= ds then
        h.CFrame = ds.CFrame
        task.wait(0.1)
        ds:Sit(hm)
        
        local t = 0
        while hm.SeatPart ~= ds and t < 15 do
            if not d.TeleportActive then return end
            task.wait(0.1)
            t = t + 1
        end
    end

    local targetCF = (typeof(dest) == "CFrame") and dest or CFrame.new(dest)
    local targetPos = targetCF.Position

    local dropY = -5
    local currentPivot = v:GetPivot()
    local dropCF = CFrame.new(Vector3.new(currentPivot.X, dropY, currentPivot.Z))
    v:PivotTo(dropCF)
    ds.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
    ds.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
    task.wait(0.05)

    if not d.TeleportActive then return end


    local startGroundPos = Vector3.new(currentPivot.X, dropY, currentPivot.Z)
    local distance = (startGroundPos - targetPos).Magnitude

    if distance > 0.5 then
        local speedVariance = d.TeleportSpeed * (0.92 + math.random() * 0.16)
        local duration = distance / speedVariance

        local info = TweenInfo.new(
            duration,
            Enum.EasingStyle.Linear,
            Enum.EasingDirection.Out
        )

        local val = Instance.new("CFrameValue")
        val.Value = v:GetPivot()

        d.CurrentConnection = val.Changed:Connect(function(newCF)
            v:PivotTo(newCF)
            local jitter = Vector3.new(
                (math.random() - 0.5) * 0.08,
                0,
                (math.random() - 0.5) * 0.08
            )
            ds.AssemblyLinearVelocity  = jitter
            ds.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
        end)

        d.CurrentTween = _G.TeleportConfig.Services.TweenService:Create(val, info, {Value = targetCF})
        d.CurrentTween:Play()
        d.CurrentTween.Completed:Wait()

        if d.CurrentConnection then
            d.CurrentConnection:Disconnect()
            d.CurrentConnection = nil
        end
        val:Destroy()
    end
    
    d.TeleportActive = false
    d.CurrentTween = nil
end

_G.TeleportConfig.TeleportToNearestDealer = function()
    local dealers = workspace:FindFirstChild("Dealers") or workspace 
    local closest, dist = nil, math.huge
    local lpPos = d.LocalPlayer.Character.HumanoidRootPart.Position

    for _, dealer in pairs(dealers:GetDescendants()) do
        if dealer:IsA("Model") and (dealer.Name == "Dealer" or dealer:GetAttribute("Dealer")) then
            local dPart = dealer.PrimaryPart or dealer:FindFirstChildWhichIsA("BasePart", true)
            if dPart then
                local di = (lpPos - dPart.Position).Magnitude
                if di < dist then
                    dist = di
                    closest = dPart
                end
            end
        end
    end

    if closest then
        local targetPos = closest.Position + (closest.CFrame.LookVector * 10)
        _G.TeleportConfig.TweenTo(CFrame.new(targetPos, closest.Position))
    else
        OrionLib:MakeNotification({Title = "Error", Content = "No Dealer nearby.", Image = "rbxassetid://79707149144849", Duration = 3})
    end
end

_G.TeleportConfig.TeleportToNearestWantedPlayer = function()
    local closest, dist = nil, math.huge
    local lpPos = d.LocalPlayer.Character.HumanoidRootPart.Position

    for _, player in pairs(game:GetService("Players"):GetPlayers()) do
        if player ~= d.LocalPlayer and player.Character then
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            if hrp and hrp:GetAttribute("IsWanted") then
                local di = (lpPos - hrp.Position).Magnitude
                if di < dist then
                    dist = di
                    closest = hrp
                end
            end
        end
    end

    if closest then
        _G.TeleportConfig.TweenTo(closest.CFrame)
    else
        OrionLib:MakeNotification({Title = "Error", Content = "No wanted player found!", Image = "rbxassetid://79707149144849", Duration = 3})
    end
end

TeleportsTab:AddSection({ Name = "Main Control" })

TeleportsTab:AddSlider({
    Name = "Teleport Speed",
    Min = 50,
    Max = 160,
    Default = d.TeleportSpeed,
    Color = Color3.fromRGB(137, 207, 240),
    Increment = 1,
    ValueName = "Speed",
    Callback = function(v)
        d.TeleportSpeed = v
    end    
})

TeleportsTab:AddButton({
    Name = "Stop Teleport",
    Callback = function()
        _G.TeleportConfig.StopTeleport()
    end
})

TeleportsTab:AddToggle({
    Name = "Click Teleport [Only PC]",
    Default = false,
    Callback = function(Value)
        _G.WRDClickTeleport = Value

        if not _G.ClickTeleportInitialized then
            _G.ClickTeleportInitialized = true

            local mouse = LocalPlayer:GetMouse()

            UserInputService.InputBegan:Connect(function(input, gameProcessed)
                if _G.WRDClickTeleport and not gameProcessed then
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                                LocalPlayer.Character:MoveTo(mouse.Hit.Position)
                            end
                        end
                    end
                end
            end)
        end
    end
})

TeleportsTab:AddSection({ Name = "Auto Find Targets" })

TeleportsTab:AddButton({
    Name = "Nearest Wanted Player",
    Callback = function()
        _G.TeleportConfig.TeleportToNearestWantedPlayer()
    end
})

TeleportsTab:AddButton({
    Name = "Teleport to Dealer",
    Callback = function()
        _G.TeleportConfig.TeleportToNearestDealer()
    end
})

TeleportsTab:AddButton({
    Name = "Nearest Vending Machine",
    Callback = function()
        local function findNearestVendingMachine()
            local nearestPart = nil
            local closestDistance = math.huge
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("Model") and obj.Name == "Vending Machine" then
                    local light = obj:FindFirstChild("Light")
                    if light and light:IsA("BasePart") and light.Color == Color3.fromRGB(73, 147, 0) then
                        local distance = (d.LocalPlayer.Character.HumanoidRootPart.Position - light.Position).Magnitude
                        if distance < closestDistance then
                            closestDistance = distance
                            nearestPart = light
                        end
                    end
                end
            end
            return nearestPart
        end

        local part = findNearestVendingMachine()
        if part then _G.TeleportConfig.TweenTo(part.CFrame) 
        else OrionLib:MakeNotification({Title = "Error", Content = "No active vending machine found!", Duration = 3}) end
    end
})

local function addTpSection(tt, lt, fl)
    TeleportsTab:AddSection({ Name = tt })
    local k = {}
    for n in pairs(lt) do table.insert(k, n) end
    table.sort(k)
    
    TeleportsTab:AddDropdown({
        Name = "Select " .. tt,
        Options = k,
        Flag = fl
    })
    TeleportsTab:AddButton({
        Name = "Teleport to " .. tt,
        Callback = function()
            local ch = OrionLib.Flags[fl].Value
            if lt[ch] then _G.TeleportConfig.TweenTo(lt[ch]) end
        end
    })
end

addTpSection("Work Places", d.Locs.Work, "WorkTP")
addTpSection("Robberies", d.Locs.Robberies, "RobTP")
addTpSection("Usable Places", d.Locs.Usable, "UseTP")

TeleportsTab:AddSection({ Name = "Safety & Utilities" })
TeleportsTab:AddParagraph("Remove Things from Car.", "How it Works: It will teleport you to the Car Dealership. Then you need to respawn your Car. All Objects/Bombs are then removed from your Car.")

TeleportsTab:AddButton({
    Name = "Remove things from your Car",
    Callback = function()
        _G.TeleportConfig.TweenTo(CFrame.new(-1391.16, 5.47, 988.26))
    end
})

TeleportsTab:AddButton({
    Name = "Safe Leave (Kick)",
    Callback = function()
        _G.TeleportConfig.TweenTo(CFrame.new(-1243.46, -20.52, 3582.90))
        task.wait(0.5)
        LocalPlayer:Kick("Safe Leave by Flux")
    end,
})

TeleportsTab:AddButton({
    Name = "Teleport to Safe Zone",
    Callback = function()
        local targetCFrame = CFrame.new(488.569672, -148.305054, 3232.17944, 0.896970689, 0.232678249, 0.375904799, -0.0708942041, 0.914990783, -0.397197485, -0.436368644, 0.32962501, 0.837215483)
        _G.TeleportConfig.TweenTo(targetCFrame)
    end,
})

TeleportsTab:AddButton({
    Name = "Teleport to Safe Zone (2)",
    Callback = function()
        local targetCFrame = CFrame.new(987.689758, -25.9224834, 3289.76245, -0.00955616497, -0.0125832371, 0.999875188, -5.5888213e-06, 0.999920845, 0.0125837578, -0.999954343, 0.000114664341, -0.00955547858)
        _G.TeleportConfig.TweenTo(targetCFrame)
    end,
})

TeleportsTab:AddButton({
    Name = "Teleport to Safe Zone (3)",
    Callback = function()
        local targetCFrame = CFrame.new(-2020.25635, 344.818085, 3095.24707, 0.990083933, 0.00525435014, -0.140378565, 0.000128507148, 0.999265969, 0.0383087397, 0.140476808, -0.0379469059, 0.989356518)
        _G.TeleportConfig.TweenTo(targetCFrame)
    end,
})

BypassTab:AddSection({ Name = "Freecam" })
BypassTab:AddButton({
	Name = "Bypass Freecam",
	Callback = function()
		loadstring(game:HttpGet("https://pastebin.com/raw/4JrUuEqn"))()
		game.StarterGui:SetCore("SendNotification", {
			Title = "Bypass Freecam";
			Text = "Press Shift and P to Toggle Freecam Bypass";
            Image = "rbxassetid://79390235538362",
			Duration = 6
		})
	end    
})

BypassTab:AddParagraph("How to Toggle Freecam.", "To use the Freecam, you need to Press Shift + P.")

_G.ACBypass = {
    BLOCKED = {
        ["e29cfe0e-3520-40a1-8c0d-662158c150bb"] = true,
        ["e37fa0bd-4679-4293-a5e0-7a50f3b50d47"] = true,
        ["2328c9a3-b855-4e6b-abb5-14491dd3cd24"] = true
    },
    enabled = UserConfig.Bypass.AntiCheatActive,
    hook = nil,
    old = nil,
    mt = nil
}

do
    local s, f = pcall(function()
        return {getrawmetatable, setreadonly, newcclosure, getnamecallmethod}
    end)
    _G.ACBypass.supported = s and typeof(f[1]) == "function" and typeof(f[2]) == "function" and typeof(f[3]) == "function" and typeof(f[4]) == "function"

    function _G.ACBypass.enable()
        if _G.ACBypass.hook then return end
        pcall(function()
            _G.ACBypass.mt = _G.ACBypass.mt or f[1](game)
            _G.ACBypass.old = _G.ACBypass.old or _G.ACBypass.mt.__namecall
            f[2](_G.ACBypass.mt, false)
            _G.ACBypass.hook = f[3](function(self, ...)
                local m = f[4]()
                if (m == "FireServer" or m == "InvokeServer") and typeof(self) == "Instance" and (self:IsA("RemoteEvent") or self:IsA("RemoteFunction")) and _G.ACBypass.BLOCKED[self.Name] then
                    return nil
                end
                return _G.ACBypass.old(self, ...)
            end)
            _G.ACBypass.mt.__namecall = _G.ACBypass.hook
            f[2](_G.ACBypass.mt, true)
        end)
    end

    function _G.ACBypass.disable()
        if not _G.ACBypass.hook then return end
        pcall(function()
            f[2](_G.ACBypass.mt, false)
            _G.ACBypass.mt.__namecall = _G.ACBypass.old
            f[2](_G.ACBypass.mt, true)
        end)
        _G.ACBypass.hook = nil
    end
end

BypassTab:AddSection({ Name = "Anti Cheat" })
BypassTab:AddButton({
    Name = "Bypass Anti Cheat (Not Working Right Now)",
    Callback = function()
        if not _G.ACBypass.supported then 
            OrionLib:MakeNotification({
                Name = "Error",
                Content = "Your Executor is not Supported.",
                Image = "rbxassetid://79390235538362",
                Time = 5
            })
            return 
        end
        
        MiscSettings.bypassActive = not MiscSettings.bypassActive
        _G.ACBypass.enabled = MiscSettings.bypassActive
        UserConfig.Bypass.AntiCheatActive = MiscSettings.bypassActive
        
        if not MiscSettings.bypassActive then
            _G.ACBypass.disable()
            OrionLib:MakeNotification({
                Name = "Anti Cheat Bypass",
                Content = "Deactivated Anti Cheat Bypass!",
                Image = "rbxassetid://79390235538362",
                Time = 3
            })
        else
            _G.ACBypass.enable()
            OrionLib:MakeNotification({
                Name = "Anti Cheat Bypass",
                Content = "Successfully Activated Anti Cheat Bypass!",
                Image = "rbxassetid://79390235538362",
                Time = 3
            })
        end
        SaveConfig()
    end
})

BypassTab:AddParagraph("Anti Cheat Warning!","This Doesnt Fully Blocks the Anti Cheat. It only reduces the chances of being Kicked by the Anti Cheat.")

game.Players.PlayerRemoving:Connect(function(plr)
    if plr == LocalPlayer and connection then  
        connection:Disconnect()
    end
end)

SafetyTab:AddSection({ Name = "Server" })
SafetyTab:AddButton({
	Name = "Server Hop",
	Callback = function()
		RejoinToNewLobby()
	end
})

SafetyTab:AddButton({
    Name = "Rejoin",
    Callback = function()
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, game.Players.LocalPlayer)
    end,
})

function RejoinToNewLobby()
	local TeleportService = game:GetService("TeleportService")
	local PlaceId = game.PlaceId
	local Player = game.Players.LocalPlayer

	local success, response = pcall(function()
		return HttpService:JSONDecode(
			game:HttpGet("https://games.roblox.com/v1/games/"..PlaceId.."/servers/Public?sortOrder=Asc&limit=100")
		)
	end)

	if success and response and response.data then
		for _, server in pairs(response.data) do
			if server.playing < server.maxPlayers and server.id ~= game.JobId then
				TeleportService:TeleportToPlaceInstance(PlaceId, server.id, Player)
				return
			end
		end
	end

	OrionLib:MakeNotification({
		Title = "Error",
		Content = "Error 601",
        Image = "rbxassetid://79390235538362",
		Duration = 4
	})
end

local autoRejoin = UserConfig.Misc.AutoRejoin
local gameId = 7711635737

SafetyTab:AddToggle({
    Name = "Auto Rejoin when kicked",
    Default = UserConfig.Misc.AutoRejoin,
    Callback = function(value)
        UserConfig.Misc.AutoRejoin = value
        autoRejoin = value
        SaveConfig()
    end
})

game:GetService("Players").LocalPlayer.AncestryChanged:Connect(function(_, parent)
    if autoRejoin and parent == nil then
        game:GetService("TeleportService"):Teleport(gameId)
    end
end)

pcall(function()
    game:GetService("CoreGui").RobloxPromptGui.promptOverlay.ChildAdded:Connect(function(child)
        if autoRejoin and child.Name == "ErrorPrompt" then
            game:GetService("TeleportService"):Teleport(gameId)
        end
    end)
end)

antiTaserActive = UserConfig.Police.AntiTaser
antiTaserConnection = nil

function toggleAntiTaser(state)
	antiTaserActive = state

	if antiTaserActive then
		local char = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
		char:SetAttribute("Tased", false)

		antiTaserConnection = char:GetAttributeChangedSignal("Tased"):Connect(function()
			if antiTaserActive then
				char:SetAttribute("Tased", false)
			end
		end)
	else
		if antiTaserConnection then
			antiTaserConnection:Disconnect()
			antiTaserConnection = nil
		end
	end
end

PoliceTab:AddSection({
    Name = "Anti Police"
})
PoliceTab:AddToggle({
	Name = "Anti Taser",
	CurrentValue = UserConfig.Police.AntiTaser,
	Callback = function(state)
        UserConfig.Police.AntiTaser = state
		toggleAntiTaser(state)
        SaveConfig()
	end
})

PoliceTab:AddButton({
    Name = "Jump Out of Vehicle [When Cuffed]",
    Callback = function()
        local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
        if humanoid and humanoid.SeatPart then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        elseif humanoid and not humanoid.SeatPart then
            OrionLib:MakeNotification({
                Name = "Error",
                Content = "You are not in a vehicle!",
                Image = "rbxassetid://79390235538362",
                Time = 2
            })
        end
    end
})

local G = {
    player     = Players.LocalPlayer,
    remote     = ReplicatedStorage.EJw["a9c5b2a3-35a1-41cf-aa7f-faf8829409f9"],
    folder     = Instance.new("Folder", workspace),
    anchors    = {},
    lamps      = {},
    attach     = false,
    target     = nil,
    fling      = false,
    radius     = 1,
    rotSpeed   = 120,
    height     = 0,
    lampESP    = false,
    playerESP  = false,
    lampHL     = {},
    playerHL   = nil,
    playerBB   = nil,
    search     = "",
    dropdown   = nil,
}

local function getVehicle()
    for _, v in ipairs(workspace.Vehicles:GetChildren()) do
        if v:FindFirstChild("Owner") and v.Owner.Value == G.player.Name then return v end
    end
    return workspace.Vehicles:FindFirstChild(G.player.Name .. "sVehicle")
        or workspace.Vehicles:FindFirstChildWhichIsA("Model")
end

local function getStreetlamps()
    local t = {}
    for _, mod in ipairs(workspace.Roads.Modules:GetChildren()) do
        if mod:FindFirstChild("Streetlamps") then
            for _, lamp in ipairs(mod.Streetlamps:GetChildren()) do
                local part = lamp:IsA("BasePart") and lamp
                    or lamp.PrimaryPart
                    or lamp:FindFirstChildWhichIsA("BasePart")
                if part then table.insert(t, { model = lamp, part = part }) end
            end
        end
    end
    return t
end

local function detach(part)
    for _, v in ipairs(part:GetChildren()) do
        if v:IsA("AlignPosition") or v:IsA("Attachment") then v:Destroy() end
    end
end

local function cleanup()
    for i, d in ipairs(G.lamps) do
        if d.part and d.part.Parent then detach(d.part) end
        if G.anchors[i] then G.anchors[i]:Destroy() end
    end
    G.anchors, G.lamps = {}, {}
end

local function attachLamp(part, anchor)
    for _, v in ipairs(part:GetChildren()) do
        if v:IsA("AlignPosition") or v:IsA("Attachment") or v:IsA("Torque") then v:Destroy() end
    end
    part.CustomPhysicalProperties = PhysicalProperties.new(0.0001, 0, 0, 0, 0)
    part.CanCollide = false
    local a0 = Instance.new("Attachment", part)
    local a1 = Instance.new("Attachment", anchor)
    local ap = Instance.new("AlignPosition", part)
    ap.MaxForce, ap.MaxVelocity, ap.Responsiveness = 9999999999, math.huge, 200
    ap.Attachment0, ap.Attachment1 = a0, a1
end

local function startLamps()
    cleanup()
    G.lamps = getStreetlamps()
    for i, d in ipairs(G.lamps) do
        local a = Instance.new("Part", G.folder)
        a.Anchored, a.CanCollide, a.Transparency = true, false, 1
        a.Size = Vector3.new(1, 1, 1)
        G.anchors[i] = a
        attachLamp(d.part, a)
    end
end


local function clearLampESP()
    for _, h in ipairs(G.lampHL) do if h and h.Parent then h:Destroy() end end
    G.lampHL = {}
end

local function applyLampESP()
    clearLampESP()
    if not G.lampESP then return end
    for _, d in ipairs(getStreetlamps()) do
        local h = Instance.new("Highlight")
        h.FillColor       = Color3.fromRGB(255, 200, 0)
        h.OutlineColor    = Color3.fromRGB(255, 230, 0)
        h.FillTransparency, h.OutlineTransparency = 0.5, 0
        h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        h.Adornee, h.Parent = d.model, d.model
        table.insert(G.lampHL, h)
    end
end

local function clearPlayerESP()
    if G.playerHL and G.playerHL.Parent then G.playerHL:Destroy() end
    if G.playerBB and G.playerBB.Parent then G.playerBB:Destroy() end
    G.playerHL, G.playerBB = nil, nil
end

local function applyPlayerESP(p)
    clearPlayerESP()
    if not G.playerESP then return end
    local char = p and p.Character
    local hrp  = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    G.playerHL = Instance.new("Highlight")
    G.playerHL.FillColor, G.playerHL.OutlineColor = Color3.fromRGB(220, 30, 30), Color3.fromRGB(255, 80, 80)
    G.playerHL.FillTransparency, G.playerHL.OutlineTransparency = 0.35, 0
    G.playerHL.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    G.playerHL.Adornee, G.playerHL.Parent = char, workspace

    G.playerBB = Instance.new("BillboardGui")
    G.playerBB.Size        = UDim2.new(0, 120, 0, 30)
    G.playerBB.StudsOffset = Vector3.new(0, 4, 0)
    G.playerBB.AlwaysOnTop = true
    G.playerBB.Adornee, G.playerBB.Parent = hrp, workspace

    local lbl = Instance.new("TextLabel", G.playerBB)
    lbl.Size, lbl.BackgroundTransparency = UDim2.new(1,0,1,0), 1
    lbl.Text, lbl.TextColor3 = p.Name, Color3.fromRGB(255, 90, 90)
    lbl.Font, lbl.TextSize = Enum.Font.GothamBold, 13
end


FlingTab:AddSection({ Name = "Fling" })
FlingTab:AddToggle({ Name = "Fling Selected Player", Default = false, Callback = function(v)
    G.fling = v
    if G.fling then
        task.spawn(function()
            while G.fling do
                local veh = getVehicle()
                local ok, lamps = pcall(getStreetlamps)
                if ok and #lamps > 0 and veh then
                    for _, d in ipairs(lamps) do
                        if not G.fling then break end
                        if d.model and d.model.Parent then
                            pcall(function() G.remote:FireServer(veh, d.model) end)
                            task.wait(0.05)
                        end
                    end
                end
                task.wait(0.5)
            end
        end)
    end
end })

FlingTab:AddSection({ Name = "ESP" })
FlingTab:AddToggle({ Name = "Lamp ESP",   Default = false, Callback = function(v) G.lampESP   = v; if v then applyLampESP() else clearLampESP() end end })

FlingTab:AddSection({ Name = "Settings" })
FlingTab:AddSlider({ Name = "Radius",         Min = 1,  Max = 500, Default = 1,   Color = Color3.fromRGB(210,30,30),   Increment = 2,  ValueName = "Studs", Callback = function(v) G.radius   = v end })
FlingTab:AddSlider({ Name = "Rotation Speed", Min = 15, Max = 300, Default = 120, Color = Color3.fromRGB(255,255,255), Increment = 15, ValueName = "Speed", Callback = function(v) G.rotSpeed = v end })

local function filteredPlayers()
    local t = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if G.search == "" or string.find(string.lower(p.Name), string.lower(G.search)) then
            table.insert(t, p.Name)
        end
    end
    return t
end

FlingTab:AddSection({ Name = "Target" })
FlingTab:AddTextbox({ Name = "Search Player", Default = "", TextDisappear = false, Callback = function(v)
    G.search = v
    G.dropdown:Refresh(filteredPlayers(), true)
end })

G.dropdown = FlingTab:AddDropdown({ Name = "Select Player to Attach", Default = "", Options = filteredPlayers(), Callback = function(v)
    local p = Players:FindFirstChild(v)
    if p and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
        G.target, G.attach = p.Character.HumanoidRootPart, true
        startLamps()
        if G.playerESP then applyPlayerESP(p) end
        OrionLib:MakeNotification({ Name = "Success", Content = "Attached to " .. v, Time = 3 })
    end
end })

task.spawn(function()
    while true do task.wait(10); if G.dropdown then G.dropdown:Refresh(filteredPlayers(), true) end end
end)

FlingTab:AddSection({ Name = "Detach" })
FlingTab:AddButton({ Name = "Detach All", Callback = function()
    G.attach, G.target = false, nil
    cleanup(); clearPlayerESP()
    OrionLib:MakeNotification({ Name = "Detached", Content = "All lamps released", Time = 3 })
end })


RunService.Heartbeat:Connect(function()
    if not G.attach or not G.target or not G.target.Parent then return end
    local c, n = G.target.Position, #G.lamps
    if n == 0 then return end
    for i, a in ipairs(G.anchors) do
        if a and a.Parent then
            local ang = (i / n) * math.pi * 2 + tick() * (G.rotSpeed / 10)
            a.CFrame = CFrame.new(c.X + math.cos(ang) * G.radius, c.Y + G.height, c.Z + math.sin(ang) * G.radius)
        end
    end
end)

RunService.Heartbeat:Connect(function()
    if not G.lampESP then return end
    for i = #G.lampHL, 1, -1 do
        if not G.lampHL[i] or not G.lampHL[i].Parent then table.remove(G.lampHL, i) end
    end
end)

OrionLib:Init()
