local pause = false

function onTouched(part)
    -- 파트에 닿은 것이 플레이어인지 확인합니다
    local humanoid = part.Parent:FindFirstChild("Humanoid")
    if not humanoid or pause then return end -- 플레이어가 아니거나 대기 중이면 넘어갑니다

    pause = true
    humanoid:TakeDamage(5) -- 체력을 5 깎습니다
    task.wait(0.2)         -- 0.2초 동안 데미지를 주지 않습니다
    pause = false
end

script.Parent.Touched:Connect(onTouched) -- 파트에 닿으면 onTouched 함수를 실행합니다
