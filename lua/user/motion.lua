local status_ok, leap = pcall(require, "leap")
if not status_ok then
  print("leap not working")
end

-- override conflicts
leap.add_default_mappings(true)
