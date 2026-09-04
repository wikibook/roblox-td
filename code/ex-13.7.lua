local Event = game.ReplicatedStorage:WaitForChild("EquipEvent") -- 장착/해제 신호를 받을 리모트 이벤트입니다

-- 클라이언트에서 장착/해제 신호가 오면 실행되는 함수입니다
Event.OnServerEvent:Connect(function(Player, UnitName)
    local HaveUnit  = Player:WaitForChild("HaveUnit")  -- 보유 중인 영웅 목록입니다
    local EquipUnit = Player:WaitForChild("EquipUnit") -- 장착 중인 영웅 목록입니다

    local haveTarget  = HaveUnit:FindFirstChild(UnitName)  -- 보유 목록에서 해당 영웅을 찾습니다
    local equipTarget = EquipUnit:FindFirstChild(UnitName) -- 장착 목록에서 해당 영웅을 찾습니다

    if haveTarget then
        -- 보유 중인 영웅이면 장착합니다 (최대 5개까지 장착 가능)
        if #EquipUnit:GetChildren() < 5 then
            haveTarget.Parent = EquipUnit -- 보유 목록에서 장착 목록으로 이동합니다
        end
    elseif equipTarget then
        -- 장착 중인 영웅이면 해제합니다
        equipTarget.Parent = HaveUnit -- 장착 목록에서 보유 목록으로 이동합니다
    end
end)
