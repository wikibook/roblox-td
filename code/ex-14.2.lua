local DataStoreService = game:GetService("DataStoreService")
local DefenceUnit      = DataStoreService:GetDataStore("DefenceUnit") -- 영웅 데이터를 저장하는 데이터 스토어입니다

-- 플레이어가 게임에 들어왔을 때 실행되는 함수입니다
local function PlayerAdded(Player)
    -- 보유 중인 영웅 목록 폴더를 만듭니다
    local HaveUnit = Instance.new("Folder")
    HaveUnit.Name   = "HaveUnit"
    HaveUnit.Parent = Player

    -- 장착 중인 영웅 목록 폴더를 만듭니다
    local EquipUnit = Instance.new("Folder")
    EquipUnit.Name   = "EquipUnit"
    EquipUnit.Parent = Player

    -- 저장된 영웅 데이터를 불러옵니다
    -- pcall은 오류가 발생해도 게임이 멈추지 않도록 안전하게 실행해줍니다
    local success, data = pcall(function()
        return DefenceUnit:GetAsync(Player.UserId)
    end)

    if success and data then
        -- 보유 중인 영웅 목록을 복원합니다
        for _, v in ipairs(data[1]) do
            local unit = Instance.new("IntValue")
            unit.Name   = v
            unit.Parent = HaveUnit
        end

        -- 장착 중인 영웅 목록을 복원합니다
        for _, v in ipairs(data[2]) do
            local unit = Instance.new("IntValue")
            unit.Name   = v
            unit.Parent = EquipUnit
        end
    end
end

-- 플레이어가 들어오거나 나갈 때 자동으로 함수를 실행합니다
game.Players.PlayerAdded:Connect(PlayerAdded)
