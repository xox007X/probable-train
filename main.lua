local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local SCAN_RATE = 0.5
local COLLECT_RADIUS = 50
local ITEM_NAMES = {}
local autoCollect = false
local totalCollected = 0

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 220, 0, 28)
Frame.Position = UDim2.new(0, 15, 0, 120)
Frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Frame.BorderSizePixel = 0
Frame.ClipsDescendants = true
Frame.Parent = ScreenGui
Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8)

local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 28)
TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = Frame
Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 8)

local TitleTxt = Instance.new("TextLabel")
TitleTxt.Size = UDim2.new(1, -55, 1, 0)
TitleTxt.Position = UDim2.new(0, 8, 0, 0)
TitleTxt.BackgroundTransparency = 1
TitleTxt.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleTxt.Text = "💎 AutoCollect"
TitleTxt.TextSize = 12
TitleTxt.Font = Enum.Font.GothamBold
TitleTxt.TextXAlignment = Enum.TextXAlignment.Left
TitleTxt.Parent = TitleBar

local BtnMin = Instance.new("TextButton")
BtnMin.Size = UDim2.new(0, 22, 0, 18)
BtnMin.Position = UDim2.new(1, -47, 0.5, -9)
BtnMin.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
BtnMin.TextColor3 = Color3.fromRGB(255, 255, 255)
BtnMin.Text = "+"
BtnMin.TextSize = 11
BtnMin.Font = Enum.Font.GothamBold
BtnMin.BorderSizePixel = 0
BtnMin.Parent = TitleBar
Instance.new("UICorner", BtnMin).CornerRadius = UDim.new(0, 4)

local BtnClose = Instance.new("TextButton")
BtnClose.Size = UDim2.new(0, 22, 0, 18)
BtnClose.Position = UDim2.new(1, -22, 0.5, -9)
BtnClose.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
BtnClose.TextColor3 = Color3.fromRGB(255, 255, 255)
BtnClose.Text = "✕"
BtnClose.TextSize = 11
BtnClose.Font = Enum.Font.GothamBold
BtnClose.BorderSizePixel = 0
BtnClose.Parent = TitleBar
Instance.new("UICorner", BtnClose).CornerRadius = UDim.new(0, 4)

local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, 0, 0, 260)
Content.Position = UDim2.new(0, 0, 0, 30)
Content.BackgroundTransparency = 1
Content.Parent = Frame

local BtnToggle = Instance.new("TextButton")
BtnToggle.Size = UDim2.new(0.9, 0, 0, 32)
BtnToggle.Position = UDim2.new(0.05, 0, 0, 5)
BtnToggle.BackgroundColor3 = Color3.fromRGB(40, 160, 40)
BtnToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
BtnToggle.Text = "▶ Auto Collect"
BtnToggle.TextSize = 13
BtnToggle.Font = Enum.Font.GothamBold
BtnToggle.BorderSizePixel = 0
BtnToggle.Parent = Content
Instance.new("UICorner", BtnToggle).CornerRadius = UDim.new(0, 7)

local StatusLbl = Instance.new("TextLabel")
StatusLbl.Size = UDim2.new(0.9, 0, 0, 18)
StatusLbl.Position = UDim2.new(0.05, 0, 0, 44)
StatusLbl.BackgroundTransparency = 1
StatusLbl.TextColor3 = Color3.fromRGB(160, 160, 160)
StatusLbl.Text = "สถานะ: ปิดอยู่"
StatusLbl.TextSize = 11
StatusLbl.Font = Enum.Font.Gotham
StatusLbl.TextXAlignment = Enum.TextXAlignment.Left
StatusLbl.Parent = Content

local CountLbl = Instance.new("TextLabel")
CountLbl.Size = UDim2.new(0.9, 0, 0, 18)
CountLbl.Position = UDim2.new(0.05, 0, 0, 62)
CountLbl.BackgroundTransparency = 1
CountLbl.TextColor3 = Color3.fromRGB(255, 200, 50)
CountLbl.Text = "เก็บไปแล้ว: 0 ชิ้น"
CountLbl.TextSize = 11
CountLbl.Font = Enum.Font.Gotham
CountLbl.TextXAlignment = Enum.TextXAlignment.Left
CountLbl.Parent = Content

