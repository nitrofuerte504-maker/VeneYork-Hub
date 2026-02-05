-- Construction Assistant - Mobile Edition
-- Herramienta discreta para construcción móvil

-- Configuración móvil optimizada
local MobileConfig = {
    TouchInterface = true,
    LongPressDelay = 0.5,
    VibrationFeedback = false,
    SimpleMode = true
}

-- Función principal optimizada para móvil
local function MobileConstructionLoader()
    -- Esperar carga del juego
    repeat task.wait() until game:IsLoaded()
    
    -- Pequeña pausa aleatoria
    task.wait(math.random(2, 4))
    
    -- Servicios esenciales
    local Players = game:GetService("Players")
    local Workspace = game:GetService("Workspace")
    local LocalPlayer = Players.LocalPlayer
    
    -- Esperar personaje
    if not LocalPlayer.Character then
        LocalPlayer.CharacterAdded:Wait()
    end
    
    -- Variables del sistema
    local ConstructionMemory = {
        savedDesigns = {},
        currentDesign = nil,
        version = "1.0",
        lastUsed = tick()
    }
    
    -- Interfaz táctil optimizada
    local function CreateTouchInterface()
        local mobileUI = Instance.new("ScreenGui")
        mobileUI.Name = "BuildHelperMobile"
        mobileUI.ResetOnSpawn = false
        mobileUI.DisplayOrder = 999
        mobileUI.Parent = LocalPlayer:WaitForChild("PlayerGui")
        
        -- Botón flotante principal (invisible hasta activación)
        local mainButton = Instance.new("TextButton")
        mainButton.Name = "BuilderToggle"
        mainButton.Text = "🔧"
        mainButton.Size = UDim2.new(0, 50, 0, 50)
        mainButton.Position = UDim2.new(0.9, 0, 0.8, 0)
        mainButton.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
        mainButton.BackgroundTransparency = 0.4
        mainButton.TextColor3 = Color3.new(1, 1, 1)
        mainButton.TextSize = 24
        mainButton.ZIndex = 100
        mainButton.Visible = false  -- Oculto inicialmente
        mainButton.Parent = mobileUI
        
        -- Panel de controles (oculto inicialmente)
        local controlPanel = Instance.new("Frame")
        controlPanel.Name = "ControlPanel"
        controlPanel.Size = UDim2.new(0, 150, 0, 120)
        controlPanel.Position = UDim2.new(0.85, 0, 0.6, 0)
        controlPanel.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
        controlPanel.BackgroundTransparency = 0.3
        controlPanel.Visible = false
        controlPanel.Parent = mobileUI
        
        -- Botón de captura
        local captureBtn = Instance.new("TextButton")
        captureBtn.Name = "CaptureBtn"
        captureBtn.Text = "📸 Capturar"
        captureBtn.Size = UDim2.new(0.9, 0, 0, 40)
        captureBtn.Position = UDim2.new(0.05, 0, 0.05, 0)
        captureBtn.BackgroundColor3 = Color3.fromRGB(60, 100, 200)
        captureBtn.TextColor3 = Color3.new(1, 1, 1)
        captureBtn.Font = Enum.Font.SourceSans
        captureBtn.TextSize = 14
        captureBtn.Parent = controlPanel
        
        -- Botón de construir
        local buildBtn = Instance.new("TextButton")
        buildBtn.Name = "BuildBtn"
        buildBtn.Text = "🏗️ Construir"
        buildBtn.Size = UDim2.new(0.9, 0, 0, 40)
        buildBtn.Position = UDim2.new(0.05, 0, 0.55, 0)
        buildBtn.BackgroundColor3 = Color3.fromRGB(200, 80, 60)
        buildBtn.TextColor3 = Color3.new(1, 1, 1)
        buildBtn.Font = Enum.Font.SourceSans
        buildBtn.TextSize = 14
        buildBtn.Parent = controlPanel
        
        -- Estado del panel
        local isPanelVisible = false
        
        -- Alternar panel
        mainButton.MouseButton1Click:Connect(function()
            isPanelVisible = not isPanelVisible
            controlPanel.Visible = isPanelVisible
            
            -- Feedback visual
            if isPanelVisible then
                mainButton.Text = "✖️"
                mainButton.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
            else
                mainButton.Text = "🔧"
                mainButton.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
            end
        end)
        
        return {
            UI = mobileUI,
            CaptureButton = captureBtn,
            BuildButton = buildBtn,
            ToggleButton = mainButton
        }
    end
    
    -- Función simple de captura (optimizada para móvil)
    local function SimpleCapture(centerPosition)
        local captured = {}
        local scanDistance = 25  -- Radio de escaneo
        
        -- Escanear partes cercanas
        for _, obj in ipairs(Workspace:GetChildren()) do
            if obj:IsA("BasePart") then
                local distance = (obj.Position - centerPosition).Magnitude
                if distance < scanDistance then
                    -- Verificar si no es del jugador
                    local ownerTag = obj:GetAttribute("Owner") or 
                                    obj:GetAttribute("owner")
                    
                    if ownerTag and ownerTag ~= LocalPlayer.Name then
                        table.insert(captured, {
                            partType = obj.ClassName,
                            dimensions = obj.Size,
                            offset = obj.Position - centerPosition,
                            appearance = obj.Color,
                            material = obj.Material
                        })
                        
                        -- Limitar cantidad para rendimiento móvil
                        if #captured >= 20 then break end
                    end
                end
            end
        end
        
        if #captured > 0 then
            local designId = #ConstructionMemory.savedDesigns + 1
            ConstructionMemory.savedDesigns[designId] = {
                id = designId,
                parts = captured,
                partCount = #captured,
                captureTime = tick(),
                origin = centerPosition
            }
            
            ConstructionMemory.currentDesign = designId
            
            -- Feedback visual sutil
            game.StarterGui:SetCore("SendNotification", {
                Title = "Constructor",
                Text = "Diseño guardado: " .. #captured .. " elementos",
                Duration = 3
            })
            
            return designId
        else
            -- Si no encuentra partes de otros, captura cualquier parte
            for _, obj in ipairs(Workspace:GetChildren()) do
                if obj:IsA("BasePart") then
                    local distance = (obj.Position - centerPosition).Magnitude
                    if distance < scanDistance and #captured < 10 then
                        table.insert(captured, {
                            partType = obj.ClassName,
                            dimensions = obj.Size,
                            offset = obj.Position - centerPosition,
                            appearance = obj.Color,
                            material = obj.Material
                        })
                    end
                end
            end
            
            if #captured > 0 then
                local designId = #ConstructionMemory.savedDesigns + 1
                ConstructionMemory.savedDesigns[designId] = {
                    id = designId,
                    parts = captured,
                    partCount = #captured,
                    captureTime = tick(),
                    origin = centerPosition
                }
                
                ConstructionMemory.currentDesign = designId
                
                game.StarterGui:SetCore("SendNotification", {
                    Title = "Constructor",
                    Text = "Estructura guardada: " .. #captured .. " partes",
                    Duration = 3
                })
                
                return designId
            end
        end
        
        return nil
    end
    
    -- Función simple de construcción
    local function SimpleBuild(designId, targetPosition)
        local design = ConstructionMemory.savedDesigns[designId]
        if not design then return false end
        
        -- Crear contenedor
        local buildContainer = Instance.new("Folder")
        buildContainer.Name = "Build_" .. math.random(1000, 9999)
        buildContainer.Parent = Workspace
        
        -- Calcular desplazamiento
        local positionOffset = targetPosition - design.origin
        
        -- Construir elementos
        local builtCount = 0
        
        for index, partData in ipairs(design.parts) do
            local newPart = Instance.new(partData.partType or "Part")
            newPart.Size = partData.dimensions
            newPart.Position = targetPosition + partData.offset
            newPart.Color = partData.appearance
            newPart.Material = partData.material
            newPart.Name = "Structure_" .. index
            newPart.Anchored = true
            newPart.CanCollide = true
            
            -- Atributos legítimos
            newPart:SetAttribute("BuiltBy", LocalPlayer.Name)
            newPart:SetAttribute("BuildTime", tick())
            
            newPart.Parent = buildContainer
            builtCount = builtCount + 1
            
            -- Pequeña pausa para rendimiento móvil
            if index % 3 == 0 then
                task.wait(0.01)
            end
        end
        
        -- Feedback
        if builtCount > 0 then
            game.StarterGui:SetCore("SendNotification", {
                Title = "Constructor",
                Text = "Construcción completada: " .. builtCount .. " partes",
                Duration = 3
            })
        end
        
        return builtCount > 0
    end
    
    -- Sistema de controles táctiles
    local function SetupTouchControls(touchUI)
        local mouse = LocalPlayer:GetMouse()
        
        -- Botón de captura
        touchUI.CaptureButton.MouseButton1Click:Connect(function()
            local designId = SimpleCapture(mouse.Hit.Position)
            if designId then
                -- Feedback de botón
                touchUI.CaptureButton.BackgroundColor3 = Color3.fromRGB(80, 140, 255)
                task.wait(0.15)
                touchUI.CaptureButton.BackgroundColor3 = Color3.fromRGB(60, 100, 200)
            else
                game.StarterGui:SetCore("SendNotification", {
                    Title = "Constructor",
                    Text = "No se encontraron estructuras cerca",
                    Duration = 3
                })
            end
        end)
        
        -- Botón de construir
        touchUI.BuildButton.MouseButton1Click:Connect(function()
            if ConstructionMemory.currentDesign then
                local success = SimpleBuild(ConstructionMemory.currentDesign, mouse.Hit.Position)
                if success then
                    -- Feedback de botón
                    touchUI.BuildButton.BackgroundColor3 = Color3.fromRGB(255, 100, 80)
                    task.wait(0.15)
                    touchUI.BuildButton.BackgroundColor3 = Color3.fromRGB(200, 80, 60)
                end
            else
                game.StarterGui:SetCore("SendNotification", {
                    Title = "Constructor",
                    Text = "Primero captura un diseño",
                    Duration = 3
                })
            end
        end)
    end
    
    -- Inicializar interfaz y controles
    local touchInterface = CreateTouchInterface()
    SetupTouchControls(touchInterface)
    
    -- Mostrar botón después de 8 segundos
    task.delay(8, function()
        touchInterface.ToggleButton.Visible = true
        game.StarterGui:SetCore("SendNotification", {
            Title = "Sistema",
            Text = "Herramienta de construcción disponible",
            Duration = 4
        })
    end)
    
    -- Mensaje en consola
    print("[MobileBuilder] Sistema activo - Versión 1.0")
    print("[MobileBuilder] Botón 🔧 aparecerá en 8 segundos")
    
    return {
        Capture = SimpleCapture,
        Build = SimpleBuild,
        GetDesigns = function() return ConstructionMemory.savedDesigns end,
        ShowUI = function() touchInterface.ToggleButton.Visible = true end
    }
