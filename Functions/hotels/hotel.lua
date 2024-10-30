local OrionLib = loadstring(game:HttpGetAsync('https://raw.githubusercontent.com/Giangplay/Script/main/Orion_Library_PE_V2.lua'))()
local Window = OrionLib:MakeWindow({IntroText = "Seeker Hub × Paint", Name = "👁️ | RSeeKer Hub", HidePremium = false, SaveConfig = true, ConfigFolder = ".seeker"})
--// APIS \\--
--[[ MSDOORS API ]]--
local MsdoorsNotify = loadstring(game:HttpGet("https://raw.githubusercontent.com/Sc-Rhyan57/Notification-doorsAPI/refs/heads/main/Msdoors/MsdoorsApi.lua"))()
--[[[ MS ESP(@mstudio45) - thanks for the API! ]]--
local ESPLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/MS-ESP/refs/heads/main/source.lua"))()

local sound = Instance.new("Sound")
sound.SoundId = "rbxassetid://4590657171"
sound.Volume = 3
sound.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
sound:Play()
sound.Ended:Connect(function()
    sound:Destroy()
end)
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "🔔 Notificação | Rseeker System",
    Text = "O Menu foi iniciado com sucesso!(Caso não tenha aparece nenhuma função eles está quebrado ou em manutenção! 🤝)",
    Icon = "rbxassetid://123071339850669",
    Duration = 5
})

if game.PlaceId == 6516141723 then
    OrionLib:MakeNotification({
        Name = "Error",
        Content = "Por favor, execute quando estiver no jogo, não no lobby.",
        Time = 2
    })
MsdoorsNotify("Aviso", "Por favor, execute quando estiver no jogo, não no lobby.", "rbxassetid://123071339850669", Color3.new(1, 0, 0), 5)
end