local QueueLbl = Instance.new("TextLabel")
QueueLbl.Size = UDim2.new(0.9, 0, 0, 18)
QueueLbl.Position = UDim2.new(0.05, 0, 0, 80)
QueueLbl.BackgroundTransparency = 1
QueueLbl.TextColor3 = Color3.fromRGB(100, 220, 255)
QueueLbl.Text = "ของในแมพ: -"
QueueLbl.TextSize = 11
QueueLbl.Font = Enum.Font.Gotham
QueueLbl.TextXAlignment = Enum.TextXAlignment.Left
QueueLbl.Parent = Content

local Line = Instance.new("Frame")
Line.Size = UDim2.new(0.9, 0, 0, 1)
Line.Position = UDim2.new(0.05, 0, 0, 104)
Line.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
Line.BorderSizePixel = 0
Line.Parent = Content

local ItemTitle = Instance.new("TextLabel")
ItemTitle.Size = UDim2.new(0.9, 0, 0, 18)
ItemTitle.Position = UDim2.new(0.05, 0, 0, 110)
ItemTitle.BackgroundTransparency = 1
ItemTitle.TextColor3 = Color3.fromRGB(255, 180, 50)
ItemTitle.Text = "📋 ชื่อของที่จะเก็บ:"
ItemTitle.TextSize = 11
ItemTitle.Font = Enum.Font.GothamBold
ItemTitle.TextXAlignment = Enum.TextXAlignment.Left
ItemTitle.Parent = Content

local InputBox = Instance.new("TextBox")
InputBox.Size = UDim2.new(0.7, 0, 0, 26)
InputBox.Position = UDim2.new(0.05, 0, 0, 130)
InputBox.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
InputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
InputBox.PlaceholderText = "พิมพ์ชื่อของ..."
InputBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
InputBox.Text = ""
InputBox.TextSize = 11
InputBox.Font = Enum.Font.Gotham
InputBox.BorderSizePixel = 0
InputBox.ClearTextOnFocus = false
InputBox.Parent = Content
Instance.new("UICorner", InputBox).CornerRadius = UDim.new(0, 6)

local BtnAdd = Instance.new("TextButton")
BtnAdd.Size = UDim2.new(0.22, 0, 0, 26)
BtnAdd.Position = UDim2.new(0.76, 0, 0, 130)
BtnAdd.BackgroundColor3 = Color3.fromRGB(50, 130, 220)
BtnAdd.TextColor3 = Color3.fromRGB(255, 255, 255)
BtnAdd.Text = "+ เพิ่ม"
BtnAdd.TextSize = 11
BtnAdd.Font = Enum.Font.GothamBold
BtnAdd.BorderSizePixel = 0
BtnAdd.Parent = Content
Instance.new("UICorner", BtnAdd).CornerRadius = UDim.new(0, 6)

local BtnScan = Instance.new("TextButton")
BtnScan.Size = UDim2.new(0.9, 0, 0, 26)
BtnScan.Position = UDim2.new(0.05, 0, 0, 162)
BtnScan.BackgroundColor3 = Color3.fromRGB(120, 50, 200)
BtnScan.TextColor3 = Color3.fromRGB(255, 255, 255)
BtnScan.Text = "🔍 สแกนหาของในแมพ"
BtnScan.TextSize = 11
BtnScan.Font = Enum.Font.GothamBold
BtnScan.BorderSizePixel = 0
BtnScan.Parent = Content
Instance.new("UICorner", BtnScan).CornerRadius = UDim.new(0, 6)

local ListLbl = Instance.new("TextLabel")
ListLbl.Size = UDim2.new(0.9, 0, 0, 60)
ListLbl.Position = UDim2.new(0.05, 0, 0, 194)
ListLbl.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
ListLbl.TextColor3 = Color3.fromRGB(150, 255, 150)
ListLbl.Text = "ยังไม่มีชื่อของ"
ListLbl.TextSize = 10
ListLbl.Font = Enum.Font.Gotham
ListLbl.TextXAlignment = Enum.TextXAlignment.Left
ListLbl.TextYAlignment = Enum.TextYAlignment.Top
ListLbl.TextWrapped = true
ListLbl.BorderSizePixel = 0
ListLbl.Parent = Content
local lp = Instance.new("UIPadding", ListLbl)
lp.PaddingLeft = UDim.new(0, 5)
lp.PaddingTop = UDim.new(0, 4)
Instance.new("UICorner", ListLbl).CornerRadius = UDim.new(0, 6)

