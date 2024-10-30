local window = OrionLib:MakeWindow({
    Name = "Custom Notifications",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "OrionTest"
})

local tab = window:MakeTab({
    Name = "Notification Tab",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local section = tab:AddSection({
    Name = "Notification Controls"
})

section:AddButton({
    Name = "Enviar Notificação",
    Callback = function()
        OrionLib:MakeNotification({
            Name = "Teste",
            Content = "Aleatória",
            Image = "rbxassetid://123071339850669",
            Time = 5
        })
        print("Botão pressionado")
    end
})