--// Serviços \\--
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local TextChatService = game:GetService("TextChatService")
local UserInputService = game:GetService("UserInputService")
local PathfindingService = game:GetService("PathfindingService")
local ProximityPromptService = game:GetService("ProximityPromptService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local LatestRoom = ReplicatedStorage:WaitForChild("GameData"):WaitForChild("LatestRoom")

--// Tabela de Itens Prompt \\--
local PromptTable = {
    GamePrompts = {},
    Aura = {
        ["ActivateEventPrompt"] = false,
        ["FusesPrompt"] = true,
        ["HerbPrompt"] = false,
        ["LeverPrompt"] = true,
        ["LootPrompt"] = true,
        ["SkullPrompt"] = false,
        ["ValvePrompt"] = true,
    },
    Clip = {
        "AwesomePrompt",
        "FusesPrompt",
        "HerbPrompt",
        "LeverPrompt",
        "LootPrompt",
        "ValvePrompt",
        "LeverForGate",
        "LiveBreakerPolePickup",
        "LiveHintBook",
        "Button",
    },
    Excluded = {
        Prompt = {
            "HintPrompt",
            "HidePrompt",
            "InteractPrompt"
        },
        Parent = {
            "KeyObtainFake",
            "Padlock"
        },
        ModelAncestor = {
            "DoorFake"
        }
    }
}
--// VARIÁVEIS \\--
local autoLootEnabled = false
-- AUTO LOOT
local autoLootAtivo = false
local function AutoLoot()
    while autoLootAtivo do
        for _, comodo in pairs(workspace.CurrentRooms:GetChildren()) do
            local assets = comodo:FindFirstChild("Assets")
            if assets then
                for _, v in pairs(assets:GetChildren()) do
                    if v.Name == "ChestBox" or 
                       v.Name == "GoldPile" or 
                       v.Name == "Crucifix" or 
                       v.Name == "KeyObtain" or 
                       v.Name == "Gold" or
                       v.Name == "LootPrompt" or 
                       v.Name == "LeverPrompt" or 
                       v.Name == "SkullPrompt" or
                       v.Name == "UnlockPrompt" or
                       v.Name == "ValvePrompt" then

                        local prompt = v:FindFirstChildWhichIsA("ProximityPrompt")
                        if prompt and prompt.Enabled then
                            fireproximityprompt(prompt)
                        end
                    end
                end
            end
        end
        wait(0.1)
    end
end

-- [ ESP, TRAÇOS ETC... ]--
-- OBJETOS ESP
local objetos_esp = { 
    {"KeyObtain", "Chave", Color3.fromRGB(0, 255, 0)},
    {"LeverForGate", "Alavanca", Color3.fromRGB(0, 255, 0)},
    {"ElectricalKeyObtain", "Chave elétrica", Color3.fromRGB(0, 255, 0)},
    {"LiveHintBook", "Livro", Color3.fromRGB(0, 255, 0)},
    {"LiveBreakerPolePickup", "Disjuntor", Color3.fromRGB(0, 255, 0)},
    {"MinesGenerator", "Gerador", Color3.fromRGB(0, 255, 0)},
    {"MinesGateButton", "Botão do portão", Color3.fromRGB(0, 255, 0)},
    {"FuseObtain", "Fusível", Color3.fromRGB(0, 255, 0)},
    {"MinesAnchor", "Torre", Color3.fromRGB(0, 255, 0)},
    {"WaterPump", "Bomba de água", Color3.fromRGB(0, 255, 0)}
}

local espAtivosObjetos = {}
local espAtivoObjetos = false
local verificarEspObjetos = false

local function encontrarObjetosEsp(nomeObjeto)
    local objetosEncontrados = {}
    for _, objeto in ipairs(workspace:GetDescendants()) do
        if objeto.Name == nomeObjeto then
            table.insert(objetosEncontrados, objeto)
        end
    end
    return objetosEncontrados
end

local function aplicarESPObjetos(objeto, nome, cor)
    local highlightColor = cor or BrickColor.random().Color

    local Tracer = ESPLibrary.ESP.Tracer({
        Model = objeto,
        MaxDistance = 5000,
        From = "tracerDirection",
        Color = highlightColor
    })

    local Billboard = ESPLibrary.ESP.Billboard({
        Name = nome,
        Model = objeto,
        MaxDistance = 5000,
        Color = highlightColor
    })

    local Highlight = ESPLibrary.ESP.Highlight({
        Name = nome,
        Model = objeto,
        MaxDistance = 5000,
        FillColor = highlightColor,
        OutlineColor = highlightColor,
        TextColor = highlightColor
    })
    
    
    return {Tracer = Tracer, Billboard = Billboard, Highlight = Highlight}
end

local function ativarESPObjetos()
    for _, objData in ipairs(objetos_esp) do
        local objetosEncontrados = encontrarObjetosEsp(objData[1])
        if #objetosEncontrados > 0 then
            for _, objeto in ipairs(objetosEncontrados) do
                local espElementos = aplicarESPObjetos(objeto, objData[2], objData[3])
                table.insert(espAtivosObjetos, espElementos)
            end
        else
            warn("[Seeker Logs] O Objeto " .. objData[1] .. " não foi encontrado!")
        end
    end
end

local function desativarESPObjetos()
    for _, espElementos in ipairs(espAtivosObjetos) do
        if espElementos.Tracer then espElementos.Tracer:Destroy() end
        if espElementos.Billboard then espElementos.Billboard:Destroy() end
        if espElementos.Highlight then espElementos.Highlight:Destroy() end
    end
    espAtivosObjetos = {} 
end

local function verificarNovosObjetos()
    while verificarEspObjetos do
        if espAtivoObjetos then
            ativarESPObjetos()
        end
        wait(5)
    end
end

-- ENTIDADES ESP

local entidades = { 
    {"RushMoving", "Rush", Color3.fromRGB(255, 0, 0)},
    {"AmbushMoving", "Ambush", Color3.fromRGB(0, 255, 0)},
    {"Snare", "Armadilha", Color3.fromRGB(255, 0, 0)},
    {"FigureRig", "Figure", Color3.fromRGB(255, 0, 0)},
    {"A60", "A-60", Color3.fromRGB(255, 0, 0)},
    {"A120", "A-120", Color3.fromRGB(255, 0, 0)},
    {"GiggleCeiling", "Giggle", Color3.fromRGB(255, 0, 0)},
    {"GrumbleRig", "Grumbo", Color3.fromRGB(255, 0, 0)},
    {"BackdoorRush", "Blitz", Color3.fromRGB(255, 0, 0)},
    {"Entity10", "Entidade 10", Color3.fromRGB(128, 128, 0)}
}

local espAtivos = {}
local espAtivo = false
local verificarEsp = false

local function encontrarEntidades(nomeEntidade)
    local entidadesEncontradas = {}
    for _, entidade in ipairs(workspace:GetDescendants()) do
        if entidade.Name == nomeEntidade then
            table.insert(entidadesEncontradas, entidade)
        end
    end
    return entidadesEncontradas
end

local function aplicarESP(entidade, nome, cor)
    local highlightColor = cor or BrickColor.random().Color

    local Tracer = ESPLibrary.ESP.Tracer({
        Model = entidade,
        MaxDistance = 5000,
        From = "Bottom",
        Color = highlightColor
    })

    local Billboard = ESPLibrary.ESP.Billboard({
        Name = nome,
        Model = entidade,
        MaxDistance = 5000,
        Color = highlightColor
    })

    local Highlight = ESPLibrary.ESP.Highlight({
        Name = nome,
        Model = entidade,
        MaxDistance = 5000,
        FillColor = highlightColor,
        OutlineColor = highlightColor,
        TextColor = highlightColor
    })
    
    return {Tracer = Tracer, Billboard = Billboard, Highlight = Highlight}
end

local function ativarESP()
    for _, entData in ipairs(entidades) do
        local entidadesEncontradas = encontrarEntidades(entData[1])
        if #entidadesEncontradas > 0 then
            for _, entidade in ipairs(entidadesEncontradas) do
                local espElementos = aplicarESP(entidade, entData[2], entData[3])
                table.insert(espAtivos, espElementos)
            end
        else
            warn("[Seeker Logs] A Entidade " .. entData[1] .. " não foi encontrada!")
        end
    end
end

local function desativarESP()
    for _, espElementos in ipairs(espAtivos) do
        if espElementos.Tracer then espElementos.Tracer:Destroy() end
        if espElementos.Billboard then espElementos.Billboard:Destroy() end
        if espElementos.Highlight then espElementos.Highlight:Destroy() end
    end
    espAtivos = {} 
end

local function verificarNovasEntidades()
    while verificarEsp do
        if espAtivo then
            ativarESP()
        end
        wait(5)
    end
end

-- LOOT ESP
local esp_loot = {
    {"Item", "+", Color3.fromRGB(0, 255, 0)}
    }

local esp_loot_ativos = {}
local esp_loot_ativado = false
local verificar_esp_loot = false

local function encontrarLootESP(nome_loot)
    local loot_encontrado = {}
    for _, loot in ipairs(workspace:GetDescendants()) do
        if loot.Name == nome_loot then
            table.insert(loot_encontrado, loot)
        end
    end
    return loot_encontrado
end

local function aplicarESPLoot(loot, nome, cor)
    local cor_destaque = cor or BrickColor.random().Color

    local Tracer = ESPLibrary.ESP.Tracer({
        Model = loot,
        MaxDistance = 5000,
        From = "Bottom",
        Color = cor_destaque
    })

    local Billboard = ESPLibrary.ESP.Billboard({
        Name = nome,
        Model = loot,
        MaxDistance = 5000,
        Color = cor_destaque
    })

    local Highlight = ESPLibrary.ESP.Highlight({
        Name = nome,
        Model = loot,
        MaxDistance = 5000,
        FillColor = cor_destaque,
        OutlineColor = cor_destaque,
        TextColor = cor_destaque
    })

    return {Tracer = Tracer, Billboard = Billboard, Highlight = Highlight}
end

local function ativarESPLoot()
    for _, lootData in ipairs(esp_loot) do
        local loot_encontrado = encontrarLootESP(lootData[1])
        if #loot_encontrado > 0 then
            for _, loot in ipairs(loot_encontrado) do
                local espElementos = aplicarESPLoot(loot, lootData[2], lootData[3])
                table.insert(esp_loot_ativos, espElementos)
            end
        else
            warn("[Seeker Logs] O Loot " .. lootData[1] .. " não foi encontrado!")
        end
    end
end

local function desativarESPLoot()
    for _, espElementos in ipairs(esp_loot_ativos) do
        if espElementos.Tracer then espElementos.Tracer:Destroy() end
        if espElementos.Billboard then espElementos.Billboard:Destroy() end
        if espElementos.Highlight then espElementos.Highlight:Destroy() end
    end
    esp_loot_ativos = {} 
end

local function verificarNovoLoot()
    while verificar_esp_loot do
        if esp_loot_ativado then
            ativarESPLoot()
        end
        wait(5)
    end
end

-- DOOR ESP
local portas_esp = {
    {"Door", "Porta", Color3.fromRGB(241, 196, 15)}
}

local espAtivosPortas = {}
local doorEspAtivo = false
local verificarEspPortas = false

local function encontrarPortasESP(nomePorta)
    local portasEncontradas = {}
    for _, room in pairs(workspace.CurrentRooms:GetChildren()) do
        if room:FindFirstChild(nomePorta) and room[nomePorta]:FindFirstChild(nomePorta) then
            table.insert(portasEncontradas, room[nomePorta][nomePorta])
        end
    end
    return portasEncontradas
end

local function aplicarESPPorta(porta, nome, cor)
    local highlightColor = cor or BrickColor.random().Color

    local Tracer = ESPLibrary.ESP.Tracer({
        Model = porta,
        MaxDistance = 5000,
        From = "Bottom",
        Color = highlightColor
    })

    local Billboard = ESPLibrary.ESP.Billboard({
        Name = nome,
        Model = porta,
        MaxDistance = 5000,
        Color = highlightColor
    })

    local Highlight = ESPLibrary.ESP.Highlight({
        Name = nome,
        Model = porta,
        MaxDistance = 5000,
        FillColor = highlightColor,
        OutlineColor = highlightColor,
        TextColor = highlightColor
    })


    return {Tracer = Tracer, Billboard = Billboard, Highlight = Highlight}
end

local function ativarDoorESP()
    for _, portaData in ipairs(portas_esp) do
        local portasEncontradas = encontrarPortasESP(portaData[1])
        if #portasEncontradas > 0 then
            for _, porta in ipairs(portasEncontradas) do
                local room = porta.Parent.Parent 
                local doorNumber = tonumber(room.Name) + 1
                local opened = room.Door:GetAttribute("Opened")
                local locked = room:GetAttribute("RequiresKey")

                local doorState = opened and "[Aberta]" or (locked and "[Trancada]" or "")
                local espElementos = aplicarESPPorta(porta, portaData[2] .. " " .. doorNumber .. " " .. doorState, portaData[3])

                room.Door:GetAttributeChangedSignal("Opened"):Connect(function()
                    if espElementos.Billboard then
                        espElementos.Billboard:SetText(portaData[2] .. " " .. doorNumber .. " [Aberta]")
                    end
                end)

                table.insert(espAtivosPortas, espElementos)
            end
        else
            warn("[Seeker Logs] A Porta " .. portaData[1] .. " não foi encontrada!")
        end
    end
end

local function desativarDoorESP()
    for _, espElementos in ipairs(espAtivosPortas) do
        if espElementos.Tracer then espElementos.Tracer:Destroy() end
        if espElementos.Billboard then espElementos.Billboard:Destroy() end
        if espElementos.Highlight then espElementos.Highlight:Destroy() end
    end
    espAtivosPortas = {}
end

local function verificarNovasPortas()
    while verificarEspPortas do
        if doorEspAtivo then
            ativarDoorESP()
        end
        wait(5)
    end
end

--[ FUNÇÕES ]--
-- NOCLIP FUNÇÃO 
local noclipEnabled = false
local noclipConnection

function Noclip()
    if noclipEnabled then
        noclipConnection = game:GetService("RunService").Stepped:Connect(function()
            for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                if v:IsA("BasePart") and v.CanCollide then
                    v.CanCollide = false
                end
            end
        end)

        local sound = Instance.new("Sound")
sound.SoundId = "rbxassetid://8486683243"
sound.Volume = 1
sound.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
sound:Play()
sound.Ended:Connect(function()
    sound:Destroy()
end)
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "🔔 Notificação",
    Text = "Agora você pode atravessar paredes!",
    Icon = "rbxassetid://17328930447",
    Duration = 5
})
        
    else
        if noclipConnection then
            noclipConnection:Disconnect()
            noclipConnection = nil
        end

        local sound = Instance.new("Sound")
