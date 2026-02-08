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
local Menu, MenuError = cargarModulo("menu")
local Builder, BuilderError = cargarModulo("builder")

print("Menu cargado:", Menu and "✅" or "❌ " .. tostring(MenuError))
print("Builder cargado:", Builder and "✅" or "❌ " .. tostring(BuilderError))

if Menu and Builder then
    print("✅ Todos los módulos cargados")
    
    -- Verificar que Menu tenga la función 'iniciar'
    if type(Menu.iniciar) == "function" then
        print("✅ Llamando a Menu.iniciar()...")
        local exito, errorMsg = pcall(function()
            Menu.iniciar(Builder)
        end)
        
        if not exito then
            print("❌ Error al iniciar menú:", errorMsg)
        end
    else
        print("❌ Menu no tiene función 'iniciar'")
        print("Funciones disponibles en Menu:", next(Menu) and "Sí" or "No")
    end
else
    print("❌ No se pudieron cargar todos los módulos")
    
    -- Si al menos Builder cargó, intentar usarlo directamente
    if Builder then
        print("🔄 Intentando activar Decorar directamente...")
        if Builder.activarDecorar then
            local ok, msg = pcall(Builder.activarDecorar)
            print("Resultado:", ok and "✅ " .. msg or "❌ " .. msg)
        end
    end
end

return "Veneyork Builder v" .. VERSION
