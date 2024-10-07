local OrionLib = loadstring(game:HttpGetAsync('https://raw.githubusercontent.com/shlexware/Orion/main/source'))()
local Window = OrionLib:MakeWindow({IntroText = "Seeker Hub × Paint", Name = "👁️ | RSeeKer Hub", HidePremium = false, SaveConfig = true, ConfigFolder = ".seeker"})

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


-- DELETE SEEK
local Toggles = {
    DeleteSeek = {Value = true}
}
function DeleteSeek(collision: BasePart)
    if not rootPart then return end

    task.spawn(function()
        local attempts = 0
        repeat task.wait() attempts += 1 until collision.Parent or attempts > 200

        if collision:IsDescendantOf(workspace) and (collision.Parent and collision.Parent.Name == "TriggerEventCollision") then
            OrionLib:MakeNotification({
                Name = "Delete Seek - Seeker Hub",
                Content = "Deleting Seek trigger...",
                Time = 5,
                Image = "rbxassetid://6023426923"
            })

            task.delay(4, function()
                if collision:IsDescendantOf(workspace) then
                    OrionLib:MakeNotification({
                        Name = "Delete Seek FE",
                        Content = "Failed to delete Seek trigger!",
                        Time = 5,
                        Image = "rbxassetid://6023426923"
                    })
                end
            end)

            if fireTouch then
                rootPart.Anchored = true
                task.delay(0.25, function() rootPart.Anchored = false end)

                repeat
                    if collision:IsDescendantOf(workspace) then fireTouch(collision, rootPart, 1) end
                    task.wait()
                    if collision:IsDescendantOf(workspace) then fireTouch(collision, rootPart, 0) end
                    task.wait()
                until not collision:IsDescendantOf(workspace) or not Toggles.DeleteSeek.Value
            else
                collision:PivotTo(CFrame.new(rootPart.Position))
                rootPart.Anchored = true
                repeat task.wait() until not collision:IsDescendantOf(workspace) or not Toggles.DeleteSeek.Value
                rootPart.Anchored = false
            end

            if not collision:IsDescendantOf(workspace) then
                OrionLib:MakeNotification({
                    Name = "Delete Seek - Seeker Hub",
                    Content = "Deleted Seek trigger successfully!",
                    Time = 5,
                    Image = "rbxassetid://6023426923"
                })
            end
        end
    end)
end

function TestDeleteSeek()
    local exampleCollision = game.Workspace:FindFirstChild("SomeCollisionPart") -- Altere para um objeto válido de colisão
    if exampleCollision then
        DeleteSeek(exampleCollision)
    else
        OrionLib:MakeNotification({
            Name = "Error",
            Content = "No collision object found!",
            Time = 5
        })
    end
end

--// Tabela de Entidades \\--
local EntityTable = {
    ["Names"] = {"BackdoorRush", "BackdoorLookman", "RushMoving", "AmbushMoving", "Eyes", "JeffTheKiller", "A60", "A120"},
    ["NotifyReason"] = {
        ["A60"] = { ["Image"] = "12350986086" },
        ["A120"] = { ["Image"] = "12351008553" },
        ["BackdoorRush"] = { ["Image"] = "11102256553" },
        ["RushMoving"] = { ["Image"] = "11102256553" },
        ["AmbushMoving"] = { ["Image"] = "10938726652" },
        ["Eyes"] = { ["Image"] = "10865377903", ["Spawned"] = true },
        ["BackdoorLookman"] = { ["Image"] = "16764872677", ["Spawned"] = true },
        ["JeffTheKiller"] = { ["Image"] = "98993343", ["Spawned"] = true },
        ["GloombatSwarm"] = { ["Image"] = "108578770251369", ["Spawned"] = true }
    }
}

