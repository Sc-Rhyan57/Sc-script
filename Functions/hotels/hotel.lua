local OrionLib = loadstring(game:HttpGetAsync('https://raw.githubusercontent.com/shlexware/Orion/main/source'))()
local Window = OrionLib:MakeWindow({IntroText = "Seeker Hub × Paint", Name = "👁️ | RSeeKer Hub", HidePremium = false, SaveConfig = true, ConfigFolder = ".seeker"})

local sound = Instance.new("Sound")
sound.SoundId = "rbxassetid://4590657171"
sound.Volume = 1
sound.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
sound:Play()
sound.Ended:Connect(function()
    sound:Destroy()
end)
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "🔔 Notificação | Rseeker System",
    Text = "O Menu foi iniciado com sucesso!(Caso não tenha aparece nenhuma função eles está quebrado ou em manutenção! 🤝)",
    Icon = "rbxassetid://76411928845479",
    Duration = 5
})

if game.PlaceId == 6516141723 then
    OrionLib:MakeNotification({
        Name = "Error",
        Content = "Por favor, execute quando estiver no jogo, não no lobby.",
        Time = 2
    })
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

--// Players  Vars \\--
local camera = workspace.CurrentCamera

local localPlayer = Players.LocalPlayer
local playerGui = localPlayer.PlayerGui
local playerScripts = localPlayer.PlayerScripts

local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
local alive = localPlayer:GetAttribute("Alive")
local humanoid: Humanoid
local rootPart: BasePart
local collision
local collisionClone
local velocityLimiter

                
--// VARIÁVEIS \\--

local autoLootEnabled = false
local autoInteractEnabled = false

--[ Automoção ]--
-- AUTO INTERACT
local RunService = game:GetService("RunService")
local autoInteractEnabled = false

local function autoInteract()
    while autoInteractEnabled do
        for _, prompt in pairs(workspace:GetDescendants()) do
            if prompt:IsA("ProximityPrompt") and prompt.ActionText == "Loot" then
                if prompt.MaxActivationDistance > (game.Players.LocalPlayer:DistanceFromCharacter(prompt.Parent.Position) or math.huge) then
                    fireproximityprompt(prompt)
                end
            end
        end
        task.wait(0.3) 
    end
end

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
-- MS ESP(@mstudio45) - thanks for the API!
-- OBJETOS ESP
local ESPLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/mstudio45/MS-ESP/refs/heads/main/source.lua"))()

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
        From = "Bottom",
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
    {"Item", "+", Color3.fromRGB(0, 255, 0)},
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
    {"droppedItem", "+", Color3.fromRGB(0, 0, 255)}
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

-- DOORS ESP
function round(number, decimals)
    local power = 10 ^ decimals
    return math.floor(number * power) / power
end

local ESPColors = {
    Door = Color3.fromRGB(241, 196, 15),
}

local function setupESPForDoors(door)
    local highlight = ESPLibrary.ESP.Highlight({
        Name = "Door",
        Model = door,
        FillColor = ESPColors.Door,
        OutlineColor = ESPColors.Door,
        TextColor = ESPColors.Door,

        Tracer = {
            Enabled = true,
            Color = ESPColors.Door
        }
    })
end

spawn(function()
    while wait(0.2) do 
        if doorESPEnabled then
            for _, room in pairs(workspace.CurrentRooms:GetChildren()) do
                if room:FindFirstChild("Door") and room.Door:FindFirstChild("Door") then
                    local door = room.Door.Door

                    if not door:FindFirstChild("Highlight") then
                        setupESPForDoors(door)
                    end

                    -- Removendo as legendas "Door (number)" e "Studs"
                    local bb = door:FindFirstChild("BillBoard")
                    if bb then
                        bb:Destroy()
                    end
                end
            end
        end
    end
end)

ESPLibrary.Rainbow.Set(true)

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
local antiLagConnection

local function ActivateAntiLag()
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
        Text = "Anti Lag Ativo",
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
    local currentRoom = game.ReplicatedStorage:WaitForChild("GameData"):WaitForChild("LatestRoom").Value
    print("[Seekee Logs] AntiLag Adicionado a sala " .. currentRoom)

    ActivateAntiLag()
end

local latestRoom = game.ReplicatedStorage:WaitForChild("GameData"):WaitForChild("LatestRoom")
latestRoom:GetPropertyChangedSignal("Value"):Connect(onRoomChanged)

