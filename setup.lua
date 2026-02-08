-- setup.lua - Configuración fácil para Android
print("🔧 CONFIGURADOR VENEYORK PARA ANDROID")

-- Pedir token
print("\n1. Abre tu navegador y ve a:")
print("   https://github.com/settings/tokens")
print("\n2. Crea un nuevo token con:")
print("   - Note: 'Veneyork Android'")
print("   - Expiration: 30 days")
print("   - Select scopes: SOLO 'repo'")
print("\n3. Copia el token (empieza con ghp_)")
print("\n4. Regresa a Roblox")

-- Almacenar token
local function guardarToken()
    -- Para Delta en Android
    local token = "PEGA_TU_TOKEN_AQUI" -- El usuario edita esto
    
    if #token > 50 and token:sub(1,4) == "ghp_" then
        -- Guardar en ReplicatedStorage
        local storage = Instance.new("StringValue")
        storage.Name = "VeneyorkTokenStorage"
        storage.Value = token
        storage.Parent = game:GetService("ReplicatedStorage")
        
        print("✅ Token guardado correctamente")
        print("\n🎯 Ahora ejecuta el loader normal:")
        print('   loadstring(game:HttpGet("https://raw.githubusercontent.com/nitrofuertes504-maker/VeneYork-Hub/main/loader.lua"))()')
        
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "✅ Configuración completa",
            Text = "Token guardado. Ejecuta el loader.",
            Duration = 7
        })
    else
        print("❌ Token inválido. Asegúrate de copiarlo completo.")
    end
end

-- Instrucciones interactivas
print("\n" .. string.rep("=", 50))
print("📝 INSTRUCCIONES:")
print("1. Copia TODO el código de arriba")
print("2. Pégalo en Delta")
print("3. Reemplaza 'PEGA_TU_TOKEN_AQUI' con tu token real")
print("4. Ejecuta el código")
print(string.rep("=", 50))

return guardarToken