-- Função para notificar sobre entidades usando OrionLib
function NotifyEntity(entityName)
    if EntityTable.NotifyReason[entityName] then
        local notificationData = EntityTable.NotifyReason[entityName]
        local notifyTitle = entityName
        local notifyMessage = "Entidade Detectada!"

        OrionLib:MakeNotification({
            Name = notifyTitle,
            Content = notifyMessage,
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

-- Variável para controlar se as notificações estão ativas
local notificationsEnabled = false

-- Função para monitorar a aparição de entidades e notificá-las
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

--// Cart System \\--
local minecartVisualizerActive = false
local minecartTeleportActive = false

function MinecartPathVisualiser()
    local realNodes = {}
    local fakeNodes = {}

    local function changeNodeColor(node, color)
        if not node then return end
        node.Color = color or Color3.fromRGB(255, 255, 0)
        node.Material = Enum.Material.Neon
        node.Transparency = 0
    end

    while minecartVisualizerActive do
        for _, node in pairs(realNodes) do
            changeNodeColor(node, Color3.fromRGB(0, 255, 0))
        end
        for _, node in pairs(fakeNodes) do
            changeNodeColor(node, Color3.fromRGB(255, 0, 0))
        end
        task.wait(1)
    end
end

function MinecartTeleport()
    local minecartRoot
    local minecartRig
    local roomNum = 45

    while minecartTeleportActive do
        minecartRig = workspace.CurrentCamera:FindFirstChild("MinecartRig")
        if minecartRig then
            minecartRoot = minecartRig:FindFirstChild("Root")
            for _, path in ipairs(MinecartPathfind) do
                if path.room_number >= roomNum then
                    local lastNode = path.real[#path.real]
                    minecartRoot.CFrame = lastNode.CFrame
                    task.wait(2)
                    if roomNum == 49 then break end
                end
            end
        end
        task.wait(1)
    end
end


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

--[ Funções de automação ]--
local autoIn = Window:MakeTab({
    Name = "Automoção",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
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

--[ VOU JOGAR FNF, DEPOIS TERMINO. ]--
--[ RESOLVER: AUTO LIBRARY 50, ANTI ENTITY E MORE. ]--

local Options = {
    AutoBreakerSolverMethod = {Value = "Legit"},
    AutoBreakerSolver = {Value = false}, 
    LegitMode = {Value = true} 
}

function EnableBreaker(breaker, value)
    breaker:SetAttribute("Enabled", value)

    if value then
        breaker:FindFirstChild("PrismaticConstraint", true).TargetPosition = -0.2
        breaker.Light.Material = Enum.Material.Neon
        breaker.Light.Attachment.Spark:Emit(1)
        breaker.Sound.Pitch = 1.3
    else
        breaker:FindFirstChild("PrismaticConstraint", true).TargetPosition = 0.2
        breaker.Light.Material = Enum.Material.Glass
        breaker.Sound.Pitch = 1.2
    end

    breaker.Sound:Play()
end

function SolveBreakerBox(breakerBox)
    if not Options.AutoBreakerSolver.Value then return end -- Verifica se o AutoBreakerSolver está ativado
    if not breakerBox then return end

    local code = breakerBox:FindFirstChild("Code", true)
    local correct = breakerBox:FindFirstChild("Correct", true)

    repeat task.wait() until code.Text ~= "..." or not breakerBox:IsDescendantOf(workspace)
    if not breakerBox:IsDescendantOf(workspace) then return end

    OrionLib:MakeNotification({
        Name = "Auto Breaker Solver",
        Content = "Solving the breaker box...",
        Image = "rbxassetid://4483345998",
        Time = 5
    })

    if Options.LegitMode.Value then
        local UsedBreakers = {}
        if correct then
            correct:GetPropertyChangedSignal("Playing"):Connect(function()
                if correct.Playing then table.clear(UsedBreakers) end
            end)

            code:GetPropertyChangedSignal("Text"):Connect(function()
                task.delay(0.1, AutoBreaker, code, breakerBox)
            end)
        end
    else
        repeat task.wait(0.1)
            remotesFolder.EBF:FireServer()
        until not workspace.CurrentRooms["100"]:FindFirstChild("DoorToBreakDown")

        OrionLib:MakeNotification({
            Name = "Auto Breaker Solver",
            Content = "The breaker box has been successfully solved.",
            Image = "rbxassetid://4483345998",
            Time = 5
        })
    end
end
function AutoBreaker(code, breakerBox)
    local newCode = code.Text
    if not tonumber(newCode) and newCode ~= "??" then return end

    local isEnabled = code.Frame.BackgroundTransparency == 0
    local breaker = breakerBox[newCode]

    if newCode == "??" and #UsedBreakers == 9 then
        for i = 1, 10 do
            local id = string.format("%02d", i)
            if not table.find(UsedBreakers, id) then
                breaker = breakerBox[id]
            end
        end
    end

    if breaker then
        table.insert(UsedBreakers, newCode)
        if breaker:GetAttribute("Enabled") ~= isEnabled then
            EnableBreaker(breaker, isEnabled)
        end
    end
end


--[[ Byppas Area ]]--
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

--//Anti Giggle\\--
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

ByTab:AddToggle({
    Name = "Anti-Halt",
    Default = false,
    Callback = function(value)
        local entityModules = game:GetService("ReplicatedStorage"):FindFirstChild("EntityModules")
        if entityModules then
            local haltModule = entityModules:FindFirstChild("Shade") or entityModules:FindFirstChild("_Shade")
            
            if haltModule then
                haltModule.Name = value and "_Shade" or "Shade"
                
                if value then
                    local entity = workspace:FindFirstChild("ShadeEntity")
                    if entity then
                        Script.Functions.DeleteSeek(entity)
                        print("[ SeekerLogs ] a Entidade 'Shade' foi detectada e deletada.")
                    else
                        print("[ SeekerLogs ] a Entidade 'Shade' não foi encontrada.")
                    end
                end
            end
        end
    end
})


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


-- Exploits
local ExploitsTab = Window:MakeTab({
    Name = "Exploits",
    Icon = "rbxassetid://13264701341",
    PremiumOnly = false
})


ExploitsTab:AddToggle({
    Name = "Activate Delete Seek",
    Default = true,
    Callback = function(Value)
        Toggles.DeleteSeek.Value = Value
        OrionLib:MakeNotification({
            Name = "Rseeker Hub",
            Content = "Delete Seek agora está " .. (Value and "Active" or "Inactive"),
            Time = 5
        })
    end
})

ExploitsTab:AddButton({
    Name = "Test Delete Seek",
    Callback = function()
        TestDeleteSeek()
    end
})

-- Aba de notificações
local notifsTab = Window:MakeTab({
    Name = "Notificações",
    Icon = "rbxassetid://17328380241",
    PremiumOnly = false
})

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

local Visuals = FloorTab:AddSection({
    Name = "Visual"
})

Visuals:AddToggle({
    Name = "Visualizador de Caminho do Minecart",
    Default = false,
    Callback = function(value)
        minecartVisualizerActive = value
        if minecartVisualizerActive then
            task.spawn(MinecartPathVisualiser)
        end
    end    
})

local AutomationSection = FloorTab:AddSection({
    Name = "Automoção"
})

AutomationSection:AddToggle({
    Name = "Auto Breaker Solver",
    Default = false,
    Callback = function(Value)
        Options.AutoBreakerSolver.Value = Value -- (Basicamente liga/desliga)
    end    
})

AutomationSection:AddToggle({
    Name = "Use Legit Method",
    Default = true,
    Callback = function(Value)
        Options.LegitMode.Value = Value
    end    
})


AutomationSection:AddToggle({
    Name = "AutoMinecart tp",
    Default = false,
    Callback = function(value)
        minecartTeleportActive = value
        if minecartTeleportActive then
            task.spawn(MinecartTeleport)
        end
    end    
})

AutomationSection:AddButton({
    Name = "Bater Porta 200",
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

Livraria:AddParagraph("Mstudio45", "Disponibilizou a API de esps para uso")
Livraria:AddParagraph("MsPaint V2", "Algun Recursos/funções foram feitas com base no código da MsPaint")


-- Inicializa a interface
OrionLib:Init()
