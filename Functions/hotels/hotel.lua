local OrionLib = loadstring(game:HttpGetAsync('https://raw.githubusercontent.com/shlexware/Orion/main/source'))()
local Window = OrionLib:MakeWindow({IntroText = "RSeekerHUb 1.0.0", Name = "👁️ | RSeeKer Hub", HidePremium = false, SaveConfig = true, ConfigFolder = ".seeker"})

local sound = Instance.new("Sound")
sound.SoundId = "rbxassetid://3458224686"
sound.Volume = 1
sound.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
sound:Play()
sound.Ended:Connect(function()
    sound:Destroy()
end)
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "✨ Rseeker Hub V1",
    Text = "🟢 Menu ativo com sucesso!",
    Icon = "rbxassetid://13264701341",
    Duration = 5
})

if game.PlaceId == 6516141723 then
    OrionLib:MakeNotification({
        Name = "Error",
        Content = "Por favor, execute quando estiver no jogo, não no lobby.",
        Time = 2
    })
end


-- VARIÁVEIS --

local autoLootEnabled = false
local autoInteractEnabled = false
local doorESPEnabled = false

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
local autoLootEnabled = false
local lootItems = { "KeyObtain", "Nomedoarquivo2" }

local function autoLoot()
    while autoLootEnabled do
        for _, itemName in pairs(lootItems) do
            local item = workspace:FindFirstChild(itemName)
            if item and item:IsA("Model") and item:FindFirstChild("Lootable") then
                print("Interagindo com o item:", itemName)
                firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, item, 0)
            else
                print("Item não encontrado ou não lootable:", itemName)
            end
        end
        wait(1)
    end
end
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
    {"Eyes", "Olhos", Color3.fromRGB(255, 0, 0)},
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
    {"KeyObtain", "Chave", Color3.fromRGB(0, 0, 255)},
    {"LeverForGate", "Alavanca", Color3.fromRGB(0, 0, 255)},
    {"ElectricalKeyObtain", "Chave elétrica", Color3.fromRGB(0, 0, 255)},
    {"LiveHintBook", "Livro", Color3.fromRGB(0, 0, 255)},
    {"LiveBreakerPolePickup", "Disjuntor", Color3.fromRGB(0, 0, 255)},
    {"MinesGenerator", "Gerador", Color3.fromRGB(0, 0, 255)},
    {"MinesGateButton", "Botão do portão", Color3.fromRGB(0, 0, 255)},
    {"FuseObtain", "Fusível", Color3.fromRGB(0, 0, 255)},
    {"MinesAnchor", "Torre", Color3.fromRGB(0, 0, 255)},
    {"WaterPump", "Bomba de água", Color3.fromRGB(0, 0, 255)}
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

portasSkESP.Rainbow.Enable()
portasSkESP.Tracers.Enable()

local function roundSk(number, decimals)
    local power = 10 ^ decimals
    return math.floor(number * power) / power
end

local function removeOldESP(portasSkModel)
    if portasSkModel:FindFirstChild("DOOR ESP : SeekerHub") then
        portasSkModel["DOOR ESP : SeekerHub"]:Destroy()
    end
    if portasSkModel:FindFirstChild("DOOR LGD : SeekerHub") then
        portasSkModel["DOOR LGD : SeekerHub"]:Destroy()
    end
end

local function createESPForPorta(portasSkModel, portasSkNumber, portasSkState)
    removeOldESP(portasSkModel)
    local portaESP = portasSkESP.ESP.Highlight({
        Name = "Door " .. portasSkNumber .. portasSkState,
        Model = portasSkModel,
        FillColor = nil,
        OutlineColor = Color3.fromRGB(255, 255, 255),
        TextColor = Color3.fromRGB(241, 196, 15),
        Tracer = { 
            Enabled = true,
            Color = Color3.fromRGB(255, 0, 0)
        }
    })

    local bb = Instance.new('BillboardGui', portasSkModel)
    bb.Adornee = portasSkModel
    bb.ExtentsOffset = Vector3.new(0, 1, 0)
    bb.AlwaysOnTop = true
    bb.Size = UDim2.new(0, 6, 0, 6)
    bb.StudsOffset = Vector3.new(0, 1, 0)
    bb.Name = "DOOR LGD : SeekerHub"

    local txtlbl = Instance.new('TextLabel', bb)
    txtlbl.ZIndex = 10
    txtlbl.BackgroundTransparency = 1
    txtlbl.Position = UDim2.new(0, 0, 0, -45)
    txtlbl.Size = UDim2.new(1, 0, 10, 0)
    txtlbl.Font = Enum.Font.ArialBold
    txtlbl.Text = "Door " .. portasSkNumber .. portasSkState
    txtlbl.TextStrokeTransparency = 0.5
    txtlbl.TextColor3 = Color3.fromRGB(241, 196, 15)

    local txtlbl2 = Instance.new('TextLabel', bb)
    txtlbl2.ZIndex = 10
    txtlbl2.BackgroundTransparency = 1
    txtlbl2.Position = UDim2.new(0, 0, 0, -15)
    txtlbl2.Size = UDim2.new(1, 0, 10, 0)
    txtlbl2.Font = Enum.Font.ArialBold
    txtlbl2.Text = "? Studs"
    txtlbl2.Name = "Dist"
    txtlbl2.TextStrokeTransparency = 0.5
    txtlbl2.TextColor3 = Color3.fromRGB(241, 196, 15)
end

