local Wave = 0       -- 현재 웨이브 번호
local WaveTime = 5   -- 웨이브 사이의 대기 시간(초)

-- 게임에 필요한 요소들을 가져옵니다
local CastleHealth = game.Workspace.Castle:WaitForChild("Health") -- 성의 체력 값을 가져옵니다
local Waves        = game.ReplicatedStorage:WaitForChild("Waves") -- 웨이브마다 어떤 몬스터가 나오는지 설정한 폴더입니다
local Mobs         = game.ReplicatedStorage:WaitForChild("Mobs") -- 몬스터 모델들이 들어있는 폴더입니다
local WayPart      = game.Workspace:WaitForChild("WayPart") -- 몬스터가 이동할 길을 설정한 폴더입니다
local RemoteEvent  = game.ReplicatedStorage:WaitForChild("GuiEvent") -- 리모트 이벤트로 웨이브 번호를 모든 플레이어에게 보냅니다

-- 몬스터 한 마리를 시작 지점에 스폰하는 함수입니다
local function MobSpawn(MobValue)
    local Mob = Mobs:FindFirstChild(MobValue.Name)
    if not Mob then return end -- 해당 몬스터가 없으면 넘어갑니다

    local Clone = Mob:Clone()
    Clone.Parent = game.Workspace        -- Workspace에 배치합니다
    Clone:MoveTo(WayPart.Start.Position) -- 시작 지점으로 이동합니다

    -- 서버가 몬스터를 직접 제어하도록 설정합니다 (멈춤 현상 방지)
    for _, part in ipairs(Clone:GetDescendants()) do
        if part:IsA("BasePart") then
            part:SetNetworkOwner(nil)
        end
    end
end

-- 한 웨이브의 몬스터를 모두 스폰하는 함수입니다
local function Main(Set)
	--	웨이브 폴더 안에 있는 모든 밸류를 구합니다 (각 몬스터 종류와 수량이 설정된 밸류들)
    for _, MobValue in ipairs(Set:GetChildren()) do
        -- 해당 몬스터를 Value에 설정된 수만큼 스폰합니다 (예: Value가 5면 몬스터 5마리를 스폰)
        for i = 1, MobValue.Value do
            task.spawn(function() -- 몬스터마다 별도로 실행합니다
                MobSpawn(MobValue) -- 몬스터 스폰 함수 실행
            end)
            task.wait(1) -- 몬스터 한 마리가 나온 후 1초 기다립니다
        end
    end
end

task.wait(5) -- 게임 시작 후 5초 뒤에 웨이브를 시작합니다

while true do
    Wave += 1 -- 웨이브를 1 올립니다
    local FindWave = Waves:FindFirstChild(tostring(Wave)) -- 현재 웨이브 번호에 해당하는 폴더를 찾습니다 (예: Wave가 1이면 "1"이라는 이름의 폴더를 찾습니다)
    RemoteEvent:FireAllClients(Wave) -- 모든 플레이어 화면의 웨이브 번호를 업데이트합니다

    if FindWave then
        Main(FindWave) -- 해당 웨이브의 몬스터를 스폰합니다
    else
        print("웨이브 종료") -- 더 이상 웨이브가 없으면 종료합니다
        break
    end

    task.wait(WaveTime) -- 다음 웨이브 시작 전에 WaveTime만큼 기다립니다
end
