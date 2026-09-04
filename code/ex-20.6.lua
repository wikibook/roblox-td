-- 영웅별 스탯을 한곳에서 관리하는 모듈 스크립트입니다
-- 새로운 영웅을 추가하려면 아래 형식으로 추가하면 됩니다
local Unit = {
    ["군인"] = {
        CoolTime = 1,  -- 공격 간격(초)입니다
        Damage   = 45, -- 한 번에 입히는 데미지입니다
        Range    = 35, -- 공격 가능한 거리입니다
        ShotCoin = 5,  -- 공격할 때마다 지급되는 코인입니다
    },
    ["군인2"] = {
        CoolTime = 1,
        Damage   = 45,
        Range    = 35,
        ShotCoin = 5,
    },
    ["군인3"] = {
        CoolTime = 1,
        Damage   = 45,
        Range    = 35,
        ShotCoin = 5,
    },
    ["군인4"] = {
        CoolTime = 1,
        Damage   = 45,
        Range    = 35,
        ShotCoin = 5,
    },
    ["군인5"] = {
        CoolTime = 1,
        Damage   = 45,
        Range    = 35,
        ShotCoin = 5,
    },
    ["군인6"] = {
        CoolTime = 1,
        Damage   = 45,
        Range    = 35,
        ShotCoin = 5,
    },
    -- 새로운 영웅을 추가하려면 여기에 같은 형식으로 입력하세요
}

-- 영웅을 복사해서 지정한 위치에 설치하는 함수입니다
-- Player는 영웅을 설치한 플레이어의 이름입니다
function Unit.Place(UnitName, UnitCFrame, Player)
    local unitData = Unit[UnitName] -- 해당 영웅의 스탯 데이터를 가져옵니다
    if not unitData then return nil end -- 스탯 데이터가 없으면 설치하지 않습니다

    local Folder = game.ReplicatedStorage:WaitForChild("Units")

    -- 영웅 모델이 존재하는지 확인합니다
    if not Folder:FindFirstChild(UnitName) then return nil end

    -- 영웅 모델을 복사해서 UnitPlace 폴더에 배치합니다
    local unitClone = Folder:WaitForChild(UnitName):Clone()
    unitClone.Parent = game.Workspace.UnitPlace

    -- 지정한 위치로 영웅을 이동시킵니다
    unitClone:PivotTo(UnitCFrame)

    -- 영웅이 제자리에 고정되도록 설정합니다
    if unitClone.PrimaryPart then
        unitClone.PrimaryPart.Anchored = true
    end

    -- 스탯 정보를 영웅 모델의 Attribute(속성)로 저장합니다
    -- Attribute는 오브젝트에 붙여두는 메모지와 같습니다
    -- 공격 스크립트에서 GetAttribute로 이 값을 꺼내 사용합니다
    unitClone:SetAttribute("Damage",   unitData.Damage)
    unitClone:SetAttribute("Range",    unitData.Range)
    unitClone:SetAttribute("CoolTime", unitData.CoolTime)
    unitClone:SetAttribute("ShotCoin", unitData.ShotCoin) -- 공격 시 지급할 코인입니다
    unitClone:SetAttribute("Owner",    Player)            -- 영웅을 설치한 플레이어 이름입니다

    return unitClone -- 설치된 영웅 모델을 반환합니다
end

-- 이 모듈을 불러온 스크립트에서 Unit 테이블을 사용할 수 있게 합니다
return Unit
