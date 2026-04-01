# Youtube video downloader

Minimalist YouTube downloader, built with **[Zig](https://ziglang.org/download/)**.

## Особенности
* **Minimalist Design**: Чистое черно-белое оформление в стиле минимализма.
* **High Performance**: Серверная часть на Zig обеспечивает мгновенный отклик.
* **Clean Code**: HTML, JS, CSS вынесены в отдельные файлы для удобства редактирования.

## Авторы
* **[dimonc1o](https://github.com/dimonc1o)** — Идея и разработка ядра.
* **[Wrethr](https://github.com/Wrethr)** — Главный программист.

---

## Ресурсы
При создании проекта использовалось:
1.  **[Zig 0.15.2](https://ziglang.org/download/)**
2.  **[yt-dlp](https://github.com/yt-dlp/yt-dlp)**
3.  **[ffmpeg](https://ffmpeg.org/)** (необходим для обработки видео)

---

## Инструкция по установке и запуску

**[Скачайте последий release](https://github.com/dimonc1o/Youtube-video-downloader/releases)**

	* Распакуйте архив
	* Запустите main.zig
	* Откройте браузер по адресу: `http://127.0.0.1:8080`
	* Вставьте ссылку на нужное видео.
	* Нажмите кнопку **➔**. Видео сохранится в папку с программой.

---

## Разработка
* Фронтенд (HTML/CSS) — `html_page.html`.
* Бекенд (Сервер/Логика) — `main.zig`.