local BtnClearList = Instance.new("TextButton")
BtnClearList.Size = UDim2.new(0.9, 0, 0, 22)
BtnClearList.Position = UDim2.new(0.05, 0, 0, 258)
BtnClearList.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
BtnClearList.TextColor3 = Color3.fromRGB(255, 255, 255)
BtnClearList.Text = "🗑 ล้างรายการทั้งหมด"
BtnClearList.TextSize = 11
BtnClearList.Font = Enum.Font.Gotham
BtnClearList.BorderSizePixel = 0
BtnClearList.Parent = Content
Instance.new("UICorner", BtnClearList).CornerRadius = UDim.new(0, 6)

-- ============ ลาก GUI (รองรับมือถือ + PC) ============
local dragging = false
local dragStartPos = nil
local frameStartPos = nil
local camera = workspace.CurrentCamera

local function onDragStart(pos)
    dragging = true
    dragStartPos = pos
    frameStartPos = Frame.Position
end

local function onDragMove(pos)
    if not dragging then return end
    local d = pos - dragStartPos
    local sx = camera.ViewportSize.X
    local sy = camera.ViewportSize.Y
    local nx = math.clamp(frameStartPos.X.Offset + d.X, 0, sx - Frame.AbsoluteSize.X)
    local ny = math.clamp(frameStartPos.Y.Offset + d.Y, 0, sy - Frame.AbsoluteSize.Y)
    Frame.Position = UDim2.new(0, nx, 0, ny)
end

local function onDragEnd()
    dragging = false
end

-- รองรับทั้ง PC (Mouse) และมือถือ (Touch)
TitleBar.InputBegan:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1
    or inp.UserInputType == Enum.UserInputType.Touch then
        onDragStart(inp.Position)
    end
end)

TitleBar.InputChanged:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseMovement
    or inp.UserInputType == Enum.UserInputType.Touch then
        onDragMove(inp.Position)
    end
end)

TitleBar.InputEnded:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1
    or inp.UserInputType == Enum.UserInputType.Touch then
        onDragEnd()
    end
end)

-- ============ ย่อ/ขยาย ============
local minimized = true
BtnMin.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        Frame:TweenSize(UDim2.new(0, 220, 0, 28), "Out", "Quad", 0.2, true)
        BtnMin.Text = "+"
    else
        Frame:TweenSize(UDim2.new(0, 220, 0, 295), "Out", "Quad", 0.2, true)
        BtnMin.Text = "—"
    end
end)

BtnClose.MouseButton1Click:Connect(function()
    autoCollect = false
    ScreenGui:Destroy()
end)

local function updateList()
    if #ITEM_NAMES == 0 then
        ListLbl.Text = "ยังไม่มีชื่อของ"
    else
        ListLbl.Text = table.concat(ITEM_NAMES, "\n")
    end
end

BtnAdd.MouseButton1Click:Connect(function()
    local txt = InputBox.Text
    if txt == "" then return end
    for _, v in ipairs(ITEM_NAMES) do
        if string.lower(v) == string.lower(txt) then
            StatusLbl.Text = "มีอยู่แล้ว!"
            return
        end
    end
    table.insert(ITEM_NAMES, txt)
    InputBox.Text = ""
    updateList()
    StatusLbl.Text = "เพิ่ม: " .. txt
end)

BtnClearList.MouseButton1Click:Connect(function()
    ITEM_NAMES = {}
    updateList()
    StatusLbl.Text = "ล้างรายการแล้ว"
end)

BtnScan.MouseButton1Click:Connect(function()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local myPos = char.HumanoidRootPart.Position
    local found = {}
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") or obj:IsA("Model") then
            local pos
            if obj:IsA("Model") and obj.PrimaryPart then
                pos = obj.PrimaryPart.Position
            elseif obj:IsA("BasePart") then
                pos = obj.Position
            end
            if pos and (myPos - pos).Magnitude <= COLLECT_RADIUS then
                local n = obj.Name
                if n ~= "Baseplate" and n ~= "Part" and n ~= "HumanoidRootPart"
                    and n ~= "Head" and n ~= "Torso" and n ~= "" then
                    local dup = false
                    for _, v in ipairs(found) do if v == n then dup = true break end end
                    for _, v in ipairs(ITEM_NAMES) do if string.lower(v) == string.lower(n) then dup = true break end end
                    if not dup then table.insert(found, n) end
                end
            end
        end
    end
    if #found == 0 then
        StatusLbl.Text = "สแกนไม่เจออะไรใกล้ๆ"
    else
        StatusLbl.Text = "เจอ " .. #found .. " อย่าง"
        InputBox.Text = found[1]
        for _, v in ipairs(found) do print("  - " .. v) end
    end
end)

