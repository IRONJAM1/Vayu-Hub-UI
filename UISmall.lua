local VayuLib = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Configuration
local Config = {
    Colors = {
        Main = Color3.fromRGB(18, 18, 18),
        Header = Color3.fromRGB(25, 25, 25),
        Section = Color3.fromRGB(32, 32, 32),
        Text = Color3.fromRGB(240, 240, 240),
        SubText = Color3.fromRGB(150, 150, 150),
        Accent = Color3.fromRGB(0, 230, 160), -- สีเขียว
        Red = Color3.fromRGB(255, 60, 60),
        ToggleOff = Color3.fromRGB(60, 60, 60)
    },
    Duration = 0.4,
    EasingStyle = Enum.EasingStyle.Quint,
    EasingDirection = Enum.EasingDirection.Out
}

local function CreateTween(obj, props, duration)
    local info = TweenInfo.new(duration or Config.Duration, Config.EasingStyle, Config.EasingDirection)
    local tween = TweenService:Create(obj, info, props)
    tween:Play()
    return tween
end

function VayuLib:CreateWindow(Settings)
    local WindowName = Settings.Name or "VAYU HUB"
    local LogoId = Settings.Logo or "rbxassetid://7072724"

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "VayuLib_Final"
    ScreenGui.Parent = game.CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- 1. Main Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 380, 0, 60)
    MainFrame.Position = UDim2.new(0.5, -190, 0.4, 0)
    MainFrame.BackgroundColor3 = Config.Colors.Main
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui
    
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 12)
    MainCorner.Parent = MainFrame
    
    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = Config.Colors.Accent
    MainStroke.Thickness = 1.5
    MainStroke.Transparency = 0.6
    MainStroke.Parent = MainFrame

    local Drag = Instance.new("UIDragDetector")
    Drag.Parent = MainFrame

    -- 2. Header
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Size = UDim2.new(1, 0, 0, 60)
    Header.BackgroundColor3 = Config.Colors.Header
    Header.ZIndex = 10
    Header.Parent = MainFrame
    Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 12)

    local Logo = Instance.new("ImageLabel")
    Logo.Position = UDim2.new(0, 12, 0, 10)
    Logo.Size = UDim2.new(0, 40, 0, 40)
    Logo.Image = LogoId
    Logo.BackgroundTransparency = 1
    Logo.Parent = Header

    local TitleLbl = Instance.new("TextLabel")
    TitleLbl.Position = UDim2.new(0, 65, 0, 0)
    TitleLbl.Size = UDim2.new(0, 200, 1, 0)
    TitleLbl.Text = WindowName
    TitleLbl.Font = Enum.Font.GothamBold
    TitleLbl.TextSize = 18
    TitleLbl.TextColor3 = Config.Colors.Text
    TitleLbl.TextXAlignment = Enum.TextXAlignment.Left
    TitleLbl.BackgroundTransparency = 1
    TitleLbl.Parent = Header

    local ToggleBtn = Instance.new("ImageButton")
    ToggleBtn.Position = UDim2.new(1, -50, 0.5, -15)
    ToggleBtn.Size = UDim2.new(0, 30, 0, 30)
    ToggleBtn.BackgroundColor3 = Config.Colors.Red
    ToggleBtn.Image = "rbxassetid://6031094678"
    ToggleBtn.Parent = Header
    Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)

    -- 3. Content Area
    local ContentFrame = Instance.new("Frame")
    ContentFrame.Name = "Content"
    ContentFrame.Size = UDim2.new(1, -20, 1, -80)
    ContentFrame.Position = UDim2.new(0, 10, 0, 70)
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.Visible = false
    ContentFrame.Parent = MainFrame

    -- Tab Trigger
    local TabTrigger = Instance.new("TextButton")
    TabTrigger.Name = "TabTrigger"
    TabTrigger.Size = UDim2.new(1, 0, 0, 40)
    TabTrigger.BackgroundColor3 = Config.Colors.Section
    TabTrigger.Text = "Select Tab..."
    TabTrigger.TextColor3 = Config.Colors.Accent
    TabTrigger.Font = Enum.Font.GothamBold
    TabTrigger.TextSize = 14
    TabTrigger.ZIndex = 20
    TabTrigger.Parent = ContentFrame
    Instance.new("UICorner", TabTrigger).CornerRadius = UDim.new(0, 8)
    
    local TabArrow = Instance.new("ImageLabel")
    TabArrow.Image = "rbxassetid://6031091304"
    TabArrow.Size = UDim2.new(0, 20, 0, 20)
    TabArrow.Position = UDim2.new(1, -30, 0.5, -10)
    TabArrow.ImageColor3 = Config.Colors.Accent
    TabArrow.BackgroundTransparency = 1
    TabArrow.ZIndex = 21
    TabArrow.Parent = TabTrigger

    -- Tab List (Dropdown)
    local TabListFrame = Instance.new("Frame")
    TabListFrame.Name = "TabList"
    TabListFrame.Size = UDim2.new(1, 0, 0, 0)
    TabListFrame.Position = UDim2.new(0, 0, 0, 45)
    TabListFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    TabListFrame.BorderSizePixel = 0
    TabListFrame.ClipsDescendants = true
    TabListFrame.ZIndex = 50
    TabListFrame.Parent = ContentFrame
    Instance.new("UICorner", TabListFrame).CornerRadius = UDim.new(0, 8)
    
    local TabListLayout = Instance.new("UIListLayout")
    TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabListLayout.Parent = TabListFrame

    -- Pages Container
    local PagesContainer = Instance.new("Frame")
    PagesContainer.Size = UDim2.new(1, 0, 1, -50)
    PagesContainer.Position = UDim2.new(0, 0, 0, 50)
    PagesContainer.BackgroundTransparency = 1
    PagesContainer.ZIndex = 5
    PagesContainer.Parent = ContentFrame

    -- Logic: Tab Dropdown
    local IsDropdownOpen = false
    TabTrigger.MouseButton1Click:Connect(function()
        IsDropdownOpen = not IsDropdownOpen
        local targetSize = IsDropdownOpen and UDim2.new(1, 0, 0, TabListLayout.AbsoluteContentSize.Y) or UDim2.new(1, 0, 0, 0)
        CreateTween(TabListFrame, {Size = targetSize})
        CreateTween(TabArrow, {Rotation = IsDropdownOpen and 180 or 0})
    end)

    -- Logic: Expand/Collapse
    local IsExpanded = false
    local WindowHeight = 450

    ToggleBtn.MouseButton1Click:Connect(function()
        IsExpanded = not IsExpanded
        if IsExpanded then
            ContentFrame.Visible = true
            CreateTween(MainFrame, {Size = UDim2.new(0, 380, 0, WindowHeight)})
            CreateTween(ToggleBtn, {BackgroundColor3 = Config.Colors.Accent, Rotation = 180})
        else
            IsDropdownOpen = false
            CreateTween(TabListFrame, {Size = UDim2.new(1, 0, 0, 0)})
            CreateTween(TabArrow, {Rotation = 0})
            
            local t = CreateTween(MainFrame, {Size = UDim2.new(0, 380, 0, 60)})
            CreateTween(ToggleBtn, {BackgroundColor3 = Config.Colors.Red, Rotation = 0})
            t.Completed:Connect(function()
                if not IsExpanded then ContentFrame.Visible = false end
            end)
        end
    end)

    local Tabs = {}
    local FirstTab = nil

    local function SwitchTab(tabName)
        TabTrigger.Text = tabName
        for name, page in pairs(Tabs) do
            page.Visible = (name == tabName)
        end
        IsDropdownOpen = false
        CreateTween(TabListFrame, {Size = UDim2.new(1, 0, 0, 0)})
        CreateTween(TabArrow, {Rotation = 0})
    end

    local WindowFuncs = {}

    function WindowFuncs:CreateTab(Name)
        local Page = Instance.new("ScrollingFrame")
        Page.Name = Name
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.ScrollBarThickness = 2
        Page.ScrollBarImageColor3 = Config.Colors.Accent
        Page.Visible = false
        Page.Parent = PagesContainer
        
        local PageLayout = Instance.new("UIListLayout")
        PageLayout.Padding = UDim.new(0, 8)
        PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        PageLayout.Parent = Page
        
        PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Page.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 20)
        end)
        
        local TabBtn = Instance.new("TextButton")
        TabBtn.Size = UDim2.new(1, 0, 0, 35)
        TabBtn.BackgroundColor3 = Config.Colors.Header
        TabBtn.Text = Name
        TabBtn.TextColor3 = Config.Colors.Text
        TabBtn.Font = Enum.Font.Gotham
        TabBtn.TextSize = 14
        TabBtn.ZIndex = 51
        TabBtn.Parent = TabListFrame
        
        TabBtn.MouseButton1Click:Connect(function()
            SwitchTab(Name)
        end)

        Tabs[Name] = Page
        if FirstTab == nil then
            FirstTab = Name
            SwitchTab(Name)
        end

        local TabFuncs = {}

        function TabFuncs:CreateSection(Text)
            local Sec = Instance.new("TextLabel")
            Sec.Text = string.upper(Text)
            Sec.Size = UDim2.new(1, -10, 0, 25)
            Sec.BackgroundTransparency = 1
            Sec.TextColor3 = Config.Colors.Accent
            Sec.Font = Enum.Font.GothamBold
            Sec.TextSize = 12
            Sec.TextXAlignment = Enum.TextXAlignment.Left
            Sec.Parent = Page
            Instance.new("UIPadding", Sec).PaddingLeft = UDim.new(0, 5)
        end

        function TabFuncs:CreateButton(Text, Callback)
            Callback = Callback or function() end
            local Btn = Instance.new("TextButton")
            Btn.Size = UDim2.new(1, -12, 0, 40)
            Btn.BackgroundColor3 = Config.Colors.Section
            Btn.Text = Text
            Btn.TextColor3 = Config.Colors.Text
            Btn.Font = Enum.Font.GothamSemibold
            Btn.TextSize = 14
            Btn.Parent = Page
            Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
            
            Btn.MouseButton1Click:Connect(function()
                CreateTween(Btn, {TextColor3 = Config.Colors.Accent}, 0.1).Completed:Wait()
                CreateTween(Btn, {TextColor3 = Config.Colors.Text}, 0.2)
                Callback()
            end)
        end

        function TabFuncs:CreateToggle(Text, Default, Callback)
            if type(Default) == "function" then
                Callback = Default
                Default = false
            end
            
            Default = Default or false
            Callback = Callback or function() end
            local Toggled = Default

            local TogContainer = Instance.new("Frame")
            TogContainer.Size = UDim2.new(1, -12, 0, 42)
            TogContainer.BackgroundColor3 = Config.Colors.Section
            TogContainer.Parent = Page
            Instance.new("UICorner", TogContainer).CornerRadius = UDim.new(0, 6)

            local TogTitle = Instance.new("TextLabel")
            TogTitle.Text = Text
            TogTitle.Size = UDim2.new(0.6, 0, 1, 0)
            TogTitle.Position = UDim2.new(0, 10, 0, 0)
            TogTitle.BackgroundTransparency = 1
            TogTitle.TextColor3 = Config.Colors.Text
            TogTitle.Font = Enum.Font.Gotham
            TogTitle.TextXAlignment = Enum.TextXAlignment.Left
            TogTitle.TextSize = 14
            TogTitle.Parent = TogContainer

            local SwitchBg = Instance.new("Frame")
            SwitchBg.Size = UDim2.new(0, 50, 0, 24)
            SwitchBg.Position = UDim2.new(1, -60, 0.5, -12)
            SwitchBg.BackgroundColor3 = Toggled and Config.Colors.Accent or Config.Colors.Red
            SwitchBg.Parent = TogContainer
            Instance.new("UICorner", SwitchBg).CornerRadius = UDim.new(1, 0)

            local SwitchKnob = Instance.new("Frame")
            SwitchKnob.Size = UDim2.new(0, 20, 0, 20)
            SwitchKnob.Position = Toggled and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
            SwitchKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            SwitchKnob.Parent = SwitchBg
            Instance.new("UICorner", SwitchKnob).CornerRadius = UDim.new(1, 0)

            local Trigger = Instance.new("TextButton")
            Trigger.Size = UDim2.new(1, 0, 1, 0)
            Trigger.BackgroundTransparency = 1
            Trigger.Text = ""
            Trigger.Parent = TogContainer

            Trigger.MouseButton1Click:Connect(function()
                Toggled = not Toggled
                local targetColor = Toggled and Config.Colors.Accent or Config.Colors.Red
                CreateTween(SwitchBg, {BackgroundColor3 = targetColor})
                local targetPos = Toggled and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
                CreateTween(SwitchKnob, {Position = targetPos})
                Callback(Toggled)
            end)
            
            if Default then Callback(true) end
        end

        function TabFuncs:CreateSlider(Text, Min, Max, Default, Callback)
            Default = Default or Min
            Callback = Callback or function() end
            local Value = math.clamp(Default, Min, Max)

            local SliderFrame = Instance.new("Frame")
            SliderFrame.Size = UDim2.new(1, -12, 0, 60)
            SliderFrame.BackgroundColor3 = Config.Colors.Section
            SliderFrame.Parent = Page
            Instance.new("UICorner", SliderFrame).CornerRadius = UDim.new(0, 6)

            local Title = Instance.new("TextLabel")
            Title.Text = Text
            Title.Position = UDim2.new(0, 10, 0, 5)
            Title.Size = UDim2.new(0.5, 0, 0, 20)
            Title.BackgroundTransparency = 1
            Title.TextColor3 = Config.Colors.Text
            Title.Font = Enum.Font.Gotham
            Title.TextSize = 14
            Title.TextXAlignment = Enum.TextXAlignment.Left
            Title.Parent = SliderFrame

            local ValueLabel = Instance.new("TextLabel")
            ValueLabel.Text = tostring(Value)
            ValueLabel.Position = UDim2.new(1, -60, 0, 5)
            ValueLabel.Size = UDim2.new(0, 50, 0, 20)
            ValueLabel.BackgroundTransparency = 1
            ValueLabel.TextColor3 = Config.Colors.Accent
            ValueLabel.Font = Enum.Font.GothamBold
            ValueLabel.TextSize = 14
            ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
            ValueLabel.Parent = SliderFrame

            local SliderBar = Instance.new("Frame")
            SliderBar.Size = UDim2.new(1, -20, 0, 6)
            SliderBar.Position = UDim2.new(0, 10, 0, 35)
            SliderBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            SliderBar.Parent = SliderFrame
            Instance.new("UICorner", SliderBar).CornerRadius = UDim.new(1, 0)

            local Fill = Instance.new("Frame")
            Fill.Size = UDim2.new((Value - Min) / (Max - Min), 0, 1, 0)
            Fill.BackgroundColor3 = Config.Colors.Accent
            Fill.Parent = SliderBar
            Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)

            local Trigger = Instance.new("TextButton")
            Trigger.Size = UDim2.new(1, 0, 1, 0)
            Trigger.BackgroundTransparency = 1
            Trigger.Text = ""
            Trigger.Parent = SliderBar

            local isDragging = false
            local function UpdateSlider(input)
                local pos = UDim2.new(math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1), 0, 1, 0)
                CreateTween(Fill, {Size = pos}, 0.05)
                local NewValue = math.floor(Min + ((Max - Min) * pos.X.Scale))
                ValueLabel.Text = tostring(NewValue)
                Callback(NewValue)
            end

            Trigger.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    isDragging = true
                    UpdateSlider(input)
                end
            end)

            Trigger.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    isDragging = false
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    UpdateSlider(input)
                end
            end)
        end
        
        -- [[ FIX DROPDOWN ]] --
        function TabFuncs:CreateDropdown(Text, Items, Callback)
            Callback = Callback or function() end
            local Selected = Items[1] or "None"
            local DropOpen = false

            -- กล่องหลัก (DropFrame)
            local DropFrame = Instance.new("Frame")
            DropFrame.Size = UDim2.new(1, -12, 0, 45) -- เริ่มต้นขนาด 45
            DropFrame.BackgroundColor3 = Config.Colors.Section
            DropFrame.ClipsDescendants = true
            DropFrame.Parent = Page
            Instance.new("UICorner", DropFrame).CornerRadius = UDim.new(0, 6)

            -- 1. Header Frame (สำหรับชื่อและลูกศร) - แยกออกมาไม่ให้โดน UIListLayout กวน
            local Header = Instance.new("Frame")
            Header.Name = "Header"
            Header.Size = UDim2.new(1, 0, 0, 45)
            Header.BackgroundTransparency = 1
            Header.Parent = DropFrame

            local Title = Instance.new("TextLabel")
            Title.Text = Text .. ": " .. Selected
            Title.Size = UDim2.new(1, -40, 1, 0)
            Title.Position = UDim2.new(0, 10, 0, 0)
            Title.BackgroundTransparency = 1
            Title.TextColor3 = Config.Colors.Text
            Title.Font = Enum.Font.Gotham
            Title.TextSize = 14
            Title.TextXAlignment = Enum.TextXAlignment.Left
            Title.Parent = Header
            
            local Arrow = Instance.new("TextLabel")
            Arrow.Text = "▼"
            Arrow.Size = UDim2.new(0, 30, 1, 0)
            Arrow.Position = UDim2.new(1, -30, 0, 0)
            Arrow.BackgroundTransparency = 1
            Arrow.TextColor3 = Config.Colors.Accent
            Arrow.Font = Enum.Font.Gotham
            Arrow.Parent = Header

            local OpenBtn = Instance.new("TextButton")
            OpenBtn.Size = UDim2.new(1, 0, 1, 0)
            OpenBtn.BackgroundTransparency = 1
            OpenBtn.Text = ""
            OpenBtn.Parent = Header

            -- 2. Item Container (สำหรับปุ่มตัวเลือก)
            local ItemContainer = Instance.new("Frame")
            ItemContainer.Name = "Items"
            ItemContainer.Size = UDim2.new(1, 0, 0, 0) -- Auto Size
            ItemContainer.Position = UDim2.new(0, 0, 0, 45) -- อยู่ใต้ Header
            ItemContainer.BackgroundTransparency = 1
            ItemContainer.Parent = DropFrame

            local ItemListLayout = Instance.new("UIListLayout")
            ItemListLayout.Padding = UDim.new(0, 5)
            ItemListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
            ItemListLayout.Parent = ItemContainer
            
            local ItemPadding = Instance.new("UIPadding")
            ItemPadding.PaddingTop = UDim.new(0, 5)
            ItemPadding.PaddingBottom = UDim.new(0, 5)
            ItemPadding.Parent = ItemContainer

            -- สร้างปุ่มตัวเลือก
            for _, item in pairs(Items) do
                local ItemBtn = Instance.new("TextButton")
                ItemBtn.Size = UDim2.new(0.95, 0, 0, 30)
                ItemBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                ItemBtn.Text = item
                ItemBtn.TextColor3 = Config.Colors.Text
                ItemBtn.Font = Enum.Font.Gotham
                ItemBtn.Parent = ItemContainer
                Instance.new("UICorner", ItemBtn).CornerRadius = UDim.new(0, 4)

                ItemBtn.MouseButton1Click:Connect(function()
                    Selected = item
                    Title.Text = Text .. ": " .. Selected
                    Callback(item)
                    
                    -- ปิด Dropdown
                    DropOpen = false
                    CreateTween(DropFrame, {Size = UDim2.new(1, -12, 0, 45)})
                    CreateTween(Arrow, {Rotation = 0})
                end)
            end

            OpenBtn.MouseButton1Click:Connect(function()
                DropOpen = not DropOpen
                -- คำนวณความสูง: Header (45) + ความสูงของรายการทั้งหมด
                local contentHeight = 45 + ItemListLayout.AbsoluteContentSize.Y + 10
                local targetSize = DropOpen and UDim2.new(1, -12, 0, contentHeight) or UDim2.new(1, -12, 0, 45)
                
                CreateTween(DropFrame, {Size = targetSize})
                CreateTween(Arrow, {Rotation = DropOpen and 180 or 0})
            end)
        end

        return TabFuncs
    end

    return WindowFuncs
end
return VayuLib
