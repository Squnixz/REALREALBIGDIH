local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local OriginalCameraSubject = Workspace.CurrentCamera.CameraSubject

_G.AutoAttackBall = true
_G.AutoFARMCOW = true

local function TrackBall(ball)
    local trackTask = task.spawn(function()
        while _G.AutoFARMCOW and ball.Parent do
            if not Character or not Character.Parent then
                break
            end

            local direction = ball.Velocity.Unit
            local offset = direction * -5
            HumanoidRootPart.CFrame = ball.CFrame * CFrame.new(offset)

            if Character:FindFirstChild("Highlight") then
                ReplicatedStorage:WaitForChild("Remote"):WaitForChild("ParryButtonPress"):Fire()
            end

            task.wait(0.1)
        end

        Workspace.CurrentCamera.CameraSubject = OriginalCameraSubject
    end)

    ball.Destroying:Connect(function()
        task.cancel(trackTask)
    end)
end

local function HandleBall(ball)
    if not ball:IsA("BasePart") then return end

    if _G.AutoFARMCOW then
        TrackBall(ball)
    end

    if _G.AutoAttackBall and ball:GetAttribute("realBall") == true then
        local BallBeforePosition = ball.Position
        local CallTick = tick()

        ball:GetPropertyChangedSignal("Position"):Connect(function()
            if not Character or not Character.Parent then return end
            if not Character:FindFirstChild("Highlight") then return end

            local Distance = (ball.Position - Workspace.CurrentCamera.Focus.Position).Magnitude
            if Distance < 10 then
                    print ("dihling yo mama")
            end
        end)
    end
end

Workspace.Balls.ChildAdded:Connect(HandleBall)

LocalPlayer.CharacterAdded:Connect(function(newCharacter)
    Character = newCharacter
    HumanoidRootPart = newCharacter:WaitForChild("HumanoidRootPart")
end)
