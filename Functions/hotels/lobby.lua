local OrionLib = loadstring(game:HttpGetAsync('https://raw.githubusercontent.com/shlexware/Orion/main/source'))()
local Window = OrionLib:MakeWindow({IntroText = "Seeker Hub × Paint", Name = "🚪 Rseeker Lobby", HidePremium = false, SaveConfig = true, ConfigFolder = ".seekerLobby"})

local sound = Instance.new("Sound")
sound.SoundId = "rbxassetid://4590656842"
sound.Volume = 2
sound.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
sound:Play()
sound.Ended:Connect(function()
    sound:Destroy()
end)
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "🔔 Notificação | Rseeker System",
    Text = "⚙️ • Rseeker Lobby Carregado.",
    Icon = "rbxassetid://123071339850669",
    Duration = 5
})

--// BlackList \\--
local HttpService = game:GetService("HttpService")

local function getBlacklist()
    local url = "https://raw.githubusercontent.com/Sc-Rhyan57/Sc-script/refs/heads/main/system/blacklist.lua"
    local response = HttpService:GetAsync(url)
    local blacklist = HttpService:JSONDecode(response)
    return blacklist
end

--//Serviços\\--
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remotesFolder = ReplicatedStorage:WaitForChild("RemotesFolder")
local createElevator = remotesFolder:WaitForChild("CreateElevator")

local Script = {
    ElevatorPresetData = {},
    ElevatorPresets = {}
}

local function EnforceTypes(args, template)
    args = type(args) == "table" and args or {}

    for key, value in pairs(template) do
        local argValue = args[key]
        if argValue == nil or (value ~= nil and type(argValue) ~= type(value)) then
            args[key] = value
        elseif type(value) == "table" then
            args[key] = EnforceTypes(argValue, value)
        end
    end

    return args
end

local function BuildPresetStructure()
    if not isfolder(".seekerLobby/presets") then
        makefolder(".seekerLobby/presets")
    end
end

local function CreatePreset(name, data)
    local presetData = EnforceTypes(data, {
        Floor = "Hotel",
        MaxPlayers = 1,
        Modifiers = nil,
        FriendsOnly = true
    })
    BuildPresetStructure()
    writefile(".seekerLobby/presets/" .. name .. ".json", HttpService:JSONEncode(presetData))
end

local function LoadPresets()
    table.clear(Script.ElevatorPresets)
    table.clear(Script.ElevatorPresetData)

    for _, file in pairs(listfiles(".seekerLobby/presets")) do
        local success, ret = pcall(function()
            local data = readfile(file)
            return HttpService:JSONDecode(data)
        end)

        if success then
            local name = file:match("([^/]+)%.json$")
            Script.ElevatorPresetData[name] = EnforceTypes(ret, {
                Floor = "Hotel",
                MaxPlayers = 1,
                Modifiers = nil,
                FriendsOnly = true
            })
            table.insert(Script.ElevatorPresets, name)
        else
            warn("[ SeekerLogs ] Falha ao carregar:" .. file)
        end
    end
end

local function LoadPreset(name)
    BuildPresetStructure()
    local success, ret = pcall(function()
        local data = readfile(".seekerLobby/presets/" .. name .. ".json")
        return HttpService:JSONDecode(data)
    end)

    if success then
        local presetData = EnforceTypes(ret, {
            Floor = "Hotel",
            MaxPlayers = 1,
            Modifiers = nil,
            FriendsOnly = true
        })

        local data = {
            ["FriendsOnly"] = presetData.FriendsOnly,
            ["Destination"] = presetData.Floor,
            ["Mods"] = presetData.Modifiers or {},
            ["MaxPlayers"] = tostring(presetData.MaxPlayers)
        }
createElevator:FireServer(data)
        local sound = Instance.new("Sound")
sound.SoundId = "rbxassetid://3458224686"
sound.Volume = 1
sound.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
sound:Play()
sound.Ended:Connect(function()
    sound:Destroy()
end)
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "🔔 Notificação | Seeker Lobby",
    Text = "Sucesso ao Carregar predefinição.",
    Icon = "rbxassetid://13264701341",
    Duration = 5
})
    else
        warn("[Seeker Logs] Falha ao Carregar a Predefinição: " .. name)
    end
end

local ElevatorTab = Window:MakeTab({
    Name = "Predefinições de Elevadores",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

ElevatorTab:AddTextbox({
    Name = "Nome da Predefinição",
    Default = "",
    TextDisappear = false,
    Callback = function(Value)
        Script.PresetName = Value
    end
})

ElevatorTab:AddButton({
    Name = "Criar Predefinição",
    Callback = function()
        if isfile(".seekerLobby/presets/" .. Script.PresetName .. ".json") then

                local sound = Instance.new("Sound")
sound.SoundId = "rbxassetid://4590657391"
sound.Volume = 1
sound.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
sound:Play()
sound.Ended:Connect(function()
    sound:Destroy()
end)
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "🔔 Notificação | Seeker Lobby",
    Text = "Predefinição Já existe!",
    Icon = "rbxassetid://13264701341",
    Duration = 5
})
            
        else
            local presetData = {
                Floor = "Hotel",
                MaxPlayers = 1,
                Modifiers = {}, 
                FriendsOnly = true
            }
            CreatePreset(Script.PresetName, presetData)
            LoadPresets() 
        end
    end
})

