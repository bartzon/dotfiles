function reloadConfig(files)
  doReload = false
  for _, file in pairs(files) do
    if file:sub(-4) == ".lua" then
      doReload = true
    end
  end
  if doReload then
    hs.reload()
  end
end

myWatcher = hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig):start()
hs.alert.show("Hammerspoon config loaded")

local camera = hs.camera.allCameras()[1]
camera:setPropertyWatcherCallback(function(camera, property, scope, element)
  local meeting_url = "http://mini.local:51828/?accessoryId=bart_meeting&state="
  if (camera:isInUse()) then
    meeting_url = meeting_url .. "true"
  else
    meeting_url = meeting_url .. "false"
  end
  hs.http.doRequest(meeting_url, "GET")
end)
camera:startPropertyWatcher()