-- DELETE SEEK
local function StartDeleteSeek()
    local rootPart = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not rootPart then
        OrionLib:MakeNotification({
            Name = "Erro",
            Content = "Barreira do Seek não encontrada!",
            Time = 5
        })
        return
    end

    local function DeleteSeek(obj)
        if obj and obj:IsA("BasePart") and obj.Name == "Collision" then
            firetouchinterest(rootPart, obj, 1)
            firetouchinterest(rootPart, obj, 0)

            OrionLib:MakeNotification({
                Name = "Delete Seek",
                Content = "Seek foi deletado com sucesso!",
                Time = 5
            })
        end
    end

    game.Workspace.DescendantAdded:Connect(function(child)
        if getgenv().DeleteSeekEnabled and child.Name == "Collision" then
            DeleteSeek(child)
        end
    end)
end

--- Anti Screesh
local isAntiScreechActive = false  
local RunService = game:GetService("RunService")  
local mainGame = game.Players.LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("Main_Game")

local function AntiScreechCheck()
    RunService.RenderStepped:Connect(function()
        if isAntiScreechActive and mainGame then
            local module = mainGame:FindFirstChild("Screech", true) or mainGame:FindFirstChild("_Screech", true)
            if module then
                module.Name = "_Screech"
            end
        end
    end)
end

--//NOTIFICAÇÃO\\--
local EntityTable = {
    ["Names"] = {"BackdoorRush", "BackdoorLookman", "RushMoving", "AmbushMoving", "Eyes", "JeffTheKiller", "A60", "A120"},
    ["SideNames"] = {"FigureRig", "GiggleCeiling", "GrumbleRig", "Snare"},
    ["ShortNames"] = {
        ["BackdoorRush"] = "Blitz",
        ["JeffTheKiller"] = "Jeff The Killer"
    },
    ["NotifyMessage"] = {
        ["GloombatSwarm"] = "Gloombats in the next room!"
    },
    ["Avoid"] = {
        "RushMoving",
        "AmbushMoving"
    },
    ["NotifyReason"] = {
        ["A60"] = {
            ["Image"] = "12350986086",
        },
        ["A120"] = {
            ["Image"] = "12351008553",
        },
        ["BackdoorRush"] = {
            ["Image"] = "11102256553",
        },
        ["RushMoving"] = {
            ["Image"] = "11102256553",
        },
        ["AmbushMoving"] = {
            ["Image"] = "10938726652",
        },
        ["Eyes"] = {
            ["Image"] = "10865377903",
            ["Spawned"] = true
        },
        ["BackdoorLookman"] = {
            ["Image"] = "16764872677",
            ["Spawned"] = true
        },
        ["JeffTheKiller"] = {
            ["Image"] = "98993343",
            ["Spawned"] = true
        },
        ["GloombatSwarm"] = {
            ["Image"] = "108578770251369",
            ["Spawned"] = true
        }
    }
}

local notificationsEnabled = false

function NotifyEntity(entityName)
    if notificationsEnabled and EntityTable.NotifyReason[entityName] then
        local notificationData = EntityTable.NotifyReason[entityName]
        local notifyTitle = EntityTable.ShortNames[entityName] or entityName
        local notifyMessage = EntityTable.NotifyMessage[entityName] or "Entity detected!"
        
        OrionLib:MakeNotification({
            Name = notifyTitle,
            Content = notifyMessage,
            Image = "rbxassetid://" .. notificationData.Image,
            Time = 5
        })
    end
end

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

--[ ORION LIB - MENU ]--
-- Define um VisualsTab vazio
local VisualsTab = Window:MakeTab({
    Name = "Início",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- ESPS
local VisualsEsp = Window:MakeTab({
    Name = "Visuais",
    Icon = "rbxassetid://6658334182",
    PremiumOnly = false
})
VisualsEsp:AddParagraph("Esp", "Ver objetos através da parede.")
-- BOTÕES ORGANIZADOS POR rhyan57
-- DOORS ESP
-- Botão usando Orion Lib
VisualsEsp:AddToggle({
    Name = "ESP de Portas",
    Default = false,
    Callback = function(value)
        doorESPEnabled = value
        if not doorESPEnabled then
            for _, room in pairs(workspace.CurrentRooms:GetChildren()) do
                if room:FindFirstChild("Door") and room.Door:FindFirstChild("Door") then
                    local door = room.Door.Door
                    if door:FindFirstChild("Highlight") then
                        door.Highlight:Destroy()
                    end
                    if door:FindFirstChild("BillBoard") then
                        door.BillBoard:Destroy()
                    end
                end
            end
        end
    end
})

-- Esp de entidades
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
    Callback = function(value)
        if value then
            ActivateAntiLag()
        else
            DeactivateAntiLag()
        end
    end
})

