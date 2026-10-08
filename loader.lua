-- Velmore Protect Loader
print("[Velmore Protect] Loading...")

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

-- ⚠️ Cambia esto por la URL de TU API (túnel Cloudflare o dominio)
local API = "https://TU_TUNEL.trycloudflare.com/api/loader"

local body = HttpService:JSONEncode({
    roblox_user = Players.LocalPlayer.Name,
})

local res = request({
    Url = API,
    Method = "POST",
    Headers = { ["Content-Type"] = "application/json" },
    Body = body,
})

if not res or res.StatusCode ~= 200 then
    return warn("[Velmore Protect] Access denied / API offline")
end

local ok, data = pcall(function()
    return HttpService:JSONDecode(res.Body)
end)

if not ok or not data or not data.script then
    return warn("[Velmore Protect] No script returned")
end

loadstring(data.script)()
