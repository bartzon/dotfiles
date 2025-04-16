local function reloadConfig(files)
  local doReload = false
  for _, file in pairs(files) do
    if file:sub(-4) == ".lua" then
      doReload = true
    end
  end
  if doReload then
    hs.reload()
  end
end

hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig):start()
hs.alert.show("Hammerspoon config loaded")

local token =
"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJiNGIxOGQxNzQ5MTg0ZmQ1OTU5OGNhMTlhMTYwYWViNCIsImlhdCI6MTcyOTU5NTEyMywiZXhwIjoyMDQ0OTU1MTIzfQ.NEuuCSeCjnF0gvx4NvBSyrTFsAAOFwFvnVKsjSsXQ78"
local headers = {}
headers["Authorization"] = "Bearer " .. token
local meeting_url = "http://homeassistant.local:8123/api/states/input_boolean.bart_in_meeting"

local my_camera = hs.camera.allCameras()[1]
my_camera:setPropertyWatcherCallback(function(camera)
  local in_meeting = ""
  if (camera:isInUse()) then
    in_meeting = "true"
  else
    in_meeting = "false"
  end
  hs.http.post(meeting_url, '{"state":' .. in_meeting .. '}', headers)
end)
my_camera:startPropertyWatcher()
