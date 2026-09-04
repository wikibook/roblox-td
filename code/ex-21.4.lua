-- 서버에서 타이머 시간을 받을 리모트 이벤트입니다
local TimerEvent = game.ReplicatedStorage:WaitForChild("TimerEvent")

-- 서버에서 타이머 시간이 전달될 때마다 실행됩니다
TimerEvent.OnClientEvent:Connect(function(time)
    -- 5초, 3초, 1초가 남았을 때 타이머를 빨간색으로 바꿔 긴박감을 표현합니다
    if time == "0:05" or time == "0:03" or time == "0:01" then
        script.Parent.TextColor3 = Color3.new(1, 0.29, 0.29) -- 빨간색
    else
        script.Parent.TextColor3 = Color3.new(1, 1, 1) -- 흰색
    end

    script.Parent.Text = time -- 화면에 타이머 시간을 표시합니다
end)
