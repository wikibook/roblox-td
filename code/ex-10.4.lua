-- 서버에서 보내는 웨이브 번호 신호를 받을 리모트 이벤트를 가져옵니다
local Event = game.ReplicatedStorage:WaitForChild("GuiEvent")
local WaveLabel = script.Parent:WaitForChild("Wave") -- 웨이브 번호를 표시하는 텍스트 레이블입니다

-- 서버에서 웨이브 번호가 바뀌면 자동으로 실행됩니다
Event.OnClientEvent:Connect(function(Wave)
    WaveLabel.Text = "🔥 Wave: " .. Wave -- 화면의 웨이브 번호를 업데이트합니다
end)
