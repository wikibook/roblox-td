-- 영웅 모델과 필요한 요소들을 가져옵니다
local Unit            = script.Parent                        -- 이 스크립트가 들어있는 영웅 모델입니다
local Humanoid        = Unit:WaitForChild("Humanoid")
local Animator        = Humanoid:WaitForChild("Animator")
local HumanoidRootPart = Unit:WaitForChild("HumanoidRootPart") -- 영웅의 중심 파트입니다

-- 애니메이션을 불러옵니다
local GunAnimation  = Unit:WaitForChild("Gun")   -- 공격 애니메이션입니다
local IdleAnimation = Unit:WaitForChild("Idle")  -- 대기 애니메이션입니다

local loadedGunAnim  = Animator:LoadAnimation(GunAnimation)
local loadedIdleAnim = Animator:LoadAnimation(IdleAnimation)

-- 애니메이션 우선순위를 설정합니다
-- Action은 높은 우선순위로 공격 시 대기 애니메이션을 덮어씌웁니다
-- Idle은 낮은 우선순위로 아무것도 안 할 때 재생됩니다
loadedGunAnim.Priority  = Enum.AnimationPriority.Action
loadedIdleAnim.Priority = Enum.AnimationPriority.Idle

-- 영웅의 공격 속성을 가져옵니다
local Range    = Unit:WaitForChild("Range")    -- 공격 가능한 거리입니다
local CoolTime = Unit:WaitForChild("CoolTime") -- 공격 간격(초)입니다
local Damage   = Unit:WaitForChild("Damage")   -- 한 번에 입히는 데미지입니다

local SpawnMobs = game.Workspace:WaitForChild("SpawnMobs") -- 몬스터가 생성되는 폴더입니다

-- 공격 범위 안에 있는 몬스터를 찾아 반환하는 함수입니다
local function findTarget()
    for _, mob in ipairs(SpawnMobs:GetChildren()) do
        -- 몬스터 모델인지 확인합니다 (Model이고 mob이라는 Humanoid를 가지고 있어야 합니다)
        local mobHumanoid = mob:FindFirstChild("mob")
        if mob:IsA("Model") and mobHumanoid then
            local mobRootPart = mob:FindFirstChild("HumanoidRootPart")
            if mobRootPart and mobHumanoid.Health > 0 then
                -- 몬스터와 영웅 사이의 거리를 계산합니다
                local distance = (mobRootPart.Position - HumanoidRootPart.Position).Magnitude
                if distance < Range.Value then
                    return mob -- 범위 안에 있는 몬스터를 반환합니다
                end
            end
        end
    end
end

loadedIdleAnim:Play() -- 게임 시작 시 대기 애니메이션을 재생합니다

-- CoolTime마다 반복하며 몬스터를 공격합니다
while true do
    task.wait(CoolTime.Value)

    local target = findTarget() -- 범위 안의 몬스터를 찾습니다

    if target then
        local mobHumanoid = target:FindFirstChild("mob")
        local mobRootPart = target:FindFirstChild("HumanoidRootPart")

        if mobHumanoid and mobRootPart then
            -- 공격 애니메이션을 재생합니다
            loadedGunAnim:Play()
            loadedGunAnim:AdjustSpeed(1.5) -- 애니메이션 재생 속도를 1.5배로 설정합니다

            -- 영웅이 몬스터를 바라보도록 방향을 변경합니다
            -- Y 좌표는 영웅 자신의 높이를 유지해야 위아래로 기울어지지 않습니다
            HumanoidRootPart.CFrame = CFrame.new(
                HumanoidRootPart.Position,
                Vector3.new(
                    mobRootPart.Position.X,
                    HumanoidRootPart.Position.Y,
                    mobRootPart.Position.Z
                )
            )

            -- 총구 이펙트와 데미지를 별도 스레드에서 처리합니다
            -- task.spawn을 사용하면 이 안의 대기 시간이 메인 루프를 지연시키지 않습니다
            local attachment = Unit.Handgun.Handle.Attachment
            task.spawn(function()
                task.wait(0.3) -- 0.3초 후에 데미지를 입힙니다 (애니메이션과 타이밍 맞추기)

                if mobHumanoid.Health > 0 then
                    mobHumanoid.Health -= Damage.Value -- 몬스터 체력을 데미지만큼 차감합니다
                end

                -- 총구 이펙트를 잠깐 켰다가 끕니다
                for _, effect in ipairs(attachment:GetChildren()) do
                    effect.Enabled = true
                    task.wait(0.05)
                    effect.Enabled = false
                end
            end)
        end
    end
end
