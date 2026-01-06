
local function setInputSource(source)
    local inputSources = hs.keycodes.layouts()
--    print("Input sources " .. hs.inspect(inputSources))

    for _, layout in ipairs(inputSources) do
        if layout == source then
            hs.keycodes.setLayout(source)
            return true
        end
    end
    return false
end


local function usbDeviceCallback(data)
--    print("Got a callback")
--    print("Device details:", hs.inspect(data))

    if data and data["vendorName"] == "Keychron" then
        if data["eventType"] == "added" then
            print("Keyboard added - switching input source")
            local success = setInputSource("British – PC")

            local message = "Keyboard connected: "
            if success then
                message = message .. "\nInput source changed to British - PC"
            else
                message = message .. "\nFailed to change input source"
            end

            hs.notify.new({
                title = "Keyboard Connected",
                informativeText = message
            }):send()
        elseif data["eventType"] == "removed" then
            print("Keyboard removed - switching input source")
            local success = setInputSource("British")

            local message = "Keyboard disconnected: "
            if success then
                message = message .. "\nInput source changed to British"
            else
                message = message .. "\nFailed to change input source"
            end

            hs.notify.new({
                title = "Keyboard Disconnected",
                informativeText = message
            }):send()
        end
    end
end

usbWatcher = hs.usb.watcher.new(usbDeviceCallback)
usbWatcher:start()
print("Started watching for USB device changes")
