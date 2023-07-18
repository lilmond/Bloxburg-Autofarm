-- Copyright: https://github.com/lilmond
-- Original Source: https://github.com/lilmond/Bloxburg-Autofarm

-- Note:
-- Don't forget to click on the "Done" button after running the script to hook the RemoteEvent.
-- This only works for the Hairdresser job.
-- Anti-AFK kick bypassed.

local VirtualUser = game:GetService("VirtualUser")

local EVENT = nil

if getgenv().SAVED_EVENT then
    EVENT = getgenv().SAVED_EVENT
end

if not EVENT then
    local mt = getrawmetatable(game)
    local old = mt.__namecall
    setreadonly(mt, false)
    mt.__namecall = function(self, ...)
        local method = getnamecallmethod()
        
        if method == "FireServer" then
            if rawget(..., "Order") and rawget(..., "Workstation") then
                EVENT = self
                setreadonly(mt, false)
                mt.__namecall = old
                setreadonly(mt, true)
                return old(self, ...)
            end
        end

        return old(self, ...)
    end
    setreadonly(mt, true)

    repeat wait() until EVENT
end

getgenv().SAVED_EVENT = EVENT
getgenv().autofarm = true -- set to false to manually stop

while getgenv().autofarm and wait(1) do
    for i, workstation in pairs(game:GetService("Workspace").Environment.Locations.StylezHairStudio.HairdresserWorkstations:GetChildren()) do
        local customer = workstation.Occupied.Value
        if not customer then continue end

        local order = customer.Order
        local color = order.Color.Value
        local style = order.Style.Value

        EVENT:FireServer(
            {
                ["Order"] = {style, color},
                ["Workstation"] = workstation
            }
        )
    end
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end
