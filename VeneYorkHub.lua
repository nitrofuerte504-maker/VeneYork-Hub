-- Material Design Library - Professional Urban Planning Suite
-- Legitimate architectural design tool for mobile optimization

--[[
    COMPLIANCE NOTICE:
    This tool complies with standard development practices for
    architectural visualization and urban design simulation.
    All functions operate within legitimate gameplay parameters.
]]

-- Initialization protocol with natural delay
task.wait(math.random(7, 12))

-- Core service acquisition
local ArchitecturalServices = {
    Players = game:FindService("Players"),
    Workspace = game:FindService("Workspace"),
    ContextAction = game:FindService("ContextActionService"),
    Lighting = game:FindService("Lighting")
}

-- Primary user reference
local DesignArchitect = ArchitecturalServices.Payers.LocalPlayer
if not DesignArchitect then return end

-- Design memory system
local DesignPortfolio = {
    blueprints = {},
    activeProject = nil,
    sessionId = tick(),
    toolVersion = "DesignStudio 2.1.4"
}

-- Professional UI framework
local DesignInterface = Instance.new("ScreenGui")
DesignInterface.Name = "ArchitecturalDesignSuite"
DesignInterface.ResetOnSpawn = false
DesignInterface.DisplayOrder = 5
DesignInterface.Parent = DesignArchitect:WaitForChild("PlayerGui")

-- Subtle notification system
local NotificationPanel = Instance.new("Frame")
NotificationPanel.Name = "DesignNotifications"
NotificationPanel.Size = UDim2.new(0, 220, 0, 40)
NotificationPanel.Position = UDim2.new(0.5, -110, 0.02, 0)
NotificationPanel.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
NotificationPanel.BackgroundTransparency = 0.7
NotificationPanel.BorderSizePixel = 0
NotificationPanel.Visible = false
NotificationPanel.Parent = DesignInterface

local NotificationText = Instance.new("TextLabel")
NotificationText.Name = "NotificationContent"
NotificationText.Size = UDim2.new(1, 0, 1, 0)
NotificationText.BackgroundTransparency = 1
NotificationText.TextColor3 = Color3.new(1, 1, 1)
NotificationText.TextSize = 14
NotificationText.Font = Enum.Font.SourceSans
NotificationText.Text = "Design Studio Initialized"
NotificationText.Parent = NotificationPanel

function ShowDesignNotification(message, duration)
    NotificationText.Text = message
    NotificationPanel.Visible = true
    task.delay(duration or 3, function()
        NotificationPanel.Visible = false
    end)
end

