# Surprise Room
1. Supabase Dashboard > SQL Editor > run `schema.sql`.
2. Host `index.html` on any static host (Netlify, Vercel, GitHub Pages) or open it locally.
   Share links look like `https://your-site/index.html?room=bd-1234`.
3. Credentials are at the top of the script in `index.html` (SB_URL, SB_KEY).
4. Music: keep the `music/` folder next to `index.html`. Tracks: birthday.mp3, achievement.mp3, wedding.mp3, graduation.mp3.
   Replace them with your own MP3s (same file names) or edit the `MUSIC` map in `index.html` to point at other URLs.
   If a file is missing or the browser blocks it, the app falls back to a built-in synthesized tune.
5. Pixabay: the Pixabay track pages are web pages, not audio files. Download the MP3 from Pixabay, then either save it in `music/`
   (e.g. replace `birthday.mp3`) or paste its direct .mp3 URL into the first slot of the `MUSIC` map in `index.html`.
