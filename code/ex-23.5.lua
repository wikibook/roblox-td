local TeleportService = game:GetService("TeleportService")
local Player          = game.Players.LocalPlayer
local Button          = script.Parent -- 로비로 이동하는 버튼입니다

-- 버튼을 클릭하면 로비맵으로 이동합니다
Button.MouseButton1Down:Connect(function()
    task.wait(2) -- 데이터가 저장될 때까지 잠깐 기다립니다
    -- 아래 숫자를 로비맵의 Place ID로 변경해 주세요
    TeleportService:Teleport(10085560590, Player)
end)