end

-- Cargador seguro para móvil
local function SafeMobileLoad()
    -- Ocultar errores
    local success, result = pcall(function()
        return MobileConstructionLoader()
    end)
    
    if not success then
        -- Fallback mínimo si falla
        warn("[MobileBuilder] Error, cargando modo simple...")
        
        local player = game.Players.LocalPlayer
        local gui = Instance.new("ScreenGui")
        gui.Parent = player:WaitForChild("PlayerGui")
        
        local btn1 = Instance.new("TextButton")
        btn1.Text = "📋 COPIAR"
        btn1.Size = UDim2.new(0, 100, 0, 50)
        btn1.Position = UDim2.new(0.1, 0, 0.85, 0)
        btn1.BackgroundColor3 = Color3.new(0, 0.5, 1)
        btn1.Parent = gui
        
        local btn2 = Instance.new("TextButton")
        btn2.Text = "📝 PEGAR"
        btn2.Size = UDim2.new(0, 100, 0, 50)
        btn2.Position = UDim2.new(0.8, 0, 0.85, 0)
        btn2.BackgroundColor3 = Color3.new(1, 0.3, 0)
        btn2.Parent = gui
        
        local copia = nil
        
        btn1.MouseButton1Click:Connect(function()
            local mouse = player:GetMouse()
            if mouse.Target then
                copia = mouse.Target
                print("✅ Copiado: " .. mouse.Target.Name)
                game.StarterGui:SetCore("SendNotification", {
                    Title = "Simple Copier",
                    Text = "Objeto copiado",
                    Duration = 2
                })
            end
        end)
        
        btn2.MouseButton1Click:Connect(function()
            if copia then
                local mouse = player:GetMouse()
                local nuevo = copia:Clone()
                nuevo.Parent = workspace
                nuevo.Position = mouse.Hit.Position
                print("🏗️ Pegado!")
                game.StarterGui:SetCore("SendNotification", {
                    Title = "Simple Copier",
                    Text = "Objeto colocado",
                    Duration = 2
                })
            end
        end)
        
        return "Modo simple activado"
    end
    
    return result
end

-- Iniciar sistema después de esperar
task.wait(3)  -- Esperar 3 segundos antes de cargar
SafeMobileLoad()

print("===========================================")
print("Construction Assistant - Mobile Edition")
print("Cargado exitosamente")
print("Espera 8 segundos para ver el botón 🔧")
print("===========================================")
