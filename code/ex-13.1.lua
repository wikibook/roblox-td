-- 영웅 정보를 설정합니다
local Unit        = "군인"
local MiddleTitle = "Weapon Unit"
local Explanation = "권총을 들고 싸우는 중거리 영웅."
local Price       = "300원"

-- UI 요소들을 가져옵니다
local Button     = script.Parent
local ShopFrame  = Button.Parent.Parent
local Click      = ShopFrame:WaitForChild("Click") -- 클릭 시 나타나는 상세 정보 창입니다

local Image = Button:WaitForChild("Image").Image -- 버튼에 표시된 영웅 이미지입니다

-- 버튼을 클릭하면 영웅 상세 정보를 표시하는 함수입니다
local function MouseClick()
    Click.ImageLabel.Image  = Image       -- 영웅 이미지를 표시합니다
    Click.Title.Text        = Unit        -- 영웅 이름을 표시합니다
    Click.MiddleTitle.Text  = MiddleTitle -- 영웅 종류를 표시합니다
    Click.Explanation.Text  = Explanation -- 영웅 설명을 표시합니다
    Click.Price.Text         = Price       -- 영웅 가격을 표시합니다

    Click.Visible = true -- 상세 정보 창을 화면에 보이게 합니다
end

-- 버튼을 클릭하면 MouseClick 함수를 실행합니다
Button.MouseButton1Click:Connect(MouseClick)
