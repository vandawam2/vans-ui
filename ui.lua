--[[ 
    SIMPLE UI LIBRARY (FINAL ULTIMATE)
    1. Auto-Deletes Old instances
    2. Dark Golden Theme (No Borders)
    3. Safe Close System (Center & Confirm)
]]

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

-- [1] UTILITIES & SAFE GUI
local function GetSafeGui()
    local success, result = pcall(function()
        return (gethui and gethui()) or (game:GetService("CoreGui"))
    end)
    if not success then return Players.LocalPlayer:WaitForChild("PlayerGui") end
    return result
end

-- HAPUS GUI LAMA OTOMATIS
for _, v in pairs(GetSafeGui():GetChildren()) do
    if v.Name:sub(1, 8) == "GoldLib_" then
        v:Destroy()
    end
end

local function MakeDraggable(topbarobject, object)
    local Dragging = nil
    local DragInput = nil
    local DragStart = nil
    local StartPosition = nil

    local function Update(input)
        local Delta = input.Position - DragStart
        local pos = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y)
        object.Position = pos
    end

    topbarobject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            DragStart = input.Position
            StartPosition = object.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    Dragging = false
                end
            end)
        end
    end)

    topbarobject.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            DragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == DragInput and Dragging then
            Update(input)
        end
    end)
end

-- [2] LIBRARY MAIN
local Library = {}

