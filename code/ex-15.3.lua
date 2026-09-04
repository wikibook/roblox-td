-- 기존
if Mouse.Target.Parent.ClassName == "Folder" then

-- 변경
if Mouse.Target.Parent == game.Workspace.NotPlace
   or Mouse.Target.Parent.Parent == game.Workspace.NotPlace then
