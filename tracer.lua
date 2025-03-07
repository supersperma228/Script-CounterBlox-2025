local Players = game:GetService("Players")
local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- Функция для создания трейсеров
local function createTracer(startPos, endPos)
    local tracer = Instance.new("Part")
    tracer.Size = Vector3.new(0.2, 0.2, (startPos - endPos).Magnitude) -- Длина трейса
    tracer.CFrame = CFrame.lookAt(startPos, endPos) * CFrame.new(0, 0, -tracer.Size.Z / 2) -- Направление
    tracer.Anchored = true
    tracer.CanCollide = false
    tracer.Material = Enum.Material.Neon
    tracer.Color = Color3.fromRGB(255, 0, 0) -- Начальный цвет (будет меняться)
    tracer.Transparency = 0.9 -- Начальная прозрачность (почти прозрачный)
    tracer.Parent = game.Workspace

    -- Плавное изменение прозрачности и цвета
    local tweenService = game:GetService("TweenService")
    local tweenInfo = TweenInfo.new(3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out) -- 3 секунды для изменения

    -- Изменяем прозрачность (становится менее прозрачным) и цвет (становится ярким красным)
    local goal = {Transparency = 0.4, Color = Color3.fromRGB(255, 0, 0)} -- Конечные значения
    local tween = tweenService:Create(tracer, tweenInfo, goal)
    tween:Play()

    -- Удаление трейса через 1.5 секунды
    task.delay(1.5, function()
        tracer:Destroy()
    end)
end

-- Таймер для стрельбы
local shooting = false
local function startShooting()
    shooting = true
    while shooting do
        if player.Character then
            local gunPos = player.Character.Head.Position -- Позиция головы (можно поменять на оружие)
            local targetPos = mouse.Hit.Position -- Позиция прицела
            createTracer(gunPos, targetPos) -- Создаём трейсер
        end
        wait(0.2) -- Трейсер создается каждые 0.2 секунды при удержании кнопки
    end
end

local function stopShooting()
    shooting = false
end

-- Обработка кнопки мыши
mouse.Button1Down:Connect(function()
    startShooting() -- Начинаем спавнить трейсер
end)

mouse.Button1Up:Connect(function()
    stopShooting() -- Останавливаем спавн трейсеров
end)
