local DataStoreService = game:GetService("DataStoreService")
local DefenceCoin      = DataStoreService:GetDataStore("DefenceCoin_V2") -- 코인 데이터를 저장하는 데이터 스토어입니다

local RunService = game:GetService("RunService")

-- 플레이어가 게임에 들어왔을 때 실행되는 함수입니다
local function PlayerAdded(Player)
    -- UnitData 스크립트가 만든 leaderstats 폴더를 가져옵니다
    local leaderstats = Player:WaitForChild("leaderstats")
    local Coins       = leaderstats:WaitForChild("Coins")

    -- 다이아몬드 값을 저장하는 IntValue를 만듭니다
    local Diamond = leaderstats:FindFirstChild("Diamond")
    if not Diamond then
        Diamond        = Instance.new("IntValue")
        Diamond.Name   = "Diamond"
        Diamond.Value  = 0
        Diamond.Parent = leaderstats
    end

    -- 저장된 데이터를 불러옵니다
    local success, data = pcall(function()
        return DefenceCoin:GetAsync(Player.UserId)
    end)

    if success and data then
        if type(data) == "table" then
            -- 코인과 다이아몬드가 테이블로 저장된 경우입니다
            Coins.Value   = data[1] or Coins.Value
            Diamond.Value = data[2] or 0
        else
            -- 이전에 코인만 숫자로 저장했던 경우입니다
            Coins.Value = tonumber(data) or Coins.Value
        end
    end
end

-- 플레이어가 게임을 나갔을 때 데이터를 저장하는 함수입니다
local function Removing(Player)
    local leaderstats = Player:FindFirstChild("leaderstats")
    if not leaderstats then return end

    -- 코인과 다이아몬드를 테이블로 함께 저장합니다
    local data = { leaderstats.Coins.Value, leaderstats.Diamond.Value }

    for i = 1, 3 do
        local success, err = pcall(function()
            DefenceCoin:SetAsync(Player.UserId, data)
        end)

        if success then
            break -- 저장에 성공하면 반복을 멈춥니다
        else
            warn("데이터 저장 실패 (" .. i .. "번째 시도): " .. tostring(err))
            task.wait(3) -- 3초 기다렸다가 다시 시도합니다
        end
    end
end

-- 서버가 종료될 때 모든 플레이어의 데이터를 저장합니다
if not RunService:IsStudio() then
    game:BindToClose(function()
        for _, player in ipairs(game.Players:GetPlayers()) do
            Removing(player)
            task.wait(3)
        end
    end)
end

-- 플레이어가 들어오거나 나갈 때 자동으로 함수를 실행합니다
game.Players.PlayerAdded:Connect(PlayerAdded)
game.Players.PlayerRemoving:Connect(Removing)
