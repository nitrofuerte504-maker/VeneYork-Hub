-- ============================================
-- VENEYORK BUILDER - SISTEMA DE LOGIN CON GUI
-- ============================================

local VERSION = "2.1.0"
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

-- Configuración
local CONFIG = {
    REPO_OWNER = "nitrofuertes504-maker",
    REPO_NAME = "VeneYork-Hub",
    MODULES = {
        menu = "modules/menu.lua",
        builder = "modules/builder.lua"
    }
}

-- Almacenamiento seguro
local function guardarToken(token)
    -- Para Android: guardar en ReplicatedStorage
    local success, result = pcall(function()
        local storage = Instance.new("Folder")
        storage.Name = "VeneyorkAuth"
        
        local tokenValue = Instance.new("StringValue")
        tokenValue.Name = "GitHubToken"
        tokenValue.Value = token
        tokenValue.Parent = storage
        
        local userValue = Instance.new("StringValue")
        userValue.Name = "AuthorizedUser"
        userValue.Value = player.Name
        userValue.Parent = storage
        
        storage.Parent = game:GetService("ReplicatedStorage")
        
        return true
    end)
    
    return success
end

local function obtenerToken()
    local success, result = pcall(function()
        local storage = game:GetService("ReplicatedStorage"):FindFirstChild("VeneyorkAuth")
        if storage then
            local tokenValue = storage:FindFirstChild("GitHubToken")
            local userValue = storage:FindFirstChild("AuthorizedUser")
            
            if tokenValue and userValue and userValue.Value == player.Name then
                return tokenValue.Value
            end
        end
        return nil
    end)
    
    return success and result or nil
end

-- Verificar token en GitHub
local function verificarToken(token)
    if not token or #token < 10 then
        return false, "Token inválido (muy corto)"
    end
    
    -- Verificar formato
    if not token:match("^ghp_[%w]+$") and not token:match("^github_pat_[%w]+$") then
        return false, "Formato de token inválido"
    end
    
    -- Probar conexión con GitHub
    local testUrl = string.format(
        "https://api.github.com/repos/%s/%s",
        CONFIG.REPO_OWNER, CONFIG.REPO_NAME
    )
    
    local headers = {
        ["Authorization"] = "token " .. token,
        ["Accept"] = "application/vnd.github.v3+json",
        ["User-Agent"] = "Veneyork-Builder"
    }
    
    local success, response = pcall(function()
        return game:HttpGet(testUrl, false, headers)
    end)
    
    if not success then
        if response:find("401") or response:find("Bad credentials") then
            return false, "Token inválido o expirado"
        elseif response:find("404") then
            return false, "Repositorio no encontrado"
        else
            return false, "Error de conexión: " .. response
        end
    end
    
    return true, "✅ Token verificado correctamente"
end

