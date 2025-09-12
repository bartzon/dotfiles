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
headers["Content-Type"] = "application/json"
local meeting_url = "http://homeassistant.local:8123/api/states/input_boolean.bart_in_meeting"

-- Get available cameras with error handling
local cameras = hs.camera.allCameras()
if #cameras == 0 then
  hs.alert.show("No cameras found!")
  return
end

local my_camera = cameras[1]
print("Using camera: " .. (my_camera:name() or "Unknown"))

my_camera:setPropertyWatcherCallback(function(camera)
  local in_use = camera:isInUse()
  local state_value = in_use and "on" or "off"
  local json_body = '{"state":"' .. state_value .. '"}'
  
  print("Camera in use: " .. tostring(in_use) .. ", sending: " .. json_body)
  
  hs.http.asyncPost(meeting_url, json_body, headers, function(status, body, headers)
    if status == 200 then
      print("Successfully updated meeting status to: " .. state_value)
    else
      print("Failed to update meeting status. Status: " .. tostring(status) .. ", Body: " .. tostring(body))
    end
  end)
end)

my_camera:startPropertyWatcher()
