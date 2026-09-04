local Event = game.ReplicatedStorage:WaitForChild("BuyEvent") -- 구매 신호를 받을 리모트 이벤트입니다

-- 구매 가능한 영웅 목록과 가격을 설정합니다
local Units = {
    { UnitName = "군인", Price = 300 },
}

-- 클라이언트에서 구매 신호가 오면 실행되는 함수입니다
Event.OnServerEvent:Connect(function(Player, UnitName)
    local HaveUnit  = Player:WaitForChild("HaveUnit")  -- 보유 중인 영웅 목록입니다
    local EquipUnit = Player:WaitForChild("EquipUnit") -- 장착 중인 영웅 목록입니다

    -- 이미 보유하거나 장착 중인 영웅이면 구매하지 않습니다
    if HaveUnit:FindFirstChild(UnitName) or EquipUnit:FindFirstChild(UnitName) then return end

    -- 구매하려는 영웅을 목록에서 찾습니다
    for _, unit in ipairs(Units) do
        if unit.UnitName == UnitName then
            local Coins = Player:WaitForChild("leaderstats"):WaitForChild("Coins")

            if Coins.Value >= unit.Price then
                -- 코인을 차감하고 보유 목록에 추가합니다
                Coins.Value = Coins.Value - unit.Price

                local UnitValue = Instance.new("IntValue")
                UnitValue.Name   = unit.UnitName
                UnitValue.Parent = HaveUnit
            end

            break -- 영웅을 찾았으면 반복을 멈춥니다
        end
    end
end)
