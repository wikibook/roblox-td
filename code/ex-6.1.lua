-- 몬스터와 필요한 요소들을 가져옵니다
local Monster = script.Parent.Parent.Parent
local Humanoid = Monster:FindFirstChildOfClass("Humanoid") -- 휴머노이드를 찾습니다

local Frame = script.Parent.Frame.Frame:WaitForChild("Frame") -- 초록색 체력 바입니다
local TextLabel = script.Parent:WaitForChild("TextLabel")     -- 체력 숫자를 표시합니다

local MaxHealth = Humanoid.MaxHealth -- 몬스터의 최대 체력을 저장합니다

-- 체력이 바뀔 때마다 자동으로 실행됩니다
Humanoid.HealthChanged:Connect(function(Health)
    -- 현재 체력을 최대 체력으로 나눠서 체력 바의 비율을 구합니다
    -- 예) 체력이 75/150이면 Ratio = 0.5 → 체력 바가 절반 크기가 됩니다
    local Ratio = Health / MaxHealth

    if Health <= 0 then
        -- 체력이 0이 되면 체력 바를 없애고 몬스터를 삭제합니다
        Frame.Size = UDim2.new(0, 0, 1, 0)
        TextLabel.Text = "0 / " .. MaxHealth
        Monster:Destroy()
    else
        -- 남은 체력만큼 초록색 바의 크기를 줄입니다
        Frame.Size = UDim2.new(Ratio, 0, 1, 0)
        TextLabel.Text = math.floor(Health) .. " / " .. MaxHealth
    end
end)