-- Funções de automação
local autoIn = Window:MakeTab({
    Name = "Automoção",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})


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


autoIn:AddToggle({
    Name = "Auto Interact",
    Default = false,
    Callback = function(state)
        autoInteractEnabled = state
        if autoInteractEnabled then
            coroutine.wrap(autoInteract)() 
        end
    end
})

-- Define uma aba de créditos
local ByTab = Window:MakeTab({
    Name = "Byppas",
    Icon = "rbxassetid://14255000409",
    PremiumOnly = false
})

--// Anti-Eyes \\--
local AntiEyesConnection

ByTab:AddToggle({
    Name = "Anti-Eyes",
    Default = false,
    Callback = function(Value)
        if Value then
            local function applyAntiEyes(entity)
                if entity.Name == "Eyes" or entity.Name == "BackdoorLookman" then
                    if not isFools then
                        remotesFolder.MotorReplication:FireServer(-649)
                    else
                        remotesFolder.MotorReplication:FireServer(0, -90, 0, false)
                    end
                end
            end
            
            for _, entity in pairs(workspace:GetChildren()) do
                applyAntiEyes(entity)
            end
            
            AntiEyesConnection = workspace.ChildAdded:Connect(function(newChild)
                applyAntiEyes(newChild)
            end)
        else
            if AntiEyesConnection then
                AntiEyesConnection:Disconnect()
                AntiEyesConnection = nil
            end
        end
    end
})

ByTab:AddToggle({
    Name = "Anti-Screech",
    Default = false,
    Callback = function(value)
        isAntiScreechActive = value  
        if value then
            AntiScreechCheck()
        end
    end
})

--//Anti Goggle\\--
local antiGiggleEnabled = false

ByTab:AddToggle({
    Name = "Anti-Giggle",
    Default = false,
    Callback = function(value)
        antiGiggleEnabled = value
        for _, room in pairs(workspace.CurrentRooms:GetChildren()) do
            for _, giggle in pairs(room:GetChildren()) do
                if giggle.Name == "GiggleCeiling" then
                    giggle:WaitForChild("Hitbox", 5).CanTouch = not antiGiggleEnabled
                end
            end
        end
    end
})

local function toggleAntiGiggle(state)
    antiGiggleEnabled = state
    for _, room in pairs(workspace.CurrentRooms:GetChildren()) do
        for _, giggle in pairs(room:GetChildren()) do
            if giggle.Name == "GiggleCeiling" then
                giggle:WaitForChild("Hitbox", 5).CanTouch = not antiGiggleEnabled
            end
        end
    end
end

-- Define uma aba para itens
local ItensTab = Window:MakeTab({
    Name = "Give Itens",
    Icon = "rbxassetid://11713331539",
    PremiumOnly = false
})

ItensTab:AddButton({
    Name = "💊 Vitamina",
    Callback = function()
        loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/RhyanXG7/RseekerHub/Fun%C3%A7%C3%B5es/Sc/GiveVitamns.lua"))()
    end
})

-- Aba para itens infinitos
local IitensTab = Window:MakeTab({
    Name = "Infinte Itens",
    Icon = "rbxassetid://11713331539",
    PremiumOnly = false
})

IitensTab:AddButton({
    Name = "✝️ Crucifixo infinito",
    Callback = function()
        loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/RhyanXG7/RseekerHub/refs/heads/Fun%C3%A7%C3%B5es/Sc/GiveCrucifix.lua"))()
    end
})
-- Exploits
local ExploitsTab = Window:MakeTab({
    Name = "Exploits",
    Icon = "rbxassetid://13264701341",
    PremiumOnly = false
})

ExploitsTab:AddToggle({
    Name = "Anti-Halt",
    Default = false,
    Callback = function(value)
        local entityModules = game:GetService("ReplicatedStorage"):FindFirstChild("EntityModules")
        if entityModules then
            local haltModule = entityModules:FindFirstChild("Shade") or entityModules:FindFirstChild("_Shade")
            if haltModule then
                haltModule.Name = value and "_Shade" or "Shade"
            end
        end
    end    
})

ExploitsTab:AddToggle({
    Name = "Delete Seek (FE)",
    Default = false,
    Callback = function(value)
        getgenv().DeleteSeekEnabled = value
        if value then
            StartDeleteSeek()
        end
    end    
})
-- Aba de notificações
local notifsTab = Window:MakeTab({
    Name = "Notificações",
    Icon = "rbxassetid://17328380241",
    PremiumOnly = false
})

