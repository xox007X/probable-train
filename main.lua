local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- ============ ตั้งค่า ============
local ITEM_NAMES = {"Phantom Glow Skull", "Skull", "Drop", "Collect"}
local SCAN_RATE = 0.5

-- ============ สถานะ ============
local autoCollect = false
local totalCollected = 0

-- ============ GUI ============
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 210, 0, 28)
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
Content.Size = UDim2.new(1, 0, 0, 115)
Content.Position = UDim2.new(0, 0, 0, 30)
Content.BackgroundTransparency = 1
Content.Parent = Frame

local BtnToggle = Instance.new("TextButton")
BtnToggle.Size = UDim2.new(0.9, 0, 0, 32)
BtnToggle.Position = UDim2.new(0.05, 0, 0, 5)
BtnToggle.BackgroundColor3 = Color3.fromRGB(40, 160, 40)
BtnToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
BtnToggle.Text = "▶  เปิด Auto Collect"
BtnToggle.TextSize = 13
BtnToggle.Font = Enum.Font.GothamBold
BtnToggle.BorderSizePixel = 0
BtnToggle.Parent = Content
Instance.new("UICorner", BtnToggle).CornerRadius = UDim.new(0, 7)

local StatusLbl = Instance.new("TextLabel")
StatusLbl.Size = UDim2.new(0.9, 0, 0, 20)
StatusLbl.Position = UDim2.new(0.05, 0, 0, 44)
StatusLbl.BackgroundTransparency = 1
StatusLbl.TextColor3 = Color3.fromRGB(160, 160, 160)
StatusLbl.Text = "สถานะ: ปิดอยู่"
StatusLbl.TextSize = 11
StatusLbl.Font = Enum.Font.Gotham
StatusLbl.TextXAlignment = Enum.TextXAlignment.Left
StatusLbl.Parent = Content

local CountLbl = Instance.new("TextLabel")
CountLbl.Size = UDim2.new(0.9, 0, 0, 20)
CountLbl.Position = UDim2.new(0.05, 0, 0, 63)
CountLbl.BackgroundTransparency = 1
CountLbl.TextColor3 = Color3.fromRGB(255, 200, 50)
CountLbl.Text = "เก็บไปแล้ว: 0 ชิ้น"
CountLbl.TextSize = 11
CountLbl.Font = Enum.Font.Gotham
CountLbl.TextXAlignment = Enum.TextXAlignment.Left
CountLbl.Parent = Content

local QueueLbl = Instance.new("TextLabel")
QueueLbl.Size = UDim2.new(0.9, 0, 0, 20)
QueueLbl.Position = UDim2.new(0.05, 0, 0, 82)
QueueLbl.BackgroundTransparency = 1
QueueLbl.TextColor3 = Color3.fromRGB(100, 220, 255)
QueueLbl.Text = "ของในแมพ: -"
QueueLbl.TextSize = 11
QueueLbl.Font = Enum.Font.Gotham
QueueLbl.TextXAlignment = Enum.TextXAlignment.Left
QueueLbl.Parent = Content

-- ============ ลาก GUI ============
local dragging, dragStart, startPos
TitleBar.InputBegan:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = inp.Position
        startPos = Frame.Position
    end
end)
UIS.InputChanged:Connect(function(inp)
    if dragging and inp.UserInputType == Enum.UserInputType.MouseMovement then
        local d = inp.Position - dragStart
        Frame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + d.X,
            startPos.Y.Scale, startPos.Y.Offset + d.Y
        )
    end
end)
UIS.InputEnded:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- ============ ย่อ/ขยาย ============
local minimized = true
BtnMin.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        Frame:TweenSize(UDim2.new(0, 210, 0, 28), "Out", "Quad", 0.2, true)
        BtnMin.Text = "+"
    else
        Frame:TweenSize(UDim2.new(0, 210, 0, 143), "Out", "Quad", 0.2, true)
        BtnMin.Text = "—"
    end
end)

BtnClose.MouseButton1Click:Connect(function()
    autoCollect = false
    ScreenGui:Destroy()
end)

-- ============ หาของทุกชิ้นในแมพ ============
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
                        -- กันซ้ำ (Model กับ Part ของ Model เดียวกัน)
                        local dup = false
                        for _, v in ipairs(list) do
                            if (v.pos - pos).Magnitude < 1 then
                                dup = true break
                            end
                        end
                        if not dup then
                            table.insert(list, {obj = obj, pos = pos})
                        end
                    end
                end
            end
        end
    end
    return list
end

-- ============ เก็บของชิ้นเดียว ============
local function collectOne(item)
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end

    -- วาปไปหาของ
    char.HumanoidRootPart.CFrame = CFrame.new(item.pos + Vector3.new(0, 3, 0))
    task.wait(0.15)

    -- ลอง ProximityPrompt ก่อน
    local function tryPrompt(obj)
        for _, v in ipairs(obj:GetDescendants()) do
            if v:IsA("ProximityPrompt") then
                fireproximityprompt(v)
                return true
            end
        end
        return false
    end

    if not tryPrompt(item.obj) then
        -- ลองหา prompt จาก parent
        if item.obj.Parent then
            tryPrompt(item.obj.Parent)
        end
    end

    totalCollected = totalCollected + 1
    CountLbl.Text = "เก็บไปแล้ว: " .. totalCollected .. " ชิ้น"
    task.wait(0.1)
end

-- ============ ปุ่ม ON/OFF ============
BtnToggle.MouseButton1Click:Connect(function()
    autoCollect = not autoCollect

    if autoCollect then
        BtnToggle.Text = "⏹  ปิด Auto Collect"
        BtnToggle.BackgroundColor3 = Color3.fromRGB(180, 40, 40)

        -- เปิด expand อัตโนมัติ
        if minimized then
            minimized = false
            Frame:TweenSize(UDim2.new(0, 210, 0, 143), "Out", "Quad", 0.2, true)
            BtnMin.Text = "—"
        end

        task.spawn(function()
            while autoCollect do
                local items = getAllItems()

                if #items == 0 then
                    -- ไม่มีของ = หยุดรอ ไม่ทำอะไร
                    StatusLbl.Text = "สถานะ: รอของ..."
                    QueueLbl.Text  = "ของในแมพ: ไม่มี"
                    task.wait(SCAN_RATE)
                else
                    -- มีของ = วนเก็บทีละชิ้นจนหมด
                    QueueLbl.Text = "ของในแมพ: " .. #items .. " ชิ้น"
                    for i, item in ipairs(items) do
                        if not autoCollect then break end
                        StatusLbl.Text = "เก็บชิ้นที่ " .. i .. "/" .. #items
                        collectOne(item)
                    end
                    -- เก็บครบแล้ว สแกนรอบใหม่
                    StatusLbl.Text = "สถานะ: รอของ..."
                    QueueLbl.Text  = "ของในแมพ: ไม่มี"
                end
            end
        end)

    else
        autoCollect = false
        BtnToggle.Text = "▶  เปิด Auto Collect"
        BtnToggle.BackgroundColor3 = Color3.fromRGB(40, 160, 40)
        StatusLbl.Text = "สถานะ: ปิดอยู่"
        QueueLbl.Text  = "ของในแมพ: -"
    end
end)
