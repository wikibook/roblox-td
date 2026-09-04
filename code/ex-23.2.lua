local Wave = 0       -- 현재 웨이브 번호
local WaveTime = 5   -- 웨이브 사이의 대기 시간(초)

-- 게임에 필요한 요소들을 가져옵니다
local CastleHealth = game.Workspace.Castle:WaitForChild("Health") -- 성의 체력 값을 가져옵니다
local Waves        = game.ReplicatedStorage:WaitForChild("Waves") -- 웨이브마다 어떤 몬스터가 나오는지 설정한 폴더입니다
local Mobs         = game.ReplicatedStorage:WaitForChild("Mobs") -- 몬스터 모델들이 들어있는 폴더입니다
local WayPart      = game.Workspace:WaitForChild("WayPart") -- 몬스터가 이동할 길을 설정한 폴더입니다
local SpawnMobs    = game.Workspace:WaitForChild("SpawnMobs") -- 몬스터가 생성될 폴더입니다
local RemoteEvent  = game.ReplicatedStorage:WaitForChild("GuiEvent") -- 리모트 이벤트로 웨이브 번호를 모든 플레이어에게 보냅니다
-- 타이머 시간을 클라이언트(플레이어 화면)에 전달할 리모트 이벤트입니다
local TimerEvent = game.ReplicatedStorage:WaitForChild("TimerEvent")

-- 웨이포인트들 사이의 거리를 모두 더해 길의 총 거리를 구합니다
local TotalDistance = 0                              -- 길의 총 거리를 저장할 변수입니다
local NewPart = WayPart:WaitForChild("Start")        -- 거리 계산의 시작점입니다

for i = 1, #WayPart:GetChildren() do
	if i ~= #WayPart:GetChildren() - 1 then
		-- 숫자 순서대로 웨이포인트를 찾아 이전 파트와의 거리를 계산합니다
		local part = WayPart:FindFirstChild(i)
		if part then
			local magnitude = (NewPart.Position - part.Position).Magnitude -- 두 파트 사이의 거리입니다
			NewPart       = part       -- 다음 계산의 시작점을 현재 파트로 바꿉니다
			TotalDistance += magnitude -- 총 거리에 더합니다
		end
	else
		-- 마지막 웨이포인트와 Finish 파트 사이의 거리를 계산합니다
		local magnitude = (NewPart.Position - WayPart:WaitForChild("Finish").Position).Magnitude
		TotalDistance += magnitude
	end
end

-- 웨이브 시간을 계산하고 타이머를 화면에 표시하는 함수입니다
local function Timer(FindWave)
	-- 이 웨이브에서 가장 느린 몬스터의 속도를 찾습니다
	-- math.huge는 아주 큰 숫자로, 어떤 몬스터 속도와 비교해도 더 크므로 시작값으로 사용합니다
	local mostLowSpeed = math.huge
	local spawnTime    = 0

	-- 몬스터 스폰 간격 시간을 모두 더합니다 (몬스터 5마리면 약 5초 추가)
	for _, wave in ipairs(FindWave:GetChildren()) do
		spawnTime += wave.Value
	end

	-- 이 웨이브에 등장하는 몬스터 중 가장 느린 속도를 찾습니다
	for _, mob in ipairs(Mobs:GetChildren()) do
		for _, wave in ipairs(FindWave:GetChildren()) do
			if mob.Name == wave.Name then
				local walkSpeed = mob:WaitForChild("mob").WalkSpeed
				if mostLowSpeed > walkSpeed then
					mostLowSpeed = walkSpeed -- 더 느린 속도로 업데이트합니다
				end
			end
		end
	end

	-- 총 거리 ÷ 가장 느린 속도 + 스폰 시간 = 웨이브 총 시간입니다
	local roundTime = math.floor(TotalDistance / mostLowSpeed) + spawnTime

	-- 총 시간을 분과 초로 나눕니다
	local min = 0
	local sec = 0

	repeat
		if roundTime < 60 then
			sec       = roundTime
			roundTime = 0
		else
			min       += 1
			roundTime -= 60
		end
		task.wait()
	until roundTime == 0

	-- 1초마다 타이머를 줄이면서 화면에 표시합니다
	for i = 1, (min * 60) + sec do
		if sec == 0 then
			if min > 0 then
				min -= 1
				sec  = 59
			end
		else
			sec -= 1
		end

		-- 초가 10 미만이면 앞에 0을 붙여서 표시합니다 (예: 1:05)
		if sec < 10 then
			TimerEvent:FireAllClients(min .. ":0" .. sec)
		else
			TimerEvent:FireAllClients(min .. ":" .. sec)
		end

		task.wait(1) -- 1초 기다립니다
	end
end

-- 몬스터 한 마리를 시작 지점에 스폰하는 함수입니다
local function MobSpawn(MobValue)
	local Mob = Mobs:FindFirstChild(MobValue.Name)
	if not Mob then return end -- 해당 몬스터가 없으면 넘어갑니다

	local Clone = Mob:Clone()
	Clone.Parent = SpawnMobs             -- 복사한 몬스터를 SpawnMobs 폴더에 배치합니다
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
	Wave += 1 -- 웨이브 번호를 1 올립니다
	local FindWave = Waves:FindFirstChild(tostring(Wave)) -- 해당 웨이브 폴더를 찾습니다
	RemoteEvent:FireAllClients(Wave) -- 모든 플레이어 화면의 웨이브 번호를 업데이트합니다

	local newWave = false -- 타이머가 끝났는지 확인하는 변수입니다

	if FindWave then
		-- 타이머와 몬스터 소환을 동시에 실행합니다
		-- task.spawn을 사용하면 타이머가 실행되는 동안 몬스터도 함께 소환됩니다
		task.spawn(function()
			Timer(FindWave) -- 타이머를 실행합니다
			newWave = true  -- 타이머가 끝나면 true로 바꿉니다
		end)

		Main(FindWave) -- 몬스터를 스폰합니다

		-- 타이머가 끝날 때까지 기다립니다
		repeat task.wait() until newWave == true
	else
		-- 게임 클리어 시 보상을 지급합니다
		local Reward  = 100 -- 코인 보상입니다
		local Reward2 = 200 -- 다이아몬드 보상입니다

		-- 현재 접속 중인 모든 플레이어에게 보상을 지급합니다
		for _, player in ipairs(game.Players:GetPlayers()) do
			local leaderstats = player:FindFirstChild("leaderstats")

			if leaderstats then
				local coinObj    = leaderstats:FindFirstChild("Coins")   -- 코인 오브젝트를 찾습니다
				local diamondObj = leaderstats:FindFirstChild("Diamond") -- 다이아몬드 오브젝트를 찾습니다

				if coinObj    then coinObj.Value    += Reward  end -- 코인을 지급합니다
				if diamondObj then diamondObj.Value += Reward2 end -- 다이아몬드를 지급합니다
			end
		end

		-- 모든 플레이어 화면에 게임 클리어 창과 보상 내용을 표시합니다
		game.ReplicatedStorage:WaitForChild("GameClear"):FireAllClients("💰 / " .. Reward, "DIA / " .. Reward2)

		print("웨이브 종료") -- 더 이상 웨이브가 없으면 종료합니다
		break
	end

	task.wait(WaveTime) -- 다음 웨이브 시작 전에 잠시 기다립니다
end
