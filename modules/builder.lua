-- Módulo: Builder (Lógica principal para Veneyork)
local Builder = {}

-- Función para activar el botón Decorar
function Builder.activarDecorar()
    print("🔍 Buscando botón 'Decorar'...")
    
    local player = game:GetService("Players").LocalPlayer
    if not player then
        return false, "Jugador no encontrado"
    end
    
    -- Ruta exacta que encontramos
    local ruta = "PlayerGui.CustomTopBar.House.Selection.Decorate"
    local boton
    
    local function buscarBoton()
        local current = player
        for parte in ruta:gmatch("[^.]+") do
            current = current:FindFirstChild(parte)
            if not current then
                return nil
            end
        end
        return current
    end
    
    boton = buscarBoton()
    
    if not boton then
        print("❌ No se encontró en la ruta exacta. Buscando en toda la GUI...")
        -- Búsqueda alternativa
        boton = player.PlayerGui:FindFirstChild("Decorate", true)
    end
    
    if not boton then
        return false, "No se pudo encontrar el botón 'Decorar'"
    end
    
    print("✅ Botón encontrado:", boton.Name, "| Tipo:", boton.ClassName)
    
    -- Intentar diferentes métodos de activación
    local metodos = {"Activated", "MouseButton1Click", "TouchTap", "MouseButton1Down"}
    local metodoExitoso = nil
    
    for _, metodo in ipairs(metodos) do
        local exito = pcall(function()
            boton:FireEvent(metodo)
            return true
        end)
        
        if exito then
            metodoExitoso = metodo
            break
        end
    end
    
    if metodoExitoso then
        return true, "Botón activado (usando: " .. metodoExitoso .. ")"
    else
        -- Último intento: usar :Fire si es un evento
        if boton:IsA("BindableEvent") then
            pcall(function() boton:Fire() end)
            return true, "Se disparó el evento BindableEvent"
        end
        return false, "El botón no respondió a ningún método"
    end
end

-- Función para diagnóstico
function Builder.diagnostico()
    print("🩺 DIAGNÓSTICO DEL SISTEMA")
    print("==========================")
    
    local player = game:GetService("Players").LocalPlayer
    print("Jugador:", player.Name)
    print("PlaceId:", game.PlaceId)
    
    -- Verificar estructura GUI
    local gui = player:FindFirstChild("PlayerGui")
    if gui then
        print("PlayerGui: EXISTE")
        local customBar = gui:FindFirstChild("CustomTopBar")
        if customBar then
            print("CustomTopBar: EXISTE")
            local house = customBar:FindFirstChild("House")
            if house then
                print("House: EXISTE")
                local selection = house:FindFirstChild("Selection")
                if selection then
                    print("Selection: EXISTE")
                    local decorate = selection:FindFirstChild("Decorate")
                    print("Decorate:", decorate and "EXISTE" or "NO EXISTE")
                end
            end
        end
    else
        print("PlayerGui: NO EXISTE")
    end
    
    print("==========================")
    return "Diagnóstico completado"
end

-- Función futura para escanear (placeholder)
function Builder.escanearCasa(modelo)
    print("📡 Función de escaneo - En desarrollo")
    return {mensaje = "Escaneo no implementado aún"}
end

-- Función futura para construir (placeholder)
function Builder.construir(plano, posicion)
    print("🏗️ Función de construcción - En desarrollo")
    return false, "En desarrollo"
end

return Builder
