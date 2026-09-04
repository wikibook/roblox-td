-- 성 모델과 체력 값을 가져옵니다
local Castle = game.Workspace:WaitForChild("Castle")
local Value = Castle:WaitForChild("Health") -- 성의 체력 IntValue입니다

local MaxHealth = Value.Value -- 성의 최대 체력을 저장합니다

-- GUI 요소들을 가져옵니다
local MainGui = script.Parent
local Frame = MainGui:WaitForChild("Frame")
local Bar = Frame.Frame.Frame  -- 초록색 체력 바입니다
local TextLabel = MainGui:WaitForChild("Health") -- 체력 숫자를 표시합니다

-- 체력이 바뀔 때마다 자동으로 실행됩니다
Value.Changed:Connect(function(newHealth)

	if newHealth <= 0 then
		-- 체력이 0이 되면 체력 바를 완전히 비웁니다
		TextLabel.Text = "0 / " .. MaxHealth
		Bar:TweenSize(
			UDim2.new(0, 0, 1, 0),
			Enum.EasingDirection.Out,
			Enum.EasingStyle.Quart,
			0.1,
			true
		)

	elseif newHealth > MaxHealth then
		-- 체력이 최대 체력보다 커지면 꽉 찬 상태로 유지합니다
		TextLabel.Text = MaxHealth .. " / " .. MaxHealth
		Bar.Size = UDim2.new(1, 0, 1, 0)

	else
		-- 남은 체력의 비율만큼 체력 바 크기를 줄입니다
		-- 예) 체력이 500/1000이면 Current = 0.5 → 체력 바가 절반 크기가 됩니다
		local Current = newHealth / MaxHealth
		TextLabel.Text = newHealth .. " / " .. MaxHealth
		Bar:TweenSize(
			UDim2.new(Current, 0, 1, 0),
			Enum.EasingDirection.Out,
			Enum.EasingStyle.Quart,
			0.1,
			true
		)
	end
end)
