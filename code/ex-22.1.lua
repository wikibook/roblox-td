local Player    = game.Players.LocalPlayer
local UnitLabel = script.Parent -- 유닛 수를 표시할 텍스트 레이블입니다

-- 내 유닛이 저장된 폴더를 가져옵니다
-- 폴더 이름은 플레이어 이름 + "_Folder" 형식입니다 (예: wiki_gahee_Folder)
local UnitPlaceFolder = game.Workspace:WaitForChild("UnitPlace")
local UnitFolder      = UnitPlaceFolder:WaitForChild(Player.Name .. "_Folder")

-- 현재 설치된 유닛 수를 화면에 업데이트하는 함수입니다
local function UpdateUnitCount()
    local unitNumber = #UnitFolder:GetChildren() -- 폴더 안의 유닛 수를 셉니다
    UnitLabel.Text = "나의 유닛 수: " .. unitNumber .. "/15"
end

-- 유닛이 설치될 때마다 자동으로 업데이트합니다
UnitFolder.ChildAdded:Connect(UpdateUnitCount)

-- 유닛이 삭제될 때마다 자동으로 업데이트합니다
UnitFolder.ChildRemoved:Connect(UpdateUnitCount)

-- 게임 시작 시 초기값을 표시합니다
UpdateUnitCount()
