local section = VisualsEsp:AddSection({
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
