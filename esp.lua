-- Основные переменные
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = game.Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")

-- Таблица для хранения ESP объектов
local ESPObjects = {}

-- Функция для создания ESP боксов, линий, никнеймов и здоровья
local function CreateESP(entity)
    -- Пропускаем создание ESP для персонажа игрока
    if entity == LocalPlayer.Character then
        return
    end

    if ESPObjects[entity] then return end  -- Если уже создан, пропускаем

    local rootPart = entity:FindFirstChild("HumanoidRootPart")
    local humanoid = entity:FindFirstChild("Humanoid")
    if not rootPart or not humanoid then return end -- Проверяем, живое ли это существо

    -- Создание GUI для ESP
    local box = Drawing.new("Square")
    box.Visible = false
    box.Color = Color3.fromRGB(255, 0, 0) -- Красный цвет
    box.Thickness = 2
    box.Filled = false

    local line = Drawing.new("Line")
    line.Visible = false
    line.Color = Color3.fromRGB(255, 0, 0) -- Красный цвет
    line.Thickness = 1

    local nameTag = Drawing.new("Text")
    nameTag.Visible = false
    nameTag.Color = Color3.fromRGB(255, 255, 255) -- Белый цвет для имени
    nameTag.Size = 8  -- Меньше для ников
    nameTag.Center = true
    nameTag.Outline = true

    local healthBar = Drawing.new("Line")
    healthBar.Visible = false
    healthBar.Color = Color3.fromRGB(0, 255, 0) -- Зелёный цвет для здоровья
    healthBar.Thickness = 2

    ESPObjects[entity] = {box = box, line = line, nameTag = nameTag, healthBar = healthBar}

    -- Функция обновления ESP
    local function Update()
        if entity.Parent and rootPart and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local localRootPart = LocalPlayer.Character.HumanoidRootPart
            local screenPos, onScreen = Camera:WorldToViewportPoint(rootPart.Position)

            -- Проверяем разницу по высоте
            local heightDiff = math.abs(localRootPart.Position.Y - rootPart.Position.Y)
            if heightDiff > 50 then -- Существо слишком высоко или низко, не отрисовываем
                box.Visible = false
                line.Visible = false
                nameTag.Visible = false
                healthBar.Visible = false
                return
            end

            if onScreen then
                -- Расстояние между игроками
                local distance = (localRootPart.Position - rootPart.Position).Magnitude

                -- Размер бокса (увеличиваем боксы ещё больше)
                local size = Vector2.new(2500 / screenPos.Z, 4000 / screenPos.Z)  -- Увеличиваем размеры боксов
                local position = Vector2.new(screenPos.X - size.X / 2, screenPos.Y - size.Y / 2)

                -- Плавное изменение размера
                box.Size = size
                box.Position = position
                box.Visible = true

                -- Линия от низа экрана
                line.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                line.To = Vector2.new(screenPos.X, screenPos.Y + size.Y / 2)
                line.Visible = true

                -- Ники над игроками
                local nameSize = math.clamp(9 - (distance / 80), 6, 10)  -- Уменьшаем размер шрифта в зависимости от расстояния
                nameTag.Size = nameSize
                nameTag.Position = Vector2.new(screenPos.X, screenPos.Y - size.Y / 2 - 10)  -- Позиция чуть выше бокса
                nameTag.Text = entity.Name
                nameTag.Visible = true

                -- Отображение здоровья справа (с учётом размера бокса)
                local health = humanoid.Health / humanoid.MaxHealth
                local healthHeight = size.Y * health  -- Размер полосы здоровья пропорционален высоте бокса
                healthBar.From = Vector2.new(screenPos.X + size.X / 2 + 5, screenPos.Y - size.Y / 2)
                healthBar.To = Vector2.new(screenPos.X + size.X / 2 + 5, screenPos.Y - size.Y / 2 + healthHeight)
                healthBar.Visible = true
            else
                box.Visible = false
                line.Visible = false
                nameTag.Visible = false
                healthBar.Visible = false
            end
        else
            box.Visible = false
            line.Visible = false
            nameTag.Visible = false
            healthBar.Visible = false
        end
    end

    -- Подключаем к циклу обновления
    local connection
    connection = RunService.RenderStepped:Connect(Update)

    -- Удаляем ESP, если существо умерло или удалено
    if humanoid then
        humanoid.Died:Connect(function()
            connection:Disconnect()
            box:Remove()
            line:Remove()
            nameTag:Remove()
            healthBar:Remove()
            ESPObjects[entity] = nil
        end)
    end

    entity.AncestryChanged:Connect(function(_, parent)
        if not parent then
            connection:Disconnect()
            box:Remove()
            line:Remove()
            nameTag:Remove()
            healthBar:Remove()
            ESPObjects[entity] = nil
        end
    end)
end

-- Функция для обновления ESP у всех существ
local function RefreshESP()
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj:FindFirstChild("HumanoidRootPart") then
            CreateESP(obj)
        end
    end
end

-- Добавление ESP для всех существ
RefreshESP()

-- Автоматически добавлять ESP новым существам
Workspace.DescendantAdded:Connect(function(obj)
    wait(0.1) -- Даем немного времени на загрузку объекта
    if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj:FindFirstChild("HumanoidRootPart") then
        CreateESP(obj)
    end
end)

-- Проверка на выход/вход существа
Workspace.DescendantRemoved:Connect(function(obj)
    if obj:IsA("Model") and ESPObjects[obj] then
        local espObj = ESPObjects[obj]
        espObj.box:Remove()
        espObj.line:Remove()
        espObj.nameTag:Remove()
        espObj.healthBar:Remove()
        ESPObjects[obj] = nil
    end
end)

-- Обновление ESP каждые 5 секунд (если вдруг кто-то пропал)
while true do
    wait(5)
    RefreshESP()
end
