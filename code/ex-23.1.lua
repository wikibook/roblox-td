-- 서버에서 게임 클리어 신호를 받을 리모트 이벤트입니다
local Event = game.ReplicatedStorage:WaitForChild("GameClear")

local RewardFrame = script.Parent                        -- 보상을 표시하는 프레임입니다
local CoinText    = RewardFrame:WaitForChild("Coin")     -- 코인 보상을 표시하는 텍스트 레이블입니다
local MainFrame   = RewardFrame.Parent                   -- 게임 클리어 창 전체 프레임입니다

-- 서버에서 게임 클리어 신호가 오면 실행됩니다
Event.OnClientEvent:Connect(function(coinText, diamondText)
    CoinText.Text                   = coinText    -- 코인 보상 텍스트를 표시합니다
    RewardFrame.Diamond.Text        = diamondText -- 다이아몬드 보상 텍스트를 표시합니다

    MainFrame.Visible = true -- 게임 클리어 창을 화면에 보이게 합니다

    -- 게임 클리어 창이 화면 중앙으로 부드럽게 내려오는 애니메이션을 실행합니다
    MainFrame:TweenPosition(
        UDim2.new(0.5, 0, 0.5, 0),       -- 이동할 위치입니다 (화면 중앙)
        Enum.EasingDirection.Out,          -- 끝으로 갈수록 천천히 이동합니다
        Enum.EasingStyle.Quart,           -- 부드러운 이동 스타일입니다
        1,                                 -- 1초 동안 이동합니다
        false                              -- 이미 실행 중인 애니메이션을 덮어쓰지 않습니다
    )
end)
