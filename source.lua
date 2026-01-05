-- [[ 🍃 VAYU HUB: UI LIBRARY V13 (MAC STYLE & FIXES) ]] --

local cloneref = cloneref or function(o) return o end
local UserInputService = cloneref(game:GetService("UserInputService"))
local TweenService = cloneref(game:GetService("TweenService"))
local RunService = cloneref(game:GetService("RunService"))
local CoreGui = cloneref(game:GetService("CoreGui"))
local Lighting = cloneref(game:GetService("Lighting"))
local Players = cloneref(game:GetService("Players"))
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local Library = {}

-- [UTILITY]
local function Tween(obj, time, properties)
    return TweenService:Create(obj, TweenInfo.new(time, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), properties)
end

function Library:CreateWindow(Config)
    local Title = Config.Title or "My UI Library"
    local ThemeColor = Config.ThemeColor or Color3.fromRGB(0, 145, 255)
    local ToggleKey = Config.ToggleKey or Enum.KeyCode.RightControl
    local UseBlur = Config.UseBlur ~= false
    local LogoId = Config.Logo or "" 
    
    -- [1] GUI SETUP
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "VayuHub_V13"
    if CoreGui:FindFirstChild("VayuHub_V13") then CoreGui.VayuHub_V13:Destroy() end
    ScreenGui.Parent = CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- [FIX] Blur Logic (Named specifically to find later)
    local Blur
    if UseBlur then
        -- ลบตัวเก่าก่อนถ้ามีค้าง
        if Lighting:FindFirstChild("VayuBlur_V13") then Lighting.VayuBlur_V13:Destroy() end
        Blur = Instance.new("BlurEffect")
        Blur.Name = "VayuBlur_V13"
        Blur.Size = 0
        Blur.Parent = Lighting
    end

    local NotifyContainer = Instance.new("Frame"); NotifyContainer.Name = "NotifyContainer"; NotifyContainer.Size = UDim2.new(0, 300, 1, 0); NotifyContainer.Position = UDim2.new(1, -320, 0, 0); NotifyContainer.BackgroundTransparency = 1; NotifyContainer.Parent = ScreenGui
    local NotifyList = Instance.new("UIListLayout"); NotifyList.Padding = UDim.new(0, 10); NotifyList.VerticalAlignment = Enum.VerticalAlignment.Bottom; NotifyList.HorizontalAlignment = Enum.HorizontalAlignment.Right; NotifyList.SortOrder = Enum.SortOrder.LayoutOrder; NotifyList.Parent = NotifyContainer
    local NotifyPad = Instance.new("UIPadding"); NotifyPad.PaddingBottom = UDim.new(0, 30); NotifyPad.PaddingRight = UDim.new(0, 20); NotifyPad.Parent = NotifyContainer

    local DialogOverlay = Instance.new("Frame"); DialogOverlay.Name = "Overlay"; DialogOverlay.Size = UDim2.fromScale(1, 1); DialogOverlay.BackgroundColor3 = Color3.new(0,0,0); DialogOverlay.BackgroundTransparency = 1; DialogOverlay.Visible = false; DialogOverlay.ZIndex = 100; DialogOverlay.Parent = ScreenGui

    local MainFrame = Instance.new("Frame"); MainFrame.Name = "MainFrame"; MainFrame.Size = UDim2.fromOffset(600, 450); MainFrame.Position = UDim2.fromScale(0.5, 0.5); MainFrame.AnchorPoint = Vector2.new(0.5, 0.5); MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 22); MainFrame.BorderSizePixel = 0; MainFrame.ClipsDescendants = true; MainFrame.Parent = ScreenGui
    local Shadow = Instance.new("ImageLabel"); Shadow.Name = "Shadow"; Shadow.AnchorPoint = Vector2.new(0.5, 0.5); Shadow.BackgroundTransparency = 1; Shadow.Position = UDim2.new(0.5, 0, 0.5, 0); Shadow.Size = UDim2.new(1, 60, 1, 60); Shadow.ZIndex = -1; Shadow.Image = "rbxassetid://6015897843"; Shadow.ImageColor3 = Color3.new(0, 0, 0); Shadow.ImageTransparency = 0.4; Shadow.ScaleType = Enum.ScaleType.Slice; Shadow.SliceCenter = Rect.new(49, 49, 450, 450); Shadow.Parent = MainFrame
    local Stroke = Instance.new("UIStroke"); Stroke.Thickness = 1; Stroke.Color = Color3.fromRGB(45, 45, 50); Stroke.Parent = MainFrame
    local MainCorner = Instance.new("UICorner"); MainCorner.CornerRadius = UDim.new(0, 12); MainCorner.Parent = MainFrame

    local TopBar = Instance.new("Frame"); TopBar.Size = UDim2.new(1, 0, 0, 50); TopBar.BackgroundColor3 = Color3.fromRGB(25, 25, 30); TopBar.BorderSizePixel = 0; TopBar.Parent = MainFrame
    local TopBarCorner = Instance.new("UICorner"); TopBarCorner.CornerRadius = UDim.new(0, 12); TopBarCorner.Parent = TopBar
    local Filler = Instance.new("Frame"); Filler.Size = UDim2.new(1, 0, 0, 10); Filler.Position = UDim2.new(0, 0, 1, -10); Filler.BackgroundColor3 = TopBar.BackgroundColor3; Filler.BorderSizePixel = 0; Filler.Parent = TopBar

    local TitleLabel = Instance.new("TextLabel"); TitleLabel.Text = Title; TitleLabel.Font = Enum.Font.GothamBold; TitleLabel.TextSize = 16; TitleLabel.TextColor3 = Color3.fromRGB(240, 240, 240); TitleLabel.Size = UDim2.new(1, -20, 1, 0); TitleLabel.Position = UDim2.new(0, LogoId ~= "" and 50 or 20, 0, 0); TitleLabel.BackgroundTransparency = 1; TitleLabel.TextXAlignment = Enum.TextXAlignment.Left; TitleLabel.Parent = TopBar
    if LogoId ~= "" then local LogoImg = Instance.new("ImageLabel"); LogoImg.Size = UDim2.fromOffset(30, 30); LogoImg.Position = UDim2.new(0, 10, 0.5, -15); LogoImg.BackgroundTransparency = 1; LogoImg.Image = "rbxassetid://" .. LogoId:gsub("rbxassetid://", ""); LogoImg.Parent = TopBar end

    -- [FIX] Resize Handle (Clean Icon)
    local ResizeHandle = Instance.new("ImageButton")
    ResizeHandle.Size = UDim2.fromOffset(16, 16)
    ResizeHandle.Position = UDim2.new(1, -16, 1, -16)
    ResizeHandle.BackgroundTransparency = 1
    ResizeHandle.Image = "rbxassetid://7218676876" -- Standard Resize Grip Icon
    ResizeHandle.ImageColor3 = Color3.fromRGB(120, 120, 120)
    ResizeHandle.ImageTransparency = 0.5
    ResizeHandle.ZIndex = 10
    ResizeHandle.Parent = MainFrame

    -- [NEW] MAC STYLE CONTROLS
    local ControlContainer = Instance.new("Frame")
    ControlContainer.Size = UDim2.new(0, 80, 1, 0)
    ControlContainer.Position = UDim2.new(1, -15, 0, 0)
    ControlContainer.AnchorPoint = Vector2.new(1, 0)
    ControlContainer.BackgroundTransparency = 1
    ControlContainer.Parent = TopBar
    
    local ControlLayout = Instance.new("UIListLayout")
    ControlLayout.FillDirection = Enum.FillDirection.Horizontal
    ControlLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    ControlLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    ControlLayout.Padding = UDim.new(0, 8) -- Mac buttons are close together
    ControlLayout.Parent = ControlContainer

    local function ToggleUI() MainFrame.Visible = not MainFrame.Visible; if Blur then Tween(Blur, 0.5, {Size = MainFrame.Visible and 15 or 0}):Play() end end

    local function CreateMacBtn(Color, HoverIcon, Callback)
        local Btn = Instance.new("ImageButton")
        Btn.Size = UDim2.fromOffset(14, 14) -- Mac standard size
        Btn.BackgroundColor3 = Color
        Btn.Image = "" -- No image by default
        Btn.AutoButtonColor = false
        Btn.Parent = ControlContainer
        
        local Corner = Instance.new("UICorner"); Corner.CornerRadius = UDim.new(1, 0); Corner.Parent = Btn -- Perfectly Round
        
        -- Hover Icon (Shows only on mouse enter)
        local Icon = Instance.new("ImageLabel")
        Icon.Size = UDim2.fromOffset(10, 10)
        Icon.AnchorPoint = Vector2.new(0.5, 0.5)
        Icon.Position = UDim2.new(0.5, 0, 0.5, 0)
        Icon.BackgroundTransparency = 1
        Icon.Image = HoverIcon
        Icon.ImageColor3 = Color3.new(0,0,0)
        Icon.ImageTransparency = 1 -- Hidden by default
        Icon.Parent = Btn
        
        Btn.MouseEnter:Connect(function() Tween(Icon, 0.2, {ImageTransparency = 0.5}):Play(); Tween(Btn, 0.2, {ImageTransparency = 0.1}):Play() end)
        Btn.MouseLeave:Connect(function() Tween(Icon, 0.2, {ImageTransparency = 1}):Play(); Tween(Btn, 0.2, {ImageTransparency = 0}):Play() end)
        Btn.MouseButton1Click:Connect(Callback)
    end

    -- 1. Minimize (Yellow -)
    CreateMacBtn(Color3.fromRGB(255, 189, 46), "rbxassetid://10747384394", function()
        ToggleUI()
    end)

    -- 2. Maximize (Green +)
    local IsMaximized = false
    local OldSize = UDim2.fromOffset(600, 450)
    local OldPos = UDim2.fromScale(0.5, 0.5)
    
    CreateMacBtn(Color3.fromRGB(39, 201, 63), "rbxassetid://10747384534", function()
        IsMaximized = not IsMaximized
        if IsMaximized then
            OldSize = MainFrame.Size; OldPos = MainFrame.Position
            Tween(MainFrame, 0.4, {Size = UDim2.new(1, -20, 1, -20), Position = UDim2.new(0.5, 0, 0.5, 0)}):Play()
        else
            Tween(MainFrame, 0.4, {Size = OldSize, Position = OldPos}):Play()
        end
    end)

    -- 3. Close (Red x) - [FIXED BLUR REMOVAL]
    CreateMacBtn(Color3.fromRGB(255, 95, 86), "rbxassetid://10747384394", function()
        -- Destroy GUI
        ScreenGui:Destroy()
        -- [FIX] Destroy Blur explicitly
        if Blur then Blur:Destroy() end
        local checkBlur = Lighting:FindFirstChild("VayuBlur_V13")
        if checkBlur then checkBlur:Destroy() end
    end)

    -- [2] LOGIC
    local Dragging, DragInput, DragStart, StartPos
    local Resizing, ResizeStart, StartSize
    
    TopBar.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then Dragging = true; DragStart = i.Position; StartPos = MainFrame.Position end end)
    ResizeHandle.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then Resizing = true; ResizeStart = i.Position; StartSize = MainFrame.Size end end)
    UserInputService.InputChanged:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then DragInput = i end end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then Dragging = false; Resizing = false end end)
    RunService.RenderStepped:Connect(function() if Dragging and DragInput and not IsMaximized then local D = DragInput.Position - DragStart; MainFrame.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + D.X, StartPos.Y.Scale, StartPos.Y.Offset + D.Y) elseif Resizing and DragInput and not IsMaximized then local D = DragInput.Position - ResizeStart; MainFrame.Size = UDim2.new(0, math.max(400, StartSize.X.Offset + D.X), 0, math.max(300, StartSize.Y.Offset + D.Y)) end end)
    
    UserInputService.InputBegan:Connect(function(i, gp) if not gp and i.KeyCode == ToggleKey then ToggleUI() end end)
    
    -- [TOGGLE BUTTON]
    do
        local MBtn = Instance.new("ImageButton"); MBtn.Size = UDim2.fromOffset(50, 50); MBtn.Position = UDim2.new(0, 50, 0.5, -25); MBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35); MBtn.Image = LogoId ~= "" and "rbxassetid://" .. LogoId:gsub("rbxassetid://", "") or "rbxassetid://13466556465"; MBtn.Parent = ScreenGui
        Instance.new("UICorner", MBtn).CornerRadius = UDim.new(1, 0); local MStroke = Instance.new("UIStroke"); MStroke.Color = ThemeColor; MStroke.Thickness = 2; MStroke.Parent = MBtn
        local MDrag, MStart, MPos; local IsDragging = false
        MBtn.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then MDrag = true; MStart = i.Position; MPos = MBtn.Position end end)
        MBtn.InputChanged:Connect(function(i) if MDrag and (i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseMovement) then local D = i.Position - MStart; if (i.Position - MStart).Magnitude > 5 then IsDragging = true; MBtn.Position = UDim2.new(MPos.X.Scale, MPos.X.Offset + D.X, MPos.Y.Scale, MPos.Y.Offset + D.Y) end end end)
        MBtn.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then MDrag = false; if not IsDragging then ToggleUI() end; IsDragging = false end end)
    end

    if Blur then Tween(Blur, 0.8, {Size = 15}):Play() end
    MainFrame.Size = UDim2.fromOffset(0, 0); Tween(MainFrame, 0.6, {Size = UDim2.fromOffset(600, 450)}):Play()

    -- [3] CONTAINERS
    local TabContainer = Instance.new("ScrollingFrame"); TabContainer.Size = UDim2.new(0, 160, 1, -50); TabContainer.Position = UDim2.new(0, 10, 0, 50); TabContainer.BackgroundTransparency = 1; TabContainer.ScrollBarThickness = 0; TabContainer.Parent = MainFrame
    local TabList = Instance.new("UIListLayout"); TabList.Padding = UDim.new(0, 6); TabList.SortOrder = Enum.SortOrder.LayoutOrder; TabList.Parent = TabContainer
    local PageContainer = Instance.new("Frame"); PageContainer.Size = UDim2.new(1, -180, 1, -60); PageContainer.Position = UDim2.new(0, 175, 0, 55); PageContainer.BackgroundTransparency = 1; PageContainer.Parent = MainFrame
    local Divider = Instance.new("Frame"); Divider.Size = UDim2.new(0, 1, 1, -70); Divider.Position = UDim2.new(0, 170, 0, 60); Divider.BackgroundColor3 = Color3.fromRGB(45, 45, 50); Divider.BorderSizePixel = 0; Divider.Parent = MainFrame

    -- [4] FUNCTIONS
    local WF = {}

    function WF:Notify(P)
        local N = Instance.new("Frame"); N.Size = UDim2.new(1, 0, 0, 0); N.BackgroundColor3 = Color3.fromRGB(30, 30, 35); N.BackgroundTransparency = 0.1; N.Parent = NotifyContainer
        Instance.new("UICorner", N).CornerRadius = UDim.new(0, 8); local NS = Instance.new("UIStroke"); NS.Thickness = 1; NS.Color = ThemeColor; NS.Parent = N
        local NT = Instance.new("TextLabel"); NT.Text = P.Title; NT.Font = Enum.Font.GothamBold; NT.TextColor3 = ThemeColor; NT.Size = UDim2.new(1, -20, 0, 20); NT.Position = UDim2.new(0, 10, 0, 8); NT.BackgroundTransparency = 1; NT.TextXAlignment = Enum.TextXAlignment.Left; NT.Parent = N
        local ND = Instance.new("TextLabel"); ND.Text = P.Content; ND.Font = Enum.Font.GothamMedium; ND.TextColor3 = Color3.fromRGB(200, 200, 200); ND.Size = UDim2.new(1, -20, 0, 30); ND.Position = UDim2.new(0, 10, 0, 28); ND.BackgroundTransparency = 1; ND.TextXAlignment = Enum.TextXAlignment.Left; ND.TextWrapped = true; ND.Parent = N
        Tween(N, 0.4, {Size = UDim2.new(1, 0, 0, 65)}):Play()
        task.delay(P.Duration or 3, function() local Out = Tween(N, 0.4, {Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1}); Tween(NT, 0.3, {TextTransparency = 1}):Play(); Tween(ND, 0.3, {TextTransparency = 1}):Play(); Tween(NS, 0.3, {Transparency = 1}):Play(); Out:Play(); Out.Completed:Wait(); N:Destroy() end)
    end

    function WF:Dialog(P)
        DialogOverlay.Visible = true; Tween(DialogOverlay, 0.3, {BackgroundTransparency = 0.6}):Play()
        local DF = Instance.new("Frame"); DF.Size = UDim2.fromOffset(0, 0); DF.Position = UDim2.fromScale(0.5, 0.5); DF.AnchorPoint = Vector2.new(0.5, 0.5); DF.BackgroundColor3 = Color3.fromRGB(25, 25, 30); DF.Parent = DialogOverlay; Instance.new("UICorner", DF).CornerRadius = UDim.new(0, 12); local DS = Instance.new("UIStroke"); DS.Color = ThemeColor; DS.Thickness = 1; DS.Parent = DF
        local DT = Instance.new("TextLabel"); DT.Text = P.Title; DT.Font = Enum.Font.GothamBold; DT.TextColor3 = Color3.new(1,1,1); DT.Size = UDim2.new(1, 0, 0, 30); DT.Position = UDim2.new(0,0,0,10); DT.BackgroundTransparency = 1; DT.Parent = DF
        local DC = Instance.new("TextLabel"); DC.Text = P.Content; DC.Font = Enum.Font.GothamMedium; DC.TextColor3 = Color3.fromRGB(200,200,200); DC.Size = UDim2.new(1, -40, 0, 40); DC.Position = UDim2.new(0, 20, 0, 45); DC.BackgroundTransparency = 1; DC.TextWrapped = true; DC.Parent = DF
        local function B(T, C, CB) local b = Instance.new("TextButton"); b.Text = T; b.BackgroundColor3 = C; b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.GothamBold; b.Parent = DF; Instance.new("UICorner", b).CornerRadius = UDim.new(0,6)
            b.MouseButton1Click:Connect(function() Tween(DF, 0.2, {Size = UDim2.fromOffset(0, 0)}):Play(); local F = Tween(DialogOverlay, 0.2, {BackgroundTransparency = 1}); F:Play(); F.Completed:Wait(); DF:Destroy(); DialogOverlay.Visible=false; CB() end); return b end
        local B1 = B("Confirm", ThemeColor, P.OnConfirm); B1.Size = UDim2.new(0, 120, 0, 35); B1.Position = UDim2.new(0.5, 10, 1, -50)
        local B2 = B("Cancel", Color3.fromRGB(60,60,65), function() end); B2.Size = UDim2.new(0, 120, 0, 35); B2.Position = UDim2.new(0.5, -130, 1, -50)
        Tween(DF, 0.4, {Size = UDim2.fromOffset(320, 160)}):Play()
    end

    local FirstTab = true
    function WF:CreateTab(TabName, TabIcon)
        local TB = Instance.new("TextButton"); TB.Text = ""; TB.BackgroundColor3 = Color3.fromRGB(25, 25, 255); TB.BackgroundTransparency = 1; TB.Size = UDim2.new(1, 0, 0, 35); TB.Parent = TabContainer
        local TP = Instance.new("UIPadding"); TP.PaddingLeft = UDim.new(0, 10); TP.Parent = TB; Instance.new("UICorner", TB).CornerRadius = UDim.new(0, 6)
        local C = Instance.new("Frame"); C.Size = UDim2.new(1, 0, 1, 0); C.BackgroundTransparency = 1; C.Parent = TB
        local L = Instance.new("UIListLayout"); L.FillDirection = Enum.FillDirection.Horizontal; L.VerticalAlignment = Enum.VerticalAlignment.Center; L.Padding = UDim.new(0, 10); L.Parent = C
        if TabIcon then local I = Instance.new("ImageLabel"); I.Size = UDim2.fromOffset(20, 20); I.BackgroundTransparency = 1; I.Image = "rbxassetid://"..TabIcon:gsub("rbxassetid://",""); I.ImageColor3 = Color3.fromRGB(150, 150, 150); I.Parent = C end
        local TL = Instance.new("TextLabel"); TL.Text = TabName; TL.Font = Enum.Font.GothamBold; TL.TextSize = 14; TL.TextColor3 = Color3.fromRGB(150, 150, 150); TL.BackgroundTransparency = 1; TL.AutomaticSize = Enum.AutomaticSize.X; TL.Size = UDim2.new(0, 0, 1, 0); TL.TextXAlignment = Enum.TextXAlignment.Left; TL.Parent = C
        local P = Instance.new("ScrollingFrame"); P.Name = TabName.."Page"; P.Size = UDim2.new(1, 0, 1, 0); P.BackgroundTransparency = 1; P.ScrollBarThickness = 2; P.ScrollBarImageColor3 = ThemeColor; P.Visible = false; P.Parent = PageContainer; P.AutomaticCanvasSize = Enum.AutomaticSize.Y
        local PL = Instance.new("UIListLayout"); PL.Padding = UDim.new(0, 8); PL.SortOrder = Enum.SortOrder.LayoutOrder; PL.Parent = P
        local PP = Instance.new("UIPadding"); PP.PaddingTop = UDim.new(0, 5); PP.PaddingLeft = UDim.new(0, 5); PP.PaddingRight = UDim.new(0, 5); PP.PaddingBottom = UDim.new(0, 15); PP.Parent = P
        
        local function Activate()
            for _,v in pairs(TabContainer:GetChildren()) do if v:IsA("TextButton") then Tween(v, 0.3, {BackgroundTransparency = 1}):Play()
                local c = v:FindFirstChild("Frame"); if c then for _, e in pairs(c:GetChildren()) do if e:IsA("TextLabel") then Tween(e, 0.3, {TextColor3 = Color3.fromRGB(150, 150, 150)}):Play() end; if e:IsA("ImageLabel") then Tween(e, 0.3, {ImageColor3 = Color3.fromRGB(150, 150, 150)}):Play() end end end end end
            for _,v in pairs(PageContainer:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end
            Tween(TB, 0.3, {BackgroundTransparency = 0.92, BackgroundColor3 = ThemeColor}):Play(); Tween(TL, 0.3, {TextColor3 = ThemeColor}):Play(); if C:FindFirstChild("ImageLabel") then Tween(C.ImageLabel, 0.3, {ImageColor3 = ThemeColor}):Play() end; P.Visible = true
        end
        TB.MouseButton1Click:Connect(Activate); if FirstTab then FirstTab = false; Activate() end

        local TF = {}
        -- [COMPLETE ELEMENTS] --
        function TF:CreateLabel(T) local L = Instance.new("TextLabel"); L.Text = T; L.Font = Enum.Font.GothamBold; L.TextSize = 13; L.TextColor3 = Color3.fromRGB(180, 180, 180); L.Size = UDim2.new(1, 0, 0, 30); L.BackgroundTransparency = 1; L.TextXAlignment = Enum.TextXAlignment.Left; L.Parent = P end
        function TF:CreateSection(T) local F = Instance.new("Frame"); F.BackgroundTransparency = 1; F.Size = UDim2.new(1, 0, 0, 35); F.Parent = P; local L = Instance.new("TextLabel"); L.Text = "  " .. string.upper(T); L.Font = Enum.Font.GothamBlack; L.TextSize = 12; L.TextColor3 = Color3.fromRGB(100, 100, 110); L.Size = UDim2.new(1, 0, 1, 0); L.BackgroundTransparency = 1; L.TextXAlignment = Enum.TextXAlignment.Left; L.Parent = F end
        function TF:CreateParagraph(T, C) local F = Instance.new("Frame"); F.BackgroundColor3 = Color3.fromRGB(25, 25, 30); F.Size = UDim2.new(1, 0, 0, 60); F.Parent = P; Instance.new("UICorner", F).CornerRadius = UDim.new(0, 8); local TL = Instance.new("TextLabel"); TL.Text = T; TL.Font = Enum.Font.GothamBold; TL.TextSize = 14; TL.TextColor3 = ThemeColor; TL.Size = UDim2.new(1, -20, 0, 20); TL.Position = UDim2.new(0, 10, 0, 8); TL.BackgroundTransparency = 1; TL.TextXAlignment = Enum.TextXAlignment.Left; TL.Parent = F; local CL = Instance.new("TextLabel"); CL.Text = C; CL.Font = Enum.Font.GothamMedium; CL.TextSize = 12; CL.TextColor3 = Color3.fromRGB(200, 200, 200); CL.Size = UDim2.new(1, -20, 0, 30); CL.Position = UDim2.new(0, 10, 0, 28); CL.BackgroundTransparency = 1; CL.TextXAlignment = Enum.TextXAlignment.Left; CL.TextWrapped = true; CL.Parent = F end
        function TF:CreateButton(T, CB, I) local B = Instance.new("TextButton"); B.Text = ""; B.BackgroundColor3 = Color3.fromRGB(25, 25, 30); B.Size = UDim2.new(1, 0, 0, 42); B.Parent = P; Instance.new("UICorner", B).CornerRadius = UDim.new(0, 8); local L = Instance.new("TextLabel"); L.Text = T; L.Font = Enum.Font.GothamBold; L.TextSize = 14; L.TextColor3 = Color3.fromRGB(240, 240, 240); L.Size = UDim2.new(1, 0, 1, 0); L.BackgroundTransparency = 1; L.Parent = B; if I then local Im = Instance.new("ImageLabel"); Im.Size = UDim2.fromOffset(20,20); Im.Position = UDim2.new(0, 10, 0.5, -10); Im.BackgroundTransparency = 1; Im.Image = "rbxassetid://"..I:gsub("rbxassetid://",""); Im.Parent = B; L.Position = UDim2.new(0, 35, 0, 0); L.TextXAlignment = Enum.TextXAlignment.Left end; B.MouseButton1Click:Connect(function() Tween(B, 0.1, {Size = UDim2.new(1, -4, 0, 38)}):Play(); task.wait(0.1); Tween(B, 0.1, {Size = UDim2.new(1, 0, 0, 42)}):Play(); CB() end) end
        function TF:CreateToggle(T, D, CB) local B = Instance.new("TextButton"); B.Text = ""; B.BackgroundColor3 = Color3.fromRGB(25, 25, 30); B.Size = UDim2.new(1, 0, 0, 42); B.Parent = P; Instance.new("UICorner", B).CornerRadius = UDim.new(0, 8); local L = Instance.new("TextLabel"); L.Text = T; L.Font = Enum.Font.GothamBold; L.TextSize = 14; L.TextColor3 = Color3.fromRGB(240, 240, 240); L.Size = UDim2.new(1, -60, 1, 0); L.Position = UDim2.new(0, 15, 0, 0); L.BackgroundTransparency = 1; L.TextXAlignment = Enum.TextXAlignment.Left; L.Parent = B; local Bg = Instance.new("Frame"); Bg.Size = UDim2.fromOffset(42, 22); Bg.Position = UDim2.new(1, -55, 0.5, -11); Bg.BackgroundColor3 = Color3.fromRGB(50, 50, 55); Bg.Parent = B; Instance.new("UICorner", Bg).CornerRadius = UDim.new(1, 0); local Kn = Instance.new("Frame"); Kn.Size = UDim2.fromOffset(18, 18); Kn.Position = UDim2.new(0, 2, 0.5, -9); Kn.BackgroundColor3 = Color3.fromRGB(255, 255, 255); Kn.Parent = Bg; Instance.new("UICorner", Kn).CornerRadius = UDim.new(1, 0); local Val = D; local function U() if Val then Tween(Bg, 0.3, {BackgroundColor3 = ThemeColor}):Play(); Tween(Kn, 0.3, {Position = UDim2.new(1, -20, 0.5, -9)}):Play() else Tween(Bg, 0.3, {BackgroundColor3 = Color3.fromRGB(50, 50, 55)}):Play(); Tween(Kn, 0.3, {Position = UDim2.new(0, 2, 0.5, -9)}):Play() end end; B.MouseButton1Click:Connect(function() Val = not Val; U(); CB(Val) end); if D then U() end end
        function TF:CreateSlider(T, Min, Max, Def, CB) local F = Instance.new("Frame"); F.BackgroundColor3 = Color3.fromRGB(25, 25, 30); F.Size = UDim2.new(1, 0, 0, 60); F.Parent = P; Instance.new("UICorner", F).CornerRadius = UDim.new(0, 8); local L = Instance.new("TextLabel"); L.Text = T; L.Font = Enum.Font.GothamBold; L.TextSize = 14; L.TextColor3 = Color3.fromRGB(240, 240, 240); L.Size = UDim2.new(1, -20, 0, 20); L.Position = UDim2.new(0, 15, 0, 10); L.BackgroundTransparency = 1; L.TextXAlignment = Enum.TextXAlignment.Left; L.Parent = F; local V = Instance.new("TextLabel"); V.Text = tostring(Def); V.Font = Enum.Font.GothamBold; V.TextSize = 14; V.TextColor3 = ThemeColor; V.Size = UDim2.new(0, 40, 0, 20); V.Position = UDim2.new(1, -50, 0, 10); V.BackgroundTransparency = 1; V.TextXAlignment = Enum.TextXAlignment.Right; V.Parent = F; local Tr = Instance.new("Frame"); Tr.BackgroundColor3 = Color3.fromRGB(50, 50, 55); Tr.Size = UDim2.new(1, -30, 0, 6); Tr.Position = UDim2.new(0, 15, 0, 40); Tr.Parent = F; Instance.new("UICorner", Tr).CornerRadius = UDim.new(1, 0); local Fi = Instance.new("Frame"); Fi.BackgroundColor3 = ThemeColor; Fi.Size = UDim2.new((Def - Min) / (Max - Min), 0, 1, 0); Fi.Parent = Tr; Instance.new("UICorner", Fi).CornerRadius = UDim.new(1, 0); local Drag = false; Tr.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then Drag = true end end); UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then Drag = false end end); RunService.RenderStepped:Connect(function() if Drag then local S = math.clamp((Mouse.X - Tr.AbsolutePosition.X) / Tr.AbsoluteSize.X, 0, 1); local Val = math.floor(Min + ((Max - Min) * S)); Fi.Size = UDim2.new(S, 0, 1, 0); V.Text = tostring(Val); CB(Val) end end) end
        function TF:CreateDropdown(T, Op, Def, CB) local F = Instance.new("Frame"); F.BackgroundColor3 = Color3.fromRGB(25, 25, 30); F.Size = UDim2.new(1, 0, 0, 42); F.ClipsDescendants=true; F.Parent=P; Instance.new("UICorner", F).CornerRadius = UDim.new(0, 8); local B = Instance.new("TextButton"); B.Text = ""; B.BackgroundTransparency = 1; B.Size = UDim2.new(1, 0, 0, 42); B.Parent = F; local L = Instance.new("TextLabel"); L.Text = T; L.Font = Enum.Font.GothamBold; L.TextSize = 14; L.TextColor3 = Color3.fromRGB(240, 240, 240); L.Size = UDim2.new(1, -20, 1, 0); L.Position = UDim2.new(0, 15, 0, 0); L.BackgroundTransparency = 1; L.TextXAlignment = Enum.TextXAlignment.Left; L.Parent = B; local S = Instance.new("TextLabel"); S.Text = Def; S.Font = Enum.Font.GothamBold; S.TextSize = 14; S.TextColor3 = ThemeColor; S.Size = UDim2.new(0, 100, 1, 0); S.Position = UDim2.new(1, -115, 0, 0); S.BackgroundTransparency = 1; S.TextXAlignment = Enum.TextXAlignment.Right; S.Parent = B; local Li = Instance.new("ScrollingFrame"); Li.Size = UDim2.new(1, -10, 0, 100); Li.Position = UDim2.new(0, 5, 0, 45); Li.BackgroundTransparency = 1; Li.Parent = F; Li.ScrollBarThickness = 2; Li.ScrollBarImageColor3 = ThemeColor; local LL = Instance.new("UIListLayout"); LL.Padding = UDim.new(0, 5); LL.Parent = Li; local O = false; B.MouseButton1Click:Connect(function() O = not O; if O then for _,v in pairs(Li:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end; for _,v in pairs(Op) do local b=Instance.new("TextButton");b.Text=v;b.Size=UDim2.new(1,0,0,30);b.BackgroundColor3=Color3.fromRGB(40,40,45);b.TextColor3=Color3.fromRGB(200,200,200);b.Font=Enum.Font.GothamMedium;b.TextSize=13;b.Parent=Li;Instance.new("UICorner",b).CornerRadius=UDim.new(0,6);b.MouseButton1Click:Connect(function() S.Text=v;CB(v);O=false;Tween(F, 0.3, {Size=UDim2.new(1,0,0,42)}):Play() end) end; Li.CanvasSize = UDim2.new(0,0,0,LL.AbsoluteContentSize.Y); Tween(F, 0.3, {Size=UDim2.new(1,0,0,150)}):Play() else Tween(F, 0.3, {Size=UDim2.new(1,0,0,42)}):Play() end end) end
        
        function TF:CreateInput(T, Ph, CB) 
            local F = Instance.new("Frame"); F.BackgroundColor3 = Color3.fromRGB(25, 25, 30); F.Size = UDim2.new(1, 0, 0, 42); F.Parent = P; Instance.new("UICorner", F).CornerRadius = UDim.new(0, 8); 
            local L = Instance.new("TextLabel"); L.Text = T; L.Font = Enum.Font.GothamBold; L.TextSize = 14; L.TextColor3 = Color3.fromRGB(240, 240, 240); L.Size = UDim2.new(1, -120, 1, 0); L.Position = UDim2.new(0, 15, 0, 0); L.BackgroundTransparency = 1; L.TextXAlignment = Enum.TextXAlignment.Left; L.Parent = F; 
            local B = Instance.new("TextBox"); B.Text = ""; B.PlaceholderText = Ph; B.Font = Enum.Font.GothamMedium; B.TextSize = 13; B.TextColor3 = Color3.new(1, 1, 1); B.BackgroundColor3 = Color3.fromRGB(40, 40, 45); B.Size = UDim2.new(0, 100, 0, 28); B.Position = UDim2.new(1, -110, 0.5, -14); B.Parent = F; Instance.new("UICorner", B).CornerRadius = UDim.new(0, 6); 
            B.FocusLost:Connect(function(e) if e then CB(B.Text) end end) 
        end
        
        function TF:CreateKeybind(T, K, CB) local CK=K; local F=Instance.new("Frame"); F.BackgroundColor3=Color3.fromRGB(25,25,30); F.Size=UDim2.new(1,0,0,42); F.Parent=P; Instance.new("UICorner",F).CornerRadius=UDim.new(0,8); local L=Instance.new("TextLabel"); L.Text=T; L.Font=Enum.Font.GothamBold; L.TextSize=14; L.TextColor3=Color3.fromRGB(240,240,240); L.Size=UDim2.new(1,-120,1,0); L.Position=UDim2.new(0,15,0,0); L.BackgroundTransparency=1; L.TextXAlignment=Enum.TextXAlignment.Left; L.Parent=F; local B=Instance.new("TextButton"); B.Text="["..CK.Name.."]"; B.Font=Enum.Font.GothamBold; B.TextSize=12; B.TextColor3=Color3.fromRGB(200,200,200); B.BackgroundColor3=Color3.fromRGB(40,40,45); B.Size=UDim2.new(0,100,0,28); B.Position=UDim2.new(1,-110,0.5,-14); B.Parent=F; Instance.new("UICorner",B).CornerRadius=UDim.new(0,6); local Lis=false; B.MouseButton1Click:Connect(function() Lis=true; B.Text="..."; B.TextColor3=ThemeColor end); UserInputService.InputBegan:Connect(function(i,gp) if gp then return end; if Lis and i.UserInputType==Enum.UserInputType.Keyboard then CK=i.KeyCode; B.Text="["..CK.Name.."]"; B.TextColor3=Color3.fromRGB(200,200,200); Lis=false elseif not Lis and i.KeyCode==CK then CB() end end) end
        
        function TF:CreateCode(C) local F=Instance.new("Frame"); F.BackgroundColor3=Color3.fromRGB(25,25,30); F.Size=UDim2.new(1,0,0,60); F.Parent=P; Instance.new("UICorner",F).CornerRadius=UDim.new(0,6); local S=Instance.new("UIStroke"); S.Color=Color3.fromRGB(60,60,60); S.Parent=F; local T=Instance.new("TextBox"); T.Text=C; T.Font=Enum.Font.Code; T.TextSize=13; T.TextColor3=Color3.fromRGB(200,200,200); T.Size=UDim2.new(1,-10,1,-10); T.Position=UDim2.new(0,5,0,5); T.BackgroundTransparency=1; T.TextXAlignment=Enum.TextXAlignment.Left; T.TextYAlignment=Enum.TextYAlignment.Top; T.TextEditable=false; T.ClearTextOnFocus=false; T.TextWrapped=true; T.Parent=F; local B=Instance.new("ImageButton"); B.Image="rbxassetid://6031094678"; B.Size=UDim2.fromOffset(20,20); B.Position=UDim2.new(1,-25,0,5); B.BackgroundTransparency=1; B.ImageColor3=ThemeColor; B.Parent=F; B.MouseButton1Click:Connect(function() if setclipboard then setclipboard(C); WF:Notify({Title="Copied",Content="Code copied!"}) end end) end
        
        function TF:CreateColorPicker(T, D, CB) D=D or Color3.new(1,1,1); local C=Instance.new("Frame"); C.BackgroundColor3=Color3.fromRGB(25,25,30); C.Size=UDim2.new(1,0,0,42); C.ClipsDescendants=true; C.Parent=P; Instance.new("UICorner",C).CornerRadius=UDim.new(0,8); local HB=Instance.new("TextButton"); HB.Text=""; HB.Size=UDim2.new(1,0,0,42); HB.BackgroundTransparency=1; HB.Parent=C; local L=Instance.new("TextLabel"); L.Text=T; L.Font=Enum.Font.GothamBold; L.TextSize=14; L.TextColor3=Color3.fromRGB(240,240,240); L.Size=UDim2.new(1,-60,0,42); L.Position=UDim2.new(0,15,0,0); L.BackgroundTransparency=1; L.TextXAlignment=Enum.TextXAlignment.Left; L.Parent=HB; local Pre=Instance.new("Frame"); Pre.Size=UDim2.fromOffset(25,25); Pre.Position=UDim2.new(1,-40,0.5,-12.5); Pre.BackgroundColor3=D; Pre.Parent=HB; Instance.new("UICorner",Pre).CornerRadius=UDim.new(1,0); local PA=Instance.new("Frame"); PA.Size=UDim2.new(1,-20,0,140); PA.Position=UDim2.new(0,10,0,50); PA.BackgroundTransparency=1; PA.Parent=C; local SVM=Instance.new("ImageButton"); SVM.Size=UDim2.new(0,130,0,130); SVM.Image="rbxassetid://4155801252"; SVM.BackgroundColor3=D; SVM.Parent=PA; Instance.new("UICorner",SVM).CornerRadius=UDim.new(0,6); local SVC=Instance.new("Frame"); SVC.Size=UDim2.fromOffset(10,10); SVC.AnchorPoint=Vector2.new(0.5,0.5); SVC.BackgroundColor3=Color3.new(1,1,1); SVC.Parent=SVM; Instance.new("UICorner",SVC).CornerRadius=UDim.new(1,0); local HBar=Instance.new("ImageButton"); HBar.Size=UDim2.new(0,20,0,130); HBar.Position=UDim2.new(0,140,0,0); HBar.Image="rbxassetid://3641079629"; HBar.Parent=PA; Instance.new("UICorner",HBar).CornerRadius=UDim.new(0,6); local HC=Instance.new("Frame"); HC.Size=UDim2.new(1,0,0,4); HC.BackgroundColor3=Color3.new(1,1,1); HC.BorderSizePixel=0; HC.Parent=HBar; local H,S,V=Color3.toHSV(D); local O=false; local function Upd() local NC=Color3.fromHSV(H,S,V); SVM.BackgroundColor3=Color3.fromHSV(H,1,1); Pre.BackgroundColor3=NC; CB(NC) end; local DH,DSV=false,false; HBar.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then DH=true end end); SVM.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then DSV=true end end); UserInputService.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then DH=false; DSV=false end end); RunService.RenderStepped:Connect(function() if not O then return end; if DH then local Y=math.clamp((Mouse.Y-HBar.AbsolutePosition.Y)/HBar.AbsoluteSize.Y,0,1); HC.Position=UDim2.new(0,0,Y,0); H=1-Y; Upd() end; if DSV then local X=math.clamp((Mouse.X-SVM.AbsolutePosition.X)/SVM.AbsoluteSize.X,0,1); local Y=math.clamp((Mouse.Y-SVM.AbsolutePosition.Y)/SVM.AbsoluteSize.Y,0,1); SVC.Position=UDim2.new(X,0,Y,0); S=X; V=1-Y; Upd() end end); HB.MouseButton1Click:Connect(function() O=not O; if O then Tween(C, 0.3, {Size=UDim2.new(1,0,0,200)}):Play() else Tween(C, 0.3, {Size=UDim2.new(1,0,0,42)}):Play() end end) end

        return TF
    end
    return WF
end

