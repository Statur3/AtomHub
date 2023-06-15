local StartTick = tick();

if typeof(syn) == "table" and gethui then
    syn.protect_gui = not gethui and syn.protect_gui or function(Instance) Instance.Parent = gethui() end;
end

if not game:IsLoaded() then
    game.Loaded:Wait();
end

warn("--<< AtomHub Loader >>--")

local File = loadstring(game:HttpGet(("https://raw.githubusercontent.com/Statur3/AtomHub/main/Handlers/File.lua")))();

File:Setup("AtomHub", "1.0.0", {
    Subfolders = { "Games" },
    HubData = { Owner = "Statur3", Repo = "AtomHub" }
});

File:QueueDownload("AtomHub/Loader.lua", "https://raw.githubusercontent.com/Statur3/AtomHub/main/Loader.lua", true);

for _, Game in next, File:GetFilesFrom("https://github.com/Statur3/AtomHub/tree/main/Games") do
    local Name = Game:match("([^/]+)$");
    local Url = "https://raw.githubusercontent.com/Statur3/AtomHub/main/Games/"..Name;

    File:QueueDownload("AtomHub/Games/"..Name, Url);
end

File:DownloadQueued();

local function GetGameFromPlaceId()
    local Games = File:Load("AtomHub/Games/PlaceIds.lua");

    for Game, PlaceId in next, Games do
        if PlaceId == game.PlaceId then
            return Game;
        end
    end

    return false;
end

local Game = GetGameFromPlaceId();

if not Game then
    return File:Load("AtomHub/Games/Universal.lua");
end

File:Load(string.format("AtomHub/Games/%s.lua", Game));

print(string.format("AtomHub took %.2f second(s) to load.", tick() - StartTick));
