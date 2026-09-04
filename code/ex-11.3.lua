local Monster = script.Parent
local Humanoid = Monster:WaitForChild("mob")
local WayFolder = workspace:WaitForChild("WayPart")
local CastleHealth = workspace.Castle:WaitForChild("Health")

-- 애니메이션을 재생합니다
-- Humanoid:MoveTo()로 이동하면 걷기 모션이 실행되지만,
-- 커스텀 애니메이션을 별도로 재생해야 팔, 머리 등이 자연스럽게 움직입니다
local Animator = Humanoid:WaitForChild("Animator")  -- 애니메이션을 재생하는 Animator를 가져옵니다
local Animation = Animator:LoadAnimation(Monster:WaitForChild("Animation")) -- 애니메이션 데이터를 불러옵니다
Animation:Play() -- 애니메이션을 시작합니다

-- 1. Start 파트로 이동합니다
local startPart = WayFolder:FindFirstChild("Start")
if startPart then
	Humanoid:MoveTo(startPart.Position)
	Humanoid.MoveToFinished:Wait()
end

-- 2. 숫자 순서대로 웨이포인트를 찾아 이동합니다
local Way = 1
while true do
	local waypoint = WayFolder:FindFirstChild(tostring(Way))
	if waypoint then
		Humanoid:MoveTo(waypoint.Position)
		Humanoid.MoveToFinished:Wait()
		Way += 1
	else
		break
	end
end

-- 3. Finish 파트로 이동합니다
local finishPart = WayFolder:FindFirstChild("Finish")
if finishPart then
	Humanoid:MoveTo(finishPart.Position)
	Humanoid.MoveToFinished:Wait()
end

-- 4. 성에 도달하면 데미지를 주고 몬스터를 삭제합니다
local Damage = Monster:FindFirstChild("Damage")
if Damage then
	CastleHealth.Value = CastleHealth.Value - Damage.Value
end
Monster:Destroy()
