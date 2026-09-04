local DataStoreService = game:GetService("DataStoreService")
local DefenceUnit      = DataStoreService:GetDataStore("DefenceUnit") -- 영웅 데이터를 저장하는 데이터 스토어입니다

local RunService = game:GetService("RunService")

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
        for _, unitName in ipairs(data[1]) do
            local unit = Instance.new("IntValue")
            unit.Name   = unitName
            unit.Parent = HaveUnit
        end

        -- 장착 중인 영웅 목록을 복원합니다
        for _, unitName in ipairs(data[2]) do
            local unit = Instance.new("IntValue")
            unit.Name   = unitName
            unit.Parent = EquipUnit
        end
    end
end

-- 플레이어가 게임을 나갔을 때 데이터를 저장하는 함수입니다
local function Removing(Player)
    local HaveUnit  = Player:FindFirstChild("HaveUnit")
    local EquipUnit = Player:FindFirstChild("EquipUnit")
    if not HaveUnit or not EquipUnit then return end -- 폴더가 없으면 넘어갑니다

    -- 보유/장착 영웅 이름을 테이블에 담습니다
    local haveUnitData  = {}
    local equipUnitData = {}

    for _, unit in ipairs(HaveUnit:GetChildren()) do
        table.insert(haveUnitData, unit.Name)
    end

    for _, unit in ipairs(EquipUnit:GetChildren()) do
        table.insert(equipUnitData, unit.Name)
    end

    local data = { haveUnitData, equipUnitData }

    -- 저장에 실패하면 최대 3번까지 다시 시도합니다
    for i = 1, 3 do
        local success, err = pcall(function()
            DefenceUnit:SetAsync(Player.UserId, data)
        end)

        if success then
            break -- 저장에 성공하면 반복을 멈춥니다
        else
            warn("데이터 저장 실패 ("..i.."번째 시도): "..tostring(err))
            task.wait(3) -- 3초 기다렸다가 다시 시도합니다
        end
    end
end

-- 서버가 종료될 때 모든 플레이어의 데이터를 저장합니다
-- 스튜디오 테스트 환경에서는 실행하지 않습니다
if not RunService:IsStudio() then
    game:BindToClose(function()
        for _, player in ipairs(game.Players:GetPlayers()) do
            Removing(player)
            task.wait(3) -- 플레이어마다 순서대로 저장합니다
        end
    end)
end

-- 플레이어가 들어오거나 나갈 때 자동으로 함수를 실행합니다
game.Players.PlayerAdded:Connect(PlayerAdded)
game.Players.PlayerRemoving:Connect(Removing)
