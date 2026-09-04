while true do
      Wave += 1 -- 웨이브를 1 올립니다
      local FindWave = Waves:FindFirstChild(tostring(Wave)) -- 현재 웨이브 번호에 해당하는 폴더를 찾습니다 (예: Wave가 1이면 "1"이라는 이름의 폴더를 찾습니다)
     RemoteEvent:FireAllClients(Wave) -- 모든 플레이어 화면의 웨이브 번호를 업데이트합니다

     if FindWave then
           Main(FindWave) -- 해당 웨이브의 몬스터를 스폰합니다
     else
           print("웨이브 종료") -- 더 이상 웨이브가 없으면 종료합니다
           break
     end

     task.wait(WaveTime) -- 다음 웨이브 시작 전에 WaveTime만큼 기다립니다
end
