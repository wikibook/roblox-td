 -- 유닛마다 총 모델 구조가 다를 경우 이름별로 Attachment 경로를 지정합니다
local attachment
if Unit.Name == "군인" then
      attachment = Unit.Handgun.Handle.Attachment
elseif Unit.Name == "군인2" then -- 군인2의 무기에 맞게 장착 경로 변경
      attachment = Unit.ClassicSword.Handle
elseif Unit.Name == "군인3" then
      attachment = Unit.Handgun.Handle.Attachment
elseif Unit.Name == "군인4" then
      attachment = Unit.Handgun.Handle.Attachment
elseif Unit.Name == "군인5" then
      attachment = Unit.Handgun.Handle.Attachment
elseif Unit.Name == "군인6" then
      attachment = Unit.Handgun.Handle.Attachment
end
