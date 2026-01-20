--[[ 
    SIMPLE UI LIBRARY
    Lightweight, CoreGui Support, No Images.
    Author: [Your Name]
]]

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

-- [1] UTILITIES & SAFE GUI
local function GetSafeGui()
    -- Mencoba mengambil container UI yang aman (CoreGui)
    local success, result = pcall(function()
        return (gethui and gethui()) or (game:GetService("CoreGui"))
    end)
    if not success then return Players.LocalPlayer:WaitForChild("PlayerGui") end
    return result
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
    local Title = Config.Title or "Simple Hub"
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "SimpleLib_" .. math.random(1,1000)
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = GetSafeGui()

    -- Main Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 450, 0, 300)
    MainFrame.Position = UDim2.new(0.5, -225, 0.5, -150)
    MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui

    -- Rounded Corner (Simple)
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = MainFrame
    
    -- Topbar
    local Topbar = Instance.new("Frame")
    Topbar.Size = UDim2.new(1, 0, 0, 35)
    Topbar.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    Topbar.BorderSizePixel = 0
    Topbar.Parent = MainFrame
    
    local TopbarCorner = Instance.new("UICorner")
    TopbarCorner.CornerRadius = UDim.new(0, 6)
    TopbarCorner.Parent = Topbar
    
    -- Hiding bottom corners of topbar
    local HideBar = Instance.new("Frame")
    HideBar.Size = UDim2.new(1, 0, 0, 5)
    HideBar.Position = UDim2.new(0, 0, 1, -5)
    HideBar.BorderSizePixel = 0
    HideBar.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    HideBar.Parent = Topbar

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -20, 1, 0)
    TitleLabel.Position = UDim2.new(0, 15, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = Title
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextSize = 16
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = Topbar
    
    MakeDraggable(Topbar, MainFrame)

    -- Container Tabs
    local TabContainer = Instance.new("Frame")
    TabContainer.Size = UDim2.new(0, 120, 1, -35)
    TabContainer.Position = UDim2.new(0, 0, 0, 35)
    TabContainer.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    TabContainer.BorderSizePixel = 0
    TabContainer.Parent = MainFrame
    
    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 6)
    TabCorner.Parent = TabContainer

    local TabListLayout = Instance.new("UIListLayout")
    TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabListLayout.Padding = UDim.new(0, 5)
    TabListLayout.Parent = TabContainer
    
    local TabPadding = Instance.new("UIPadding")
    TabPadding.PaddingTop = UDim.new(0, 10)
    TabPadding.PaddingLeft = UDim.new(0, 5)
    TabPadding.Parent = TabContainer

    -- Page Container
    local PageContainer = Instance.new("Frame")
    PageContainer.Size = UDim2.new(1, -130, 1, -45)
    PageContainer.Position = UDim2.new(0, 125, 0, 40)
    PageContainer.BackgroundTransparency = 1
    PageContainer.Parent = MainFrame

    local WindowFunctions = {}
    local FirstTab = true

    function WindowFunctions:Tab(Name)
        -- Tab Button
        local TabBtn = Instance.new("TextButton")
        TabBtn.Size = UDim2.new(1, -10, 0, 30)
        TabBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        TabBtn.Text = Name
        TabBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
        TabBtn.Font = Enum.Font.GothamSemibold
        TabBtn.TextSize = 14
        TabBtn.Parent = TabContainer
        
        local TabBtnCorner = Instance.new("UICorner")
        TabBtnCorner.CornerRadius = UDim.new(0, 4)
        TabBtnCorner.Parent = TabBtn

        -- Page Frame
        local Page = Instance.new("ScrollingFrame")
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.ScrollBarThickness = 2
        Page.Visible = false
        Page.Parent = PageContainer
        
        local PageLayout = Instance.new("UIListLayout")
        PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        PageLayout.Padding = UDim.new(0, 5)
        PageLayout.Parent = Page
        
        local PagePadding = Instance.new("UIPadding")
        PagePadding.PaddingTop = UDim.new(0, 5)
        PagePadding.PaddingLeft = UDim.new(0, 5)
        PagePadding.PaddingRight = UDim.new(0, 5)
        PagePadding.Parent = Page

        -- Logic Switch Tab
        if FirstTab then
            Page.Visible = true
            TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            TabBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            FirstTab = false
        end

        TabBtn.MouseButton1Click:Connect(function()
            -- Reset all Tabs
            for _, child in pairs(PageContainer:GetChildren()) do
                if child:IsA("ScrollingFrame") then child.Visible = false end
            end
            for _, child in pairs(TabContainer:GetChildren()) do
                if child:IsA("TextButton") then 
                    TweenService:Create(child, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40,40,40), TextColor3 = Color3.fromRGB(150,150,150)}):Play()
                end
            end
            
            -- Active This Tab
            Page.Visible = true
            TweenService:Create(TabBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60,60,60), TextColor3 = Color3.fromRGB(255,255,255)}):Play()
        end)

        local TabFunctions = {}

        -- [ELEMENT: BUTTON]
        function TabFunctions:Button(Text, Callback)
            local Btn = Instance.new("TextButton")
            Btn.Size = UDim2.new(1, 0, 0, 35)
            Btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            Btn.Text = Text
            Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            Btn.Font = Enum.Font.Gotham
            Btn.TextSize = 14
            Btn.Parent = Page
            
            local BtnCorner = Instance.new("UICorner")
            BtnCorner.CornerRadius = UDim.new(0, 4)
            BtnCorner.Parent = Btn
            
            Btn.MouseButton1Click:Connect(function()
                -- Efek Klik Simple
                TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(80, 80, 80)}):Play()
                task.wait(0.1)
                TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}):Play()
                
                if Callback then task.spawn(Callback) end
            end)
        end

        -- [ELEMENT: DROPDOWN]
        -- [ELEMENT: DROPDOWN (UPDATED)]
        function TabFunctions:Dropdown(Text, Options, Multi, Default, Callback)
            local DropdownExpanded = false
            local Selected = Multi and (Default or {}) or (Default or nil)
            
            -- Frame Utama Dropdown
            local DropFrame = Instance.new("Frame")
            DropFrame.Size = UDim2.new(1, 0, 0, 40) -- Tinggi awal (tertutup)
            DropFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            DropFrame.ClipsDescendants = true
            DropFrame.Parent = Page
            
            local DropCorner = Instance.new("UICorner")
            DropCorner.CornerRadius = UDim.new(0, 4)
            DropCorner.Parent = DropFrame
            
            -- Header (Tombol Klik)
            local HeaderBtn = Instance.new("TextButton")
            HeaderBtn.Size = UDim2.new(1, 0, 0, 40)
            HeaderBtn.BackgroundTransparency = 1
            HeaderBtn.Text = ""
            HeaderBtn.Parent = DropFrame
            
            local TitleLabel = Instance.new("TextLabel")
            TitleLabel.Size = UDim2.new(1, -40, 1, 0)
            TitleLabel.Position = UDim2.new(0, 10, 0, 0)
            TitleLabel.BackgroundTransparency = 1
            -- Set text awal
            local displayVal = "None"
            if Multi then
                displayVal = (type(Selected) == "table" and #Selected > 0) and table.concat(Selected, ", ") or "None"
            else
                displayVal = Selected and tostring(Selected) or "None"
            end
            TitleLabel.Text = Text .. ": " .. displayVal
            
            TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            TitleLabel.Font = Enum.Font.Gotham
            TitleLabel.TextSize = 13
            TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
            TitleLabel.TextTruncate = Enum.TextTruncate.AtEnd
            TitleLabel.Parent = HeaderBtn
            
            local Arrow = Instance.new("TextLabel")
            Arrow.Size = UDim2.new(0, 30, 1, 0)
            Arrow.Position = UDim2.new(1, -30, 0, 0)
            Arrow.BackgroundTransparency = 1
            Arrow.Text = "▼"
            Arrow.TextColor3 = Color3.fromRGB(150, 150, 150)
            Arrow.Font = Enum.Font.GothamBold
            Arrow.TextSize = 14
            Arrow.Parent = HeaderBtn

            -- Container List Item
            local ListContainer = Instance.new("ScrollingFrame")
            ListContainer.Size = UDim2.new(1, -10, 0, 150)
            ListContainer.Position = UDim2.new(0, 5, 0, 45)
            ListContainer.BackgroundTransparency = 1
            ListContainer.ScrollBarThickness = 2
            ListContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
            ListContainer.Visible = false
            ListContainer.Parent = DropFrame
            
            local ListLayout = Instance.new("UIListLayout")
            ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            ListLayout.Padding = UDim.new(0, 2)
            ListLayout.Parent = ListContainer

            -- Search Bar
            local SearchBox = Instance.new("TextBox")
            SearchBox.Size = UDim2.new(1, 0, 0, 25)
            SearchBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            SearchBox.PlaceholderText = "Search..."
            SearchBox.Text = ""
            SearchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
            SearchBox.Font = Enum.Font.Gotham
            SearchBox.TextSize = 13
            SearchBox.Visible = false
            SearchBox.Parent = DropFrame
            SearchBox.Position = UDim2.new(0, 5, 0, 45)
            
            local SearchCorner = Instance.new("UICorner")
            SearchCorner.CornerRadius = UDim.new(0, 4)
            SearchCorner.Parent = SearchBox

            -- Fungsi Update Teks Header
            local function UpdateHeaderText()
                if Multi then
                    local count = #Selected
                    if count == 0 then
                        TitleLabel.Text = Text .. ": None"
                    elseif count > 3 then
                        TitleLabel.Text = Text .. ": " .. count .. " Selected"
                    else
                        TitleLabel.Text = Text .. ": " .. table.concat(Selected, ", ")
                    end
                else
                    -- Jika Selected nil, tampilkan None
                    TitleLabel.Text = Text .. ": " .. (Selected and tostring(Selected) or "None")
                end
            end

            -- Fungsi Load Item
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
                        ItemBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                        ItemBtn.Text = tostring(option)
                        ItemBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
                        ItemBtn.Font = Enum.Font.Gotham
                        ItemBtn.TextSize = 13
                        ItemBtn.Parent = ListContainer
                        
                        local ItemCorner = Instance.new("UICorner")
                        ItemCorner.CornerRadius = UDim.new(0, 4)
                        ItemCorner.Parent = ItemBtn

                        -- Cek Status Seleksi Awal (Visual)
                        if Multi then
                            if table.find(Selected, option) then
                                ItemBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
                                ItemBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
                            end
                        else
                            if Selected == option then
                                ItemBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
                                ItemBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
                            end
                        end

                        ItemBtn.MouseButton1Click:Connect(function()
                            if Multi then
                                -- LOGIKA MULTI (Tetap sama)
                                if table.find(Selected, option) then
                                    for i, v in ipairs(Selected) do
                                        if v == option then table.remove(Selected, i) break end
                                    end
                                    ItemBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                                    ItemBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
                                else
                                    table.insert(Selected, option)
                                    ItemBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
                                    ItemBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
                                end
                                UpdateHeaderText()
                                if Callback then Callback(Selected) end
                            else
                                -- LOGIKA SINGLE (Bisa Deselect)
                                if Selected == option then
                                    -- [1] Jika diklik lagi -> Deselect (Jadi Nil/None)
                                    Selected = nil
                                    UpdateHeaderText()
                                    
                                    -- Ubah warna jadi abu-abu
                                    ItemBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                                    ItemBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
                                    
                                    -- Kirim nil ke callback
                                    if Callback then Callback(nil) end
                                else
                                    -- [2] Jika pilih item baru -> Select
                                    Selected = option
                                    UpdateHeaderText()
                                    
                                    -- Reset visual semua tombol lain
                                    for _, btn in pairs(ListContainer:GetChildren()) do
                                        if btn:IsA("TextButton") then
                                            btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                                            btn.TextColor3 = Color3.fromRGB(200, 200, 200)
                                        end
                                    end
                                    
                                    -- Highlight item ini
                                    ItemBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
                                    ItemBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
                                    
                                    -- Tutup Dropdown (Hanya menutup jika MEMILIH, kalau deselect tetap buka atau tutup opsional, disini saya tutup juga biar rapi)
                                    DropdownExpanded = false
                                    TweenService:Create(DropFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 40)}):Play()
                                    Arrow.Text = "▼"
                                    ListContainer.Visible = false
                                    SearchBox.Visible = false
                                    
                                    if Callback then Callback(Selected) end
                                end
                            end
                        end)
                        
                        -- Optimasi Load
                        count = count + 1
                        if count % 30 == 0 then
                            ListContainer.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y)
                            task.wait() 
                        end
                    end
                end
                ListContainer.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y)
            end

            SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
                RefreshList(SearchBox.Text)
            end)

            HeaderBtn.MouseButton1Click:Connect(function()
                DropdownExpanded = not DropdownExpanded
                if DropdownExpanded then
                    Arrow.Text = "▲"
                    TweenService:Create(DropFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 200)}):Play()
                    ListContainer.Visible = true
                    SearchBox.Visible = true
                    
                    if #ListContainer:GetChildren() <= 1 then
                        task.spawn(function() RefreshList("") end)
                    end
                else
                    Arrow.Text = "▼"
                    TweenService:Create(DropFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 40)}):Play()
                    ListContainer.Visible = false
                    SearchBox.Visible = false
                end
            end)
            
            UpdateHeaderText()
        end

        -- [ELEMENT: TOGGLE]
        function TabFunctions:Toggle(Text, Default, Callback)
            local Enabled = Default or false
            
            local ToggleFrame = Instance.new("TextButton")
            ToggleFrame.Size = UDim2.new(1, 0, 0, 35)
            ToggleFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            ToggleFrame.Text = ""
            ToggleFrame.Parent = Page
            
            local ToggleCorner = Instance.new("UICorner")
            ToggleCorner.CornerRadius = UDim.new(0, 4)
            ToggleCorner.Parent = ToggleFrame
            
            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -40, 1, 0)
            Label.Position = UDim2.new(0, 10, 0, 0)
            Label.BackgroundTransparency = 1
            Label.Text = Text
            Label.TextColor3 = Color3.fromRGB(255, 255, 255)
            Label.Font = Enum.Font.Gotham
            Label.TextSize = 14
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = ToggleFrame
            
            local StatusBox = Instance.new("Frame")
            StatusBox.Size = UDim2.new(0, 20, 0, 20)
            StatusBox.Position = UDim2.new(1, -30, 0.5, -10)
            StatusBox.BackgroundColor3 = Enabled and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(30, 30, 30)
            StatusBox.Parent = ToggleFrame
            
            local StatusCorner = Instance.new("UICorner")
            StatusCorner.CornerRadius = UDim.new(0, 4)
            StatusCorner.Parent = StatusBox
            
            ToggleFrame.MouseButton1Click:Connect(function()
                Enabled = not Enabled
                -- Animasi Warna
                local GoalColor = Enabled and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(30, 30, 30)
                TweenService:Create(StatusBox, TweenInfo.new(0.2), {BackgroundColor3 = GoalColor}):Play()
                
                if Callback then task.spawn(Callback, Enabled) end
            end)
        end
        
        -- [ELEMENT: LABEL]
        function TabFunctions:Label(Text)
            local Lab = Instance.new("TextLabel")
            Lab.Size = UDim2.new(1, 0, 0, 25)
            Lab.BackgroundTransparency = 1
            Lab.Text = Text
            Lab.TextColor3 = Color3.fromRGB(200, 200, 200)
            Lab.Font = Enum.Font.Gotham
            Lab.TextSize = 13
            Lab.Parent = Page
        end

        return TabFunctions
    end

    return WindowFunctions
end

return Library