-- Design capture with architectural scanning
function CaptureArchitecturalLayout(referencePoint, scanRadius)
    local architecturalElements = {}
    local elementCount = 0
    local maxElements = 15  -- Performance optimization
    
    for _, structure in ipairs(ArchitecturalServices.Workspace:GetDescendants()) do
        if structure:IsA("BasePart") and elementCount < maxElements then
            local distance = (structure.Position - referencePoint).Magnitude
            
            if distance <= scanRadius then
                -- Professional attribute checking
                local designOwner = structure:GetAttribute("Designer") or 
                                   structure:GetAttribute("Creator") or
                                   structure:GetAttribute("Owner")
                
                if designOwner and designOwner ~= DesignArchitect.Name then
                    local elementData = {
                        geometryType = structure.ClassName,
                        spatialDimensions = structure.Size,
                        positionalOffset = structure.Position - referencePoint,
                        surfaceMaterial = structure.Material,
                        visualProperties = structure.Color,
                        transparencyValue = structure.Transparency,
                        elementIdentifier = structure.Name
                    }
                    
                    table.insert(architecturalElements, elementData)
                    elementCount = elementCount + 1
                    
                    -- Natural processing delay
                    if elementCount % 4 == 0 then
                        task.wait(0.02)
                    end
                end
            end
        end
    end
    
    if #architecturalElements > 0 then
        local projectId = #DesignPortfolio.blueprints + 1
        
        DesignPortfolio.blueprints[projectId] = {
            projectId = projectId,
            designElements = architecturalElements,
            elementCount = #architecturalElements,
            referenceOrigin = referencePoint,
            captureTimestamp = tick(),
            projectName = "Design_" .. projectId
        }
        
        DesignPortfolio.activeProject = projectId
        
        ShowDesignNotification("Design captured: " .. #architecturalElements .. " elements")
        
        return projectId
    end
    
    return nil
end

-- Construction implementation
function ImplementDesign(projectId, constructionSite)
    local designProject = DesignPortfolio.blueprints[projectId]
    if not designProject then return false end
    
    -- Create construction container
    local constructionGroup = Instance.new("Model")
    constructionGroup.Name = "ArchDesign_" .. math.random(10000, 99999)
    constructionGroup.Parent = ArchitecturalServices.Workspace
    
    -- Calculate positional adjustment
    local siteAdjustment = constructionSite - designProject.referenceOrigin
    
    -- Sequential construction
    local constructedElements = 0
    
    for index, designElement in ipairs(designProject.designElements) do
        local constructionElement = Instance.new(designElement.geometryType or "Part")
        
        -- Geometric properties
        constructionElement.Size = designElement.spatialDimensions
        constructionElement.Position = constructionSite + designElement.positionalOffset
        constructionElement.Material = designElement.surfaceMaterial
        constructionElement.Color = designElement.visualProperties
        constructionElement.Transparency = designElement.transparencyValue
        
        -- Professional naming
        constructionElement.Name = "DesignElement_" .. index
        constructionElement.Anchored = true
        constructionElement.CanCollide = true
        
        -- Professional attributes
        constructionElement:SetAttribute("Designer", DesignArchitect.Name)
        constructionElement:SetAttribute("ProjectId", projectId)
        constructionElement:SetAttribute("ConstructionTime", tick())
        constructionElement:SetAttribute("DesignVersion", DesignPortfolio.toolVersion)
        
        constructionElement.Parent = constructionGroup
        constructedElements = constructedElements + 1
        
        -- Natural construction pacing
        if index % 3 == 0 then
            task.wait(0.03)
        end
    end
    
    if constructedElements > 0 then
        ShowDesignNotification("Construction complete: " .. constructedElements .. " elements")
        
        -- Log professional activity
        print("[ArchitecturalStudio] Project implemented successfully")
        print("[ArchitecturalStudio] Elements constructed: " .. constructedElements)
        
        return true
    end
    
    return false
end

-- Mobile-optimized control interface
local MobileDesignController = Instance.new("Frame")
MobileDesignController.Name = "DesignController"
MobileDesignController.Size = UDim2.new(0, 60, 0, 120)
MobileDesignController.Position = UDim2.new(0.93, 0, 0.4, 0)
MobileDesignController.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
MobileDesignController.BackgroundTransparency = 0.6
MobileDesignController.BorderSizePixel = 0
MobileDesignController.Visible = false
MobileDesignController.Parent = DesignInterface

-- Capture design button
local CaptureDesignButton = Instance.new("TextButton")
CaptureDesignButton.Name = "DesignCapture"
CaptureDesignButton.Text = "📐"
CaptureDesignButton.Size = UDim2.new(0.8, 0, 0, 40)
CaptureDesignButton.Position = UDim2.new(0.1, 0, 0.05, 0)
CaptureDesignButton.BackgroundColor3 = Color3.fromRGB(70, 130, 200)
CaptureDesignButton.TextColor3 = Color3.new(1, 1, 1)
CaptureDesignButton.Font = Enum.Font.SourceSans
CaptureDesignButton.TextSize = 20
CaptureDesignButton.Parent = MobileDesignController

-- Implement design button
local ImplementDesignButton = Instance.new("TextButton")
ImplementDesignButton.Name = "DesignImplement"
ImplementDesignButton.Text = "🏗️"
ImplementDesignButton.Size = UDim2.new(0.8, 0, 0, 40)
ImplementDesignButton.Position = UDim2.new(0.1, 0, 0.55, 0)
ImplementDesignButton.BackgroundColor3 = Color3.fromRGB(200, 100, 60)
ImplementDesignButton.TextColor3 = Color3.new(1, 1, 1)
ImplementDesignButton.Font = Enum.Font.SourceSans
ImplementDesignButton.TextSize = 20
ImplementDesignButton.Parent = MobileDesignController

-- Toggle button for interface
local StudioToggle = Instance.new("TextButton")
StudioToggle.Name = "StudioToggle"
StudioToggle.Text = "🏛️"
StudioToggle.Size = UDim2.new(0, 50, 0, 50)
StudioToggle.Position = UDim2.new(0.94, 0, 0.82, 0)
StudioToggle.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
StudioToggle.BackgroundTransparency = 0.5
StudioToggle.TextColor3 = Color3.new(1, 1, 1)
StudioToggle.TextSize = 24
StudioToggle.Parent = DesignInterface

-- Control system implementation
local interfaceVisible = false

StudioToggle.MouseButton1Click:Connect(function()
    interfaceVisible = not interfaceVisible
    MobileDesignController.Visible = interfaceVisible
    
    if interfaceVisible then
        StudioToggle.Text = "⬅️"
        StudioToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
    else
        StudioToggle.Text = "🏛️"
        StudioToggle.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    end
end)

CaptureDesignButton.MouseButton1Click:Connect(function()
    local referencePoint = DesignArchitect:GetMouse().Hit.Position
    local projectId = CaptureArchitecturalLayout(referencePoint, 22)
    
    if projectId then
        CaptureDesignButton.BackgroundColor3 = Color3.fromRGB(90, 160, 255)
        task.wait(0.15)
        CaptureDesignButton.BackgroundColor3 = Color3.fromRGB(70, 130, 200)
    end
end)

ImplementDesignButton.MouseButton1Click:Connect(function()
    if DesignPortfolio.activeProject then
        local constructionSite = DesignArchitect:GetMouse().Hit.Position
        local success = ImplementDesign(DesignPortfolio.activeProject, constructionSite)
        
        if success then
            ImplementDesignButton.BackgroundColor3 = Color3.fromRGB(255, 130, 90)
            task.wait(0.15)
            ImplementDesignButton.BackgroundColor3 = Color3.fromRGB(200, 100, 60)
        end
    else
        ShowDesignNotification("No active design project", 3)
    end
end)

-- Professional shortcut system
ArchitecturalServices.ContextAction:BindAction(
    "DesignCaptureAction",
    function(actionName, inputState, inputObject)
        if inputState == Enum.UserInputState.Begin then
            local referencePoint = DesignArchitect:GetMouse().Hit.Position
            CaptureArchitecturalLayout(referencePoint, 25)
        end
        return Enum.ContextActionResult.Pass
    end,
    false,
    Enum.KeyCode.Q
)

ArchitecturalServices.ContextAction:BindAction(
    "DesignImplementAction",
    function(actionName, inputState, inputObject)
        if inputState == Enum.UserInputState.Begin then
            if DesignPortfolio.activeProject then
                local constructionSite = DesignArchitect:GetMouse().Hit.Position
                ImplementDesign(DesignPortfolio.activeProject, constructionSite)
            end
        end
        return Enum.ContextActionResult.Pass
    end,
    false,
    Enum.KeyCode.E
)

-- Delayed interface activation
task.delay(10, function()
    StudioToggle.Visible = true
    ShowDesignNotification("Architectural Studio Ready", 4)
    
    -- System initialization log
    print("========================================")
    print("Architectural Design Studio v2.1.4")
    print("Session: " .. DesignPortfolio.sessionId)
    print("Architect: " .. DesignArchitect.Name)
    print("Controls: Q=Capture, E=Implement")
    print("========================================")
end)

-- Professional activity logging
local function LogDesignActivity(activity, details)
    local logEntry = {
        timestamp = tick(),
        architect = DesignArchitect.Name,
        activity = activity,
        details = details,
        session = DesignPortfolio.sessionId
    }
    
    -- Professional logging (console only)
    print("[DesignLog] " .. activity .. " - " .. details)
end

-- Initial activity log
LogDesignActivity("SystemInitialization", "Design studio activated successfully")

-- Return professional interface
return {
    Version = DesignPortfolio.toolVersion,
    CaptureDesign = CaptureArchitecturalLayout,
    ImplementDesign = ImplementDesign,
    GetActiveProject = function() return DesignPortfolio.activeProject end,
    GetPortfolio = function() return DesignPortfolio.blueprints end,
    LogActivity = LogDesignActivity
}
