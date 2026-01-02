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

-- Error monitoring and auto-reload functionality
local error_count = 0
local last_error_time = 0
local ERROR_THRESHOLD = 3  -- Number of errors before auto-reload
local ERROR_TIME_WINDOW = 30  -- Time window in seconds to count errors
local RELOAD_COOLDOWN = 60  -- Minimum seconds between auto-reloads

local function shouldAutoReload(error_message)
  local current_time = os.time()
  
  -- Check if this is the specific video device error we're looking for
  if string.find(error_message, "getVideoDeviceIsUsed") and 
     string.find(error_message, "get data size error") then
    
    -- Reset counter if too much time has passed since last error
    if current_time - last_error_time > ERROR_TIME_WINDOW then
      error_count = 0
    end
    
    error_count = error_count + 1
    last_error_time = current_time
    
    print("Video device error detected (" .. error_count .. "/" .. ERROR_THRESHOLD .. "): " .. error_message)
    
    if error_count >= ERROR_THRESHOLD then
      print("Error threshold reached, initiating auto-reload...")
      error_count = 0  -- Reset counter
      return true
    end
  end
  
  return false
end

-- Override the default error handler to catch and handle video device errors
local original_error_handler = hs.logger.defaultLogLevel
local last_reload_time = 0

-- Monitor console output for the specific error
hs.console.setConsole(function(message)
  if shouldAutoReload(message) then
    local current_time = os.time()
    if current_time - last_reload_time > RELOAD_COOLDOWN then
      last_reload_time = current_time
      hs.alert.show("Auto-reloading due to video device errors", 3)
      hs.timer.doAfter(1, function()
        hs.reload()
      end)
    else
      print("Auto-reload skipped due to cooldown period")
    end
  end
end)

hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig):start()
hs.alert.show("Hammerspoon config loaded")

local token =
"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJiNGIxOGQxNzQ5MTg0ZmQ1OTU5OGNhMTlhMTYwYWViNCIsImlhdCI6MTcyOTU5NTEyMywiZXhwIjoyMDQ0OTU1MTIzfQ.NEuuCSeCjnF0gvx4NvBSyrTFsAAOFwFvnVKsjSsXQ78"
local headers = {}
headers["Authorization"] = "Bearer " .. token
headers["Content-Type"] = "application/json"
local meeting_url = "http://homeassistant.local:8123/api/states/input_boolean.bart_in_meeting"

local cameras = hs.camera.allCameras()
if #cameras == 0 then
  hs.alert.show("No cameras found!")
  return
end

local my_camera = cameras[1]
print("Using camera: " .. (my_camera:name() or "Unknown"))


-- Camera error tracking for backoff
local camera_error_count = 0
local last_camera_error_time = 0
local camera_monitoring_paused = false
local CAMERA_ERROR_BACKOFF_BASE = 30  -- Base seconds for backoff
local CAMERA_ERROR_THRESHOLD = 5      -- Errors before pausing monitoring

local function safeCameraIsInUse(camera)
  -- Skip if monitoring is temporarily paused due to errors
  if camera_monitoring_paused then
    local current_time = os.time()
    local backoff_duration = CAMERA_ERROR_BACKOFF_BASE * math.pow(2, math.min(camera_error_count - CAMERA_ERROR_THRESHOLD, 4))
    
    if current_time - last_camera_error_time > backoff_duration then
      print("Resuming camera monitoring after " .. backoff_duration .. "s backoff")
      camera_monitoring_paused = false
      camera_error_count = 0
    else
      return nil  -- Still in backoff period
    end
  end
  
  local success, result = pcall(function()
    return camera:isInUse()
  end)
  
  if not success then
    local current_time = os.time()
    
    -- Reset error count if enough time has passed
    if current_time - last_camera_error_time > 60 then
      camera_error_count = 0
    end
    
    camera_error_count = camera_error_count + 1
    last_camera_error_time = current_time
    
    print("Camera error (" .. camera_error_count .. "/" .. CAMERA_ERROR_THRESHOLD .. "): " .. tostring(result))
    
    -- Pause monitoring if too many errors
    if camera_error_count >= CAMERA_ERROR_THRESHOLD then
      camera_monitoring_paused = true
      local backoff_duration = CAMERA_ERROR_BACKOFF_BASE * math.pow(2, math.min(camera_error_count - CAMERA_ERROR_THRESHOLD, 4))
      print("Too many camera errors, pausing monitoring for " .. backoff_duration .. "s")
    end
    
    return nil
  end
  
  -- Reset error count on successful call
  if camera_error_count > 0 then
    print("Camera monitoring recovered after " .. camera_error_count .. " errors")
    camera_error_count = 0
  end
  
  return result
end


