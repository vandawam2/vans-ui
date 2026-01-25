local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- [1] KOMPATIBILITAS HTTP REQUEST
local httpRequest = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request

-- [2] NAMA FILE PENYIMPANAN
local KeyFileName = "zupermingkey.txt"

-- [3] LIBRARY START
local KeyLib = {}

function KeyLib:Init(Config)
    local Settings = {
        Title = Config.Title or "Zuperming Key System",
        Url = Config.Url or "https://superminghub.com/getkey",
        Callback = Config.Callback or function() end
    }

    -- Helper: Safe GUI
    local function GetSafeGui()
        local success, result = pcall(function() return (gethui and gethui()) or (game:GetService("CoreGui")) end)
        if not success then return Players.LocalPlayer:WaitForChild("PlayerGui") end
        return result
    end

    -- Hapus UI lama
    for _, v in pairs(GetSafeGui():GetChildren()) do
        if v.Name == "ZupermingKeySys" or v.Name == "ZupermingLoading" then v:Destroy() end
    end

    -------------------------------------------------------------------------
    -- [LOGIC 1] FUNGSI CEK KE SERVER
    -------------------------------------------------------------------------
    local function CheckToServer(inputKey)
        if not httpRequest then return false, "Executor not supported (No HTTP)" end
        
        local Player = Players.LocalPlayer
        local bodyData = {
            key = inputKey,
            username = Player.Name,
            userid = Player.UserId
        }

        local success, response = pcall(function()
            return httpRequest({
                Url = "https://superminghub.com/checkkey", -- Ganti Endpoint Server Kamu
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = HttpService:JSONEncode(bodyData)
            })
        end)

        if success and response and response.StatusCode == 200 then
            local data = HttpService:JSONDecode(response.Body)
            if data.valid == true or data.success == true then
                return true, "Valid"
            else
                return false, data.message or "Invalid Key"
            end
        else
            return false, "Server Error / Timeout"
        end
    end

    -------------------------------------------------------------------------
    -- [LOGIC 2] AUTO-LOAD CHECKER (DENGAN TAMPILAN LOADING)
    -------------------------------------------------------------------------
    local SavedKey = nil
    if _G.KeyMing and type(_G.KeyMing) == "string" and #_G.KeyMing > 0 then
        SavedKey = _G.KeyMing
    elseif isfile(KeyFileName) then
        SavedKey = readfile(KeyFileName)
    end

    if SavedKey then
        -- [BUAT UI LOADING]
        local LoadGui = Instance.new("ScreenGui")
        LoadGui.Name = "ZupermingLoading"
        LoadGui.IgnoreGuiInset = true
        LoadGui.Parent = GetSafeGui()

        local Blur = Instance.new("BlurEffect")
        Blur.Size = 15
        Blur.Parent = game:GetService("Lighting")

        local LoadFrame = Instance.new("Frame")
        LoadFrame.Size = UDim2.new(0, 250, 0, 80)
        LoadFrame.Position = UDim2.new(0.5, -125, 0.5, -40)
        LoadFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        LoadFrame.BorderSizePixel = 0
        LoadFrame.Parent = LoadGui

        local LCorner = Instance.new("UICorner") LCorner.CornerRadius = UDim.new(0, 8) LCorner.Parent = LoadFrame
        local LStroke = Instance.new("UIStroke") LStroke.Color = Color3.fromRGB(255, 215, 0) LStroke.Thickness = 1.5 LStroke.Parent = LoadFrame -- Emas

        local LoadTitle = Instance.new("TextLabel")
        LoadTitle.Size = UDim2.new(1, 0, 0, 30)
        LoadTitle.Position = UDim2.new(0, 0, 0, 10)
        LoadTitle.BackgroundTransparency = 1
        LoadTitle.Text = "Auto-Authenticating"
        LoadTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
        LoadTitle.Font = Enum.Font.GothamBold
        LoadTitle.TextSize = 14
        LoadTitle.Parent = LoadFrame

        local LoadStatus = Instance.new("TextLabel")
        LoadStatus.Size = UDim2.new(1, 0, 0, 20)
        LoadStatus.Position = UDim2.new(0, 0, 0, 40)
        LoadStatus.BackgroundTransparency = 1
        LoadStatus.Text = "Checking saved key..."
        LoadStatus.TextColor3 = Color3.fromRGB(180, 180, 180)
        LoadStatus.Font = Enum.Font.Gotham
        LoadStatus.TextSize = 12
        LoadStatus.Parent = LoadFrame

        -- [PROSES CEK]
        task.wait(0.5) -- Sedikit delay biar user lihat UI nya
        local isValid, msg = CheckToServer(SavedKey)

        if isValid then
            -- [JIKA SUKSES]
            LoadStatus.Text = "Key Verified! Welcome."
            LoadStatus.TextColor3 = Color3.fromRGB(100, 255, 100) -- Hijau
            LStroke.Color = Color3.fromRGB(100, 255, 100)
            task.wait(1)
            
            LoadGui:Destroy()
            Blur:Destroy()

            local HttpService = game:GetService("HttpService")
            local Players = game:GetService("Players")
            
            -- [1] KOMPATIBILITAS EXECUTOR (Penting!)
            -- Mencari fungsi request yang tersedia di executor kamu
            local httpRequest = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
            local bodyData = {
                key = inputKey,
                username = Player.Name,
                userid = Player.UserId -- Opsional: Kirim UserID juga biar lebih aman
            }
    
            local success, response = pcall(function()
                return httpRequest({
                    Url = "https://superminghub.com/loader", -- Pastikan Endpoint Benar
                    Method = "POST",
                    Headers = {
                        ["Content-Type"] = "application/json"
                    },
                    Body = HttpService:JSONEncode(bodyData)
                })
            end)
            if success and response then
                if response.StatusCode == 200 then
                    loadstring(response.Body)()
                else
                    return false, "Server Error: " .. tostring(response.StatusCode)
                end
            else
                return false, "Connection Failed / Timeout"
            end
            
            if Settings.Callback then Settings.Callback() end
            return -- STOP DISINI, TIDAK PERLU LOGIN MANUAL
        else
            -- [JIKA GAGAL / KEY EXPIRED]
            LoadStatus.Text = "Key Expired / Invalid."
            LoadStatus.TextColor3 = Color3.fromRGB(255, 80, 80) -- Merah
            LStroke.Color = Color3.fromRGB(255, 80, 80)
            task.wait(1.5)
            
            -- Hapus file lama dan UI Loading
            if isfile(KeyFileName) then delfile(KeyFileName) end
            LoadGui:Destroy()
            Blur:Destroy()
            -- Lanjut ke pembuatan UI Login Manual di bawah
        end
    end

    -------------------------------------------------------------------------
    -- [LOGIC 3] PEMBUATAN UI LOGIN (MANUAL)
    -------------------------------------------------------------------------
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ZupermingKeySys"
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.Parent = GetSafeGui()

    local Blur = Instance.new("BlurEffect")
    Blur.Size = 0
    Blur.Parent = game:GetService("Lighting")
    TweenService:Create(Blur, TweenInfo.new(0.5), {Size = 15}):Play()

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 380, 0, 220)
    MainFrame.Position = UDim2.new(0.5, -190, 0.5, -110)
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.BackgroundTransparency = 1
    MainFrame.Parent = ScreenGui

    local MainCorner = Instance.new("UICorner") MainCorner.CornerRadius = UDim.new(0, 8) MainCorner.Parent = MainFrame
    local MainStroke = Instance.new("UIStroke") MainStroke.Color = Color3.fromRGB(45, 45, 45) MainStroke.Thickness = 1 MainStroke.Parent = MainFrame

    -- Draggable
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

    -- Close Button
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
        
        -- Cek Validasi Manual
        local IsValid, Reason = CheckToServer(InputKey)
        
        if IsValid then
            StatusLabel.Text = "Success! Loading..."
            StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
            InputBox.TextEditable = false
            
            -- Simpan Key Baru
            writefile(KeyFileName, InputKey)
            
            TweenService:Create(MainFrame, TweenInfo.new(0.5), {Size = UDim2.new(0, 380, 0, 0), BackgroundTransparency = 1}):Play()
            TweenService:Create(Blur, TweenInfo.new(0.5), {Size = 0}):Play()
            task.wait(0.5)
            ScreenGui:Destroy() Blur:Destroy()
            
            if Settings.Callback then Settings.Callback() end
        else
            StatusLabel.Text = "Error: " .. (Reason or "Invalid Key")
            StatusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
            TweenService:Create(InputStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(255, 80, 80)}):Play()
            TweenService:Create(InputBox, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(255, 80, 80)}):Play()
            for i = 1, 5 do MainFrame.Position = UDim2.new(0.5, -190 + (i%2==0 and -5 or 5), 0.5, -110) task.wait(0.05) end
            MainFrame.Position = UDim2.new(0.5, -190, 0.5, -110)
        end
    end)

    TweenService:Create(MainFrame, TweenInfo.new(0.5), {BackgroundTransparency = 0}):Play()
end

return KeyLib
