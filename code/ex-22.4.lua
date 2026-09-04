for _, UI in pairs(UnitImage) do
      if EquipUnit.Name == UI.Unit then
            if EquipUnit.Value == i then
                  local Frame = MainFrame:FindFirstChild(i)

                  if Frame then
                        Frame.ImageButton.Image = UI.Image
                        Frame.TextLabel.Text = UI.Unit
                        Frame.PriceText.Text = UI.Price.." "
                        break
                  end
            end
      end
end