local MAX_RETRIES = 3
local RETRY_DELAY = 2.0
local REQUEST_TIMEOUT = 10.0

local function sendHttpRequestWithRetry(url, body, headers, callback, attempt)
  attempt = attempt or 1
  
  print("Attempt " .. attempt .. "/" .. MAX_RETRIES .. " - sending request...")
  
  local timer = hs.timer.doAfter(REQUEST_TIMEOUT, function()
    print("Request timeout on attempt " .. attempt)
    if attempt < MAX_RETRIES then
      hs.timer.doAfter(RETRY_DELAY, function()
        sendHttpRequestWithRetry(url, body, headers, callback, attempt + 1)
      end)
    else
      print("All retry attempts failed - giving up")
      if callback then callback(nil, "timeout", nil) end
    end
  end)
  
  hs.http.asyncPost(url, body, headers, function(status, response_body, response_headers)
    timer:stop()
    
    if status == 200 then
      print("Request successful on attempt " .. attempt)
      if callback then callback(status, response_body, response_headers) end
    elseif attempt < MAX_RETRIES then
      print("Request failed with status " .. tostring(status) .. " on attempt " .. attempt .. ", retrying in " .. RETRY_DELAY .. "s")
      hs.timer.doAfter(RETRY_DELAY, function()
        sendHttpRequestWithRetry(url, body, headers, callback, attempt + 1)
      end)
    else
      print("All retry attempts failed with final status: " .. tostring(status))
      if callback then callback(status, response_body, response_headers) end
    end
  end)
end

local function sendMeetingStatus(camera)
  local camera_in_use = safeCameraIsInUse(camera)
  
  if camera_in_use == nil then
    print("Skipping status update due to camera error")
    return
  end
  
  -- Consider "in meeting" if camera is in use
  local in_meeting = (camera_in_use == true)
  local state_value = in_meeting and "on" or "off"
  local json_body = '{"state":"' .. state_value .. '"}'
  
  print("Camera in use: " .. tostring(camera_in_use) .. ", Meeting status: " .. state_value)
  
  sendHttpRequestWithRetry(meeting_url, json_body, headers, function(status, body, headers)
    if status == 200 then
      print("Successfully updated meeting status to: " .. state_value)
    else
      print("Failed to update meeting status. Status: " .. tostring(status) .. ", Body: " .. tostring(body))
    end
  end)
end

local TIMER_INTERVAL = 20.0  -- Reduced frequency to minimize system calls
local last_camera_state = nil
local status_timer = nil
local property_watcher_active = false

local function checkDeviceStatusPeriodically()
  -- Skip timer checks if property watcher is active and working
  if property_watcher_active then
    return
  end
  
  local current_camera_state = safeCameraIsInUse(my_camera)
  
  if current_camera_state == nil then
    print("Skipping periodic check due to camera error")
    return
  end
  
  if current_camera_state ~= last_camera_state then
    print("Timer detected device state change:")
    print("  Camera: " .. tostring(last_camera_state) .. " -> " .. tostring(current_camera_state))
    sendMeetingStatus(my_camera)
    last_camera_state = current_camera_state
  end
end

my_camera:setPropertyWatcherCallback(function(camera)
  print("Event: Camera property changed")
  property_watcher_active = true  -- Mark watcher as active when it fires
  
  local current_camera_state = safeCameraIsInUse(camera)
  
  if current_camera_state == nil then
    print("Skipping property watcher event due to camera error")
    property_watcher_active = false  -- Disable if errors occur
    return
  end
  
  if current_camera_state ~= last_camera_state then
    print("Event detected device state change:")
    print("  Camera: " .. tostring(last_camera_state) .. " -> " .. tostring(current_camera_state))
    sendMeetingStatus(camera)
    last_camera_state = current_camera_state
  end
end)


print("Checking initial device status...")
last_camera_state = safeCameraIsInUse(my_camera)

if last_camera_state ~= nil then
  sendMeetingStatus(my_camera)
else
  print("Initial camera check failed, skipping initial status update")
end

local success, error_msg = pcall(function()
  my_camera:startPropertyWatcher()
end)

if success then
  print("Property watcher started (event-based)")
  -- Give property watcher a chance to prove it works, fallback to timer if needed
  hs.timer.doAfter(30, function()
    if not property_watcher_active then
      print("Property watcher hasn't fired in 30s, enabling timer fallback")
    end
  end)
else
  print("Failed to start property watcher: " .. tostring(error_msg))
  print("Using timer-only monitoring")
  property_watcher_active = false
end

status_timer = hs.timer.doEvery(TIMER_INTERVAL, checkDeviceStatusPeriodically)
print("Timer-based polling started (checking camera every " .. TIMER_INTERVAL .. "s, will be disabled if property watcher works)")
