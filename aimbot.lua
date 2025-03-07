-- Основные сервисы
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

-- Локальный игрок
local LocalPlayer = Players.LocalPlayer

-- Настройки аимбота
local AimEnabled = true -- Включение/выключение аимбота
local AimKey = Enum.UserInputType.MouseButton2 -- Клавиша зажатия (ПКМ)
local Smoothness = 0.1 -- Насколько плавно наводится (0.1 - быстро, 0.05 - мягче)

local Aiming = false -- Флаг для отслеживания зажатия кнопки

-- Функция поиска всех камер
local function GetAllCameras()
    local cameras = {}

    -- Добавляем стандартную камеру
    if Workspace.CurrentCamera then
        table.insert(cameras, Workspace.CurrentCamera)
    end

    -- Добавляем кастомные камеры, если они есть
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("Camera") and obj ~= Workspace.CurrentCamera then
            table.insert(cameras, obj)
        end
    end

    return cameras
end

-- Функция для поиска ближайшей головы к прицелу
local function GetNearestTarget(camera)
    local closestPlayer = nil
    local closestDist = math.huge

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local head = player.Character:FindFirstChild("Head")
            if head then
                local screenPos, onScreen = camera:WorldToViewportPoint(head.Position)
                if onScreen then
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)).Magnitude
                    if dist < closestDist then
                        closestDist = dist
                        closestPlayer = head
                    end
                end
            end
        end
    end

    return closestPlayer
end

-- Функция для наведения камеры на голову
local function AimAt(camera, target)
    if target then
        -- Интерполируем текущий поворот камеры к цели (плавность регулируется Smoothness)
        camera.CFrame = camera.CFrame:Lerp(CFrame.new(camera.CFrame.Position, target.Position), Smoothness)
    end
end

-- Цикл наведения, пока зажата кнопка
RunService.RenderStepped:Connect(function()
    if Aiming and AimEnabled then
        for _, camera in pairs(GetAllCameras()) do
            local target = GetNearestTarget(camera)
            AimAt(camera, target)
        end
    end
end)

-- Обработчик нажатия клавиши (ПКМ)
UserInputService.InputBegan:Connect(function(input)
    if input.UserInputType == AimKey then
        Aiming = true -- Начинаем наводку
    end
end)

-- Обработчик отпускания клавиши (ПКМ)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == AimKey then
        Aiming = false -- Останавливаем наводку
    end
end)
