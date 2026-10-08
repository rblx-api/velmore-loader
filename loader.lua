-- Velmore Protect Loader
print("[Velmore Protect] Loading...")

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local API = "https://students-colleague-television-italic.trycloudflare.com/api/loader"

local key = rawget(_G, "script_key")
    or (getgenv and rawget(getgenv(), "script_key"))
    or rawget(_G, "VELMORE_KEY")
    or ""

if type(key) ~= "string" or key == "" then
    return warn("[Velmore Protect] Missing script_key.\nExample:\nscript_key = \"YOUR-KEY\"\nloadstring(game:HttpGet(\"https://velmore-loader.vercel.app/loader.lua\"))()")
end

local lp = Players.LocalPlayer
if not lp then
    return warn("[Velmore Protect] LocalPlayer not found")
end

local body = HttpService:JSONEncode({
    key = key,
    roblox_user = lp.Name,
})

local req = (syn and syn.request)
    or (http and http.request)
    or http_request
    or request
    or (fluxus and fluxus.request)

if not req then
    return warn("[Velmore Protect] No HTTP request function in this executor")
end

local res = req({
    Url = API,
    Method = "POST",
    Headers = { ["Content-Type"] = "application/json" },
    Body = body,
})

if not res or (res.StatusCode and res.StatusCode ~= 200) then
    local code = res and res.StatusCode or "?"
    local errBody = res and (res.Body or res.body) or ""
    return warn("[Velmore Protect] Access denied (" .. tostring(code) .. ") " .. tostring(errBody))
end

local raw = res.Body or res.body or ""
local ok, data = pcall(function()
    return HttpService:JSONDecode(raw)
end)

if not ok or type(data) ~= "table" or type(data.script) ~= "string" then
    return warn("[Velmore Protect] Invalid response from API")
end

print("[Velmore Protect] OK — running script")
local fn, err = loadstring(data.script)
if not fn then
    return warn("[Velmore Protect] loadstring error: " .. tostring(err))
end
fn()
