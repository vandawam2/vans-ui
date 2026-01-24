--[[ 
    ZUPERMING KEY SYSTEM (LIBRARY V2 - EXTERNAL VALIDATION)
    Features: Minimalist, Custom Validator, Dynamic Error Feedback.
]]

local KeyLib = {}

function KeyLib:Init(Config)
    local Settings = {
        Title = Config.Title or "Zuperming Key System",
        Url = Config.Url or "https://superminghub.com/getkey",
        -- Validate Function: Harus return (true/false, "Alasan Error")
        Validate = Config.Validate or function(key) return false, "No validator set!" end, 
        Callback = Config.Callback or function() end
    }

    local TweenService = game:GetService("TweenService")
    local UserInputService = game:GetService("UserInputService")
    local Players = game:GetService("Players")
    local CoreGui = game:GetService("CoreGui")

    -- [UI SETUP]
    local function GetSafeGui()
        local success, result = pcall(function() return (gethui and gethui()) or (game:GetService("CoreGui")) end)
        if not success then return Players.LocalPlayer:WaitForChild("PlayerGui") end
        return result
    end

    for _, v in pairs(GetSafeGui():GetChildren()) do
        if v.Name == "ZupermingKeySys" then v:Destroy() end
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ZupermingKeySys"
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.Parent = GetSafeGui()

    -- Blur
    local Blur = Instance.new("BlurEffect")
    Blur.Size = 0
    Blur.Parent = game:GetService("Lighting")
    TweenService:Create(Blur, TweenInfo.new(0.5), {Size = 10}):Play()

    -- Main Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 380, 0, 220) -- Sedikit lebih tinggi untuk status error
    MainFrame.Position = UDim2.new(0.5, -190, 0.5, -110)
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.BackgroundTransparency = 1
    MainFrame.Parent = ScreenGui

    local MainCorner = Instance.new("UICorner") MainCorner.CornerRadius = UDim.new(0, 8) MainCorner.Parent = MainFrame
    local MainStroke = Instance.new("UIStroke") MainStroke.Color = Color3.fromRGB(45, 45, 45) MainStroke.Thickness = 1 MainStroke.Parent = MainFrame

    -- Draggable Logic
    local Dragging, DragInput, DragStart, StartPosition
    local function Update(input)
        local Delta = input.Position - DragStart
        MainFrame.Position = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y)
    end
    MainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true DragStart = input.Position StartPosition = MainFrame.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then Dragging = false end end)
        end
    end)
    MainFrame.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then DragInput = input end end)
    UserInputService.InputChanged:Connect(function(input) if input == DragInput and Dragging then Update(input) end end)

    -- Elements
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 40, 0, 40)
    CloseBtn.Position = UDim2.new(1, -40, 0, 0)
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Text = "×"
    CloseBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
    CloseBtn.TextSize = 24
    CloseBtn.Font = Enum.Font.Gotham
    CloseBtn.Parent = MainFrame
    CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() Blur:Destroy() end)

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -40, 0, 40)
    TitleLabel.Position = UDim2.new(0, 15, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = Settings.Title
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextSize = 16
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = MainFrame

    local InputFrame = Instance.new("Frame")
    InputFrame.Size = UDim2.new(1, -30, 0, 40)
    InputFrame.Position = UDim2.new(0, 15, 0, 60)
    InputFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    InputFrame.BorderSizePixel = 0
    InputFrame.Parent = MainFrame
    local InputCorner = Instance.new("UICorner") InputCorner.CornerRadius = UDim.new(0, 6) InputCorner.Parent = InputFrame
    local InputStroke = Instance.new("UIStroke") InputStroke.Color = Color3.fromRGB(50, 50, 50) InputStroke.Thickness = 1 InputStroke.Parent = InputFrame

    local InputBox = Instance.new("TextBox")
    InputBox.Size = UDim2.new(1, -20, 1, 0)
    InputBox.Position = UDim2.new(0, 10, 0, 0)
    InputBox.BackgroundTransparency = 1
    InputBox.Text = ""
    InputBox.PlaceholderText = "Paste Key Here..."
    InputBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
    InputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    InputBox.Font = Enum.Font.Gotham
    InputBox.TextSize = 14
    InputBox.Parent = InputFrame

    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Size = UDim2.new(1, -30, 0, 20)
    StatusLabel.Position = UDim2.new(0, 15, 0, 105)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Text = ""
    StatusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
    StatusLabel.Font = Enum.Font.Gotham
    StatusLabel.TextSize = 12
    StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
    StatusLabel.Parent = MainFrame

    -- Reset Error Visual on Typing
    InputBox:GetPropertyChangedSignal("Text"):Connect(function()
        if InputStroke.Color == Color3.fromRGB(255, 80, 80) then
            TweenService:Create(InputStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(50, 50, 50)}):Play()
            TweenService:Create(InputBox, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
            StatusLabel.Text = ""
        end
    end)

    local BtnContainer = Instance.new("Frame")
    BtnContainer.Size = UDim2.new(1, -30, 0, 35)
    BtnContainer.Position = UDim2.new(0, 15, 0, 140)
    BtnContainer.BackgroundTransparency = 1
    BtnContainer.Parent = MainFrame
    local BtnLayout = Instance.new("UIListLayout") BtnLayout.FillDirection = Enum.FillDirection.Horizontal BtnLayout.Padding = UDim.new(0, 10) BtnLayout.Parent = BtnContainer

    local function CreateButton(Text, HoverColor, Func)
        local Btn = Instance.new("TextButton")
        Btn.Size = UDim2.new(0.5, -5, 1, 0)
        Btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        Btn.Text = Text
        Btn.TextColor3 = Color3.fromRGB(200, 200, 200)
        Btn.Font = Enum.Font.GothamBold
        Btn.TextSize = 13
        Btn.Parent = BtnContainer
        local BtnCorner = Instance.new("UICorner") BtnCorner.CornerRadius = UDim.new(0, 6) BtnCorner.Parent = Btn
        local BtnStroke = Instance.new("UIStroke") BtnStroke.Color = Color3.fromRGB(60, 60, 60) BtnStroke.Thickness = 1 BtnStroke.Parent = Btn
        
        Btn.MouseEnter:Connect(function() TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = HoverColor, TextColor3 = Color3.new(1,1,1)}):Play() end)
        Btn.MouseLeave:Connect(function() TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35, 35, 35), TextColor3 = Color3.fromRGB(200,200,200)}):Play() end)
        Btn.MouseButton1Click:Connect(Func)
    end

    -- [BUTTON ACTIONS]
    CreateButton("Get Key", Color3.fromRGB(60, 100, 200), function()
        setclipboard(Settings.Url)
        StatusLabel.Text = "Link copied to clipboard!"
        StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    end)

    CreateButton("Verify", Color3.fromRGB(200, 150, 40), function()
        local InputKey = InputBox.Text
        StatusLabel.Text = "Checking..."
        StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 100)
        
        -- CALL EXTERNAL VALIDATOR
        local IsValid, Reason = Settings.Validate(InputKey)
        
        if IsValid then
            StatusLabel.Text = "Success! Loading..."
            StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
            InputBox.TextEditable = false
            
            TweenService:Create(MainFrame, TweenInfo.new(0.5), {Size = UDim2.new(0, 380, 0, 0), BackgroundTransparency = 1}):Play()
            TweenService:Create(Blur, TweenInfo.new(0.5), {Size = 0}):Play()
            task.wait(0.5)
            ScreenGui:Destroy() Blur:Destroy()
            
            if Settings.Callback then Settings.Callback() end
        else
            -- INVALID STATE
            StatusLabel.Text = "Error: " .. (Reason or "Invalid Key")
            StatusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
            
            -- Red Effect
            TweenService:Create(InputStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(255, 80, 80)}):Play()
            TweenService:Create(InputBox, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(255, 80, 80)}):Play()
            
            -- Shake
            for i = 1, 5 do
                MainFrame.Position = UDim2.new(0.5, -190 + (i%2==0 and -5 or 5), 0.5, -110)
                task.wait(0.05)
            end
            MainFrame.Position = UDim2.new(0.5, -190, 0.5, -110)
        end
    end)

    TweenService:Create(MainFrame, TweenInfo.new(0.5), {BackgroundTransparency = 0}):Play()
end

return KeyLib
