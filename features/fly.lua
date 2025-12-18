return function()
    local RunService = game:GetService("RunService")
    local UIS = game:GetService("UserInputService")
    local plr = game.Players.LocalPlayer
    local char = plr.Character or plr.CharacterAdded:Wait()
    local hum = char:WaitForChild("Humanoid")
    local hrp = char:WaitForChild("HumanoidRootPart")

    hum.PlatformStand = true

    local bv = Instance.new("BodyVelocity", hrp)
    local bg = Instance.new("BodyGyro", hrp)
    bv.MaxForce = Vector3.new(9e9,9e9,9e9)
    bg.MaxTorque = Vector3.new(9e9,9e9,9e9)

    RunService.RenderStepped:Connect(function()
        local cam = workspace.CurrentCamera
        local dir = Vector3.zero
        if UIS:IsKeyDown(Enum.KeyCode.W) then dir += cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then dir -= cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then dir -= cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then dir += cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.yAxis end
        if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then dir -= Vector3.yAxis end

        bv.Velocity = dir.Magnitude > 0 and dir.Unit * 50 or Vector3.zero
        bg.CFrame = cam.CFrame
    end)
end