sound.SoundId = "rbxassetid://8486683243"
sound.Volume = 1
sound.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
sound:Play()
sound.Ended:Connect(function()
    sound:Destroy()
end)
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "🔔 Notificação",
    Text = "Noclip foi desativado!",
    Icon = "rbxassetid://17328930447",
    Duration = 5
})
    end
end



-- ANTI LAG

local antiLagEnabled = false
local antiLagConnection

local function ActivateAntiLag()
    if not antiLagEnabled then return end  

    game.Lighting.FogEnd = 1e10
    game.Lighting.FogStart = 1e10
    game.Lighting.Brightness = 2
    game.Lighting.GlobalShadows = false
    game.Lighting.EnvironmentDiffuseScale = 0
    game.Lighting.EnvironmentSpecularScale = 0

    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Material ~= Enum.Material.Plastic then
            obj.Material = Enum.Material.Plastic
        elseif obj:IsA("Decal") then
            obj.Transparency = 1
        end
    end

    antiLagConnection = workspace.DescendantAdded:Connect(function(obj)
        if obj:IsA("BasePart") and obj.Material ~= Enum.Material.Plastic then
            obj.Material = Enum.Material.Plastic
        elseif obj:IsA("Decal") then
            obj.Transparency = 1
        end
    end)

    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://4590657391"
    sound.Volume = 1
    sound.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    sound:Play()
    sound.Ended:Connect(function()
        sound:Destroy()
    end)

    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "🔔 Notificação",
        Text = "Anti Lag Carregado...",
        Icon = "rbxassetid://13264701341",
        Duration = 5
    })
end

local function DeactivateAntiLag()
    game.Lighting.FogEnd = 500
    game.Lighting.FogStart = 0
    game.Lighting.Brightness = 1
    game.Lighting.GlobalShadows = true
    game.Lighting.EnvironmentDiffuseScale = 1
    game.Lighting.EnvironmentSpecularScale = 1

    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Material == Enum.Material.Plastic then
            obj.Material = Enum.Material.SmoothPlastic
        elseif obj:IsA("Decal") then
            obj.Transparency = 0
        end
    end

    if antiLagConnection then
        antiLagConnection:Disconnect()
        antiLagConnection = nil
    end

    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://4590657391"
    sound.Volume = 1
    sound.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    sound:Play()
    sound.Ended:Connect(function()
        sound:Destroy()
    end)

    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "🔔 Notificação",
        Text = "Anti Lag Desativado",
        Icon = "rbxassetid://13264701341",
        Duration = 5
    })
end

local function onRoomChanged()
    if antiLagEnabled then
        local currentRoom = game.ReplicatedStorage:WaitForChild("GameData"):WaitForChild("LatestRoom").Value
        print("[Seekee Logs] AntiLag Adicionado a sala " .. currentRoom)

        ActivateAntiLag()
    end
end

local latestRoom = game.ReplicatedStorage:WaitForChild("GameData"):WaitForChild("LatestRoom")
latestRoom:GetPropertyChangedSignal("Value"):Connect(onRoomChanged)

