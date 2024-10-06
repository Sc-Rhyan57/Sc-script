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


--//Serviços\\--
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remotesFolder = ReplicatedStorage:WaitForChild("RemotesFolder")

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local localPlayer = Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")
local remotesFolder = ReplicatedStorage:WaitForChild("RemotesFolder")
local createElevator = remotesFolder:WaitForChild("CreateElevator")
local createElevator = game:GetService("ReplicatedStorage"):WaitForChild("RemotesFolder"):WaitForChild("CreateElevator")
local createElevatorFrame = game:GetService("Players").LocalPlayer.PlayerGui.MainUI.LobbyFrame.CreateElevator
local presetName, destination, maxPlayers, friendsOnly = "", "Hotel", 4, true
local data = {}

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


--//New System Presets\\--
local PresetManager = {}
PresetManager.PresetData = {}
PresetManager.PresetList = {}

function PresetManager:BuildPresetStructure()
    if not isfolder(".seekerLobby/doors/presets") then
        makefolder(".seekerLobby/doors/presets")
    end
end

function PresetManager:CreatePreset(name, data)
    if isfile(".seekerLobby/doors/presets/" .. name .. ".json") then
        return false, "Preset já existe!"
    end

    local presetData = {
        Floor = data.Floor or "Hotel",
        MaxPlayers = data.MaxPlayers or 1,
        Modifiers = data.Modifiers or {},
        FriendsOnly = data.FriendsOnly or true
    }
    
    self:BuildPresetStructure()
    writefile(".seekerLobby/doors/presets/" .. name .. ".json", HttpService:JSONEncode(presetData))
    return true, "Preset criado com sucesso!"
end

function PresetManager:LoadPresets()
    self.PresetList = {}
    self.PresetData = {}

    for _, file in pairs(listfiles(".seekerLobby/doors/presets")) do
        local success, data = pcall(function()
            return HttpService:JSONDecode(readfile(file))
        end)

        if success then
            local name = self:GetFileNameFromPath(file)
            self.PresetData[name] = data
            table.insert(self.PresetList, name)
        else
            warn("Failed to load preset: " .. file)
        end
    end

    return self.PresetList
end

