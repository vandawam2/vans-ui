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
    MainFrame.BackgroundColor3 = Color3.fromRGB(180, 130, 20) 
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui

    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = Color3.fromRGB(220, 180, 50)
    MainStroke.Thickness = 2
    MainStroke.Parent = MainFrame

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = MainFrame
    
    -- [2] Topbar (Darker Bronze/Gold contrast)
    local Topbar = Instance.new("Frame")
    Topbar.Size = UDim2.new(1, 0, 0, 40)
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
    HideBar.BackgroundColor3 = Color3.fromRGB(60, 45, 15) 
    HideBar.Parent = Topbar

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -20, 1, 0)
    TitleLabel.Position = UDim2.new(0, 15, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = Title
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextColor3 = Color3.fromRGB(255, 245, 220) 
    TitleLabel.TextSize = 18
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = Topbar
    
    MakeDraggable(Topbar, MainFrame)

    -- [3] Tab Container (Dark Bronze Side)
    local TabContainer = Instance.new("Frame")
    TabContainer.Size = UDim2.new(0, 130, 1, -40)
    TabContainer.Position = UDim2.new(0, 0, 0, 40)
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
        local TabBtn = Instance.new("TextButton")
        TabBtn.Size = UDim2.new(1, -15, 0, 32)
        TabBtn.BackgroundColor3 = Color3.fromRGB(80, 60, 30)
        TabBtn.BackgroundTransparency = 0.5
        TabBtn.Text = Name
        TabBtn.TextColor3 = Color3.fromRGB(180, 160, 120)
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
                    TweenService:Create(child, TweenInfo.new(0.2), {
                        BackgroundColor3 = Color3.fromRGB(80, 60, 30), 
                        BackgroundTransparency = 0.5,
                        TextColor3 = Color3.fromRGB(180, 160, 120)
                    }):Play()
                end
            end
            
            Page.Visible = true
            TweenService:Create(TabBtn, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(220, 180, 50),
                BackgroundTransparency = 0,
                TextColor3 = Color3.fromRGB(40, 30, 15)
            }):Play()
        end)

        local TabFunctions = {}

        -- [ELEMENT: BUTTON - Dark Gold Style]
        function TabFunctions:Button(Text, Callback)
            local Btn = Instance.new("TextButton")
            Btn.Size = UDim2.new(1, 0, 0, 38)
            -- Background tombol jadi Emas Gelap
            Btn.BackgroundColor3 = Color3.fromRGB(80, 60, 30)
            Btn.Text = Text
            -- Teks jadi Emas Terang agar kontras
            Btn.TextColor3 = Color3.fromRGB(255, 230, 150)
            Btn.Font = Enum.Font.GothamBold
            Btn.TextSize = 14
            Btn.Parent = Page
            
            local BtnCorner = Instance.new("UICorner")
            BtnCorner.CornerRadius = UDim.new(0, 6)
            BtnCorner.Parent = Btn
            
            local Stroke = Instance.new("UIStroke")
            Stroke.Color = Color3.fromRGB(255, 230, 150)
            Stroke.Thickness = 1.5
            Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            Stroke.Parent = Btn
            
            Btn.MouseButton1Click:Connect(function()
                TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(100, 80, 40)}):Play()
                task.wait(0.1)
                TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(80, 60, 30)}):Play()
                if Callback then task.spawn(Callback) end
            end)
        end

        -- [ELEMENT: TOGGLE - Dark Gold Style]
        function TabFunctions:Toggle(Text, Default, Callback)
            local Enabled = Default or false
            
            local ToggleFrame = Instance.new("TextButton")
            ToggleFrame.Size = UDim2.new(1, 0, 0, 38)
            ToggleFrame.BackgroundColor3 = Color3.fromRGB(70, 50, 20)
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
            Label.TextColor3 = Color3.fromRGB(255, 230, 150)
            Label.Font = Enum.Font.GothamSemibold
            Label.TextSize = 14
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = ToggleFrame
            
            local StatusBox = Instance.new("Frame")
            StatusBox.Size = UDim2.new(0, 24, 0, 24)
            StatusBox.Position = UDim2.new(1, -34, 0.5, -12)
            StatusBox.BackgroundColor3 = Enabled and Color3.fromRGB(255, 215, 0) or Color3.fromRGB(40, 35, 20)
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
                local GoalColor = Enabled and Color3.fromRGB(255, 215, 0) or Color3.fromRGB(40, 35, 20)
                TweenService:Create(StatusBox, TweenInfo.new(0.2), {BackgroundColor3 = GoalColor}):Play()
                if Callback then task.spawn(Callback, Enabled) end
            end)
        end
        
        -- [ELEMENT: LABEL - Dark Style for Contrast]
        function TabFunctions:Label(Text)
            local Lab = Instance.new("TextLabel")
            Lab.Size = UDim2.new(1, 0, 0, 30)
            Lab.BackgroundTransparency = 1
            Lab.Text = Text
            -- Teks jadi gelap agar kontras dengan background halaman yang terang
            Lab.TextColor3 = Color3.fromRGB(50, 40, 20) 
            Lab.Font = Enum.Font.GothamBold
            Lab.TextSize = 15
            Lab.Parent = Page
        end

        -- [ELEMENT: DROPDOWN (UPDATED COLORS)]
        function TabFunctions:Dropdown(Text, Options, Multi, Default, Callback)
            local DropdownExpanded = false
            local Selected = Multi and (Default or {}) or (Default or nil)
            
            local DropFrame = Instance.new("Frame")
            DropFrame.Size = UDim2.new(1, 0, 0, 40)
            -- Background Header jadi Emas Gelap
            DropFrame.BackgroundColor3 = Color3.fromRGB(80, 60, 30) 
            DropFrame.ClipsDescendants = true
            DropFrame.Parent = Page
            
            local DropCorner = Instance.new("UICorner")
            DropCorner.CornerRadius = UDim.new(0, 6)
            DropCorner.Parent = DropFrame
            
            -- Stroke untuk header dropdown
            local DropStroke = Instance.new("UIStroke")
            DropStroke.Color = Color3.fromRGB(255, 230, 150)
            DropStroke.Thickness = 1.5
            DropStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            DropStroke.Parent = DropFrame
            
            local HeaderBtn = Instance.new("TextButton")
            HeaderBtn.Size = UDim2.new(1, 0, 0, 40)
            HeaderBtn.BackgroundTransparency = 1
            HeaderBtn.Text = ""
            HeaderBtn.Parent = DropFrame
            
            local TitleLabel = Instance.new("TextLabel")
            TitleLabel.Size = UDim2.new(1, -40, 1, 0)
            TitleLabel.Position = UDim2.new(0, 10, 0, 0)
            TitleLabel.BackgroundTransparency = 1
            -- Teks header jadi Emas Terang
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
            -- FIX: Background SearchBox jadi Cokelat Emas Gelap (bukan abu-abu)
            SearchBox.BackgroundColor3 = Color3.fromRGB(70, 50, 20)
            SearchBox.PlaceholderText = "Search..."
            SearchBox.Text = ""
            SearchBox.TextColor3 = Color3.fromRGB(255, 230, 150)
            SearchBox.PlaceholderColor3 = Color3.fromRGB(180, 160, 120)
            SearchBox.Font = Enum.Font.Gotham
            SearchBox.TextSize = 13
            SearchBox.Visible = false
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
                        -- Item list non-aktif: Cokelat Emas Gelap
                        ItemBtn.BackgroundColor3 = Color3.fromRGB(70, 50, 20)
                        ItemBtn.Text = tostring(option)
                        ItemBtn.TextColor3 = Color3.fromRGB(180, 160, 120)
                        ItemBtn.Font = Enum.Font.Gotham
                        ItemBtn.TextSize = 13
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
                                    ItemBtn.BackgroundColor3 = Color3.fromRGB(70, 50, 20)
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
                                    ItemBtn.BackgroundColor3 = Color3.fromRGB(70, 50, 20)
                                    ItemBtn.TextColor3 = Color3.fromRGB(180, 160, 120)
                                    if Callback then Callback(nil) end
                                else
                                    Selected = option
                                    UpdateHeaderText()
                                    for _, btn in pairs(ListContainer:GetChildren()) do
                                        if btn:IsA("TextButton") then
                                            btn.BackgroundColor3 = Color3.fromRGB(70, 50, 20)
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
