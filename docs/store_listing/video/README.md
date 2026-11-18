# Play Store promo video

- `the-accountant-promo-landscape.mp4`: 1920x1080, 30 fps, 56 s, light theme. Upload it to YouTube and put the `youtube.com/watch?v=` link (not `/shorts/`) in Play Console > Main store listing > Video.
- `youtube-thumbnail-1280x720.png`: the feature graphic (`assets/logo/feature-graphic-1024x500.png`) scaled to 720 px tall, with the right edge trimmed to fit 16:9. Use it as the YouTube thumbnail.

## Music credit (required)

"Wholesome" by Kevin MacLeod (incompetech.com), licensed under Creative Commons: By Attribution 4.0 (https://creativecommons.org/licenses/by/4.0/).

Put this line in the YouTube description:

```
Music: "Wholesome" by Kevin MacLeod (incompetech.com), licensed under CC BY 4.0
```

## Rebuilding

The recordings and the music are not committed (see `tools/.gitignore`).

1. Get the music: https://incompetech.com/music/royalty-free/mp3-royaltyfree/Wholesome.mp3, saved as `tools/wholesome.mp3`.
2. Record on the A24 (1080x2340) with a demo account only, never real data. The video used the John test account on the local backend. Put the app and the phone in light mode first, then set the phone back to dark afterwards, because the A24 is shared.
   `adb shell screenrecord --bit-rate 8000000 --time-limit 178 /sdcard/x.mp4`, stopped with `pkill -INT screenrecord`. Save it as `tools/rec2.mp4`.
3. Pick the cuts in `tools/scenes.json` (seconds into the recording, plus each caption).
4. Render, using the ffmpeg bundled with `imageio_ffmpeg`:
   `python render_landscape.py <ffmpeg.exe> scenes.json wholesome.mp3 ../the-accountant-promo-landscape.mp4`
