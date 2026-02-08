-- ============================================
-- VENEYORK BUILDER - LOADER HÍBRIDO SEGURO
-- ============================================

local VERSION = "2.0.0"
local CONFIG = {
    REPO_OWNER = "nitrofuertes504-maker",
    REPO_NAME = "VeneYork-Hub",
    MODULES = {
        menu = "modules/menu.lua",
        builder = "modules/builder.lua"
    }
}

-- Sistema de almacenamiento seguro
local Storage = {}

function Storage.guardarToken(token)
    -- Para escritorio: guarda en archivo
    if writefile and readfile then
        writefile("veneyork_token.txt", token)
        return true
    end
    
    -- Para Android: usa valores de instancia
    local success, result = pcall(function()
        local storage = Instance.new("StringValue")
        storage.Name = "VeneyorkTokenStorage"
        storage.Value = token
        storage.Parent = game:GetService("ReplicatedStorage")
        return true
    end)
    
    return success
end

function Storage.obtenerToken()
    -- Intentar desde archivo (PC)
    if readfile and isfile and isfile("veneyork_token.txt") then
        return readfile("veneyork_token.txt")
    end
    
    -- Intentar desde instancia (Android)
    local success, token = pcall(function()
        local storage = game:GetService("ReplicatedStorage"):FindFirstChild("VeneyorkTokenStorage")
        return storage and storage.Value or nil
    end)
    
    return success and token or nil
end

-- Función para cargar desde GitHub con token
local function cargarConToken(url, token)
    local headers = {
        ["Authorization"] = "token " .. token,
        ["Accept"] = "application/vnd.github.v3.raw",
        ["User-Agent"] = "Veneyork-Builder"
    }
    
    local success, response = pcall(function()
        return game:HttpGet(url, false, headers)
    end)
    
    return success, response
end

-- Interfaz para configurar token
local function configurarToken()
    print("\n" .. string.rep("=", 50))
    print("🔐 CONFIGURACIÓN DE TOKEN REQUERIDA")
    print(string.rep("=", 50))
    
    -- Mostrar instrucciones detalladas
    local instrucciones = {
        "1. Ve a: https://github.com/settings/tokens",
        "2. Haz clic en 'Generate new token' → 'Generate new token (classic)'",
        "3. Configura:",
        "   - Note: 'Veneyork Android'",
        "   - Expiration: 30 days",
        "   - Select scopes: SOLO 'repo'",
        "4. Copia el token (empieza con ghp_)",
        "5. Vuelve aquí y pega tu token"
    }
    
    for _, line in ipairs(instrucciones) do
        print(line)
    end
    
    -- En Android, mostrar notificación
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "🔐 Configuración requerida",
        Text = "Revisa la consola (F9) para instrucciones",
        Duration = 10,
        Icon = "rbxassetid://4483345998"
    })
    
    -- En PC/Android con soporte de entrada
    if rconsoleprint and rconsoleinput then
        rconsoleprint("@@YELLOW@@\nPega tu token aquí y presiona Enter: @@WHITE@@")
        local tokenInput = rconsoleinput()
        
        if tokenInput and #tokenInput > 10 then
            Storage.guardarToken(tokenInput)
            print("✅ Token guardado correctamente")
            return tokenInput
        end
    end
    
    -- Método alternativo para Android
    print("\n⚠️  Para Android, ejecuta este comando después de obtener tu token:")
    print('   loadstring(game:HttpGet("https://raw.githubusercontent.com/nitrofuertes504-maker/VeneYork-Hub/main/setup.lua"))()')
    
    return nil
end

-- Cargar módulo específico
local function cargarModulo(nombre, token)
    if not CONFIG.MODULES[nombre] then
        return nil, "Módulo no encontrado: " .. nombre
    end
    
    local url = string.format(
        "https://raw.githubusercontent.com/%s/%s/main/%s",
        CONFIG.OWNER, CONFIG.REPO_NAME, CONFIG.MODULES[nombre]
    )
    
    local success, response = cargarConToken(url, token)
    
    if not success then
        if response:find("401") or response:find("Bad credentials") then
            return nil, "Token inválido o expirado"
        elseif response:find("404") then
            return nil, "Módulo no encontrado: " .. CONFIG.MODULES[nombre]
        end
        return nil, "Error de conexión: " .. response
    end
    
    local modulo, errorMsg = loadstring(response)
    if not modulo then
        return nil, "Error en código: " .. tostring(errorMsg)
    end
    
    return pcall(modulo)
end

-- Inicialización principal
local function iniciar()
    print("\n" .. string.rep("=", 50))
    print("🏗️  VENEYORK BUILDER HÍBRIDO v" .. VERSION)
    print(string.rep("=", 50))
    
    -- Obtener token almacenado
    local token = Storage.obtenerToken()
    
    -- Si no hay token, configurar
    if not token then
        token = configurarToken()
        if not token then
            print("❌ No se pudo configurar el token")
            return "Configuración requerida"
        end
    end
    
    print("✅ Token detectado")
    
    -- Verificar token
    local testUrl = string.format(
        "https://api.github.com/repos/%s/%s",
        CONFIG.REPO_OWNER, CONFIG.REPO_NAME
    )
    
    local testSuccess = pcall(function()
        local headers = {["Authorization"] = "token " .. token}
        game:HttpGet(testUrl, false, headers)
    end)
    
    if not testSuccess then
        print("❌ Token inválido. Reconfigurando...")
        Storage.guardarToken("") -- Limpiar token inválido
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "❌ Token inválido",
            Text = "Genera un nuevo token",
            Duration = 7
        })
        return iniciar() -- Reiniciar proceso
    end
    
    -- Cargar módulos
    print("📦 Cargando módulos...")
    
    local Menu, menuErr = cargarModulo("menu", token)
    local Builder, builderErr = cargarModulo("builder", token)
    
    if menuErr then print("⚠️  Menu:", menuErr) end
    if builderErr then print("⚠️  Builder:", builderErr) end
    
    -- Si falla la carga, usar versiones de emergencia
    if not Menu then
        print("🔄 Usando menú de emergencia")
        Menu = {
            iniciar = function(b)
                print("Menú emergencia activado")
                return true
            end
        }
    end
    
    if not Builder then
        print("🔄 Usando builder de emergencia")
        Builder = {
            activarDecorar = function()
                return false, "Builder no disponible"
            end
        }
    end
    
    -- Iniciar sistema
    if Menu.iniciar then
        local success, err = pcall(Menu.iniciar, Builder)
        if not success then
            print("❌ Error al iniciar:", err)
        else
            print("✅ Sistema iniciado correctamente")
            
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "✅ Veneyork Builder",
                Text = "Sistema híbrido activo",
                Duration = 5
            })
        end
    end
    
    return "Sistema híbrido v" .. VERSION
end

-- Punto de entrada
return iniciar()
