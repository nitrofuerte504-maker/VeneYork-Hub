-- ============================================
-- MENÚ FLOTANTE "jFran" PARA VENEYORK (ANDROID)
-- ============================================

local Menu = {}
local menuPrincipal = nil
local estadoExpandido = false

-- Configuración visual (puedes ajustar estos valores)
local CONFIG = {
    nombre = "jFran",              -- Texto que se muestra
    colorBase = Color3.fromRGB(0, 170, 255),     -- Azul
    colorHover = Color3.fromRGB(255, 165, 0),    -- Naranja al tocar
    transparencia = 0.3,           -- 0 = invisible, 1 = sólido
    posicion = {x = 0.85, y = 0.1}, -- Esquina superior derecha
    tamañoContraido = UDim2.new(0, 70, 0, 40),
    tamañoExpandido = UDim2.new(0, 150, 0, 200)
}

function Menu.iniciar(Builder)
    print("🎨 Creando menú flotante '" .. CONFIG.nombre .. "'...")
    
    if not Builder then
        print("❌ Builder no disponible")
        return false
    end
    
    -- Crear la GUI principal
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "jFranMenu"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    
    -- Marco principal (contraído inicialmente)
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = CONFIG.tamañoContraido
    mainFrame.Position = UDim2.new(CONFIG.posicion.x, 0, CONFIG.posicion.y, 0)
    mainFrame.BackgroundColor3 = CONFIG.colorBase
    mainFrame.BackgroundTransparency = CONFIG.transparencia
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    
    -- Esquinas redondeadas
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = mainFrame
    
    -- Sombra sutil
    local shadow = Instance.new("UIStroke")
    shadow.Color = Color3.fromRGB(255, 255, 255)
    shadow.Thickness = 1
    shadow.Transparency = 0.7
    shadow.Parent = mainFrame
    
    -- Texto principal (nombre)
    local texto = Instance.new("TextLabel")
    texto.Name = "TextoPrincipal"
    texto.Text = CONFIG.nombre
    texto.Size = UDim2.new(1, 0, 1, 0)
    texto.Position = UDim2.new(0, 0, 0, 0)
    texto.BackgroundTransparency = 1
    texto.TextColor3 = Color3.fromRGB(255, 255, 255)
    texto.TextSize = 16
    texto.Font = Enum.Font.GothamBold
    texto.TextStrokeTransparency = 0.5
    texto.Parent = mainFrame
    
    -- Contenedor para opciones (inicialmente oculto)
    local opcionesFrame = Instance.new("Frame")
    opcionesFrame.Name = "OpcionesFrame"
    opcionesFrame.Size = UDim2.new(1, 0, 0, 0)
    opcionesFrame.Position = UDim2.new(0, 0, 1, 5)
    opcionesFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    opcionesFrame.BackgroundTransparency = 0.2
    opcionesFrame.BorderSizePixel = 0
    opcionesFrame.Visible = false
    opcionesFrame.Parent = mainFrame
    
    local opcionesCorner = Instance.new("UICorner")
    opcionesCorner.CornerRadius = UDim.new(0, 8)
    opcionesCorner.Parent = opcionesFrame
    
    -- Crear botones de opciones
    local opciones = {
        {"🏗️ Decorar", function()
            print("🔄 Activando menú Decorar...")
            if Builder.activarDecorar then
                local ok, msg = pcall(Builder.activarDecorar)
                print("Resultado:", ok and "✅ " .. tostring(msg) or "❌ " .. tostring(msg))
                contraerMenu()
            end
        end},
        
        {"📡 Escanear", function()
            print("📡 Función de escaneo - En desarrollo")
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "En desarrollo",
                Text = "Función de escaneo próximamente",
                Duration = 3
            })
            contraerMenu()
        end},
        
        {"⚙️ Ajustes", function()
            print("⚙️ Menú de ajustes")
            contraerMenu()
        end},
        
        {"❌ Cerrar", function()
            print("🔒 Cerrando menú...")
            screenGui:Destroy()
            menuPrincipal = nil
        end}
    }
    
    -- Función para expandir/contraer el menú
    local function alternarMenu()
        estadoExpandido = not estadoExpandido
        
        if estadoExpandido then
            -- EXPANDIR
            mainFrame.Size = CONFIG.tamañoExpandido
            mainFrame.BackgroundColor3 = CONFIG.colorHover
            texto.Text = "▲ " .. CONFIG.nombre
            opcionesFrame.Visible = true
            opcionesFrame.Size = UDim2.new(1, 0, 0, #opciones * 40)
            
            -- Crear/actualizar botones de opciones
            opcionesFrame:ClearAllChildren()
            
            for i, opcion in ipairs(opciones) do
                local btn = Instance.new("TextButton")
                btn.Name = "Btn_" .. opcion[1]
                btn.Size = UDim2.new(1, -10, 0, 35)
                btn.Position = UDim2.new(0, 5, 0, (i-1) * 40 + 5)
                btn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
                btn.BackgroundTransparency = 0.3
                btn.Text = opcion[1]
                btn.TextColor3 = Color3.white
                btn.TextSize = 14
                btn.Font = Enum.Font.Gotham
                btn.Parent = opcionesFrame
                
                local btnCorner = Instance.new("UICorner")
                btnCorner.CornerRadius = UDim.new(0, 6)
                btnCorner.Parent = btn
                
                btn.MouseButton1Click:Connect(function()
                    opcion[2]()
                end)
            end
            
        else
            -- CONTRARER
            mainFrame.Size = CONFIG.tamañoContraido
            mainFrame.BackgroundColor3 = CONFIG.colorBase
            texto.Text = CONFIG.nombre
            opcionesFrame.Visible = false
        end
    end
    
    local function contraerMenu()
        if estadoExpandido then
            estadoExpandido = false
            mainFrame.Size = CONFIG.tamañoContraido
            mainFrame.BackgroundColor3 = CONFIG.colorBase
            texto.Text = CONFIG.nombre
            opcionesFrame.Visible = false
        end
    end
    
    -- Hacer el marco arrastrable
    local dragging = false
    local dragStart, startPos
    
    local function iniciarArrastre(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
            
            -- Feedback visual
            mainFrame.BackgroundTransparency = CONFIG.transparencia - 0.1
        end
    end
    
    local function actualizarArrastre(input)
        if dragging then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(
                startPos.X.Scale, 
                startPos.X.Offset + delta.X,
                startPos.Y.Scale, 
                startPos.Y.Offset + delta.Y
            )
        end
    end
    
    local function terminarArrastre()
        dragging = false
        mainFrame.BackgroundTransparency = CONFIG.transparencia
    end
    
    -- Conectar eventos táctiles
    mainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            if not estadoExpandido then
                -- Primer toque: expandir menú
                alternarMenu()
            end
            iniciarArrastre(input)
        end
    end)
    
    mainFrame.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.Touch then
            actualizarArrastre(input)
        end
    end)
    
    game:GetService("UserInputService").InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            terminarArrastre()
        end
    end)
    
    -- Tocar fuera del menú para contraer
    game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
        if estadoExpandido and input.UserInputType == Enum.UserInputType.Touch then
            -- Verificar si tocó fuera del menú
            local touchPos = input.Position
            local absPos = mainFrame.AbsolutePosition
            local absSize = mainFrame.AbsoluteSize
            
            if estadoExpandido then
                local menuBounds = {
                    x1 = absPos.X,
                    y1 = absPos.Y,
                    x2 = absPos.X + absSize.X,
                    y2 = absPos.Y + absSize.Y + opcionesFrame.AbsoluteSize.Y
                }
                
                if touchPos.X < menuBounds.x1 or touchPos.X > menuBounds.x2 or
                   touchPos.Y < menuBounds.y1 or touchPos.Y > menuBounds.y2 then
                    contraerMenu()
                end
            end
        end
    end)
    
    menuPrincipal = screenGui
    
    -- Notificación inicial
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "✅ Menú " .. CONFIG.nombre,
        Text = "Menú flotante activado. Toca para expandir.",
        Duration = 5
    })
    
    print("✅ Menú flotante '" .. CONFIG.nombre .. "' creado")
    print("📍 Posición: arrastra para mover")
    print("👆 Toca para expandir/contraer")
    
    return true
end

function Menu.cerrar()
    if menuPrincipal then
        menuPrincipal:Destroy()
        menuPrincipal = nil
    end
    print("🔒 Menú flotante cerrado")
end

return Menu
