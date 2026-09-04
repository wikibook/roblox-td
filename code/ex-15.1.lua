-- 필요한 서비스와 오브젝트를 가져옵니다
local UserInputService = game:GetService("UserInputService")


local Frame  = script.Parent
local Part   = game.ReplicatedStorage:WaitForChild("UI")     -- 범위 표시 파트입니다
local Units  = game.ReplicatedStorage:WaitForChild("Units")  -- 영웅 모델이 들어있는 폴더입니다
local Event  = game.ReplicatedStorage:WaitForChild("PlaceEvent") -- 설치 위치를 서버에 전달합니다


local Player   = game.Players.LocalPlayer
local Mouse    = Player:GetMouse()


-- 상태를 관리하는 변수들입니다
local Debounce = false -- 버튼이 중복으로 눌리는 것을 방지합니다
local Cancel   = false -- Q키를 누르면 true가 되어 설치를 취소합니다
local Place    = false -- 클릭하면 true가 되어 설치를 확정합니다
local NotPlace = false -- 설치 불가능한 위치면 true가 됩니다


-- 영웅이 설치될 높이를 설정합니다 (맵 환경에 맞게 조정해 주세요)
local Height = 0


-- 마우스 위치에 따라 미리보기 색상을 바꾸는 함수입니다
-- 설치 가능한 위치면 흰색, 불가능한 위치면 빨간색으로 표시합니다
local function PartColor(clone, highlight)
    local color = Color3.new(1, 1, 1) -- 기본값은 흰색입니다

    if Mouse.Target ~= nil then
        if Mouse.Target.Parent.ClassName == "Folder" then
            -- 마우스가 Folder 위에 있으면 설치 불가 영역입니다
            color    = Color3.new(1, 0.2, 0.2)
            NotPlace = true
        else
            color    = Color3.new(1, 1, 1)
            NotPlace = false
        end
    else
        NotPlace = true
    end

    -- Highlight와 범위 파트의 색상을 바꿉니다
    highlight.OutlineColor = color
    highlight.FillColor    = color


    for _, v in ipairs(clone.SurfaceGui:GetChildren()) do
        v.BackgroundColor3 = color


        local stroke = v:FindFirstChild("UIStroke")
        if stroke then stroke.Color = color end


        local image = v:FindFirstChild("ImageLabel")
        if image then image.ImageColor3 = color end
    end
end


-- Q키를 누르면 설치를 취소합니다
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.Q then
        if Debounce then
            Cancel = true
        end
    end
end)


-- 화면을 클릭하면 Place를 true로 바꿔 설치를 확정합니다
-- 모바일과 PC 환경을 모두 지원합니다
local function onClickPlace()
    if not Cancel and Debounce and not NotPlace then
        Place = true
    end
end


if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then
    -- 모바일 환경
    UserInputService.TouchTapInWorld:Connect(function(_, processedByUI)
        if not processedByUI then onClickPlace() end
    end)
else
    -- PC 환경
    Mouse.Button1Down:Connect(onClickPlace)
end


-- 영웅 버튼을 클릭했을 때 미리보기를 보여주고 설치 위치를 결정합니다
for _, v in ipairs(Frame:GetChildren()) do
    if not v:IsA("Frame") then continue end -- 프레임이 아니면 넘어갑니다


    local imageButton = v:WaitForChild("ImageButton")


    imageButton.MouseButton1Click:Connect(function()
        if Debounce then
            -- 이미 선택 중이면 취소합니다
            Cancel = true
            return
        end


        Debounce = true


        -- 빈 슬롯이면 아무것도 하지 않습니다
        if v.TextLabel.Text == "" or v.ImageButton.Image == "" then
            Debounce = false
            return
        end


        -- 범위 표시 파트를 복사합니다
        local clone = Part:Clone()
        clone.Parent = game.Workspace.SpawnMobs -- TargetFilter에 포함시켜 마우스가 무시하도록 합니다


        local unit = Units:FindFirstChild(v.TextLabel.Text) -- 버튼 이름으로 영웅을 찾습니다
        if not unit then
            Debounce = false
            return
        end


        -- 미리보기용 영웅을 복사합니다
        local unitClone = unit:Clone()
        unitClone.Parent = game.Workspace.SpawnMobs
        unitClone:WaitForChild("HumanoidRootPart").Anchored = true -- 고정하지 않으면 아래로 떨어집니다


        -- 미리보기 영웅의 모든 파트를 충돌 불가로 설정
        for _, part in ipairs(unitClone:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end


        -- Highlight로 미리보기 영웅에 테두리를 추가합니다
        local highlight = Instance.new("Highlight")
        highlight.Parent           = unitClone
        highlight.FillTransparency = 0.8


        -- 마우스를 따라 미리보기를 업데이트합니다
        while task.wait() do
            -- 마우스 위치에 맞게 영웅이 놓일 위치를 계산합니다
            local unitCFrame = CFrame.new(
                Mouse.Hit.Position.X,
                Height + unitClone:GetExtentsSize().Y / 2,
                Mouse.Hit.Position.Z
            )


            PartColor(clone, highlight) -- 위치에 따라 색상을 업데이트합니다


            -- SpawnMobs 폴더 안의 오브젝트는 마우스가 무시합니다 (몬스터 방해 방지)
            Mouse.TargetFilter = game.Workspace.SpawnMobs


            unitClone.PrimaryPart.CFrame = unitCFrame
            clone.Position = Vector3.new(Mouse.Hit.Position.X, Height, Mouse.Hit.Position.Z)


            if Cancel then break end -- Q키를 누르면 설치를 취소합니다


            if Place then
                -- 설치 위치를 서버에 전달합니다
                Event:FireServer(v.TextLabel.Text, unitCFrame, Mouse.Target.Parent)
                break
            end
        end


        -- 변수를 초기화하고 미리보기를 삭제합니다
        Cancel = false
        Place  = false
        clone:Destroy()
        unitClone:Destroy()


        Debounce = false
    end)
end
