-- ============================================
-- VENEYORK AUTO BUILDER - PRUEBA 1: ABRIR DECORAR
-- Repositorio Oficial: https://github.com/nitrofuerte504-maker/VeneYork-Hub
-- ============================================

local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Función para mostrar mensajes claros
local function Notificar(mensaje)
    print("[VeneYork Hub] " .. mensaje)
    -- Intenta mostrar notificación en pantalla si es posible
    if pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "VeneYork Hub",
            Text = mensaje,
            Duration = 5
        })
    end) then
        -- Notificación enviada con éxito
    end
end

-- Verificar que estamos listos
if not player then
    Notificar("❌ ERROR: No se encontró al jugador.")
    return
end

Notificar("🚀 Iniciando VeneYork Hub...")

-- 1. BUSCAR EL BOTÓN 'DECORAR' DE FORMA SEGURA
local botonDecorar
local ok, errorMsg = pcall(function()
    botonDecorar = player:WaitForChild("PlayerGui"):WaitForChild("CustomTopBar"):WaitForChild("House"):WaitForChild("Selection"):WaitForChild("Decorate")
end)

if not ok or not botonDecorar then
    Notificar("❌ No se pudo encontrar el botón 'Decorar'.")
    Notificar("   Asegúrate de estar en tu parcela y que el menú 'Mi casa' sea visible.")
    return
end

Notificar("✅ Botón 'Decorar' encontrado. Activando...")

-- 2. INTENTAR DIFERENTES MÉTODOS DE ACTIVACIÓN
local activado = false
local metodos = {"Activated", "MouseButton1Click", "MouseClick"}

for _, nombreEvento in ipairs(metodos) do
    local eventoOk = pcall(function()
        botonDecorar:FireEvent(nombreEvento)
        activado = true
        Notificar("   Evento '" .. nombreEvento .. "' ejecutado.")
    end)
    if activado then break end
end

-- 3. RESULTADO FINAL
if activado then
    Notificar("🎉 ¡MENÚ DE DECORACIÓN ACTIVADO!")
    Notificar("   El menú con muebles y objetos debería estar visible.")
else
    Notificar("⚠️  El botón no respondió a los métodos comunes.")
    Notificar("   Próximo paso: Investigar el evento exacto.")
end

-- 4. INFORMACIÓN PARA DIAGNÓSTICO
print("\n" .. string.rep("=", 50))
print("DIAGNÓSTICO COMPLETO")
print("Nombre del Jugador: " .. player.Name)
print("Ruta usada: PlayerGui.CustomTopBar.House.Selection.Decorate")
print(string.rep("=", 50))

return "VeneYork Hub - Prueba 1 completada."