spawn(function()
    while wait(1) do
        if doorESPEnabled then
            local latestRoom = game.ReplicatedStorage.GameData.LatestRoom.Value
            for _, room in ipairs(workspace.CurrentRooms:GetChildren()) do
                if room:FindFirstChild("Door") and room.Door:FindFirstChild("Door") then
                    local portasSkModel = room.Door.Door
                    local portasSkState = ""
                    local opened = room.Door:GetAttribute("Opened")
                    local locked = room:GetAttribute("RequiresKey")

                    if opened then
                        portasSkState = " [🔓]"
                        removeOldESP(portasSkModel)
                        continue
                    elseif locked then
                        portasSkState = " [🔐]"
                    else
                        portasSkState = " [🔒]"
                    end

                    local portasSkNumber = tonumber(room.Name) or latestRoom + 1

                    if portasSkNumber > latestRoom then
                        if not portasSkModel:FindFirstChild("DOOR ESP : SeekerHub") then
                            createESPForPorta(portasSkModel, portasSkNumber, portasSkState)
                        end

                        if portasSkModel:FindFirstChild("DOOR LGD : SeekerHub") then
                            local distLabel = portasSkModel["DOOR LGD : SeekerHub"].Dist
                            distLabel.Text = roundSk((game.Players.LocalPlayer.Character.PrimaryPart.Position - portasSkModel.Position).magnitude, 1) .. " Studs"
                        end
                    end
                end
            end
        end
    end
end)

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

-- BOTÕES ORGANIZADOS POR rhyan57
-- DOORS ESL
VisualsEsp:AddToggle({
    Name = "ESP de Portas",
    Default = false,
    Callback = function(Value)
        doorESPEnabled = Value
        if not doorESPEnabled then
            for _, room in ipairs(workspace.CurrentRooms:GetChildren()) do
                if room:FindFirstChild("Door") and room.Door:FindFirstChild("Door") then
                    local portasSkModel = room.Door.Door
                    removeOldESP(portasSkModel)
                end
            end
        end
    end
})

-- ENTIDADES ESP
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

-- Funções de automação
local autoIn = Window:MakeTab({
    Name = "Automoção",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

autoIn:AddToggle({
    Name = "Auto Loot",
    Default = false,
    Callback = function(state)
        autoLootEnabled = state
        if state then
            autoLoot()
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

-- Aba de notificações
local notifsTab = Window:MakeTab({
    Name = "Notificações",
    Icon = "rbxassetid://17328380241",
    PremiumOnly = false
})

notifsTab:AddButton({
    Name = "⚠️ Rush Alert",
    Callback = function()
        loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/RhyanXG7/RseekerHub/NaSum/Sc/RushSum.lua"))()
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

-- Define uma aba local
local GameLocal = Window:MakeTab({
    Name = "Local",
    Icon = "rbxassetid://17328380241",
    PremiumOnly = false
})

GameLocal:AddSlider({
    Name = "🏃 Velocidade de caminhada",
    Min = 16,
    Max = 100,
    Default = 16,
    Color = Color3.fromRGB(255, 255, 255),
    Increment = 1,
    ValueName = "Speed",
    Callback = function(value)
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoid = character:WaitForChild("Humanoid")
        humanoid.WalkSpeed = value
    end
})

local speedBoostEnabled = false

local function toggleSpeedBoost()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")
    
    if humanoid then
        if speedBoostEnabled then
            humanoid.WalkSpeed = 16 -- Velocidade padrão
            print("Velocidade restaurada para 16.")
        else
            humanoid.WalkSpeed = 50 -- Aumenta a velocidade de caminhada
            print("Velocidade aumentada para 50.")
        end

        speedBoostEnabled = not speedBoostEnabled
    else
        warn("Humanoid não encontrado!")
    end
end

GameLocal:AddButton({
    Name = "🏃 Toggle Speed Boost",
    Callback = function()
        toggleSpeedBoost()
    end    
})

GameLocal:AddButton({
    Name = "🔄 Resetar velocidade",
    Callback = function()
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoid = character:WaitForChild("Humanoid")
        humanoid.WalkSpeed = 16
    end
})

GameLocal:AddParagraph("❓ Info velocidade", "Não consegue interagir? utilize um mouse.")

local fovEnabled = false

local function toggleFieldOfView()
    local camera = workspace.CurrentCamera

    if fovEnabled then
        camera.FieldOfView = 70
    else
        camera.FieldOfView = 120
    end

    fovEnabled = not fovEnabled
end

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
    Name = "👁️ Brilho total",
    Callback = function()
        loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/RhyanXG7/RseekerHub/Fun%C3%A7%C3%B5es/Sc/fullbright.lua"))()
        print("O botão brilho total foi ativo!")
    end
})

GameLocal:AddButton({
    Name = "👻 Modo Fantasma",
    Callback = function()
        loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/RhyanXG7/RseekerHub/Fun%C3%A7%C3%B5es/Sc/Godmode.lua"))()
        print("O godmode foi ativo!")
    end
})

GameLocal:AddButton({
    Name = "👻 Noclip",
    Callback = function()
        loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/RhyanXG7/RseekerHub/Fun%C3%A7%C3%B5es/Sc/noclip.lua"))()
        print("O botão nc foi clicado!")
    end
})

-- Define uma aba de créditos
local CreditsTab = Window:MakeTab({
    Name = "Creditos",
    Icon = "rbxassetid://14255000409",
    PremiumOnly = false
})

CreditsTab:AddParagraph("Rhyan57", "Criador do RSeeker hub.")
CreditsTab:AddParagraph("SeekAlegriaFla", "Pensador das funções e programador")

-- Inicializa a interface
OrionLib:Init()

