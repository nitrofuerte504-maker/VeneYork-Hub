-- Script de Prueba para Veneyork - Paso 1: Activar Decorar
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- 1. DEFINIR la ruta exacta del botón (LA QUE ENCONTRAMOS)
local rutaBotonDecorar = player.PlayerGui.CustomTopBar.House.Selection.Decorate

-- 2. INTENTAR encontrar el botón y activarlo
local exito = false
local mensaje = ""

-- Usamos 'pcall' para capturar errores sin que crashee el script
local funciono, errorMsg = pcall(function()
    local boton = rutaBotonDecorar
    -- Método 1: Intentar activar el evento común de botones
    boton:FireEvent("Activated")
    -- Método 2: Alternativa común
    boton:FireEvent("MouseClick")
    
    exito = true
    mensaje = "✅ Comando 'Decorar' enviado. Revisa si se abrió el menú de objetos."
end)

-- 3. MOSTRAR RESULTADO
if not funciono then
    -- Si 'pcall' capturó un error
    mensaje = "❌ Error al intentar activar el botón: " .. tostring(errorMsg)
elseif not exito then
    mensaje = "⚠️ El script se ejecutó, pero no se pudo confirmar la activación."
end

print("=== RESULTADO PRUEBA ===")
print(mensaje)
print("========================")

-- Opcional: Notificación en pantalla si tienes una librería
if exito then
    -- Si usas JmodsLib o similar, puedes agregar una notificación aquí
    -- Ejemplo: JmodsLib:Notify({Title="Prueba", Content=mensaje, Duration=5})
end
