local PhysicsService = game:GetService("PhysicsService")
local Players = game:GetService("Players")
local SpawnMobs = game.Workspace:WaitForChild("SpawnMobs") -- 몬스터가 생성되는 폴더입니다

-- 'Characters' 충돌 그룹을 만들고, 같은 그룹끼리는 통과하도록 설정합니다
PhysicsService:RegisterCollisionGroup("Characters")
PhysicsService:CollisionGroupSetCollidable("Characters", "Characters", false)

-- 파트를 Characters 충돌 그룹에 넣는 함수입니다
local function onDescendantAdded(descendant)
    if descendant:IsA("BasePart") then
        descendant.CollisionGroup = "Characters"
    end
end

-- 캐릭터(플레이어 또는 몬스터)의 모든 파트를 충돌 그룹에 넣는 함수입니다
local function onCharacterAdded(character)
    for _, descendant in ipairs(character:GetDescendants()) do
        onDescendantAdded(descendant)
    end
    -- 나중에 추가되는 파트도 자동으로 처리합니다
    character.DescendantAdded:Connect(onDescendantAdded)
end

-- 플레이어가 게임에 들어올 때마다 캐릭터를 충돌 그룹에 추가합니다
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(onCharacterAdded)
end)

-- SpawnMobs 폴더에 몬스터가 추가될 때마다 충돌 그룹에 자동으로 추가합니다
SpawnMobs.ChildAdded:Connect(onCharacterAdded)
