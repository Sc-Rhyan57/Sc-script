--// Discord Banner Welcome \\--
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local Title = Instance.new("TextLabel")
local Description = Instance.new("TextLabel")
local CopyButton = Instance.new("TextButton")
local CloseButton = Instance.new("TextButton")
local Image = Instance.new("ImageLabel")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local StarterGui = player:WaitForChild("PlayerGui")

ScreenGui.Parent = StarterGui
ScreenGui.ResetOnSpawn = false

MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -150)
MainFrame.Size = UDim2.new(0, 300, 0, 300)
MainFrame.BackgroundTransparency = 1

UICorner.CornerRadius = UDim.new(0, 15)
UICorner.Parent = MainFrame

Title.Parent = MainFrame
Title.Size = UDim2.new(0, 300, 0, 50)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.Text = "Deprecated Alert!"
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 24
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(255, 255, 255)


local colorIndex = 0
local function animateTitleColor()
    colorIndex = (colorIndex + 1) % 2
    local tween = TweenService:Create(Title, TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), {
        TextColor3 = colorIndex == 0 and Color3.fromRGB(115, 0, 255) or Color3.fromRGB(155, 31, 196)
    })
    tween:Play()
end
animateTitleColor()


Image.Parent = MainFrame
Image.Size = UDim2.new(0, 100, 0, 100)
Image.Position = UDim2.new(0.5, -50, 0, 60)
Image.Image = "rbxassetid://123071339850669" 

Description.Parent = MainFrame
Description.Size = UDim2.new(0, 280, 0, 50)
Description.Position = UDim2.new(0.5, -140, 0.5, 20)
Description.Text = "Gostou desse script? então entre na comunidade da RSeeker Scripts!"
Description.Font = Enum.Font.FredokaOne 
Description.TextSize = 18
Description.BackgroundTransparency = 1
Description.TextWrapped = true
Description.TextColor3 = Color3.fromRGB(255, 255, 255)

CopyButton.Parent = MainFrame
CopyButton.Size = UDim2.new(0, 150, 0, 40)
CopyButton.Position = UDim2.new(0.5, -75, 1, -60)
CopyButton.Text = "Entrar"
CopyButton.Font = Enum.Font.GothamBold
CopyButton.TextSize = 20
CopyButton.BackgroundColor3 = Color3.fromRGB(115, 0, 255)
CopyButton.TextColor3 = Color3.fromRGB(255, 255, 255)


local contentToCopy = "https://discord.gg/MqAdfVkhuR"
CopyButton.MouseButton1Click:Connect(function()
    setclipboard(contentToCopy)
    CopyButton.Text = "Link Copiado!"
    wait(2)
    CopyButton.Text = "Obter Nova versão"
end)

CloseButton.Parent = MainFrame
CloseButton.Size = UDim2.new(0, 40, 0, 40)
CloseButton.Position = UDim2.new(1, -50, 0, 10)
CloseButton.Text = "X"
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 24
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)

MainFrame:TweenPosition(UDim2.new(0.5, -150, 0.5, -150), Enum.EasingDirection.InOut, Enum.EasingStyle.Quad, 0.5, true)

CloseButton.MouseButton1Click:Connect(function()
    local tween = TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, -150, 0.5, -600)
    })
    tween:Play()
    tween.Completed:Connect(function()
        ScreenGui:Destroy()
    end)
end)

local tweenBackground = TweenService:Create(MainFrame, TweenInfo.new(0.5), {BackgroundTransparency = 0})
tweenBackground:Play()

local sound = Instance.new("Sound")
sound.SoundId = "rbxassetid://3458224686"
sound.Volume = 1
sound.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
sound:Play()
sound.Ended:Connect(function()
    sound:Destroy()
end)
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "🔔 RSeeker",
    Text = "RSeeker Hub obteve falha ao carregar!",
    Icon = "rbxassetid://111591503022732",
    Duration = 5
})
