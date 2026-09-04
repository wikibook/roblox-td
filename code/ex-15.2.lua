-- 클라이언트에서 설치 위치 신호가 오면 실행되는 함수입니다
game.ReplicatedStorage:WaitForChild("PlaceEvent").OnServerEvent:Connect(function(player, unitName, unitCFrame)
    -- 해당 영웅 모델을 복사해서 게임에 배치합니다
    local clone = game.ReplicatedStorage:WaitForChild("Units"):WaitForChild(unitName):Clone()
    clone.Parent = game.Workspace
    clone.PrimaryPart.CFrame = unitCFrame -- 클라이언트에서 받은 위치에 영웅을 배치합니다
end)
