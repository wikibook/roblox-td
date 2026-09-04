for _, v in pairs(EquipUnit:GetChildren()) do
      for i = 1, 5 do
            if PlayerGui.MainGui.Frame[i].TextLabel.Text == v.Name then
                  table.insert(EquipUnitData, v.Name)
            end
      end
end
