-- 3. 서버가 몬스터를 직접 제어하도록 설정합니다 (멈춤 현상 방지)
for _, part in ipairs(Clone:GetDescendants()) do
      if part:IsA("BasePart") then
            part:SetNetworkOwner(nil)
      end
end