-- ============ หาของทุกชิ้น ============
local function getAllItems()
    local list = {}
    for _, obj in ipairs(workspace:GetDescendants()) do
        for _, name in ipairs(ITEM_NAMES) do
            if string.find(string.lower(obj.Name), string.lower(name)) then
                if obj:IsA("BasePart") or obj:IsA("Model") then
                    local pos
                    if obj:IsA("Model") and obj.PrimaryPart then
                        pos = obj.PrimaryPart.Position
                    elseif obj:IsA("BasePart") then
                        pos = obj.Position
                    end
                    if pos then
                        local dup = false
                        for _, v in ipairs(list) do if (v.pos - pos).Magnitude < 1 then dup = true break end end
                        if not dup then table.insert(list, {obj = obj, pos = pos}) end
                    end
                end
            end
        end
    end
    return list
end

-- ============ เก็บของ (รองรับหลายวิธี) ============
local function collectOne(item)
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end

    -- วาปชิดมากๆ
    char.HumanoidRootPart.CFrame = CFrame.new(item.pos + Vector3.new(0, 2, 0))
    task.wait(0.2)

    -- วิธีที่ 1: ProximityPrompt
    local collected = false
    local function tryPrompt(obj)
        for _, v in ipairs(obj:GetDescendants()) do
            if v:IsA("ProximityPrompt") then
                pcall(function() fireproximityprompt(v) end)
                collected = true
                return true
            end
        end
        return false
    end

    if not tryPrompt(item.obj) then
        if item.obj.Parent then tryPrompt(item.obj.Parent) end
    end

    -- วิธีที่ 2: แตะ TouchInterest
    if not collected then
        for _, v in ipairs(item.obj:GetDescendants()) do
            if v:IsA("TouchTransmitter") then
                pcall(function() firetouchinterest(char.HumanoidRootPart, item.obj, 0) end)
                collected = true
                break
            end
        end
    end

    -- วิธีที่ 3: ClickDetector
    if not collected then
        for _, v in ipairs(item.obj:GetDescendants()) do
            if v:IsA("ClickDetector") then
                pcall(function() fireclickdetector(v) end)
                collected = true
                break
            end
        end
    end

    totalCollected = totalCollected + 1
    CountLbl.Text = "เก็บไปแล้ว: " .. totalCollected .. " ชิ้น"
    task.wait(0.15)
end

-- ============ ON/OFF ============
BtnToggle.MouseButton1Click:Connect(function()
    if #ITEM_NAMES == 0 then
        StatusLbl.Text = "❌ เพิ่มชื่อของก่อนนะ!"
        return
    end
    autoCollect = not autoCollect
    if autoCollect then
        BtnToggle.Text = "⏹ หยุด"
        BtnToggle.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
        if minimized then
            minimized = false
            Frame:TweenSize(UDim2.new(0, 220, 0, 295), "Out", "Quad", 0.2, true)
            BtnMin.Text = "—"
        end
        task.spawn(function()
            while autoCollect do
                local items = getAllItems()
                if #items == 0 then
                    StatusLbl.Text = "รอของ..."
                    QueueLbl.Text  = "ของในแมพ: ไม่มี"
                    task.wait(SCAN_RATE)
                else
                    QueueLbl.Text = "ของในแมพ: " .. #items .. " ชิ้น"
                    for i, item in ipairs(items) do
                        if not autoCollect then break end
                        StatusLbl.Text = "เก็บชิ้นที่ " .. i .. "/" .. #items
                        collectOne(item)
                    end
                    StatusLbl.Text = "รอของ..."
                    QueueLbl.Text  = "ของในแมพ: ไม่มี"
                end
            end
        end)
    else
        autoCollect = false
        BtnToggle.Text = "▶ Auto Collect"
        BtnToggle.BackgroundColor3 = Color3.fromRGB(40, 160, 40)
        StatusLbl.Text = "สถานะ: ปิดอยู่"
        QueueLbl.Text  = "ของในแมพ: -"
    end
end)
