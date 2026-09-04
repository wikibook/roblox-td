-- 영웅 모델과 필요한 요소들을 가져옵니다
local Unit             = script.Parent                         -- 이 스크립트가 들어있는 영웅 모델입니다
local Humanoid         = Unit:WaitForChild("Humanoid")
local Animator         = Humanoid:WaitForChild("Animator")
local HumanoidRootPart = Unit:WaitForChild("HumanoidRootPart") -- 영웅의 중심 파트입니다

-- 애니메이션을 불러옵니다
local GunAnimation  = Unit:WaitForChild("Gun")  -- 공격 애니메이션입니다
local IdleAnimation = Unit:WaitForChild("Idle") -- 대기 애니메이션입니다

local loadedGunAnim  = Animator:LoadAnimation(GunAnimation)
local loadedIdleAnim = Animator:LoadAnimation(IdleAnimation)

-- 애니메이션 우선순위를 설정합니다
loadedGunAnim.Priority  = Enum.AnimationPriority.Action
loadedIdleAnim.Priority = Enum.AnimationPriority.Idle

-- UnitStats 모듈에서 이 영웅의 스탯을 가져옵니다
-- 모델 이름(Unit.Name)으로 해당 영웅의 스탯을 찾습니다
local UnitStats = require(game.ServerScriptService.UnitStats)
local Range     = UnitStats[Unit.Name].Range    -- 공격 가능한 거리입니다
local CoolTime  = UnitStats[Unit.Name].CoolTime -- 공격 간격(초)입니다
local Damage    = UnitStats[Unit.Name].Damage   -- 한 번에 입히는 데미지입니다
local ShotCoin  = UnitStats[Unit.Name].ShotCoin -- 공격할 때마다 지급되는 코인입니다

local SpawnMobs = game.Workspace:WaitForChild("SpawnMobs") -- 몬스터가 생성되는 폴더입니다

-- 몬스터를 처치했을 때 지급되는 코인을 설정합니다
-- 키 이름은 Mobs 폴더 안의 몬스터 모델 이름과 정확히 일치해야 합니다
local MobCoin = {
	["red"]  = 70,
	["blue"] = 50,
	["boss"] = 500,
}

-- 공격 범위 안에 있는 몬스터를 찾아 반환하는 함수입니다
local function findTarget()
	for _, mob in ipairs(SpawnMobs:GetChildren()) do
		local mobHumanoid = mob:FindFirstChild("mob")
		if mob:IsA("Model") and mobHumanoid then
			local mobRootPart = mob:FindFirstChild("HumanoidRootPart")
			if mobRootPart and mobHumanoid.Health > 0 then
				local distance = (mobRootPart.Position - HumanoidRootPart.Position).Magnitude
				if distance < Range then
					return mob
				end
			end
		end
	end
end

loadedIdleAnim:Play() -- 게임 시작 시 대기 애니메이션을 재생합니다

-- CoolTime마다 반복하며 몬스터를 공격합니다
while true do
	task.wait(CoolTime)

	local target = findTarget()

	if target then
		local mobHumanoid = target:FindFirstChild("mob")
		local mobRootPart = target:FindFirstChild("HumanoidRootPart")

		if mobHumanoid and mobRootPart then
			-- 공격 애니메이션을 재생합니다
			loadedGunAnim:Play()
			loadedGunAnim:AdjustSpeed(1.5)

			-- 영웅이 몬스터를 바라보도록 방향을 변경합니다
			HumanoidRootPart.CFrame = CFrame.new(
				HumanoidRootPart.Position,
				Vector3.new(
					mobRootPart.Position.X,
					HumanoidRootPart.Position.Y,
					mobRootPart.Position.Z
				)
			)

			-- 기존 아래 코드를 대체
			-- local attachment = Unit.Handgun.Handle.Attachment
			-- 유닛마다 총 모델 구조가 다를 경우 이름별로 Attachment 경로를 지정합니다
			local attachment
			if Unit.Name == "군인" then
				attachment = Unit.Handgun.Handle.Attachment
			elseif Unit.Name == "군인2" then -- 군인2의 무기에 맞게 장착 경로 변경
				attachment = Units.ClassicSword.Handle
			elseif Unit.Name == "군인3" then
				attachment = Unit.Handgun.Handle.Attachment
			elseif Unit.Name == "군인4" then
				attachment = Unit.Handgun.Handle.Attachment
			elseif Unit.Name == "군인5" then
				attachment = Unit.Handgun.Handle.Attachment
			elseif Unit.Name == "군인6" then
				attachment = Unit.Handgun.Handle.Attachment
			end

			task.spawn(function()
				task.wait(0.3) -- 0.3초 후에 데미지를 입힙니다

				if mobHumanoid.Health > 0 then
					-- 처치 여부를 데미지 차감 전에 미리 확인합니다
					local isDead = mobHumanoid.Health - Damage <= 0
					mobHumanoid.Health -= Damage

					-- 영웅을 설치한 플레이어를 찾아 코인을 지급합니다
					-- Owner 속성에는 영웅 설치 시 저장된 플레이어 이름이 들어있습니다
					local playerName = Unit:GetAttribute("Owner")
					local player     = game.Players:FindFirstChild(playerName)

					if player then
						local Coins = player:WaitForChild("leaderstats"):WaitForChild("Coins")
						Coins.Value += ShotCoin -- 공격할 때마다 코인을 지급합니다

						if isDead and MobCoin[target.Name] then
							-- 몬스터를 처치하면 추가 코인을 지급합니다
							Coins.Value += MobCoin[target.Name]
						end
					end
				end

				-- 총구 이펙트를 잠깐 켰다가 끕니다
				for _, effect in ipairs(attachment:GetChildren()) do
					if effect:IsA("ParticleEmitter") then
						effect.Enabled = true
						task.wait(0.05)
						effect.Enabled = false
					end
				end
			end)
		end
	end
end
