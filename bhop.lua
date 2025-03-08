local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:FindFirstChildWhichIsA("Humanoid")
local rootPart = character:FindFirstChild("HumanoidRootPart")
local autoStrafe = true  -- Включить авто-страйф
local maintainVelocity = true -- Сохранение скорости при приземлении
local jumpPower = 5  -- Увеличена высота прыжка
local forwardBoost = 3  -- Увеличена длина прыжка
local speedBoost = 5 -- Ускорение при прыжке

local currentVelocity = Vector3.new() -- Сохраняем текущую скорость

-- Функция для баннихопа
local function BunnyHop()
    if humanoid and rootPart and humanoid:GetState() ~= Enum.HumanoidStateType.Freefall then
        humanoid.Jump = true
        local moveDirection = humanoid.MoveDirection
        if moveDirection.Magnitude > 0 then
            -- Увеличение скорости при прыжке
            rootPart.Velocity = Vector3.new(moveDirection.X * jumpPower * forwardBoost, jumpPower, moveDirection.Z * jumpPower * forwardBoost)
            -- Ускорение в горизонтальной плоскости
            rootPart.Velocity = rootPart.Velocity * speedBoost
        end
    end
end

-- Авто-страйф
local function AutoStrafe()
    if not autoStrafe then return end
    if humanoid and rootPart then
        local moveDirection = humanoid.MoveDirection
        if moveDirection.Magnitude > 0 then
            rootPart.CFrame = rootPart.CFrame * CFrame.Angles(0, math.rad(2), 0)
        end
    end
end

-- Поддержание скорости
local function MaintainVelocity()
    if not maintainVelocity then return end
    -- Сохраняем горизонтальную скорость и вертикальную составляющую
    if humanoid:GetState() == Enum.HumanoidStateType.Freefall then
        -- Применяем сохранённую скорость, даже если в воздухе
        rootPart.Velocity = Vector3.new(currentVelocity.X, rootPart.Velocity.Y, currentVelocity.Z)
    end
end

-- Обновляем скорость
local function UpdateVelocity()
    if rootPart then
        -- Запоминаем текущую скорость по оси X и Z, игнорируя Y (высоту)
        currentVelocity = Vector3.new(rootPart.Velocity.X, 0, rootPart.Velocity.Z)
    end
end

RunService.RenderStepped:Connect(function()
    UpdateVelocity()

    if UserInputService:IsKeyDown(Enum.KeyCode.Space) and humanoid:GetState() ~= Enum.HumanoidStateType.Freefall then
        BunnyHop()
        AutoStrafe()
        MaintainVelocity()
    end
end)