--// Tabela de Entidades para notificação.\\--
local EntityTable = {
    ["Names"] = {"BackdoorRush", "BackdoorLookman", "RushMoving", "AmbushMoving", "Eyes", "JeffTheKiller", "A60", "A120"},

    ["NotifyReason"] = {
        ["A60"] = { ["Image"] = "12350986086", ["Title"] = "Alerta A-60", ["Description"] = "Entidade A-60 detectada!" },
        ["A120"] = { ["Image"] = "12351008553", ["Title"] = "Cuidado com A-120", ["Description"] = "Entidade A-120 se aproximando!" },
        ["HaltRoom"] = { ["Image"] = "11331795398", ["Title"] = "Halt Detected", ["Description"] = "Prepare-se para o Halt!" },
        ["BackdoorRush"] = { ["Image"] = "11102256553", ["Title"] = "Backdoor Rush", ["Description"] = "Rush se aproximando pelo backdoor!" },
        ["RushMoving"] = { ["Image"] = "11102256553", ["Title"] = "Rush em Movimento", ["Description"] = "Rush foi visto se movendo." },
        ["AmbushMoving"] = { ["Image"] = "10938726652", ["Title"] = "Ambush em Movimento", ["Description"] = "Ambush está ativo." },
        ["Eyes"] = { ["Image"] = "10865377903", ["Title"] = "Olhos!", ["Description"] = "Não olhe para os olhos!", ["Spawned"] = true },
        ["BackdoorLookman"] = { ["Image"] = "16764872677", ["Title"] = "Backdoor Lookman", ["Description"] = "Lookman foi visto!", ["Spawned"] = true },
        ["GloombatSwarm"] = { ["Image"] = "79221203116470", ["Title"] = "Gloombats", ["Description"] = "Gloombats no chão atento a onde pisa!", ["Spawned"] = true},
        ["HaltRoom"] = { ["Image"] = "11331795398", ["Title"] = "Halt Room!", ["Description"] = "Se prepare para o desafio!", ["Spawned"] = true},
        ["JeffTheKiller"] = { ["Image"] = "98993343", ["Title"] = "Jeff está Aqui", ["Description"] = "Fuja do Jeff the Killer!" }
    }
}

-- Função para criar notificação.

