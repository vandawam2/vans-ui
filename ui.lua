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
    local Title = Config.Title or "Golden Luxury Hub"
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "GoldLib_" .. math.random(1,1000)
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = GetSafeGui()

    -- [1] Main Frame (Solid Deep Gold)
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 450, 0, 300)
    MainFrame.Position = UDim2.new(0.5, -225, 0.5, -150)
    -- Warna Emas Kaya (Rich Gold) - Tidak terlalu kuning terang
    MainFrame.BackgroundColor3 = Color3.fromRGB(180, 130, 20) 
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui

    -- Memberikan Border Emas Terang agar terlihat seperti lempengan emas
    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = Color3.fromRGB(220, 180, 50) -- Emas lebih terang
    MainStroke.Thickness = 2
    MainStroke.Parent = MainFrame

    -- Rounded Corner
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8) -- Sedikit lebih bulat untuk kesan premium
    Corner.Parent = MainFrame
    
    -- [2] Topbar (Darker Bronze/Gold contrast)
    local Topbar = Instance.new("Frame")
    Topbar.Size = UDim2.new(1, 0, 0, 40) -- Sedikit lebih tinggi
    -- Warna kontras gelap (Bronze tua) agar judul terbaca jelas
    Topbar.BackgroundColor3 = Color3.fromRGB(60, 45, 15) 
    Topbar.BorderSizePixel = 0
    Topbar.Parent = MainFrame
    
    local TopbarCorner = Instance.new("UICorner")
    TopbarCorner.CornerRadius = UDim.new(0, 8)
    TopbarCorner.Parent = Topbar
    
    local HideBar = Instance.new("Frame")
    HideBar.Size = UDim2.new(1, 0, 0, 10)
    HideBar.Position = UDim2.new(0, 0, 1, -10)
    HideBar.BorderSizePixel = 0
    Topbar.BackgroundColor3 = Color3.fromRGB(60, 45, 15) 
    HideBar.Parent = Topbar

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -20, 1, 0)
    TitleLabel.Position = UDim2.new(0, 15, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = Title
    TitleLabel.Font = Enum.Font.GothamBold
    -- Teks warna Emas Krim Terang
    TitleLabel.TextColor3 = Color3.fromRGB(255, 245, 220) 
    TitleLabel.TextSize = 18
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = Topbar
    
    MakeDraggable(Topbar, MainFrame)

    -- [3] Tab Container (Dark Bronze Side)
    local TabContainer = Instance.new("Frame")
    TabContainer.Size = UDim2.new(0, 130, 1, -40)
    TabContainer.Position = UDim2.new(0, 0, 0, 40)
    -- Menyamakan dengan topbar
    TabContainer.BackgroundColor3 = Color3.fromRGB(50, 35, 10) 
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

    -- Page Container
    local PageContainer = Instance.new("Frame")
    PageContainer.Size = UDim2.new(1, -145, 1, -55)
    PageContainer.Position = UDim2.new(0, 135, 0, 45)
    PageContainer.BackgroundTransparency = 1
    PageContainer.Parent = MainFrame

    local WindowFunctions = {}
    local FirstTab = true

    function WindowFunctions:Tab(Name)
        -- Tab Button Style (Inactive state: Dark gold text on dark BG)
        local TabBtn = Instance.new("TextButton")
        TabBtn.Size = UDim2.new(1, -15, 0, 32)
        TabBtn.BackgroundColor3 = Color3.fromRGB(80, 60, 30) -- Emas gelap
        TabBtn.BackgroundTransparency = 0.5
        TabBtn.Text = Name
        TabBtn.TextColor3 = Color3.fromRGB(180, 160, 120) -- Teks emas pudar
        TabBtn.Font = Enum.Font.GothamSemibold
        TabBtn.TextSize = 14
        TabBtn.Parent = TabContainer
        
        local TabBtnCorner = Instance.new("UICorner")
        TabBtnCorner.CornerRadius = UDim.new(0, 6)
        TabBtnCorner.Parent = TabBtn

        -- Page Frame
        local Page = Instance.new("ScrollingFrame")
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.ScrollBarThickness = 4
        -- Scrollbar warna emas terang
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

        -- Logic Switch Tab
        if FirstTab then
            Page.Visible = true
            -- Active State: Bright Gold BG, Dark Text
            TabBtn.BackgroundColor3 = Color3.fromRGB(220, 180, 50)
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
                    -- Reset to inactive gold
                    TweenService:Create(child, TweenInfo.new(0.2), {
                        BackgroundColor3 = Color3.fromRGB(80, 60, 30), 
                        BackgroundTransparency = 0.5,
                        TextColor3 = Color3.fromRGB(180, 160, 120)
                    }):Play()
                end
            end
            
            Page.Visible = true
            -- Set to active bright gold
            TweenService:Create(TabBtn, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(220, 180, 50),
                BackgroundTransparency = 0,
                TextColor3 = Color3.fromRGB(40, 30, 15)
            }):Play()
        end)

        local TabFunctions = {}

        -- [ELEMENT: BUTTON - Gold Style]
        function TabFunctions:Button(Text, Callback)
            local Btn = Instance.new("TextButton")
            Btn.Size = UDim2.new(1, 0, 0, 38)
            -- Background tombol emas medium
            Btn.BackgroundColor3 = Color3.fromRGB(200, 150, 40) 
            Btn.Text = Text
            -- Teks gelap agar kontras
            Btn.TextColor3 = Color3.fromRGB(50, 40, 20) 
            Btn.Font = Enum.Font.GothamBold
            Btn.TextSize = 14
            Btn.Parent = Page
            
            local BtnCorner = Instance.new("UICorner")
            BtnCorner.CornerRadius = UDim.new(0, 6)
            BtnCorner.Parent = Btn
            
            -- Stroke Emas Terang untuk highlight
            local Stroke = Instance.new("UIStroke")
            Stroke.Color = Color3.fromRGB(255, 230, 150)
            Stroke.Thickness = 1.5
            Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            Stroke.Parent = Btn
            
            Btn.MouseButton1Click:Connect(function()
                -- Efek klik: jadi lebih terang lalu kembali
                TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(255, 200, 80)}):Play()
                task.wait(0.1)
                TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(200, 150, 40)}):Play()
                if Callback then task.spawn(Callback) end
            end)
        end

        -- [ELEMENT: TOGGLE - Gold Style]
        function TabFunctions:Toggle(Text, Default, Callback)
            local Enabled = Default or false
            
            local ToggleFrame = Instance.new("TextButton")
            ToggleFrame.Size = UDim2.new(1, 0, 0, 38)
            ToggleFrame.BackgroundColor3 = Color3.fromRGB(70, 50, 20) -- Background gelap
            ToggleFrame.Text = ""
            ToggleFrame.Parent = Page
            
            local ToggleCorner = Instance.new("UICorner")
            ToggleCorner.CornerRadius = UDim.new(0, 6)
            ToggleCorner.Parent = ToggleFrame
            
            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -50, 1, 0)
            Label.Position = UDim2.new(0, 10, 0, 0)
            Label.BackgroundTransparency = 1
            Label.Text = Text
            Label.TextColor3 = Color3.fromRGB(255, 230, 150) -- Teks emas terang
            Label.Font = Enum.Font.GothamSemibold
            Label.TextSize = 14
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = ToggleFrame
            
            -- Kotak Status
            local StatusBox = Instance.new("Frame")
            StatusBox.Size = UDim2.new(0, 24, 0, 24)
            StatusBox.Position = UDim2.new(1, -34, 0.5, -12)
            -- Warna Status: Emas Murni (Aktif) atau Emas Gelap Kusam (Mati)
            StatusBox.BackgroundColor3 = Enabled and Color3.fromRGB(255, 215, 0) or Color3.fromRGB(40, 35, 20)
            StatusBox.Parent = ToggleFrame
            
            local StatusCorner = Instance.new("UICorner")
            StatusCorner.CornerRadius = UDim.new(0, 4)
            StatusCorner.Parent = StatusBox
            
            -- Stroke pada status box
            local StatusStroke = Instance.new("UIStroke")
            StatusStroke.Color = Color3.fromRGB(255, 230, 150)
            StatusStroke.Thickness = 1
            StatusStroke.Parent = StatusBox
            
            ToggleFrame.MouseButton1Click:Connect(function()
                Enabled = not Enabled
                local GoalColor = Enabled and Color3.fromRGB(255, 215, 0) or Color3.fromRGB(40, 35, 20)
                TweenService:Create(StatusBox, TweenInfo.new(0.2), {BackgroundColor3 = GoalColor}):Play()
                if Callback then task.spawn(Callback, Enabled) end
            end)
        end
        
        -- [ELEMENT: LABEL - Gold Style]
        function TabFunctions:Label(Text)
            local Lab = Instance.new("TextLabel")
            Lab.Size = UDim2.new(1, 0, 0, 30)
            Lab.BackgroundTransparency = 1
            Lab.Text = Text
            Lab.TextColor3 = Color3.fromRGB(255, 215, 0) -- Emas murni
            Lab.Font = Enum.Font.GothamBold
            Lab.TextSize = 15
            Lab.Parent = Page
        end

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
        
        return TabFunctions
    end

    return WindowFunctions
end

return Library
