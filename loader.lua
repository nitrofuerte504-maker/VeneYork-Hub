-- ============================================
-- VENEYORK BUILDER - LOADER OFICIAL
-- ============================================

local VERSION = "1.0.0"
print("🚀 Iniciando Veneyork Builder v" .. VERSION)

-- Función para cargar un módulo
local function cargarModulo(nombre)
    local baseURL = "https://raw.githubusercontent.com/nitrofuerte504-maker/VeneYork-Hub/main/"
    local modulos = {
        menu = "modules/menu.lua",
        builder = "modules/builder.lua"
    }
    
    if not modulos[nombre] then
        return nil, "Módulo no encontrado: " .. nombre
    end
    
    local url = baseURL .. modulos[nombre]
    local exito, resultado = pcall(function()
        local codigo = game:HttpGet(url)
        return loadstring(codigo)
    end)
    
    if exito then
        return resultado()
    else
        return nil, "Error cargando " .. nombre .. ": " .. tostring(resultado)
    end
end

-- Iniciar sistema
print("🔍 Cargando módulos...")
local Menu = cargarModulo("menu")
local Builder = cargarModulo("builder")

if not Menu then
    print("❌ ERROR CRÍTICO: Menu NO se cargó")
    -- Cargar un Menu de emergencia
    Menu = {
        iniciar = function(builder)
            print("🔄 Usando Menu de emergencia")
            if builder and builder.activarDecorar then
                builder.activarDecorar()
            end
            return true
        end
    }
end

if not Builder then
    print("❌ ERROR CRÍTICO: Builder NO se cargó")
    return "Error: Builder no disponible"
end

print("✅ Módulos cargados. Iniciando sistema...")

-- Verificar que Menu tenga la función 'iniciar'
if type(Menu.iniciar) ~= "function" then
    print("⚠️ Menu no tiene 'iniciar', pero tiene estas funciones:")
    for key, value in pairs(Menu) do
        print("   - " .. key .. ": " .. type(value))
    end
    
    -- Intentar usar cualquier función que parezca de inicio
    for key, value in pairs(Menu) do
        if type(value) == "function" and (key:lower():find("init") or key:lower():find("start")) then
            print("🔄 Intentando con función: " .. key)
            local ok, err = pcall(value, Builder)
            print("Resultado:", ok and "✅ Éxito" or "❌ Error: " .. tostring(err))
            break
        end
    end
else
    print("✅ Llamando a Menu.iniciar(Builder)...")
    local ok, err = pcall(Menu.iniciar, Builder)
    if not ok then
        print("❌ Error en Menu.iniciar:", err)
    else
        print("✅ Sistema iniciado correctamente")
    end
end

print("🎯 Veneyork Builder listo")
return "Veneyork Builder v" .. VERSION .. " - Completado"
