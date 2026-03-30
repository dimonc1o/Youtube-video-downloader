const std = @import("std");

const html_page =
    \\<!DOCTYPE html>
    \\<html lang="en">
    \\<head>
    \\    <meta charset="UTF-8">
    \\    <title>YTD by dimoncio</title>
    \\    <style>
    \\        body { background-color: #000; color: #fff; display: flex; flex-direction: column; justify-content: center; align-items: center; height: 100vh; margin: 0; font-family: 'Segoe UI', sans-serif; overflow: hidden; }
    \\        h1 { letter-spacing: 5px; margin-bottom: 30px; font-weight: 200; transition: all 0.5s ease; }
    \\        .container { position: relative; display: flex; align-items: center; gap: 10px; z-index: 2; }
    \\        input { 
    \\            padding: 15px 25px; width: 400px; border: 1px solid #333; background: #111; color: #fff; 
    \\            border-radius: 12px; font-size: 16px; outline: none; transition: all 0.4s ease; 
    \\        }
    \\        input:hover, input:focus { border-color: #555; box-shadow: 0 0 20px rgba(255, 255, 255, 0.1); }
    \\        .btn-download {
    \\            width: 0; opacity: 0; overflow: hidden; background: #fff; color: #000; border: none; border-radius: 12px;
    \\            padding: 15px 0; cursor: pointer; font-size: 20px; transition: all 0.5s cubic-bezier(0.175, 0.885, 0.32, 1.275);
    \\            display: flex; align-items: center; justify-content: center;
    \\        }
    \\        input:not(:placeholder-shown) + .btn-download { width: 60px; opacity: 1; padding: 15px; }
    \\        .info-panel { 
    \\            margin-top: 20px; width: 420px; font-size: 14px; color: #888; 
    \\            display: none; opacity: 1; max-height: 200px;
    \\            transition: opacity 0.5s ease, max-height 0.5s ease, transform 0.5s ease, margin 0.5s ease;
    \\            overflow: hidden;
    \\        }
    \\        .info-panel.hidden {
    \\            display: block !important;
    \\            opacity: 0;
    \\            max-height: 0;
    \\            transform: translateY(-40px);
    \\            margin-top: 0;
    \\        }
    \\        #status-text { color: #fff; font-weight: bold; margin-bottom: 10px; display: block; }
    \\        .loader { width: 100%; height: 4px; background: #222; position: relative; overflow: hidden; margin-top: 15px; border-radius: 2px; }
    \\        .loader::after { content: ""; position: absolute; left: -150%; width: 100%; height: 100%; background: #fff; animation: loading 2s infinite; }
    \\        @keyframes loading { 100% { left: 100%; } }
    \\        .author { position: fixed; bottom: 20px; font-size: 10px; letter-spacing: 2px; color: #333; text-transform: uppercase; }
    \\    </style>
    \\</head>
    \\<body>
    \\    <h1>YTD</h1>
    \\    <div class="container">
    \\        <input type="text" id="url" placeholder="Paste YouTube link here..." autocomplete="off" />
    \\        <button class="btn-download" id="dl-btn">➔</button>
    \\    </div>
    \\    <div class="info-panel" id="info">
    \\        <span id="status-text">Processing video download...</span>
    \\        <div class="loader"></div>
    \\    </div>
    \\    <div class="author">Created by dimoncio</div>
    \\    <script>
    \\        const input = document.getElementById('url');
    \\        const btn = document.getElementById('dl-btn');
    \\        const info = document.getElementById('info');
    \\        btn.onclick = async () => {
    \\            const url = input.value.trim();
    \\            if (!url) return;
    \\            info.classList.remove('hidden');
    \\            info.style.display = 'block';
    \\            document.getElementById('status-text').innerText = "Processing video download...";
    \\            const res = await fetch('/dl?url=' + encodeURIComponent(url));
    \\            if (res.ok) {
    \\                document.getElementById('status-text').innerText = "Done! Video ready for AE.";
    \\                input.value = "";
    \\                setTimeout(() => {
    \\                    info.classList.add('hidden');
    \\                    setTimeout(() => {
    \\                        if (info.classList.contains('hidden')) info.style.display = 'none';
    \\                    }, 500);
    \\                }, 2000);
    \\            } else {
    \\                document.getElementById('status-text').innerText = "Error! Check connection.";
    \\            }
    \\        };
    \\    </script>
    \\</body>
    \\</html>
;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const address = try std.net.Address.parseIp4("127.0.0.1", 8080);
    var net_server = try address.listen(.{ .reuse_address = true });
    defer net_server.deinit();

    while (true) {
        const conn = try net_server.accept();
        defer conn.stream.close();

        var read_buffer: [4096]u8 = undefined;
        var http_server = std.http.Server.init(conn, &read_buffer);
        var request = try http_server.receiveHead();

        if (std.mem.indexOf(u8, request.head.target, "/dl?url=")) |index| {
            const encoded_url = request.head.target[index + 8 ..];
            const url_buffer = try allocator.dupe(u8, encoded_url);
            defer allocator.free(url_buffer);
            
            const decoded_url = std.Uri.percentDecodeInPlace(url_buffer);
            
            const argv = &[_][]const u8{
                "yt-dlp",
                "--cookies", "cookies.txt",
                "-f", "bestvideo[vcodec^=avc1]+bestaudio[acodec^=mp4a]/best[vcodec^=avc1]/best",
                "--merge-output-format", "mp4",
                "--ffmpeg-location", ".",
                "--postprocessor-args", "ffmpeg:-vcodec libx264 -pix_fmt yuv420p -profile:v high -level 4.1",
                decoded_url,
            };

            var child = std.process.Child.init(argv, allocator);
            _ = try child.spawnAndWait();
            
            try request.respond("OK", .{});
        } else {
            try request.respond(html_page, .{});
        }
    }
}