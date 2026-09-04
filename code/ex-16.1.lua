local PhysicsService = game:GetService("PhysicsService")

-- 충돌 그룹 이름을 정의합니다
-- 이 이름은 PlayerCollision 스크립트와 정확히 일치해야 합니다
local groupPlayers = "Players" -- 플레이어 충돌 그룹 이름입니다
local groupUnits   = "Units"   -- 영웅 충돌 그룹 이름입니다

-- 충돌 그룹을 등록하는 함수입니다
-- pcall을 사용하면 이미 그룹이 있어도 오류 없이 넘어갑니다
local function registerGroup(name)
    pcall(function()
        PhysicsService:RegisterCollisionGroup(name)
    end)
end

registerGroup(groupPlayers)
registerGroup(groupUnits)

-- 플레이어와 영웅이 서로 통과하도록 충돌을 끕니다
-- false는 '충돌하지 않음'을 의미합니다
PhysicsService:CollisionGroupSetCollidable(groupPlayers, groupUnits, false)

-- 영웅끼리도 서로 통과하게 하려면 아래 줄의 주석(--)을 지우세요
-- PhysicsService:CollisionGroupSetCollidable(groupUnits, groupUnits, false)
