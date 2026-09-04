local MainFrame = script.Parent

local Player    = game.Players.LocalPlayer
local EquipUnit = Player:WaitForChild("EquipUnit") -- 장착 중인 영웅 목록 폴더입니다

-- 영웅 이름과 이미지를 연결하는 목록입니다
-- Unit에는 영웅 이름, Image에는 rbxassetid://... 형식의 이미지 주소를 입력합니다
local UnitImage = {
	{Unit = "군인", Image = "rbxassetid://17138346774", Price = 300}, -- 가격을 추가합니다
}

-- 장착된 영웅 목록을 화면에 업데이트하는 함수입니다
local function Update()
	-- 모든 슬롯을 먼저 초기화합니다
	for _, v in ipairs(MainFrame:GetChildren()) do
		if v:IsA("Frame") then
			v.ImageButton.Image = ""
			v.TextLabel.Text    = ""
		end
	end

	-- 장착된 영웅을 순서대로 슬롯에 표시합니다
	local slot = 1 -- 몇 번째 슬롯에 표시할지 순서를 정합니다
	for _, equippedUnit in ipairs(EquipUnit:GetChildren()) do
		for _, UI in ipairs(UnitImage) do
			if equippedUnit.Name == UI.Unit then
				local Frame = MainFrame:FindFirstChild(slot) -- 해당 번호의 슬롯을 찾습니다
				if Frame then
					Frame.ImageButton.Image = UI.Image    -- 영웅 이미지를 표시합니다
					Frame.TextLabel.Text    = UI.Unit     -- 영웅 이름을 표시합니다
				end
				slot += 1 -- 다음 슬롯으로 넘어갑니다
				break
			end
		end
	end
end

Update() -- 게임 시작 시 한 번 실행합니다

-- 영웅을 장착하거나 해제할 때마다 자동으로 업데이트합니다
EquipUnit.ChildAdded:Connect(Update)
EquipUnit.ChildRemoved:Connect(Update)