-- Crear ventana de login
local function crearVentanaLogin()
    local gui = Instance.new("ScreenGui")
    gui.Name = "VeneyorkLogin"
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Fondo semi-transparente
    local fondo = Instance.new("Frame")
    fondo.Name = "Fondo"
    fondo.Size = UDim2.new(1, 0, 1, 0)
    fondo.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    fondo.BackgroundTransparency = 0.5
    fondo.BorderSizePixel = 0
    fondo.Parent = gui
    
    -- Ventana principal
    local ventana = Instance.new("Frame")
    ventana.Name = "VentanaLogin"
    ventana.Size = UDim2.new(0, 400, 0, 320)
    ventana.Position = UDim2.new(0.5, -200, 0.5, -160)
    ventana.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    ventana.BorderSizePixel = 0
    ventana.ClipsDescendants = true
    ventana.Parent = gui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = ventana
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(0, 170, 255)
    stroke.Thickness = 2
    stroke.Parent = ventana
    
    -- Título
    local titulo = Instance.new("TextLabel")
    titulo.Name = "Titulo"
    titulo.Size = UDim2.new(1, 0, 0, 60)
    titulo.Position = UDim2.new(0, 0, 0, 0)
    titulo.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
    titulo.BackgroundTransparency = 0
    titulo.Text = "🔐 VENEYORK BUILDER"
    titulo.TextColor3 = Color3.white
    titulo.TextSize = 22
    titulo.Font = Enum.Font.GothamBold
    titulo.Parent = ventana
    
    local tituloCorner = Instance.new("UICorner")
    tituloCorner.CornerRadius = UDim.new(0, 12)
    tituloCorner.Parent = titulo
    
    -- Instrucciones
    local instrucciones = Instance.new("TextLabel")
    instrucciones.Name = "Instrucciones"
    instrucciones.Size = UDim2.new(1, -40, 0, 80)
    instrucciones.Position = UDim2.new(0, 20, 0, 70)
    instrucciones.BackgroundTransparency = 1
    instrucciones.Text = "1. Ve a: github.com/settings/tokens\n2. Crea token con permiso 'repo'\n3. Pega tu token aquí:"
    instrucciones.TextColor3 = Color3.fromRGB(200, 200, 220)
    instrucciones.TextSize = 14
    instrucciones.Font = Enum.Font.Gotham
    instrucciones.TextXAlignment = Enum.TextXAlignment.Left
    instrucciones.TextYAlignment = Enum.TextYAlignment.Top
    instrucciones.Parent = ventana
    
    -- Campo para token
    local inputFrame = Instance.new("Frame")
    inputFrame.Name = "InputFrame"
    inputFrame.Size = UDim2.new(1, -40, 0, 40)
    inputFrame.Position = UDim2.new(0, 20, 0, 160)
    inputFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    inputFrame.BorderSizePixel = 0
    inputFrame.Parent = ventana
    
    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, 8)
    inputCorner.Parent = inputFrame
    
    local tokenInput = Instance.new("TextBox")
    tokenInput.Name = "TokenInput"
    tokenInput.Size = UDim2.new(1, -20, 1, -10)
    tokenInput.Position = UDim2.new(0, 10, 0, 5)
    tokenInput.BackgroundTransparency = 1
    tokenInput.Text = ""
    tokenInput.PlaceholderText = "ghp_tu_token_aqui"
    tokenInput.TextColor3 = Color3.white
    tokenInput.TextSize = 16
    tokenInput.Font = Enum.Font.Gotham
    tokenInput.ClearTextOnFocus = false
    tokenInput.Parent = inputFrame
    
    -- Botón verificar
    local botonVerificar = Instance.new("TextButton")
    botonVerificar.Name = "BotonVerificar"
    botonVerificar.Size = UDim2.new(0, 120, 0, 40)
    botonVerificar.Position = UDim2.new(0.5, -60, 0, 220)
    botonVerificar.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    botonVerificar.Text = "✅ VERIFICAR"
    botonVerificar.TextColor3 = Color3.white
    botonVerificar.TextSize = 16
    botonVerificar.Font = Enum.Font.GothamBold
    botonVerificar.AutoButtonColor = true
    botonVerificar.Parent = ventana
    
    local botonCorner = Instance.new("UICorner")
    botonCorner.CornerRadius = UDim.new(0, 8)
    botonCorner.Parent = botonVerificar
    
    -- Estado/resultado
    local estadoLabel = Instance.new("TextLabel")
    estadoLabel.Name = "Estado"
    estadoLabel.Size = UDim2.new(1, -40, 0, 30)
    estadoLabel.Position = UDim2.new(0, 20, 0, 270)
    estadoLabel.BackgroundTransparency = 1
    estadoLabel.Text = "Esperando token..."
    estadoLabel.TextColor3 = Color3.fromRGB(200, 200, 100)
    estadoLabel.TextSize = 14
    estadoLabel.Font = Enum.Font.Gotham
    estadoLabel.TextXAlignment = Enum.TextXAlignment.Center
    estadoLabel.Parent = ventana
    
    -- Función para cerrar ventana
    local function cerrarVentana()
        TweenService:Create(ventana, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0)
        }):Play()
        
        task.wait(0.35)
        gui:Destroy()
    end
    
    -- Evento del botón
    botonVerificar.MouseButton1Click:Connect(function()
        local token = tokenInput.Text:gsub("%s+", "")  -- Quitar espacios
        
        if #token < 10 then
            estadoLabel.Text = "❌ Token muy corto"
            estadoLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
            return
        end
        
        botonVerificar.Text = "⏳ VERIFICANDO..."
        botonVerificar.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
        estadoLabel.Text = "Verificando token con GitHub..."
        
        local valido, mensaje = verificarToken(token)
        
        if valido then
            estadoLabel.Text = mensaje
            estadoLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
            botonVerificar.Text = "✅ VÁLIDO"
            botonVerificar.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
            
            -- Guardar token
            guardarToken(token)
            
            -- Cerrar ventana después de 1.5 segundos
            task.wait(1.5)
            cerrarVentana()
            return true
        else
            estadoLabel.Text = "❌ " .. mensaje
            estadoLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
            botonVerificar.Text = "❌ ERROR"
            botonVerificar.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
            
            task.wait(2)
            botonVerificar.Text = "✅ VERIFICAR"
            botonVerificar.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
            estadoLabel.Text = "Intenta de nuevo..."
            estadoLabel.TextColor3 = Color3.fromRGB(200, 200, 100)
            
            return false
        end
    end)
    
    -- Cerrar al tocar fondo
    fondo.MouseButton1Click:Connect(cerrarVentana)
    
    -- Animar entrada
    ventana.Size = UDim2.new(0, 0, 0, 0)
    ventana.Position = UDim2.new(0.5, 0, 0.5, 0)
    
    TweenService:Create(ventana, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 400, 0, 320),
        Position = UDim2.new(0.5, -200, 0.5, -160)
    }):Play()
    
    gui.Parent = player:WaitForChild("PlayerGui")
    return gui