local function DoorsNotify(options)
    local title = options.Title or "No Title"
    local description = options.Description or "No Text"
    local image = options.Image or "rbxassetid://6023426923"
    local time = options.Time or 5

    local mainUI = game.Players.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("MainUI", 2.5)
    if mainUI then
        local achievement = mainUI.AchievementsHolder.Achievement:Clone()
        achievement.Size = UDim2.new(0, 0, 0, 0)
        achievement.Frame.Position = UDim2.new(1.1, 0, 0, 0)
        achievement.Name = "LiveAchievement"
        achievement.Visible = true

        achievement.Frame.Details.Desc.Text = description
        achievement.Frame.Details.Title.Text = title
        achievement.Frame.ImageLabel.Image = image
        achievement.Parent = mainUI.AchievementsHolder

        achievement.Size = UDim2.new(0, 400, 0, 100)
        achievement.Frame:TweenPosition(UDim2.new(0.5, -200, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Bounce, 1, true)
        game:GetService("Debris"):AddItem(achievement, time)
    end
end

-- Função para notificar sobre entidades usando OrionLib
function NotifyEntity(entityName)
    if EntityTable.NotifyReason[entityName] then
        local notificationData = EntityTable.NotifyReason[entityName]
        
        DoorsNotify({
            Title = notificationData.Title,
            Description = notificationData.Description,
            Image = "rbxassetid://" .. notificationData.Image,
            Time = 5
        })
        
        local sound = Instance.new("Sound")
        sound.SoundId = "rbxassetid://10469938989"
        sound.Volume = 3
        sound.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
        sound:Play()
        sound.Ended:Connect(function()
            sound:Destroy()
        end)
    end
end

local notificationsEnabled = false

function MonitorEntities()
    game:GetService("RunService").Stepped:Connect(function()
        if notificationsEnabled then
            for _, entityName in ipairs(EntityTable.Names) do
                local entity = workspace:FindFirstChild(entityName)
                if entity and not entity:GetAttribute("Notified") then
                    entity:SetAttribute("Notified", true)
                    NotifyEntity(entityName)
                end
            end
        end
    end)
end
MonitorEntities()
--[[ Auto Library Code ]]---
local mainUI = Players.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("MainUI", 2.5)
local function DoorsNotify(options)
    local title = options.Title or "No Title"
    local description = options.Description or "No Text"
    local image = options.Image or "rbxassetid://6023426923"
    local time = options.Time or 5
    local color = options.Color

    if mainUI then
        local achievement = mainUI.AchievementsHolder.Achievement:Clone()
        achievement.Size = UDim2.new(0, 0, 0, 0)
        achievement.Frame.Position = UDim2.new(1.1, 0, 0, 0)
        achievement.Name = "LiveAchievement"
        achievement.Visible = true

        achievement.Frame.Details.Desc.Text = description
        achievement.Frame.Details.Title.Text = title
        achievement.Frame.ImageLabel.Image = image

        if color then
            achievement.Frame.TextLabel.TextColor3 = color
            achievement.Frame.UIStroke.Color = color
            achievement.Frame.Glow.ImageColor3 = color
        end

        achievement.Parent = mainUI.AchievementsHolder
        achievement.Sound.SoundId = "rbxassetid://10469938989"
        achievement.Sound.Volume = 1
        achievement.Sound:Play()

        achievement:TweenSize(UDim2.new(1, 0, 0.2, 0), "In", "Quad", 0.8, true)
        task.wait(0.8)
        achievement.Frame:TweenPosition(UDim2.new(0, 0, 0, 0), "Out", "Quad", 0.5, true)

        task.delay(time, function()
            achievement.Frame:TweenPosition(UDim2.new(1.1, 0, 0, 0), "In", "Quad", 0.5, true)
            task.wait(0.5)
            achievement:Destroy()
        end)
    end
end

local function LogNotification(level, message)
    local title, color, icon
    if level == "SUCESSO" then
        title, color, icon = "🟩 | Rseeker", Color3.fromRGB(0, 255, 0), "rbxassetid://13311697821"
    elseif level == "ERRO" then
        title, color, icon = "🟥 | Rseeker", Color3.fromRGB(255, 0, 0), "rbxassetid://13369776727"
    else -- Em análise
        title, color, icon = "🟨 | Rseeker", Color3.fromRGB(255, 255, 0), "rbxassetid://97983317580515"
    end

    DoorsNotify({
        Title = title,
        Description = message,
        Image = icon,
        Time = 5,
        Color = color
    })
end

local function AutoLibrarySolver(value)
    if value then
        for _, otherPlayer in pairs(Players:GetPlayers()) do
            if not otherPlayer.Character then continue end
            local tool = otherPlayer.Character:FindFirstChildOfClass("Tool")

            if tool and tool.Name:match("LibraryHintPaper") then
                local code = Script.Functions.GetPadlockCode(tool)
                local padlock = Workspace:FindFirstChild("Padlock", true)

                if tonumber(code) then
                    if Script.Functions.DistanceFromCharacter(padlock) <= Options.AutoLibraryDistance then
                        Script.RemotesFolder.PL:FireServer(code)
                        LogNotification("SUCESSO", "Cadeado desbloqueado com o código correto.")
                    else
                        LogNotification("ERRO", "Distância insuficiente para desbloquear o cadeado.")
                    end
                else
                    LogNotification("ERRO", "Código inválido detectado.")
                end
            else
                LogNotification("+-", "Procurando LibraryHintPaper...")
            end
        end
    else
        LogNotification("ERRO", "Auto Library Solver desativado.")
    end
end


--[ ORION LIB - MENU ]--
--// CRÉDITOS \\--
local CreditsTab = Window:MakeTab({
    Name = "Creditos",
    Icon = "rbxassetid://7743871002",
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

-- ESPS
local VisualsEsp = Window:MakeTab({
    Name = "Visual",
    Icon = "rbxassetid://7743874674",
    PremiumOnly = false
})
VisualsEsp:AddParagraph("Esp", "Ver objetos através da parede.")
--[BOTÕES ORGANIZADOS POR rhyan57]--

-- DOORS ESP

VisualsEsp:AddToggle({
    Name = "Door ESP",
    Default = false,
    Callback = function(state)
        doorEspAtivo = state
        if doorEspAtivo then
            verificarEspPortas = true
            spawn(verificarNovasPortas)
        else
            verificarEspPortas = false
            desativarDoorESP()
        end
    end
})

--[ esp functions ]--
VisualsEsp:AddToggle({
    Name = "Esp Entidade",
    Default = false,
    Callback = function(state)
        espAtivo = state
        if espAtivo then
            verificarEsp = true
            spawn(verificarNovasEntidades)
        else
            verificarEsp = false
            desativarESP()
        end
    end
})
-- OBJETIVO
VisualsEsp:AddToggle({
    Name = "Esp Objetivo",
    Default = false,
    Callback = function(state)
        espAtivoObjetos = state
        if espAtivoObjetos then
            verificarEspObjetos = true
            spawn(verificarNovosObjetos)
        else
            verificarEspObjetos = false
            desativarESPObjetos()
        end
    end
})

-- LOOT ESP
VisualsEsp:AddToggle({
    Name = "Esp Loot",
    Default = false,
    Callback = function(state)
        esp_loot_ativado = state
        if esp_loot_ativado then
            verificar_esp_loot = true
            spawn(verificarNovoLoot)
        else
            verificar_esp_loot = false
            desativarESPLoot()
        end
    end
})

VisualsEsp:AddParagraph("Local Player", "Funções visuais do jogador.")

VisualsEsp:AddToggle({
    Name = "Anti-Lag",
    Default = false,
    Callback = function(Value)
        antiLagEnabled = Value
        if Value then
            ActivateAntiLag() 
        else
            DeactivateAntiLag()
        end
    end
})


VisualsEsp:AddToggle({
    Name = "No Cutscenes",
    Default = false,
    Callback = function(enabled)
        if enabled then
            for _, cutsceneName in ipairs(CutsceneExclude) do
                local cutscene = workspace:FindFirstChild(cutsceneName)
                if cutscene then
                    cutscene:Destroy()
                end
            end
        end
    end
})

local notifsTab = VisualsEsp:AddSection({
    Name = "Notificações"
})
notifsTab:AddParagraph("Notificações", "Aba de Notificações de entidades ou outros.")

notifsTab:AddToggle({
    Name = "Notificar Entidades",
    Default = false,
    Callback = function(value)
        notificationsEnabled = value
        if value then
            local sound = Instance.new("Sound")
            sound.SoundId = "rbxassetid://4590657391"
            sound.Volume = 1
            sound.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
            sound:Play()
            sound.Ended:Connect(function()
                sound:Destroy()
            end)
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "🔔 Notificação",
                Text = "Notificações de Entidades ativas!",
                Icon = "rbxassetid://13264701341",
                Duration = 3
            })
        else
            local sound = Instance.new("Sound")
            sound.SoundId = "rbxassetid://4590662766"
            sound.Volume = 1
            sound.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
            sound:Play()
            sound.Ended:Connect(function()
                sound:Destroy()
            end)
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "🔔 Notificação",
                Text = "Notificações de Entidades desativadas!",
                Icon = "rbxassetid://13264701341",
                Duration = 3
            })
        end
    end
})

