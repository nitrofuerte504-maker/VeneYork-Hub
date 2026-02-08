-- Módulo: Menu (Interfaz simple y funcional)
local Menu = {}

-- Función PRINCIPAL que debe existir
function Menu.iniciar(Builder)
    print("🎮 Menu.iniciar() llamado")
    
    -- Verificar que Builder tiene las funciones necesarias
    if not Builder or not Builder.activarDecorar then
        print("❌ Builder no tiene función activarDecorar")
        return false
    end
    
    print("✅ Builder verificado")
    
    -- Función para notificaciones
    local function notificar(titulo, texto)
        print("[Menu] " .. titulo .. ": " .. texto)
        pcall(function()
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = titulo,
                Text = texto,
                Duration = 5
            })
        end)
    end
    
    -- Función para abrir menú Decorar
    local function abrirDecorar()
        print("🖱️ Ejecutando abrirDecorar()")
        notificar("Veneyork Builder", "Abriendo menú Decorar...")
        
        local exito, mensaje = pcall(function()
            return Builder.activarDecorar()
        end)
        
        if exito then
            notificar("✅ Éxito", mensaje or "Menú activado")
        else
            notificar("❌ Error", "Error: " .. tostring(mensaje))
        end
    end
    
    -- Asignar tecla (INSERT)
    local UIS = game:GetService("UserInputService")
    local conexion
    conexion = UIS.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.KeyCode == Enum.KeyCode.Insert then
            print("⌨️ Tecla INSERT presionada")
            abrirDecorar()
        end
    end)
    
    -- Configurar notificación inicial
    notificar("✅ Veneyork Builder", "Sistema activado. Presiona INSERT (tecla Ins)")
    print("✅ Sistema listo. Presiona INSERT para abrir menú Decorar.")
    
    -- Guardar referencia para desconectar si es necesario
    Menu._conexionTecla = conexion
    
    return true
end

-- Función para cerrar/limpiar
function Menu.cerrar()
    if Menu._conexionTecla then
        Menu._conexionTecla:Disconnect()
        Menu._conexionTecla = nil
    end
    print("🔒 Menu cerrado")
end

-- Función de diagnóstico
function Menu.diagnostico()
    return {
        version = "1.0",
        funciones = {
            "iniciar",
            "cerrar", 
            "diagnostico"
        }
    }
end

return Menu
