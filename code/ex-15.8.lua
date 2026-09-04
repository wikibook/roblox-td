local PlaceEvent = game.ReplicatedStorage:WaitForChild("PlaceEvent") -- 설치 위치 신호를 받을 리모트 이벤트입니다
local Folder     = game.ReplicatedStorage:WaitForChild("Units")      -- 영웅 모델이 들어있는 폴더입니다

-- 설치 가능한 영웅 목록과 설치 비용을 설정합니다
local UnitTable = {
    { Unit = "군인", Price = 300 },
}

-- 클라이언트에서 설치 위치 신호가 오면 실행되는 함수입니다
PlaceEvent.OnServerEvent:Connect(function(Player, UnitName, UnitCFrame, Target)
    -- 설치 불가 영역(Folder)이면 설치하지 않습니다
    if not Target or Target.ClassName == "Folder" then return end

    local Coins = Player:WaitForChild("leaderstats"):WaitForChild("Coins") -- 플레이어의 코인을 가져옵니다

    for _, unit in ipairs(UnitTable) do
        if unit.Unit == UnitName then
            -- 코인이 부족하면 설치하지 않습니다
            if Coins.Value < unit.Price then return end

            -- 코인을 차감하고 영웅을 설치합니다
            Coins.Value -= unit.Price

            local unitClone = Folder:WaitForChild(UnitName):Clone()
            unitClone.Parent             = game.Workspace
            unitClone.PrimaryPart.CFrame = UnitCFrame -- 지정된 위치에 영웅을 배치합니다
            break
        end
    end
end)
