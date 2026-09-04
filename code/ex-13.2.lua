-- UI 요소들을 가져옵니다
local Button = script.Parent
local Frame  = Button.Parent
local Unit   = Frame:WaitForChild("Title") -- 영웅 이름이 표시된 텍스트 레이블입니다

-- 서버와 신호를 주고받을 리모트 이벤트를 가져옵니다
local BuyEvent   = game.ReplicatedStorage:WaitForChild("BuyEvent")   -- 구매 신호를 보냅니다
local EquipEvent = game.ReplicatedStorage:WaitForChild("EquipEvent") -- 장착/해제 신호를 보냅니다

-- 플레이어의 보유/장착 영웅 목록을 가져옵니다
local Player    = game.Players.LocalPlayer
local HaveUnit  = Player:WaitForChild("HaveUnit")  -- 보유 중인 영웅 목록입니다
local EquipUnit = Player:WaitForChild("EquipUnit") -- 장착 중인 영웅 목록입니다

-- 버튼이 너무 빠르게 여러 번 눌리는 것을 방지합니다
local Debounce = false

-- 버튼을 클릭했을 때 실행되는 함수입니다
Button.MouseButton1Click:Connect(function()
    if Debounce then return end -- 처리 중이면 넘어갑니다
    Debounce = true

    local UnitText = Unit.Text -- 현재 선택된 영웅 이름을 저장합니다

    if Button.Text == "BUY" then
        -- 아직 보유하지 않은 영웅이라면 구매 신호를 보냅니다
        if not HaveUnit:FindFirstChild(UnitText) and not EquipUnit:FindFirstChild(UnitText) then
            BuyEvent:FireServer(UnitText)
        end
    else
        -- 장착 또는 해제 신호를 보냅니다
        EquipEvent:FireServer(UnitText)
    end

    -- 처리 중임을 표시합니다
    Button.Text = "..."
    Button.BackgroundColor3 = Color3.fromRGB(77, 77, 77)
    task.wait(0.5) -- 0.5초 기다린 후 버튼 상태를 업데이트합니다

    -- 선택된 영웅이 바뀌지 않았을 때만 버튼 상태를 업데이트합니다
    if Unit.Text == UnitText then
        if EquipUnit:FindFirstChild(UnitText) then
            -- 장착 중인 영웅이면 해제 버튼으로 바꿉니다
            Button.Text = "해제"
            Button.BackgroundColor3 = Color3.fromRGB(203, 0, 0)
        elseif HaveUnit:FindFirstChild(UnitText) then
            -- 보유 중인 영웅이면 장착 버튼으로 바꿉니다
            Button.Text = "장착"
            Button.BackgroundColor3 = Color3.fromRGB(0, 88, 203)
        else
            -- 보유하지 않은 영웅이면 구매 버튼으로 바꿉니다
            Button.Text = "BUY"
            Button.BackgroundColor3 = Color3.fromRGB(0, 203, 7)
        end
    end

    Debounce = false
end)
