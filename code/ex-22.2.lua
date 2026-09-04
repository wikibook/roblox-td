local PlaceEvent = game.ReplicatedStorage:WaitForChild("PlaceEvent")
local Folder     = game.ReplicatedStorage:WaitForChild("Units") -- 영웅 모델이 들어있는 폴더입니다

-- UnitScript를 복사해서 설치된 영웅마다 나눠줄 준비를 합니다
-- UnitScript는 비활성화 상태로 여기에 보관되어 있습니다
local UnitScript = script.UnitScript

-- UnitStats 모듈에서 영웅 스탯과 설치 함수를 가져옵니다
-- require()는 모듈 스크립트를 불러오는 함수입니다
local UnitStats = require(game.ServerScriptService.UnitStats)

-- 플레이어 한 명이 설치할 수 있는 최대 유닛 수입니다
-- 이 숫자를 바꾸면 설치 가능한 유닛 수가 달라집니다
local MaxUnitCount = 15

-- 설치 가능한 영웅 목록과 설치 비용을 설정합니다
local UnitTable = {
	{ Unit = "군인", Price = 300 },
	{ Unit = "군인2", Price = 300 },
	{ Unit = "군인3", Price = 300 },
	{ Unit = "군인4", Price = 300 },
	{ Unit = "군인5", Price = 300 },
	{ Unit = "군인6", Price = 300 },
}

-- 클라이언트에서 설치 신호가 오면 실행되는 함수입니다
PlaceEvent.OnServerEvent:Connect(function(Player, UnitName, UnitCFrame, Target)
	-- Target이 nil이거나 설치 불가 영역이면 아무것도 하지 않습니다
	if not Target or Target == game.Workspace.NotPlace then return end

	local Coins = Player:WaitForChild("leaderstats"):WaitForChild("Coins")

	for _, unit in ipairs(UnitTable) do
		if unit.Unit == UnitName then
			-- 이미 같은 영웅이 설치된 자리면 중복 설치를 막습니다
			if unit.Unit == Target.Name then break end

            -- 플레이어별 유닛 폴더를 찾거나 없으면 새로 만듭니다
            -- 폴더 이름은 플레이어 이름 + "_Folder" 형식입니다 (예: wiki_gahee_Folder)
            local playerFolder = game.Workspace.UnitPlace:FindFirstChild(Player.Name .. "_Folder")
            if not playerFolder then
                playerFolder        = Instance.new("Folder")
                playerFolder.Name   = Player.Name .. "_Folder"
                playerFolder.Parent = game.Workspace.UnitPlace
            end

            -- 이미 최대 유닛 수(15개)에 도달했으면 설치를 중단합니다
            -- 설치가 중단되므로 코인도 차감되지 않습니다
            if #playerFolder:GetChildren() >= MaxUnitCount then
                break
            end

			if Coins.Value >= unit.Price then
				-- 코인을 차감하고 영웅을 설치합니다
				Coins.Value -= unit.Price

				-- UnitStats 모듈의 Place 함수로 영웅을 설치합니다
				-- 영웅 복사, 위치 설정, 고정이 모두 이 함수 안에서 처리됩니다
				local unitClone = UnitStats.Place(UnitName, UnitCFrame, Player.Name)

				if unitClone then
					-- 플레이어 폴더 안으로 이동합니다
    				unitClone.Parent = playerFolder

					-- 설치된 영웅의 모든 파트를 Units 충돌 그룹에 배정합니다
					-- 이렇게 해야 플레이어가 영웅을 통과할 수 있습니다
					for _, part in ipairs(unitClone:GetDescendants()) do
						if part:IsA("BasePart") then
							part.CollisionGroup = "Units"
						end
					end

					-- UnitScript를 복사해서 설치된 영웅 안에 넣고 활성화합니다
					-- 영웅마다 각자의 스크립트를 가지게 되어 독립적으로 작동합니다
					local ScriptClone = UnitScript:Clone()
					ScriptClone.Parent  = unitClone
					ScriptClone.Enabled = true
					print("스크립트 활성화 상태: " .. tostring(ScriptClone.Enabled))
					print("스크립트 부모 이름: " .. tostring(ScriptClone.Parent.Name))

					-- 영웅이 설치된 자리에 투명한 파트를 생성합니다
					-- 이 파트가 NotPlace 폴더에 들어가면 해당 자리에 마우스를 올렸을 때
					-- 빨간색으로 표시되어 중복 설치를 방지합니다
					local orientation, size = unitClone:GetBoundingBox()
					local blockPart         = Instance.new("Part")
					blockPart.CanCollide   = false
					blockPart.Transparency = 1
					blockPart.Anchored     = true
					blockPart.Size         = size + Vector3.new(3, 1, 4)
					blockPart.CFrame       = orientation
					blockPart.Parent       = game.Workspace.NotPlace
				end
			else
				warn(Player.Name .. " 코인 부족: " .. Coins.Value .. " / 필요: " .. unit.Price)
			end
			break
		end
	end
end)
