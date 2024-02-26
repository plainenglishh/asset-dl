local process = require("@lune/process");
local net = require("@lune/net");
local fs = require("@lune/fs");

function main(argc: number, argv: {string}): number
    local asset_id = argv[1];
    local output = argv[2];
    local version_id = argv[3];

    local ver = "";
    if version_id then
        ver = `version/{version_id}`;
    end

    local info = net.request({
        url = `https://assetdelivery.roblox.com/v1/assetId/{asset_id}/{ver}`
    });

    assert(info.ok, "Request for asset metadata failed.");
    info = net.jsonDecode(info.body);
    assert(info.location, "No location available");

    local asset = net.request({
        url = info.location
    });

    assert(asset.ok, "Asset failed to download");

    fs.writeFile(output, asset.body);

    return 0;
end

process.exit(main(#process.args, process.args))