ElevatorTab:AddDropdown({
    Name = "Preset List",
    Options = Script.ElevatorPresets,
    Callback = function(Value)
        Script.SelectedPreset = Value
    end
})

ElevatorTab:AddButton({
    Name = "Carregar Preset",
    Callback = function()
        LoadPreset(Script.SelectedPreset)
    end
})

ElevatorTab:AddButton({
    Name = "Deletar Preset",
    Callback = function()
        if not isfile(".seekerLobby/presets/" .. Script.SelectedPreset .. ".json") then
            
                local sound = Instance.new("Sound")
sound.SoundId = "rbxassetid://4590657391"
sound.Volume = 1
sound.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
sound:Play()
sound.Ended:Connect(function()
    sound:Destroy()
end)
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "🔔 Notificação | Seeker Lobby",
    Text = "Predefinição Inexistente!",
    Icon = "rbxassetid://13264701341",
    Duration = 5
})
                
        else
            delfile(".seekerLobby/presets/" .. Script.SelectedPreset .. ".json")
            LoadPresets()  -- Recarrega a lista de presets após deletar
        end
    end
})

ElevatorTab:AddButton({
    Name = "Refresh Presets",
    Callback = function()
        LoadPresets()
    end
})

local Script = {
    CurrentBadge = 0,
    Achievements = {
        "SurviveWithoutHiding",
        "SurviveGloombats",
        "SurviveSeekMinesSecond",
        "TowerHeroesGoblino",
        "EscapeBackdoor",
        "SurviveFiredamp",
        "CrucifixDread",
        "EnterRooms",
        "EncounterVoid",
        "Join",
        "DeathAmt100",
        "UseCrucifix",
        "EncounterSpider",
        "SurviveHalt",
        "SurviveRush",
        "DeathAmt10",
        "Revive",
        "PlayFriend",
        "SurviveNest",
        "CrucifixFigure",
        "CrucifixAmbush",
        "PlayerBetrayal",
        "SurviveEyes",
        "KickGiggle",
        "EscapeMines",
        "GlowstickGiggle",
        "DeathAmt1",
        "SurviveSeek",
        "UseRiftMutate",
        "CrucifixGloombatSwarm",
        "SurviveScreech",
        "SurviveDread",
        "SurviveSeekMinesFirst",
        "CrucifixHalt",
        "TowerHeroesVoid",
        "JoinLSplash",
        "CrucifixDupe",
        "EncounterGlitch",
        "JeffShop",
        "CrucifixScreech",
        "SurviveGiggle",
        "EscapeHotelMod1",
        "SurviveDupe",
        "CrucifixRush",
        "EscapeBackdoorHunt",
        "EscapeHotel",
        "CrucifixGiggle",
        "EscapeFools",
        "UseRift",
        "SpecialQATester",
        "EscapeRetro",
        "TowerHeroesHard",
        "EnterBackdoor",
        "EscapeRooms1000",
        "EscapeRooms",
        "EscapeHotelMod2",
        "EncounterMobble",
        "CrucifixGrumble",
        "UseHerbGreen",
        "CrucifixSeek",
        "JeffTipFull",
        "SurviveFigureLibrary",
        "TowerHeroesHotel",
        "CrucifixEyes",
        "BreakerSpeedrun",
        "SurviveAmbush",
        "SurviveHide",
        "JoinAgain"
    }
}

local function LoopAchievements()
    task.spawn(function()
        while OrionLib.Flags["LoopAchievements"].Value do
            if Script.CurrentBadge >= #Script.Achievements then
                Script.CurrentBadge = 0
            end
            Script.CurrentBadge = Script.CurrentBadge + 1
            local randomAchievement = Script.Achievements[Script.CurrentBadge]
            remotesFolder.FlexAchievement:FireServer(randomAchievement)
            task.wait(OrionLib.Flags["LoopAchievementsSpeed"].Value)
        end
    end)
end

local AchievementTab = Window:MakeTab({
    Name = "Achievements",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

AchievementTab:AddToggle({
    Name = "Loop Achievements",
    Default = false,
    Flag = "LoopAchievements",
    Callback = function(Value)
        if Value then
            LoopAchievements()
        end
    end
})

AchievementTab:AddSlider({
    Name = "Loop Speed",
    Min = 0.05,
    Max = 1,
    Default = 0.1,
    Color = Color3.fromRGB(255, 0, 0),
    Increment = 0.01,
    Flag = "LoopAchievementsSpeed",
    Callback = function(Value)
    end
})

local CreditsTab = Window:MakeTab({
    Name = "Creditos",
    Icon = "rbxassetid://14255000409",
    PremiumOnly = false
})
local CreditsTab = Window:MakeTab({
    Name = "Creditos",
    Icon = "rbxassetid://14255000409",
    PremiumOnly = false
})
local CdSc = CreditsTab:AddSection({
    Name = "Créditos"
})

CdSc:AddParagraph("Rhyan57", "Criador do RSeeker hub.")
CdSc:AddParagraph("SeekAlegriaFla", "Pensador das funções e programador")

local Livraria = CreditsTab:AddSection({
    Name = "Livrarias"
})

Livraria:AddParagraph("Mstudio45", "Disponibilizou a API de esps para uso")
Livraria:AddParagraph("MsPaint V2", "Algun Recursos/funções foram feitas com base no código da MsPaint")
OrionLib:Init()