--[ Funções de automação ]--
local autoIn = Window:MakeTab({
    Name = "Automoção",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

autoIn:AddToggle({
    Name = "Auto Library Code",
    Default = false,
    Callback = function(value)
        AutoLibrarySolver(value)
    end
})

local function PromptCondition(prompt)
    local modelAncestor = prompt:FindFirstAncestorOfClass("Model")
    return prompt:IsA("ProximityPrompt") and 
        not table.find(PromptTable.Excluded.Prompt, prompt.Name) and 
        not table.find(PromptTable.Excluded.Parent, prompt.Parent and prompt.Parent.Name or "") and 
        not table.find(PromptTable.Excluded.ModelAncestor, modelAncestor and modelAncestor.Name or "")
end
local function AutoInteractWithPrompt(prompt)
    if prompt:IsA("ProximityPrompt") and prompt.Enabled then
        fireproximityprompt(prompt)
    end
end
local function CheckPrompts()
    for _, prompt in pairs(workspace:GetDescendants()) do
        if PromptCondition(prompt) then
            AutoInteractWithPrompt(prompt)
        end
    end
end

local function AdjustPromptProperties(prompt)
    task.defer(function()
        if not prompt:GetAttribute("Hold") then prompt:SetAttribute("Hold", prompt.HoldDuration) end
        if not prompt:GetAttribute("Distance") then prompt:SetAttribute("Distance", prompt.MaxActivationDistance) end
        if not prompt:GetAttribute("Enabled") then prompt:SetAttribute("Enabled", prompt.Enabled) end
        if not prompt:GetAttribute("Clip") then prompt:SetAttribute("Clip", prompt.RequiresLineOfSight) end
    end)
    
    task.defer(function()
        prompt.MaxActivationDistance = prompt:GetAttribute("Distance") * 1 -- Ajuste da distância multiplicada
        prompt.HoldDuration = 0
        prompt.RequiresLineOfSight = false
    end)
    
    table.insert(PromptTable.GamePrompts, prompt)
end

local function ChildCheck(child)
    if PromptCondition(child) then
        AdjustPromptProperties(child)
    end
end

local autoInteractEnabled = false
autoIn:AddToggle({
    Name = "Auto Interact",
    Default = false,
    Callback = function(Value)
        autoInteractEnabled = Value
        if Value then
            while autoInteractEnabled do
                CheckPrompts()
                task.wait(1)
            end
        end
    end
})
workspace.DescendantAdded:Connect(ChildCheck)
CheckPrompts()

autoIn:AddToggle({
    Name = "Auto Loot",
    Default = false,
    Callback = function(estado)
        autoLootAtivo = estado
        if autoLootAtivo then
            task.spawn(AutoLoot) 
        end
    end
})


local connections = {}

local function antiEyes()
    for _, instance in pairs(Workspace:GetChildren()) do
        if instance.Name == "Eyes" then
            instance:Destroy()
        end
    end
end

local function antiScreech()
    local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
    local head = character:FindFirstChild("Head")

    if head then
        local screechAttack = head:FindFirstChild("Screech")
        if screechAttack then
            screechAttack:Destroy()
        end
    end
end

local function antiHalt()
    for _, instance in pairs(Workspace:GetChildren()) do
        if instance.Name == "Halt" then
            instance:Destroy()
        end
    end
end

--//Anti Entity\\--
local AntiMonstersTab = Window:MakeTab({
    Name = "Anti Monsters",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

AntiMonstersTab:AddToggle({
    Name = "Anti Eyes",
    Default = false,
    Callback = function(Value)
        if Value then
            connections.antiEyes = RunService.RenderStepped:Connect(antiEyes) 
        else
            if connections.antiEyes then connections.antiEyes:Disconnect() end
        end
    end
})

AntiMonstersTab:AddToggle({
    Name = "Anti Screech",
    Default = false,
    Callback = function(Value)
        if Value then
            connections.antiScreech = RunService.RenderStepped:Connect(antiScreech)
        else
            if connections.antiScreech then connections.antiScreech:Disconnect() end
        end
    end
})

AntiMonstersTab:AddToggle({
    Name = "Anti Halt",
    Default = false,
    Callback = function(Value)
        if Value then
            connections.antiHalt = RunService.RenderStepped:Connect(antiHalt)
        else
            if connections.antiHalt then connections.antiHalt:Disconnect() end
        end
    end
})

-- Exploits
local ExploitsTab = Window:MakeTab({
    Name = "Exploits",
    Icon = "rbxassetid://13264701341",
    PremiumOnly = false
})
--// Anti Entity Tab \\--
local AntiEntitySection = ExploitsTab:AddSection({Name = "Anti-Entity"})



--[EM BREVE]--

--[[ Byppas Area ]]--
local ByTab = Window:MakeTab({
    Name = "Byppas",
    Icon = "rbxassetid://14255000409",
    PremiumOnly = false
})

--[ EM BREVE ]--

--[ Itens ]--
local ItensTab = Window:MakeTab({
    Name = "Give Itens",
    Icon = "rbxassetid://11713331539",
    PremiumOnly = false
})

ItensTab:AddButton({
    Name = "💊 Vitamina Fake",
    Callback = function()
        loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/RhyanXG7/RseekerHub/Fun%C3%A7%C3%B5es/Sc/GiveVitamns.lua"))()
    end
})

-- Local Player
local GameLocal = Window:MakeTab({
    Name = "Player",
    Icon = "rbxassetid://17328380241",
    PremiumOnly = false
})

GameLocal:AddButton({
    Name = "🎥 Alternar campo de visão",
    Callback = function()
        toggleFieldOfView()
    end    
})


GameLocal:AddButton({
    Name = "💾 Stats de FPS",
    Callback = function()
        loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/RhyanXG7/RseekerHub/Fun%C3%A7%C3%B5es/Sc/Stats.lua"))()
        print("O botão stats foi ativo!")
       end
})

GameLocal:AddButton({
    Name = "👻 Modo Fantasma",
    Callback = function()
        loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/RhyanXG7/RseekerHub/Fun%C3%A7%C3%B5es/Sc/Godmode.lua"))()
        print("O godmode foi ativo!")
    end
})

GameLocal:AddToggle({
    Name = "Noclip",
    Default = false,
    Callback = function(value)
        noclipEnabled = value
        Noclip()
    end
})

GameLocal:AddToggle({
    Name = "Speed Bypass",
    Default = false,
    Callback = function(value)
        speedBypass(value)
    end    
})

GameLocal:AddToggle({
    Name = "Speed Bypass Delay",
    Default = false,
    Callback = function(value)
        if value then
            speedBypassWithDelay(true, 2)
        else
            speedBypassWithDelay(false, 0)
            speedBypass(false) 
        end
    end    
})

local FloorTab = Window:MakeTab({
    Name = "Floors",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})


--[MODS]--
local ModFolder = ".seeker/mods/"
local modFiles = {}
local loadedMods = {}
local modPage = nil
local selectedMod = nil
local exampleModFileName = "modExemplo.lua"
local exampleModContent = [[
return function(modTab)
    modTab:AddButton({
        Name = "Testar Funcionamento",
        Callback = function()
            OrionLib:MakeNotification({
                Name = "Teste de Funcionamento",
                Content = "Funciona!",
                Image = "rbxassetid://4483345998",
                Time = 5
            })
            print("[INFO] Mod de Teste: Funciona!")
        end
    })
end
]]

local function createFolderIfNotExists()
    if not isfolder(ModFolder) then
        makefolder(ModFolder)
    end
end

local function createExampleModFile()
    local filePath = ModFolder .. exampleModFileName
    if not isfile(filePath) then
        writefile(filePath, exampleModContent)
        OrionLib:MakeNotification({
            Name = "Arquivo de Exemplo Criado",
            Content = "Arquivo de mod de exemplo foi criado em '"..filePath.."'",
            Image = "rbxassetid://4483345998",
            Time = 5
        })
        print("[INFO] Arquivo de mod de exemplo criado em '"..filePath.."'")
    end
end

local function listModFiles()
    createFolderIfNotExists()
    createExampleModFile()
    
    local success, result = pcall(function()
        return listfiles(ModFolder)
    end)
    
    if success and result then
        for _, file in ipairs(result) do
            table.insert(modFiles, file:match("([^/]+)$"))
        end
    else
        OrionLib:MakeNotification({
            Name = "Erro",
            Content = "Não foi possível carregar a lista de mods.",
            Image = "rbxassetid://4483345998",
            Time = 5
        })
        print("[ERRO] Não foi possível carregar a lista de mods: ", result)
    end
end

local function filterModContent(content)
    local filteredContent = {}
    for line in content:gmatch("[^\r\n]+") do
        if not line:find("OrionLib:MakeWindow") and not line:find("Window:MakeTab") then
            table.insert(filteredContent, line)
        end
    end
    return table.concat(filteredContent, "\n")
end

local function loadMod(fileName)
    if loadedMods[fileName] then
        OrionLib:MakeNotification({
            Name = "Erro",
            Content = "O mod '"..fileName.."' já está carregado.",
            Image = "rbxassetid://4483345998",
            Time = 5
        })
        return
    end
    
    local filePath = ModFolder .. fileName
    local success, modContent = pcall(function()
        return readfile(filePath)
    end)

    if not success then
        OrionLib:MakeNotification({
            Name = "Erro ao Ler",
            Content = "Erro ao ler o arquivo de mod '"..fileName.."'.",
            Image = "rbxassetid://4483345998",
            Time = 5
        })
        print("[ERRO] Falha ao ler o arquivo de mod '"..fileName.."': ", modContent)
        return
    end

    local filteredContent = filterModContent(modContent)
    local modFunc = loadstring(filteredContent)
    if modFunc then
        setfenv(modFunc, {OrionLib = OrionLib, print = print}) 

        local modTab = Window:MakeTab({
            Name = fileName:gsub("%.lua$", ""),
            Icon = "rbxassetid://4483345998",
            PremiumOnly = false
        })

        local loadSuccess, runError = pcall(function()
            modFunc()(modTab)
        end)

        if loadSuccess then
            loadedMods[fileName] = true
            OrionLib:MakeNotification({
                Name = "Mod Carregado",
                Content = "O Mod '"..fileName.."' foi carregado com sucesso.",
                Image = "rbxassetid://4483345998",
                Time = 5
            })
            print("[INFO] Mod '"..fileName.."' carregado com sucesso.")
        else
            OrionLib:MakeNotification({
                Name = "Erro no Mod",
                Content = "Erro ao executar o Mod '"..fileName.."'.",
                Image = "rbxassetid://4483345998",
                Time = 5
            })
            print("[ERRO] Erro ao executar o Mod '"..fileName.."': ", runError)
        end
    else
        OrionLib:MakeNotification({
            Name = "Erro de Compilação",
            Content = "Erro ao compilar o Mod '"..fileName.."'.",
            Image = "rbxassetid://4483345998",
            Time = 5
        })
        print("[ERRO] Erro ao compilar o Mod '"..fileName.."'.")
    end
end

local function createModPage()
    if not modPage then
        modPage = Window:MakeTab({
            Name = "Mods",
            Icon = "rbxassetid://4483345998",
            PremiumOnly = false
        })
        --// MODS DO SCRIPT \\--
--[[ TIMER ]]--

local TimerGui = Instance.new("ScreenGui")
TimerGui.Enabled = false
TimerGui.IgnoreGuiInset = true
TimerGui.Parent = LocalPlayer.PlayerGui

local TimerLabel = Instance.new("TextLabel")
TimerLabel.AnchorPoint = Vector2.new(0.5, 0)
TimerLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TimerLabel.BorderColor3 = Color3.fromRGB(255, 0, 0)
TimerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TimerLabel.BorderSizePixel = 2
TimerLabel.Position = UDim2.new(0.5, 0, 0, 0) 
TimerLabel.Size = UDim2.fromOffset(262, 64)
TimerLabel.Font = Enum.Font.ArialBold
TimerLabel.Text = "00:00.00"
TimerLabel.TextScaled = true
TimerLabel.Parent = TimerGui
TimerLabel.BackgroundTransparency = 0
TimerLabel.TextStrokeTransparency = 0
TimerLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12) 
UICorner.Parent = TimerLabel

local locked = false
local selectedColor = "RGB"
local countdownLimit = 0
local countdownExpired = false
local currentStyle = "Padrão"
local resizing = false
local styleSliderExists = false
local opacityValue = 0

local gradientRunning = false
local gradientCoroutine
local function stopGradient()
    if gradientRunning and gradientCoroutine then
        coroutine.close(gradientCoroutine)
        gradientRunning = false
    end
end

TimerLabel.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 and not locked then
        resizing = not resizing
        TimerLabel.Draggable = resizing
        TimerLabel.Selectable = resizing
        TimerLabel.Active = resizing
    end
end)

local function applyTimerStyle(style)
    if style == "Tempo Limite" then
        if countdownLimit > 0 and getgenv().SpeedRunTime >= countdownLimit then
            countdownExpired = true
            TimerLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
            TimerLabel.TextStrokeTransparency = 0
            TimerLabel.Text = "Time Expired!"
            TimerLabel.BorderColor3 = Color3.fromRGB(255, 0, 0)
            RunService.Heartbeat:Connect(function()
                TimerLabel.Visible = not TimerLabel.Visible
            end)
        end
    elseif style == "Tempo Limite kick" then
        if getgenv().SpeedRunTime >= countdownLimit then
            LocalPlayer:Kick("[Seeker Hub] ⏰ Timer Expirado! ")
        end
    end
end

local function updateTimerColor(color)
    stopGradient() 
    if color == "RGB" then
        TimerLabel.BackgroundColor3 = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255))
    elseif color == "Amarelo" then
        TimerLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
    elseif color == "Verde" then
        TimerLabel.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    elseif color == "Gradiente" then
        gradientRunning = true
        gradientCoroutine = coroutine.create(function()
            while gradientRunning do
                TimerLabel.BackgroundColor3 = Color3.fromHSV(tick() % 5 / 5, 1, 1)
                RunService.Heartbeat:Wait()
            end
        end)
        coroutine.resume(gradientCoroutine)
    end