end

-- Cargar módulo desde GitHub
local function cargarModulo(nombre, token)
    if not CONFIG.MODULES[nombre] then
        return nil, "Módulo no encontrado"
    end
    
    local url = string.format(
        "https://raw.githubusercontent.com/%s/%s/main/%s",
        CONFIG.REPO_OWNER, CONFIG.REPO_NAME, CONFIG.MODULES[nombre]
    )
    
    local headers = {
        ["Authorization"] = "token " .. token,
        ["Accept"] = "application/vnd.github.v3.raw"
    }
    
    local success, response = pcall(function()
        return game:HttpGet(url, false, headers)
    end)
    
    if not success then
        return nil, "Error descargando: " .. response
    end
    
    local modulo, errorMsg = loadstring(response)
    if not modulo then
        return nil, "Error en código: " .. tostring(errorMsg)
    end
    
    return pcall(modulo)
end

-- Sistema principal
local function main()
    print("\n" .. string.rep("=", 50))
    print("🔐 VENEYORK BUILDER - SISTEMA DE LOGIN")
    print(string.rep("=", 50))
    
    -- Verificar si ya tiene token
    local token = obtenerToken()
    
    if token then
        print("🔍 Verificando token guardado...")
        local valido, mensaje = verificarToken(token)
        
        if valido then
            print("✅ Token válido detectado")
            -- Cargar módulos directamente
        else
            print("❌ Token inválido: " .. mensaje)
            token = nil
        end
    end
    
    -- Si no hay token válido, mostrar login
    if not token then
        print("📱 Mostrando ventana de login...")
        crearVentanaLogin()
        
        -- Esperar a que el usuario ingrese token
        repeat
            token = obtenerToken()
            task.wait(1)
        until token
        
        print("✅ Token ingresado por usuario")
    end
    
    -- Cargar módulos
    print("📦 Cargando módulos...")
    
    local Menu, menuErr = cargarModulo("menu", token)
    local Builder, builderErr = cargarModulo("builder", token)
    
    if menuErr then print("⚠️  Menu:", menuErr) end
    if builderErr then print("⚠️  Builder:", builderErr) end
    
    -- Iniciar sistema
    if Menu and type(Menu.iniciar) == "function" then
        local success, err = pcall(Menu.iniciar, Builder)
        if not success then
            print("❌ Error iniciando menú:", err)
        else
            print("✅ Sistema iniciado correctamente")
        end
    end
    
    return "Veneyork Builder v" .. VERSION
end

-- Iniciar
return main()
