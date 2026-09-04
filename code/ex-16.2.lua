local PhysicsService = game:GetService("PhysicsService")
local Players        = game:GetService("Players")

-- CollisionSetup 스크립트에서 설정한 그룹 이름과 정확히 일치해야 합니다
local playerGroupName = "Players"

-- 플레이어가 게임에 들어올 때 실행됩니다
Players.PlayerAdded:Connect(function(player)
    -- 캐릭터가 생성될 때마다 실행됩니다 (죽고 다시 살아날 때도 자동으로 실행됩니다)
    player.CharacterAdded:Connect(function(character)
        task.wait() -- 캐릭터 파트가 완전히 로딩될 때까지 잠깐 기다립니다

        -- 캐릭터의 모든 파트(팔, 다리, 머리 등)를 Players 그룹에 배정합니다
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CollisionGroup = playerGroupName
            end
        end
    end)
end)
