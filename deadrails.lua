local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

local enemiesFolder = nil
for _, v in pairs(workspace:GetChildren()) do
    if v:IsA("Folder") and v:FindFirstChildWhichIsA("Model") and v.Name:lower():find("enemy") then
        enemiesFolder = v
        break
    end
end

if not enemiesFolder then
    warn("Không tìm thấy folder chứa quái. Tự kiểm tra lại tên folder!")
    return
end

RunService.RenderStepped:Connect(function()
    for _, enemy in pairs(enemiesFolder:GetChildren()) do
        if enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") then
            local hrp = enemy.HumanoidRootPart
            hrp.Size = Vector3.new(10,10,10)
            hrp.Transparency = 0.6
            hrp.Material = Enum.Material.ForceField
            hrp.BrickColor = BrickColor.new("Really red")
            hrp.CanCollide = false

            if not hrp:FindFirstChild("ESP") then
                local billboard = Instance.new("BillboardGui", hrp)
                billboard.Name = "ESP"
                billboard.Size = UDim2.new(4,0,1,0)
                billboard.AlwaysOnTop = true

                local label = Instance.new("TextLabel", billboard)
                label.Size = UDim2.new(1,0,1,0)
                label.BackgroundTransparency = 1
                label.Text = enemy.Name
                label.TextColor3 = Color3.new(1,0,0)
                label.TextScaled = true
                label.Font = Enum.Font.SourceSansBold
            end
        end
    end
end)

task.spawn(function()
    while task.wait(0.1) do
        if not LocalPlayer.Character then continue end
        local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
        if not tool then continue end

        for _, enemy in pairs(enemiesFolder:GetChildren()) do
            local hrp = enemy:FindFirstChild("HumanoidRootPart")
            local hum = enemy:FindFirstChildOfClass("Humanoid")
            if hrp and hum and hum.Health > 0 then
                local dist = (hrp.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                if dist < 10 then
                    tool:Activate()
                end
            end
        end
    end
end)