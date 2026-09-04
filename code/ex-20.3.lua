local Event = game.ReplicatedStorage:WaitForChild("BuyEvent")

local Unit = {
	{UnitName = "군인", Price = 300},
	{UnitName = "군인2", Price = 300},
	{UnitName = "군인3", Price = 300},
	{UnitName = "군인4", Price = 300},
	{UnitName = "군인5", Price = 300},
	{UnitName = "군인6", Price = 300}
}

Event.OnServerEvent:Connect(function(Player, UnitName)
	print("1. 요청 받음: " .. tostring(UnitName)) -- [확인 1]

	local HaveUnit = Player:WaitForChild("HaveUnit")
	local EquipUnit = Player:WaitForChild("EquipUnit")

	-- 보유 여부 확인
	if HaveUnit:FindFirstChild(UnitName) then 
		warn("이미 가지고 있음")
		return 
	end

	-- 테이블 검색 시작
	local found = false
	for i = 1, #Unit do
		-- 이름 비교 (공백 제거 후 비교하면 더 안전함)
		if Unit[i].UnitName == UnitName then
			print("2. 목록에서 유닛 찾음: " .. UnitName) -- [확인 2]
			found = true

			local leaderstats = Player:WaitForChild("leaderstats")
			local Coin = leaderstats.Coins 

			if Coin.Value >= Unit[i].Price then
				Coin.Value = Coin.Value - Unit[i].Price

				local UnitValue = Instance.new("IntValue")
				UnitValue.Name = Unit[i].UnitName
				UnitValue.Parent = HaveUnit

				print("3. 구매 성공! HaveUnit 폴더에 추가됨.") -- [확인 3]
			else
				warn("돈이 부족함. 내 돈: " .. Coin.Value .. " / 필요: " .. Unit[i].Price)
			end
			break
		end
	end

	if not found then
		warn("🚨 오류: Unit 테이블에 '" .. UnitName .. "' 이라는 이름이 없습니다!")
		warn("   -> 스크립트의 UnitName과 GUI의 텍스트가 일치하는지 확인하세요.")
	end
end)
