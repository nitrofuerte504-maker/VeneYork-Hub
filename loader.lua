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
local Menu = cargarModulo("menu")
local Builder = cargarModulo("builder")

if Menu and Builder then
    print("✅ Módulos cargados")
    Menu.iniciar(Builder)
else
    print("❌ Error cargando módulos")
end

return "Veneyork Builder v" .. VERSION
