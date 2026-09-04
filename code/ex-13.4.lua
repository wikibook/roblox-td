local DataStoreService = game:GetService("DataStoreService")
local DefenceCoin      = DataStoreService:GetDataStore("DefenceCoin") -- 코인 데이터를 저장하는 데이터 스토어입니다

local RunService = game:GetService("RunService")

-- 플레이어가 게임에 들어왔을 때 실행되는 함수입니다
local function PlayerAdded(Player)
    -- leaderstats 폴더를 만들면 로블록스가 자동으로 리더보드에 표시해줍니다
    local leaderstats = Instance.new("Folder")
    leaderstats.Name   = "leaderstats"
    leaderstats.Parent = Player

    -- 코인 값을 저장하는 IntValue를 만듭니다
    local Coins = Instance.new("IntValue")
    Coins.Name   = "Coins"
    Coins.Value  = 300 -- 처음 게임에 들어오면 300코인으로 시작합니다
    Coins.Parent = leaderstats

    -- 저장된 데이터를 불러옵니다
    -- pcall은 오류가 발생해도 게임이 멈추지 않도록 안전하게 실행해줍니다
    local success, data = pcall(function()
        return DefenceCoin:GetAsync(Player.UserId)
    end)

    if success and data then
        Coins.Value = data -- 저장된 코인 값으로 업데이트합니다
    end
end

-- 플레이어가 게임을 나갔을 때 데이터를 저장하는 함수입니다
local function Removing(Player)
    local leaderstats = Player:FindFirstChild("leaderstats")
    if not leaderstats then return end -- leaderstats가 없으면 넘어갑니다

    local data = leaderstats.Coins.Value -- 저장할 코인 값입니다

    -- 저장에 실패하면 최대 3번까지 다시 시도합니다
    for i = 1, 3 do
        local success, err = pcall(function()
            DefenceCoin:SetAsync(Player.UserId, data)
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
        local players = game.Players:GetPlayers()

        for _, player in ipairs(players) do
            Removing(player)
            task.wait(1) -- 플레이어마다 순서대로 저장합니다
        end
    end)
end

-- 플레이어가 들어오거나 나갈 때 자동으로 함수를 실행합니다
game.Players.PlayerAdded:Connect(PlayerAdded)
game.Players.PlayerRemoving:Connect(Removing)
