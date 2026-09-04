function onTouch(part)
    -- 파트에 닿은 것이 플레이어인지 확인합니다
    local humanoid = part.Parent:FindFirstChild("Humanoid")
    if not humanoid then return end -- 플레이어가 아니면 넘어갑니다

    humanoid.Health = 0 -- 체력을 0으로 만들어 플레이어를 죽입니다
end

script.Parent.Touched:Connect(onTouch) -- 파트에 닿으면 onTouch 함수를 실행합니다
