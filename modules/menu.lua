-- Módulo: Builder (Lógica principal)
local Builder = {}

function Builder.activarDecorar()
    local player = game:GetService("Players").LocalPlayer
    
    -- Intentar encontrar el botón
    local boton = player.PlayerGui:FindFirstChild("CustomTopBar")
    if boton then
        boton = boton:FindFirstChild("House")
        if boton then
            boton = boton:FindFirstChild("Selection")
            if boton then
                boton = boton:FindFirstChild("Decorate")
            end
        end
    end
    
    if not boton then
        return false, "No se encontró el botón 'Decorar'"
    end
    
    -- Intentar diferentes métodos de activación
    local metodos = {"Activated", "MouseButton1Click", "TouchTap"}
    
    for _, metodo in ipairs(metodos) do
        local exito = pcall(function()
            boton:FireEvent(metodo)
        end)
        
        if exito then
            return true, "Menú activado (método: " .. metodo .. ")"
        end
    end
    
    return false, "El botón no respondió a ningún método"
end

-- Función para escanear una casa (futura implementación)
function Builder.escanearCasa(casaModel)
    print("📡 Función de escaneo - En desarrollo")
    return {}
end

-- Función para construir (futura implementación)
function Builder.construir(plano, posicion)
    print("🏗️ Función de construcción - En desarrollo")
    return false, "En desarrollo"
end

return Builder