function PresetManager:GetFileNameFromPath(path)
    local fileExtension = ".json"
    path = path:gsub("\\", "/")
    local pos = path:find("/[^/]*$")
    
    if pos then
        return path:sub(pos + 1, -#fileExtension - 1)
    end
end

function PresetManager:LoadPreset(name)
    local presetData = self.PresetData[name]
    
    if not presetData then
        return false, "Preset não encontrado!"
    end
    
    local data = {
        ["FriendsOnly"] = presetData.FriendsOnly,
        ["Destination"] = presetData.Floor,
        ["Mods"] = presetData.Modifiers or {},
        ["MaxPlayers"] = tostring(presetData.MaxPlayers)
    }

    createElevator:FireServer(data)

    return true, "Preset carregado: " .. name
end

function PresetManager:DeletePreset(name)
    if isfile(".seekerLobby/doors/presets/" .. name .. ".json") then
        delfile(".seekerLobby/doors/presets/" .. name .. ".json")
        self.PresetData[name] = nil
        return true, "Preset deletado: " .. name
    else
        return false, "Preset não encontrado!"
    end
end

function PresetManager:OverridePreset(name, data)
    local presetData = {
        Floor = data.Floor or "Hotel",
        MaxPlayers = data.MaxPlayers or 1,
        Modifiers = data.Modifiers or {},
        FriendsOnly = data.FriendsOnly or true
    }

    writefile(".seekerLobby/doors/presets/" .. name .. ".json", HttpService:JSONEncode(presetData))
    return true, "Preset sobrescrito: " .. name
end

local Window = OrionLib:MakeWindow({
    Name = "Gerenciamento de Presets",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "OrionPresets"
})

local Tab = Window:MakeTab({
    Name = "Presets",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

Tab:AddTextbox({
    Name = "Nome do Preset",
    Default = "",
    TextDisappear = true,
    Callback = function(value)
        _G.PresetName = value
    end
})

Tab:AddButton({
    Name = "Criar Preset",
    Callback = function()
        if _G.PresetName then
            local success, message = PresetManager:CreatePreset(_G.PresetName, {
                Floor = "Hotel",
                MaxPlayers = 4,
                FriendsOnly = true,
                Modifiers = {"RetroMode"}
            })
            OrionLib:MakeNotification({
                Name = success and "Sucesso" or "Erro",
                Content = message,
                Image = "rbxassetid://4483345998",
                Time = 5
            })

            local newOptions = PresetManager:LoadPresets()
            Tab:SetDropdown("Selecione um Preset", newOptions)
        end
    end
})

local PresetDropdown = Tab:AddDropdown({
    Name = "Selecione um Preset",
    Default = "",
    Options = PresetManager:LoadPresets(),
    Callback = function(selectedPreset)
        _G.SelectedPreset = selectedPreset
    end
})

Tab:AddButton({
    Name = "Carregar Preset",
    Callback = function()
        if _G.SelectedPreset then
            local success, message = PresetManager:LoadPreset(_G.SelectedPreset)
            OrionLib:MakeNotification({
                Name = success and "Sucesso" or "Erro",
                Content = message,
                Image = "rbxassetid://4483345998",
                Time = 5
            })
        end
    end
})

Tab:AddButton({
    Name = "Deletar Preset",
    Callback = function()
        if _G.SelectedPreset then
            local success, message = PresetManager:DeletePreset(_G.SelectedPreset)
            OrionLib:MakeNotification({
                Name = success and "Sucesso" or "Erro",
                Content = message,
                Image = "rbxassetid://4483345998",
                Time = 5
            })

            local newOptions = PresetManager:LoadPresets()
            PresetDropdown:SetOptions(newOptions)
        end
    end
})

Tab:AddButton({
    Name = "Sobrescrever Preset",
    Callback = function()
        if _G.SelectedPreset then
            local success, message = PresetManager:OverridePreset(_G.SelectedPreset, {
                Floor = "Hotel",
                MaxPlayers = 5,
                FriendsOnly = false,
                Modifiers = {"HardMode"}
            })
            OrionLib:MakeNotification({
                Name = success and "Sucesso" or "Erro",
                Content = message,
                Image = "rbxassetid://4483345998",
                Time = 5
            })
        end
    end
})

Tab:AddButton({
    Name = "Atualizar Presets",
    Callback = function()
        local newOptions = PresetManager:LoadPresets()
        PresetDropdown:SetOptions(newOptions)
        OrionLib:MakeNotification({
            Name = "Atualizado",
            Content = "Lista de presets atualizada!",
            Image = "rbxassetid://4483345998",
            Time = 5
        })
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

local function CreateRetroModeElevator()
    data = {
        ["FriendsOnly"] = friendsOnly,
        ["Destination"] = destination,
        ["Mods"] = {"RetroMode"},
        ["MaxPlayers"] = tostring(maxPlayers)
    }

    local success, err = pcall(function()
        createElevator:FireServer(data)
    end)

    if success then
        OrionLib:MakeNotification({
            Name = "Sucesso",
            Content = "Elevador Retro criado com sucesso!",
            Time = 5
        })
    else
        OrionLib:MakeNotification({
            Name = "Erro",
            Content = "Falha ao criar o Elevador Retro: " .. err,
            Time = 5
        })
    end
end

local function CreateElevator()
    data = {
        ["FriendsOnly"] = friendsOnly,
        ["Destination"] = destination,
        ["Mods"] = {},
        ["MaxPlayers"] = tostring(maxPlayers)
    }

    local success, err = pcall(function()
        createElevator:FireServer(data)
    end)

    if success then
        OrionLib:MakeNotification({
            Name = "Sucesso",
            Content = "Elevador criado com sucesso!",
            Time = 5
        })
    else
        OrionLib:MakeNotification({
            Name = "Erro",
            Content = "Falha ao criar o elevador: " .. err,
            Time = 5
        })
    end
end


local function SetupElevatorUI()

    local MainTab = Window:MakeTab({
        Name = "Elevadores",
        Icon = "rbxassetid://4483345998",
        PremiumOnly = false
    })

    MainTab:AddParagraph("Elevator Controls", "Gerencie e crie elevadores com as configurações desejadas.")

    -- Input para o nome do preset
    MainTab:AddTextbox({
        Name = "Nome do Preset",
        Default = "",
        TextDisappear = true,
        Callback = function(Value)
            presetName = Value
        end
    })

    MainTab:AddButton({
        Name = "Criar Elevador Retro",
        Callback = function()
            CreateRetroModeElevator()
        end
    })

    MainTab:AddButton({
        Name = "Criar Elevador",
        Callback = function()
            CreateElevator()
        end
    })

    MainTab:AddDropdown({
        Name = "Destino do Elevador",
        Default = "Hotel",
        Options = {"Hotel", "Rooms", "Backdoor"},
        Callback = function(Value)
            destination = Value
        end
    })

    MainTab:AddSlider({
        Name = "Número Máximo de Jogadores",
        Min = 1,
        Max = 12,
        Default = 4,
        Color = Color3.fromRGB(255,255,255),
        Increment = 1,
        ValueName = "Jogadores",
        Callback = function(Value)
            maxPlayers = Value
        end    
    })

    MainTab:AddToggle({
        Name = "Somente Amigos",
        Default = true,
        Callback = function(Value)
            friendsOnly = Value
        end
    })

    MainTab:AddToggle({
        Name = "Modo Hard",
        Default = false,
        Callback = function(Value)
            if Value then
                table.insert(data.Mods, "HardMode")
            end
        end
    })
end

SetupElevatorUI()

-- Notificação de carregamento completo
OrionLib:MakeNotification({
    Name = "Sistema Carregado",
    Content = "Gerenciador de Elevadores pronto!",
    Time = 5
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
