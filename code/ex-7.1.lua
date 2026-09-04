local Monster = script.Parent
local Humanoid = Monster:WaitForChild("mob")         -- 몬스터의 휴머노이드를 가져옵니다
local WayFolder = workspace:WaitForChild("WayPart")  -- 웨이포인트 폴더를 가져옵니다

-- 1. 먼저 Start 파트로 이동합니다
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
        Humanoid:MoveTo(waypoint.Position) -- 다음 웨이포인트로 이동합니다
        Humanoid.MoveToFinished:Wait()     -- 도착할 때까지 기다립니다
        Way += 1                           -- 다음 번호로 넘어갑니다
    else
        break -- 더 이상 웨이포인트가 없으면 멈춥니다
    end
end

-- 3. 마지막으로 Finish 파트로 이동합니다
local finishPart = WayFolder:FindFirstChild("Finish")
if finishPart then
    Humanoid:MoveTo(finishPart.Position)
    Humanoid.MoveToFinished:Wait()
end
