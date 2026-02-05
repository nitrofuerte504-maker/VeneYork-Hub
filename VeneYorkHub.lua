-- ===========================================
-- VENEYORK BASE COPIER v2.0 - BY NITROFUERTE
-- ===========================================

-- Configuración
local Config = {
    Version = "2.0",
    Author = "nitrofuerte504",
    CopyKey = Enum.KeyCode.F,
    PasteKey = Enum.KeyCode.G
}

-- Servicios
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local UIS = game:GetService("UserInputService")

-- Variables
local Player = Players.LocalPlayer
local CopiedBlueprints = {}

-- ================= FUNCIÓN PARA COPIAR =================
function CopyStructure(position, radius)
    local parts = Workspace:GetPartsInRegion(
        Region3.new(
            position - Vector3.new(radius, radius, radius),
            position + Vector3.new(radius, radius, radius)
        ),
        nil,
        100
    )
    
    local blueprint = {
        id = #CopiedBlueprints + 1,
        parts = {},
        origin = position,
        time = os.time()
    }
    
    for _, part in ipairs(parts) do
        -- Solo copiar partes de otros jugadores
        local owner = part:GetAttribute("Owner") or part:GetAttribute("owner")
        if owner and owner ~= Player.Name then
            table.insert(blueprint.parts, {
                Type = part.ClassName,
                Size = part.Size,
                Position = part.Position - position,
                Color = part.Color,
                Material = part.Material,
                Name = part.Name
            })
        end
    end
    
    if #blueprint.parts > 0 then
        table.insert(CopiedBlueprints, blueprint)
        Notify("✅ ÉXITO", "Copiadas " .. #blueprint.parts .. " partes", 3)
        return blueprint.id
    else
        Notify("❌ ERROR", "No se encontraron partes para copiar", 3)
        return nil
    end
end

-- ================= FUNCIÓN PARA PEGAR =================
function PasteStructure(blueprintId, newPosition)
    local blueprint = CopiedBlueprints[blueprintId]
    if not blueprint then
        Notify("❌ ERROR", "Blueprint no encontrado", 3)
        return false
    end
    
    -- Crear contenedor
    local container = Instance.new("Folder")
    container.Name = "VY_Copy_" .. Player.Name .. "_" .. os.time()
    container.Parent = Workspace
    
    -- Recrear partes
    for _, partData in ipairs(blueprint.parts) do
        local newPart = Instance.new(partData.Type or "Part")
        newPart.Size = partData.Size
        newPart.Position = newPosition + partData.Position
        newPart.Color = partData.Color
        newPart.Material = partData.Material
        newPart.Name = partData.Name .. "_Copy"
        newPart.Anchored = true
        newPart.CanCollide = true
        newPart.Parent = container
        
        -- Marcar como copia
        newPart:SetAttribute("IsCopy", true)
        newPart:SetAttribute("Copier", Player.Name)
    end
    
    Notify("🏗️ CONSTRUIDO", "Base pegada: " .. #blueprint.parts .. " partes", 3)
    return true
end

-- ================= INTERFAZ MÓVIL =================
function CreateMobileUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "VeneYorkUI_Mobile"
    screenGui.Parent = Player:WaitForChild("PlayerGui")
    
    -- Botón COPIAR (izquierda)
    local copyBtn = Instance.new("TextButton")
    copyBtn.Name = "CopyBtn"
    copyBtn.Text = "📋 COPIAR"
    copyBtn.Size = UDim2.new(0, 120, 0, 50)
    copyBtn.Position = UDim2.new(0.05, 0, 0.85, 0)
    copyBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
    copyBtn.TextColor3 = Color3.new(1, 1, 1)
    copyBtn.Font = Enum.Font.GothamBold
    copyBtn.Parent = screenGui
    
    copyBtn.MouseButton1Click:Connect(function()
        local mouse = Player:GetMouse()
        CopyStructure(mouse.Hit.Position, 20)
    end)
    
    -- Botón PEGAR (derecha)
    local pasteBtn = Instance.new("TextButton")
    pasteBtn.Name = "PasteBtn"
    pasteBtn.Text = "📝 PEGAR"
    pasteBtn.Size = UDim2.new(0, 120, 0, 50)
    pasteBtn.Position = UDim2.new(0.8, 0, 0.85, 0)
    pasteBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 0)
    pasteBtn.TextColor3 = Color3.new(1, 1, 1)
    pasteBtn.Font = Enum.Font.GothamBold
    pasteBtn.Parent = screenGui
    
    pasteBtn.MouseButton1Click:Connect(function()
        if #CopiedBlueprints > 0 then
            local mouse = Player:GetMouse()
            PasteStructure(#CopiedBlueprints, mouse.Hit.Position)
        else
            Notify("⚠️ AVISO", "Primero copia una base", 3)
        end
    end)
    
    -- Panel de información
    local infoPanel = Instance.new("Frame")
    infoPanel.Size = UDim2.new(0.8, 0, 0, 60)
    infoPanel.Position = UDim2.new(0.1, 0, 0.05, 0)
    infoPanel.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    infoPanel.BackgroundTransparency = 0.3
    infoPanel.Parent = screenGui
    
    local infoText = Instance.new("TextLabel")
    infoText.Text = "🔧 VENEYORK HACK v2.0\nToca los botones para copiar/pegar"
    infoText.Size = UDim2.new(1, 0, 1, 0)
    infoText.TextColor3 = Color3.new(1, 1, 1)
    infoText.BackgroundTransparency = 1
    infoText.TextSize = 14
    infoText.Parent = infoPanel
    
    return screenGui
end

-- ================= FUNCIONES AUXILIARES =================
function Notify(title, text, duration)
    game.StarterGui:SetCore("SendNotification", {
        Title = "[VeneYork] " .. title,
        Text = text,
        Duration = duration or 3,
        Icon = "rbxassetid://0"
    })
end

-- ================= INICIALIZACIÓN =================
CreateMobileUI()

-- Controles de teclado (opcional)
UIS.InputBegan:Connect(function(input)
    if input.KeyCode == Config.CopyKey then
        local mouse = Player:GetMouse()
        CopyStructure(mouse.Hit.Position, 25)
    elseif input.KeyCode == Config.PasteKey then
        if #CopiedBlueprints > 0 then
            local mouse = Player:GetMouse()
            PasteStructure(#CopiedBlueprints, mouse.Hit.Position)
        end
    end
end)

-- Mensaje de carga
print("========================================")
print("VeneYork Base Copier v2.0")
print("Creado por: " .. Config.Author)
print("GitHub: nitrofuerte504-maker/VeneYork-Hub")
print("========================================")

Notify("✅ CARGADO", "VeneYork Hack v2.0 activo!", 3)

-- API pública
return {
    Version = Config.Version,
    Copy = CopyStructure,
    Paste = PasteStructure,
    GetBlueprints = function() return CopiedBlueprints end,
    ClearBlueprints = function() CopiedBlueprints = {} end
}
