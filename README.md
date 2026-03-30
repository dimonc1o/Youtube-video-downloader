# 🎥 YTD for After Effects

A lightweight, high-performance YouTube video downloader with a minimalist web interface. Specifically pre-configured to output videos that are 100% compatible with **Adobe After Effects** (H.264 / AAC MP4).

Created by **dimoncio**.

---

## 🚀 Features
- **One-Click Download**: Just paste the link and hit the arrow.
- **AE Ready**: No more "File format not supported" errors in After Effects.
- **Dark Mode**: Clean, distraction-free black interface.
- **Fast**: Powered by the Zig programming language for maximum efficiency.

## 🛠️ How to Setup (For Everyone)

Since this is a portable tool, you need to place a few dependencies in the same folder as the app:

1. **Download the Essentials**:
   - Get `yt-dlp.exe` from [yt-dlp releases](https://github.com/yt-dlp/yt-dlp/releases).
   - Get `ffmpeg.exe` and `ffprobe.exe` from [gyan.dev](https://www.gyan.dev/ffmpeg/builds/).
2. **Project Folder**:
   Your folder should look like this:
   ```text
   my_downloader/
   ├── main.exe (or main.zig if running via Zig)
   ├── yt-dlp.exe
   ├── ffmpeg.exe
   ├── ffprobe.exe
   └── cookies.txt (Optional: for age-restricted videos)