end

if getgenv().SpeedRunStopped then
    getgenv().SpeedRunTime += (tick() - getgenv().SpeedRunStopped)
else
    getgenv().SpeedRunTime = 0
end

task.spawn(function()
    if LatestRoom.Value < 1 then
        LatestRoom.Changed:Wait()
    end

    if OrionLib.Unloaded then return end
    RunService.RenderStepped:Connect(function(delta)
        getgenv().SpeedRunTime += delta
        TimerLabel.Text = string.format("%02i:%02i.%02i", getgenv().SpeedRunTime // 60, getgenv().SpeedRunTime % 60, (getgenv().SpeedRunTime % 1) * 100)
        applyTimerStyle(currentStyle)
    end)
end)

--[[ mods UI ]]--
local modsSc = modPage:AddSection({
    Name = "Mods do script"
})

modsSc:AddToggle({
    Name = "Ativar Cronômetro",
    Default = false,
    Callback = function(value)
        TimerGui.Enabled = value
    end
})

modsSc:AddDropdown({
    Name = "Cor do Cronômetro",
    Default = "RGB",
    Options = {"RGB", "Gradiente", "Amarelo", "Verde"},
    Callback = function(value)
        selectedColor = value
        updateTimerColor(selectedColor)
    end
})



modsSc:AddSlider({
    Name = "Opacidade do Cronômetro",
    Min = 0,
    Max = 100,
    Default = 100,
    Color = Color3.fromRGB(255, 0, 0),
    Increment = 1,
    ValueName = "%",
    Callback = function(value)
        opacityValue = value / 100
        TimerLabel.BackgroundTransparency = 1 - opacityValue
    end
})

modsSc:AddSlider({
    Name = "Tamanho do Cronômetro",
    Min = 100,
    Max = 500,
    Default = 262,
    Color = Color3.fromRGB(255, 0, 0),
    Increment = 1,
    ValueName = "Tamanho",
    Callback = function(value)
        TimerLabel.Size = UDim2.fromOffset(value, 64)
    end
})

modsSc:AddDropdown({
    Name = "Posição do Cronômetro",
    Default = "Meio",
    Options = {"Meio", "Canto Esquerdo", "Canto Direito"},
    Callback = function(value)
        if value == "Meio" then
            TimerLabel.Position = UDim2.new(0.5, 0, 0, 0)
        elseif value == "Canto Esquerdo" then
            TimerLabel.Position = UDim2.new(0, 50, 0, 0)
        elseif value == "Canto Direito" then
            TimerLabel.Position = UDim2.new(1, -50, 0, 0)
        end
    end
})

modsSc:AddDropdown({
    Name = "Modos do Cronômetro",
    Default = "Padrão",
    Options = {"Padrão", "Tempo Limite", "Tempo Limite kick"},
    Callback = function(value)
        currentStyle = value
        -- Remove existing sliders if already created
        if styleSliderExists then
            Tab:RemoveObject("Definir Tempo Limite")
        end
        if currentStyle == "Personalizado" or currentStyle == "Personalizado 2" then
            Tab:AddSlider({
                Name = "Definir Tempo Limite",
                Min = 10,
                Max = 300,
                Default = 60,
                Color = Color3.fromRGB(255, 0, 0),
                Increment = 1,
                ValueName = "Segundos",
                Callback = function(limit)
                    countdownLimit = limit
                end
            })
            styleSliderExists = true
        end
    end
})

modsSc:AddButton({
    Name = "Posição Free",
    Callback = function()
        locked = not locked
        if locked then
            TimerLabel.Draggable = false
            OrionLib:MakeNotification({
                Name = "UI Travada",
                Content = "O cronômetro foi travado na posição atual.",
                Image = "rbxassetid://4483345998",
                Time = 3
            })
        else
            TimerLabel.Draggable = true
            OrionLib:MakeNotification({
                Name = "UI Destravada",
                Content = "Você pode mover o cronômetro novamente.",
                Image = "rbxassetid://4483345998",
                Time = 3
            })
        end
    end
})

--//mods Area\\--
        modsSc:AddParagraph("Mods(BETA)", "Crie Mods e os Exporte para cá usando os arquivos!")
        modsSc:AddDropdown({
            Name = "Selecionar Mod",
            Default = "",
            Options = modFiles,
            Callback = function(selectedFile)
                selectedMod = selectedFile
                OrionLib:MakeNotification({
                    Name = "Mod Selecionado",
                    Content = "Mod '"..selectedMod.."' foi selecionado.",
                    Image = "rbxassetid://4483345998",
                    Time = 3
                })
                print("[Seeker Logs - INFO] Mod '"..selectedMod.."' selecionado.")
            end
        })
        
        modsSc:AddButton({
            Name = "Executar Mod",
            Callback = function()
                if selectedMod then
                    loadMod(selectedMod)
                else
                    OrionLib:MakeNotification({
                        Name = "Nenhum Mod Selecionado",
                        Content = "Por favor, selecione um Mod antes de executar.",
                        Image = "rbxassetid://4483345998",
                        Time = 5
                    })
                    print("[Seeker Logs - ERRO] Nenhum mod foi selecionado.")
                end
            end
        })
    end
end

local function removeModPage()
    if modPage then
        modPage:Destroy()
        modPage = nil
        selectedMod = nil
    end
end

local ConfigTab= Window:MakeTab({
    Name = "Configurações",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local tracerDirection = "Bottom"
ConfigTab:AddToggle({
    Name = "Mods",
    Default = false,
    Callback = function(enabled)
        if enabled then
            createModPage()
        else
            removeModPage()
        end
    end
})

local ESPConfigTab = ConfigTab:AddSection({
    Name = "Configurações do esp"
})

ESPConfigTab:AddToggle({
    Name = "Rainbow ESP",
    Default = false,
    Callback = function(value)
        if value then
            ESPLibrary.Rainbow.Set(true)
            ESPLibrary.Rainbow.Enable()
        else
            ESPLibrary.Rainbow.Disable()
        end
    end
})

ESPConfigTab:AddDropdown({
    Name = "Direção do Traço",
    Default = "Bottom",
    Options = {"Bottom", "Top", "Left", "Right"},
    Callback = function(direction)
        tracerDirection = direction
    end
})

ESPConfigTab:AddToggle({
    Name = "Traços",
    Default = true,
    Callback = function(value)
        if value then
            ESPLibrary.Tracers.Set(true)
            ESPLibrary.Tracers.Enable()

            local tracerSettings = {
                Color = BrickColor.random().Color,
                Direction = tracerDirection
            }

            if tracerDirection == "Bottom" then

            elseif tracerDirection == "Top" then

            elseif tracerDirection == "Left" then

            elseif tracerDirection == "Right" then

            end
        else
            ESPLibrary.Tracers.Disable()
        end
    end
})

ESPConfigTab:AddToggle({
    Name = "Setas",
    Default = false,
    Callback = function(value)
        if value then
            ESPLibrary.Arrows.Set(true)
    local Arrow = ESPLibrary.ESP.Arrow({
                Model = door, 
                MaxDistance = 5000, 
                CenterOffset = 300, 
                Color = highlightColor
            })
            ESPLibrary.Arrows.Enable()
        else
            ESPLibrary.Arrows.Disable()
        end
    end
})

listModFiles()
OrionLib:Init()
