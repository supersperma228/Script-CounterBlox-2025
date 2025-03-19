-- Создаём GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui  

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 250, 0, 220)
Frame.Position = UDim2.new(1, -270, 0, 20)  -- Справа сверху
Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Frame.BorderSizePixel = 2
Frame.BorderColor3 = Color3.fromRGB(100, 100, 100)
Frame.Active = true
Frame.Draggable = true  -- Позволяет перетаскивать окно
Frame.Parent = ScreenGui

-- Заголовок
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Title.Text = "🔥 CheatMenu 🔥"
Title.TextSize = 16
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.Parent = Frame

-- Функция создания кнопок
local function createButton(text, pos, action)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, -20, 0, 35)
    Button.Position = UDim2.new(0.5, -115, 0, pos)
    Button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    Button.Text = text
    Button.TextSize = 14
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.Font = Enum.Font.SourceSansBold
    Button.Parent = Frame
    Button.MouseButton1Click:Connect(action)
    return Button
end

local espLoaded, aimLoaded, bhopLoaded, tracerLoaded = false, false, false, false
local espScript, aimScript, bhopScript, tracerScript = nil, nil, nil, nil

-- Кнопки функций
createButton("ESP [ON]", 40, function()
    if not espLoaded then
        espScript = loadstring(game:HttpGet("https://raw.githubusercontent.com/supersperma228/Script-CounterBlox-2025/refs/heads/main/esp.lua"))()
        espLoaded = true
    else
        if espScript then espScript:Destroy() end
        espLoaded = false
    end
end)

createButton("AimBot [ON]", 80, function()
    if not aimLoaded then
        aimScript = loadstring(game:HttpGet("https://raw.githubusercontent.com/supersperma228/Script-CounterBlox-2025/refs/heads/main/aimbot.lua"))()
        aimLoaded = true
    else
        if aimScript then aimScript:Destroy() end
        aimLoaded = false
    end
end)

createButton("Bhop [ON]", 120, function()
    if not bhopLoaded then
        bhopScript = loadstring(game:HttpGet("https://raw.githubusercontent.com/supersperma228/Script-CounterBlox-2025/refs/heads/main/bhop.lua"))()
        bhopLoaded = true
    else
        if bhopScript then bhopScript:Destroy() end
        bhopLoaded = false
    end
end)

createButton("Tracer [ON]", 160, function()
    if not tracerLoaded then
        tracerScript = loadstring(game:HttpGet("https://raw.githubusercontent.com/supersperma228/Script-CounterBlox-2025/refs/heads/main/bhop.lua"))()
        tracerLoaded = true
    else
        if tracerScript then tracerScript:Destroy() end
        tracerLoaded = false
    end
end)

-- Скрытие и показ меню на Insert
local menuVisible = true
game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.Insert then
        menuVisible = not menuVisible
        Frame.Visible = menuVisible
    end
end)