function Library:CreateWindow(Config)
    local Title = Config.Title or "Golden Luxury Hub"
    local LogoText = Config.Logo or "G"
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "GoldLib_" .. math.random(1,1000)
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = GetSafeGui()

    -- [A] MINIMIZER FRAME (Kotak Kecil)
    local MiniFrame = Instance.new("TextButton")
    MiniFrame.Name = "MiniFrame"
    MiniFrame.Size = UDim2.new(0, 50, 0, 50)
    MiniFrame.Position = UDim2.new(0.1, 0, 0.1, 0)
    MiniFrame.BackgroundColor3 = Color3.fromRGB(180, 130, 20)
    MiniFrame.Text = LogoText
    MiniFrame.TextColor3 = Color3.fromRGB(40, 25, 10)
    MiniFrame.Font = Enum.Font.GothamBold
    MiniFrame.TextSize = 24
    MiniFrame.Visible = false
    MiniFrame.BorderSizePixel = 0
    MiniFrame.Parent = ScreenGui
    
    local MiniCorner = Instance.new("UICorner")
    MiniCorner.CornerRadius = UDim.new(0, 12)
    MiniCorner.Parent = MiniFrame
    
    local MiniStroke = Instance.new("UIStroke")
    MiniStroke.Color = Color3.fromRGB(255, 230, 150)
    MiniStroke.Thickness = 2
    MiniStroke.Parent = MiniFrame

    MakeDraggable(MiniFrame, MiniFrame)

    -- [B] MAIN FRAME
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 450, 0, 300)
    MainFrame.Position = UDim2.new(0.5, -225, 0.5, -150)
    MainFrame.BackgroundColor3 = Color3.fromRGB(180, 130, 20) 
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui

    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = Color3.fromRGB(255, 215, 0)
    MainStroke.Thickness = 2
    MainStroke.Parent = MainFrame

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = MainFrame
    
    -- LOGIC RESTORE
    MiniFrame.MouseButton1Click:Connect(function()
        MainFrame.Visible = true
        MiniFrame.Visible = false
        MainFrame.Size = UDim2.new(0, 0, 0, 0)
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back), {Size = UDim2.new(0, 450, 0, 300)}):Play()
    end)

    -- [C] TOPBAR
    local Topbar = Instance.new("Frame")
    Topbar.Size = UDim2.new(1, 0, 0, 40)
    Topbar.BackgroundColor3 = Color3.fromRGB(50, 35, 10)
    Topbar.BorderSizePixel = 0
    Topbar.Parent = MainFrame
    
    local TopbarCorner = Instance.new("UICorner")
    TopbarCorner.CornerRadius = UDim.new(0, 8)
    TopbarCorner.Parent = Topbar
    
    local HideBar = Instance.new("Frame")
    HideBar.Size = UDim2.new(1, 0, 0, 10)
    HideBar.Position = UDim2.new(0, 0, 1, -10)
    HideBar.BorderSizePixel = 0
    HideBar.BackgroundColor3 = Color3.fromRGB(50, 35, 10) 
    HideBar.Parent = Topbar

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -100, 1, 0)
    TitleLabel.Position = UDim2.new(0, 15, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = Title
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextColor3 = Color3.fromRGB(255, 245, 220) 
    TitleLabel.TextSize = 18
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = Topbar
    
    MakeDraggable(Topbar, MainFrame)

    -- [D] CONFIRMATION POPUP (Overlay)
    local ConfirmCanvas = Instance.new("Frame")
    ConfirmCanvas.Name = "ConfirmOverlay"
    ConfirmCanvas.Size = UDim2.new(1, 0, 1, 0)
    ConfirmCanvas.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    ConfirmCanvas.BackgroundTransparency = 0.4
    ConfirmCanvas.ZIndex = 20 -- Paling atas
    ConfirmCanvas.Visible = false
    ConfirmCanvas.Parent = MainFrame
    
    local ConfirmCanvasCorner = Instance.new("UICorner")
    ConfirmCanvasCorner.CornerRadius = UDim.new(0, 8)
    ConfirmCanvasCorner.Parent = ConfirmCanvas

    local ConfirmBox = Instance.new("Frame")
    ConfirmBox.Size = UDim2.new(0, 220, 0, 110)
    ConfirmBox.Position = UDim2.new(0.5, -110, 0.5, -55)
    ConfirmBox.BackgroundColor3 = Color3.fromRGB(45, 30, 10) -- Dark Theme
    ConfirmBox.ZIndex = 21
    ConfirmBox.Parent = ConfirmCanvas

    local ConfirmStroke = Instance.new("UIStroke")
    ConfirmStroke.Color = Color3.fromRGB(255, 215, 0)
    ConfirmStroke.Thickness = 2
    ConfirmStroke.Parent = ConfirmBox

    local ConfirmCorner = Instance.new("UICorner")
    ConfirmCorner.CornerRadius = UDim.new(0, 8)
    ConfirmCorner.Parent = ConfirmBox

    local ConfirmText = Instance.new("TextLabel")
    ConfirmText.Size = UDim2.new(1, 0, 0, 40)
    ConfirmText.BackgroundTransparency = 1
    ConfirmText.Text = "Exit Hub?"
    ConfirmText.TextColor3 = Color3.fromRGB(255, 230, 150)
    ConfirmText.Font = Enum.Font.GothamBold
    ConfirmText.TextSize = 18
    ConfirmText.ZIndex = 22
    ConfirmText.Parent = ConfirmBox

    -- YES Button
    local YesBtn = Instance.new("TextButton")
    YesBtn.Size = UDim2.new(0, 80, 0, 30)
    YesBtn.Position = UDim2.new(0, 20, 0, 60)
    YesBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50) -- Merah
    YesBtn.Text = "Yes"
    YesBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    YesBtn.Font = Enum.Font.GothamBold
    YesBtn.TextSize = 14
    YesBtn.ZIndex = 22
    YesBtn.Parent = ConfirmBox
    local YesCorner = Instance.new("UICorner")
    YesCorner.CornerRadius = UDim.new(0, 6)
    YesCorner.Parent = YesBtn
    
    YesBtn.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)

    -- NO Button
    local NoBtn = Instance.new("TextButton")
    NoBtn.Size = UDim2.new(0, 80, 0, 30)
    NoBtn.Position = UDim2.new(1, -100, 0, 60)
    NoBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70) -- Abu
    NoBtn.Text = "No"
    NoBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    NoBtn.Font = Enum.Font.GothamBold
    NoBtn.TextSize = 14
    NoBtn.ZIndex = 22
    NoBtn.Parent = ConfirmBox
    local NoCorner = Instance.new("UICorner")
    NoCorner.CornerRadius = UDim.new(0, 6)
    NoCorner.Parent = NoBtn

    NoBtn.MouseButton1Click:Connect(function()
        ConfirmCanvas.Visible = false
    end)


    -- [E] CONTROL BUTTONS (Topbar)
    local ButtonContainer = Instance.new("Frame")
    ButtonContainer.Size = UDim2.new(0, 80, 1, 0)
    ButtonContainer.Position = UDim2.new(1, -85, 0, 0)
    ButtonContainer.BackgroundTransparency = 1
    ButtonContainer.Parent = Topbar

    local Layout = Instance.new("UIListLayout")
    Layout.FillDirection = Enum.FillDirection.Horizontal
    Layout.SortOrder = Enum.SortOrder.LayoutOrder
    Layout.Padding = UDim.new(0, 5)
    Layout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    Layout.VerticalAlignment = Enum.VerticalAlignment.Center
    Layout.Parent = ButtonContainer

    -- 1. Close Button (X)
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Name = "Close"
    CloseBtn.Size = UDim2.new(0, 30, 0, 30)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50) -- Merah Gelap
    CloseBtn.Text = "X"
    CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextSize = 14
    CloseBtn.LayoutOrder = 2
    CloseBtn.Parent = ButtonContainer
    
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 6)
    CloseCorner.Parent = CloseBtn

    -- LOGIC CLOSE (Center & Confirm)
    CloseBtn.MouseButton1Click:Connect(function()
        -- Pindahkan UI ke tengah layar dengan smooth
        TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Position = UDim2.new(0.5, -225, 0.5, -150)
        }):Play()
        
        -- Munculkan konfirmasi
        ConfirmCanvas.Visible = true
    end)

    -- 2. Minimize Button (-)
    local MinBtn = Instance.new("TextButton")
    MinBtn.Name = "Minimize"
    MinBtn.Size = UDim2.new(0, 30, 0, 30)
    MinBtn.BackgroundColor3 = Color3.fromRGB(180, 130, 20) -- Emas
    MinBtn.Text = "-"
    MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    MinBtn.Font = Enum.Font.GothamBold
    MinBtn.TextSize = 18
    MinBtn.LayoutOrder = 1
    MinBtn.Parent = ButtonContainer

    local MinCorner = Instance.new("UICorner")
    MinCorner.CornerRadius = UDim.new(0, 6)
    MinCorner.Parent = MinBtn

    MinBtn.MouseButton1Click:Connect(function()
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back), {Size = UDim2.new(0, 0, 0, 0)}):Play()
        task.wait(0.3)
        MainFrame.Visible = false
        MiniFrame.Visible = true
    end)

    -- [F] TABS & PAGES
    local TabContainer = Instance.new("Frame")
    TabContainer.Size = UDim2.new(0, 130, 1, -40)
    TabContainer.Position = UDim2.new(0, 0, 0, 40)
    TabContainer.BackgroundColor3 = Color3.fromRGB(40, 25, 5) 
    TabContainer.BorderSizePixel = 0
    TabContainer.Parent = MainFrame
    
    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 8)
    TabCorner.Parent = TabContainer

    local TabListLayout = Instance.new("UIListLayout")
    TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabListLayout.Padding = UDim.new(0, 8)
    TabListLayout.Parent = TabContainer
    
    local TabPadding = Instance.new("UIPadding")
    TabPadding.PaddingTop = UDim.new(0, 15)
    TabPadding.PaddingLeft = UDim.new(0, 10)
    TabPadding.Parent = TabContainer

    local PageContainer = Instance.new("Frame")
    PageContainer.Size = UDim2.new(1, -145, 1, -55)
    PageContainer.Position = UDim2.new(0, 135, 0, 45)
    PageContainer.BackgroundTransparency = 1
    PageContainer.Parent = MainFrame

    local WindowFunctions = {}
    local FirstTab = true

    function WindowFunctions:Tab(Name)
        local TabBtn = Instance.new("TextButton")
        TabBtn.Size = UDim2.new(1, -15, 0, 32)
        TabBtn.BackgroundColor3 = Color3.fromRGB(60, 45, 15)
        TabBtn.BackgroundTransparency = 0.5
        TabBtn.Text = Name
        TabBtn.TextColor3 = Color3.fromRGB(150, 130, 100)
        TabBtn.Font = Enum.Font.GothamSemibold
        TabBtn.TextSize = 14
        TabBtn.Parent = TabContainer
        
        local TabBtnCorner = Instance.new("UICorner")
        TabBtnCorner.CornerRadius = UDim.new(0, 6)
        TabBtnCorner.Parent = TabBtn

        local Page = Instance.new("ScrollingFrame")
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.ScrollBarThickness = 4
        Page.ScrollBarImageColor3 = Color3.fromRGB(255, 215, 0) 
        Page.Visible = false
        Page.Parent = PageContainer
        
        local PageLayout = Instance.new("UIListLayout")
        PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        PageLayout.Padding = UDim.new(0, 8)
        PageLayout.Parent = Page
        
        local PagePadding = Instance.new("UIPadding")
        PagePadding.PaddingTop = UDim.new(0, 5)
        PagePadding.PaddingLeft = UDim.new(0, 5)
        PagePadding.PaddingRight = UDim.new(0, 5)
        PagePadding.Parent = Page

        if FirstTab then
            Page.Visible = true
            TabBtn.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
            TabBtn.TextColor3 = Color3.fromRGB(40, 30, 15)
            TabBtn.BackgroundTransparency = 0
            FirstTab = false
        end

        TabBtn.MouseButton1Click:Connect(function()
            for _, child in pairs(PageContainer:GetChildren()) do
                if child:IsA("ScrollingFrame") then child.Visible = false end
            end
            for _, child in pairs(TabContainer:GetChildren()) do
                if child:IsA("TextButton") then 
                    TweenService:Create(child, TweenInfo.new(0.2), {
                        BackgroundColor3 = Color3.fromRGB(60, 45, 15), 
                        BackgroundTransparency = 0.5,
                        TextColor3 = Color3.fromRGB(150, 130, 100)
                    }):Play()
                end
            end
            
            Page.Visible = true
            TweenService:Create(TabBtn, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(255, 215, 0),
                BackgroundTransparency = 0,
                TextColor3 = Color3.fromRGB(40, 30, 15)
            }):Play()
        end)

        local TabFunctions = {}

        -- BUTTON (DARK)
        function TabFunctions:Button(Text, Callback)
            local Btn = Instance.new("TextButton")
            Btn.Size = UDim2.new(1, 0, 0, 38)
            Btn.BackgroundColor3 = Color3.fromRGB(45, 30, 10) 
            Btn.Text = Text
            Btn.TextColor3 = Color3.fromRGB(255, 230, 150)
            Btn.Font = Enum.Font.GothamBold
            Btn.TextSize = 14
            Btn.BorderSizePixel = 0 
            Btn.Parent = Page
            local BtnCorner = Instance.new("UICorner")
            BtnCorner.CornerRadius = UDim.new(0, 6)
            BtnCorner.Parent = Btn
            
            Btn.MouseButton1Click:Connect(function()
                TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(65, 50, 30)}):Play()
                task.wait(0.1)
                TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(45, 30, 10)}):Play()
                if Callback then task.spawn(Callback) end
            end)
        end

        -- TOGGLE (DARK)
        function TabFunctions:Toggle(Text, Default, Callback)
            local Enabled = Default or false
            local ToggleFrame = Instance.new("TextButton")
            ToggleFrame.Size = UDim2.new(1, 0, 0, 38)
            ToggleFrame.BackgroundColor3 = Color3.fromRGB(45, 30, 10) 
            ToggleFrame.Text = ""
            ToggleFrame.BorderSizePixel = 0
            ToggleFrame.Parent = Page
            local ToggleCorner = Instance.new("UICorner")
            ToggleCorner.CornerRadius = UDim.new(0, 6)
            ToggleCorner.Parent = ToggleFrame
            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -50, 1, 0)
            Label.Position = UDim2.new(0, 10, 0, 0)
            Label.BackgroundTransparency = 1
            Label.Text = Text
            Label.TextColor3 = Color3.fromRGB(255, 230, 150)
            Label.Font = Enum.Font.GothamSemibold
            Label.TextSize = 14
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = ToggleFrame
            local StatusBox = Instance.new("Frame")
            StatusBox.Size = UDim2.new(0, 24, 0, 24)
            StatusBox.Position = UDim2.new(1, -34, 0.5, -12)
            StatusBox.BackgroundColor3 = Enabled and Color3.fromRGB(255, 215, 0) or Color3.fromRGB(30, 20, 5)
            StatusBox.Parent = ToggleFrame
            local StatusCorner = Instance.new("UICorner")
            StatusCorner.CornerRadius = UDim.new(0, 4)
            StatusCorner.Parent = StatusBox
            local StatusStroke = Instance.new("UIStroke")
            StatusStroke.Color = Color3.fromRGB(255, 230, 150)
            StatusStroke.Thickness = 1
            StatusStroke.Parent = StatusBox
            ToggleFrame.MouseButton1Click:Connect(function()
                Enabled = not Enabled
                local GoalColor = Enabled and Color3.fromRGB(255, 215, 0) or Color3.fromRGB(30, 20, 5)
                TweenService:Create(StatusBox, TweenInfo.new(0.2), {BackgroundColor3 = GoalColor}):Play()
                if Callback then task.spawn(Callback, Enabled) end
            end)
        end
        
        -- LABEL
        function TabFunctions:Label(Text)
            local Lab = Instance.new("TextLabel")
            Lab.Size = UDim2.new(1, 0, 0, 30)
            Lab.BackgroundTransparency = 1
            Lab.Text = Text
            Lab.TextColor3 = Color3.fromRGB(40, 25, 10) 
            Lab.Font = Enum.Font.GothamBold
            Lab.TextSize = 15
            Lab.Parent = Page
        end

        -- DROPDOWN (DARK)
        function TabFunctions:Dropdown(Text, Options, Multi, Default, Callback)
            local DropdownExpanded = false
            local Selected = Multi and (Default or {}) or (Default or nil)
            local DropFrame = Instance.new("Frame")
            DropFrame.Size = UDim2.new(1, 0, 0, 40)
            DropFrame.BackgroundColor3 = Color3.fromRGB(45, 30, 10) 
            DropFrame.ClipsDescendants = true
            DropFrame.BorderSizePixel = 0
            DropFrame.Parent = Page
            local DropCorner = Instance.new("UICorner")
            DropCorner.CornerRadius = UDim.new(0, 6)
            DropCorner.Parent = DropFrame
            local HeaderBtn = Instance.new("TextButton")
            HeaderBtn.Size = UDim2.new(1, 0, 0, 40)
            HeaderBtn.BackgroundTransparency = 1
            HeaderBtn.Text = ""
            HeaderBtn.Parent = DropFrame
            local TitleLabel = Instance.new("TextLabel")
            TitleLabel.Size = UDim2.new(1, -40, 1, 0)
            TitleLabel.Position = UDim2.new(0, 10, 0, 0)
            TitleLabel.BackgroundTransparency = 1
            TitleLabel.TextColor3 = Color3.fromRGB(255, 230, 150) 
            TitleLabel.Font = Enum.Font.GothamSemibold
            TitleLabel.TextSize = 14
            TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
            TitleLabel.TextTruncate = Enum.TextTruncate.AtEnd
            TitleLabel.Parent = HeaderBtn
            local Arrow = Instance.new("TextLabel")
            Arrow.Size = UDim2.new(0, 30, 1, 0)
            Arrow.Position = UDim2.new(1, -30, 0, 0)
            Arrow.BackgroundTransparency = 1
            Arrow.Text = "▼"
            Arrow.TextColor3 = Color3.fromRGB(255, 230, 150)
            Arrow.Font = Enum.Font.GothamBold
            Arrow.TextSize = 14
            Arrow.Parent = HeaderBtn
            local ListContainer = Instance.new("ScrollingFrame")
            ListContainer.Size = UDim2.new(1, -10, 0, 150)
            ListContainer.Position = UDim2.new(0, 5, 0, 45)
            ListContainer.BackgroundTransparency = 1
            ListContainer.ScrollBarThickness = 2
            ListContainer.ScrollBarImageColor3 = Color3.fromRGB(255, 215, 0)
            ListContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
            ListContainer.Visible = false
            ListContainer.Parent = DropFrame
            local ListLayout = Instance.new("UIListLayout")
            ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            ListLayout.Padding = UDim.new(0, 2)
            ListLayout.Parent = ListContainer
            local SearchBox = Instance.new("TextBox")
            SearchBox.Size = UDim2.new(1, 0, 0, 25)
            SearchBox.BackgroundColor3 = Color3.fromRGB(30, 20, 5) 
            SearchBox.PlaceholderText = "Search..."
            SearchBox.Text = ""
            SearchBox.TextColor3 = Color3.fromRGB(255, 230, 150)
            SearchBox.PlaceholderColor3 = Color3.fromRGB(150, 130, 100)
            SearchBox.Font = Enum.Font.Gotham
            SearchBox.TextSize = 13
            SearchBox.Visible = false
            SearchBox.BorderSizePixel = 0
            SearchBox.Parent = DropFrame
            SearchBox.Position = UDim2.new(0, 5, 0, 45)
            local SearchCorner = Instance.new("UICorner")
            SearchCorner.CornerRadius = UDim.new(0, 4)
            SearchCorner.Parent = SearchBox
            local function UpdateHeaderText()
                if Multi then
                    local count = #Selected
                    if count == 0 then TitleLabel.Text = Text .. ": None"
                    elseif count > 3 then TitleLabel.Text = Text .. ": " .. count .. " Selected"
                    else TitleLabel.Text = Text .. ": " .. table.concat(Selected, ", ") end
                else
                    TitleLabel.Text = Text .. ": " .. (Selected and tostring(Selected) or "None")
                end
            end
            local function RefreshList(filterText)
                for _, v in pairs(ListContainer:GetChildren()) do
                    if v:IsA("TextButton") then v:Destroy() end
                end
                ListContainer.Position = UDim2.new(0, 5, 0, 75) 
                ListContainer.Size = UDim2.new(1, -10, 0, 120)
                local count = 0
                for _, option in ipairs(Options) do
                    if filterText == "" or string.find(tostring(option):lower(), filterText:lower()) then
                        local ItemBtn = Instance.new("TextButton")
                        ItemBtn.Size = UDim2.new(1, 0, 0, 25)
                        ItemBtn.BackgroundColor3 = Color3.fromRGB(45, 30, 10)
                        ItemBtn.Text = tostring(option)
                        ItemBtn.TextColor3 = Color3.fromRGB(180, 160, 120)
                        ItemBtn.Font = Enum.Font.Gotham
                        ItemBtn.TextSize = 13
                        ItemBtn.BorderSizePixel = 0
                        ItemBtn.Parent = ListContainer
                        local ItemCorner = Instance.new("UICorner")
                        ItemCorner.CornerRadius = UDim.new(0, 4)
                        ItemCorner.Parent = ItemBtn
                        if Multi then
                            if table.find(Selected, option) then
                                ItemBtn.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
                                ItemBtn.TextColor3 = Color3.fromRGB(40, 35, 20)
                            end
                        else
                            if Selected == option then
                                ItemBtn.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
                                ItemBtn.TextColor3 = Color3.fromRGB(40, 35, 20)
                            end
                        end
                        ItemBtn.MouseButton1Click:Connect(function()
                            if Multi then
                                if table.find(Selected, option) then
                                    for i, v in ipairs(Selected) do if v == option then table.remove(Selected, i) break end end
                                    ItemBtn.BackgroundColor3 = Color3.fromRGB(45, 30, 10)
                                    ItemBtn.TextColor3 = Color3.fromRGB(180, 160, 120)
                                else
                                    table.insert(Selected, option)
                                    ItemBtn.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
                                    ItemBtn.TextColor3 = Color3.fromRGB(40, 35, 20)
                                end
                                UpdateHeaderText()
                                if Callback then Callback(Selected) end
                            else
                                if Selected == option then
                                    Selected = nil
                                    UpdateHeaderText()
                                    ItemBtn.BackgroundColor3 = Color3.fromRGB(45, 30, 10)
                                    ItemBtn.TextColor3 = Color3.fromRGB(180, 160, 120)
                                    if Callback then Callback(nil) end
                                else
                                    Selected = option
                                    UpdateHeaderText()
                                    for _, btn in pairs(ListContainer:GetChildren()) do
                                        if btn:IsA("TextButton") then
                                            btn.BackgroundColor3 = Color3.fromRGB(45, 30, 10)
                                            btn.TextColor3 = Color3.fromRGB(180, 160, 120)
                                        end
                                    end
                                    ItemBtn.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
                                    ItemBtn.TextColor3 = Color3.fromRGB(40, 35, 20)
                                    DropdownExpanded = false
                                    TweenService:Create(DropFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 40)}):Play()
                                    Arrow.Text = "▼"
                                    ListContainer.Visible = false
                                    SearchBox.Visible = false
                                    if Callback then Callback(Selected) end
                                end
                            end
                        end)
                        count = count + 1
                        if count % 30 == 0 then
                            ListContainer.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y)
                            task.wait() 
                        end
                    end
                end
                ListContainer.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y)
            end
            SearchBox:GetPropertyChangedSignal("Text"):Connect(function() RefreshList(SearchBox.Text) end)
            HeaderBtn.MouseButton1Click:Connect(function()
                DropdownExpanded = not DropdownExpanded
                if DropdownExpanded then
                    Arrow.Text = "▲"
                    TweenService:Create(DropFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 200)}):Play()
                    ListContainer.Visible = true
                    SearchBox.Visible = true
                    if #ListContainer:GetChildren() <= 1 then task.spawn(function() RefreshList("") end) end
                else
                    Arrow.Text = "▼"
                    TweenService:Create(DropFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 40)}):Play()
                    ListContainer.Visible = false
                    SearchBox.Visible = false
                end
            end)
            UpdateHeaderText()
        end
        return TabFunctions
    end
    return WindowFunctions
end
return Library