-- Dropdown para escolher quais entidades notificar
notifsTab:AddDropdown({
    Name = "Notify Entities",
    AllowNull = true,
    Values = {"Blitz", "Lookman", "Rush", "Ambush", "Eyes", "A60", "A120", "Jeff The Killer", "Gloombat Swarm"},
    Default = {},
    Multi = true,
    Callback = function(selectedEntities)
        for _, entity in ipairs(selectedEntities) do
            NotifyEntity(entity)
        end
    end
})

-- Adiciona o toggle para ativar/desativar as notificações
notifsTab:AddToggle({
    Name = "Enable Notifications",
    Default = false,
    Callback = function(value)
        notificationsEnabled = value
        if value then
            OrionLib:MakeNotification({
                Name = "Notifications Enabled",
                Content = "Entity notifications have been enabled.",
                Time = 3
            })
        else
            OrionLib:MakeNotification({
                Name = "Notifications Disabled",
                Content = "Entity notifications have been disabled.",
                Time = 3
            })
        end
    end
})

notifsTab:AddButton({
    Name = "⚠️ Ambush Alert",
    Callback = function()
        loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/RhyanXG7/RseekerHub/NaSum/Sc/AmbushoSum.lua"))()
    end
})

notifsTab:AddButton({
    Name = "⚠️ Eyes Alert",
    Callback = function()
        loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/RhyanXG7/RseekerHub/NaSum/Sc/EyesSum.lua"))()
    end
})

-- Local Player
local GameLocal = Window:MakeTab({
    Name = "Local",
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

local FloorTab = Window:MakeTab({
    Name = "Floors",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local AutomationSection = FloorTab:AddSection({
    Name = "Automation"
})

AutomationSection:AddButton({
    Name = "Beat Door 200",
    Callback = function()
        if latestRoom.Value < 99 then
            local sound = Instance.new("Sound")
sound.SoundId = "rbxassetid://4590657391"
sound.Volume = 1
sound.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
sound:Play()
sound.Ended:Connect(function()
    sound:Destroy()
end)
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "🔔 Notificação | Floor 2",
    Text = "Você ainda não alcançou a porta 200!",
    Icon = "rbxassetid://13264701341",
    Duration = 5
})
            return
        end

        local bypassing = Toggles.SpeedBypass.Value
        local startPos = rootPart.CFrame

        Toggles.SpeedBypass:SetValue(false)

        local damHandler = workspace.CurrentRooms[latestRoom.Value]:FindFirstChild("_DamHandler")

        if damHandler then
-- FASE 1
            if damHandler:FindFirstChild("PlayerBarriers1") then
                for _, pump in pairs(damHandler.Flood1.Pumps:GetChildren()) do
                    character:PivotTo(pump.Wheel.CFrame)
                    task.wait(0.25)
                    fireproximityprompt(pump.Wheel.ValvePrompt)
                    task.wait(0.25)
                end
                task.wait(8)
            end

-- FASE 2
            if damHandler:FindFirstChild("PlayerBarriers2") then
                for _, pump in pairs(damHandler.Flood2.Pumps:GetChildren()) do
                    character:PivotTo(pump.Wheel.CFrame)
                    task.wait(0.25)
                    fireproximityprompt(pump.Wheel.ValvePrompt)
                    task.wait(0.25)
                end
                task.wait(8)
            end

-- FASE 3
            if damHandler:FindFirstChild("PlayerBarriers3") then
                for _, pump in pairs(damHandler.Flood3.Pumps:GetChildren()) do
                    character:PivotTo(pump.Wheel.CFrame)
                    task.wait(0.25)
                    fireproximityprompt(pump.Wheel.ValvePrompt)
                    task.wait(0.25)
                end
                task.wait(10)
            end
        end

        local generator = workspace.CurrentRooms[latestRoom.Value]:FindFirstChild("MinesGenerator", true)

        if generator then
            character:PivotTo(generator.PrimaryPart.CFrame)
            task.wait(0.25)
            fireproximityprompt(generator.Lever.LeverPrompt)
            task.wait(0.25)
        end

        Toggles.SpeedBypass:SetValue(bypassing)
        character:PivotTo(startPos)
    end
})

-- Define uma aba de créditos
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

CdSc:AddParagraph("Mstudio45", "Disponibilizou a API de esps para uso")
CdSc:AddParagraph("MsPaint V2", "Algun Recursos/funções foram feitas com base no código da MsPaint")


-- Inicializa a interface
OrionLib:Init()
