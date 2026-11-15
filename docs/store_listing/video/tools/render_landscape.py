"""The Accountant Play Store promo video, LANDSCAPE 1920x1080, light theme.

Captions on the left, the phone recording on the right, on a warm light
background. Usage:

    python render_landscape.py <ffmpeg.exe> <scenes.json> <music> <out.mp4>

scenes.json: {"segments": [{"src", "a", "b", "chip", "title", "sub"}, ...]}
with `src` a recording in this folder and `a`/`b` the trim in seconds.
"""

import json
import subprocess
import sys
from pathlib import Path

from PIL import Image, ImageDraw, ImageFilter, ImageFont

D = Path(__file__).parent
APP = D.parents[3]  # the_accountant/
FONTS = APP / "assets" / "fonts"
LOGO = APP / "assets" / "logo" / "app-icon-512.png"
FF, SCENES, MUSIC, OUT = sys.argv[1:5]

W, H = 1920, 1080
BG_TOP = (255, 246, 236)
BG_BOTTOM = (255, 233, 222)
INK = (43, 24, 16)
MUTED = (122, 96, 82)
ORANGE = (249, 115, 22)
CORAL = (239, 68, 98)
AMBER = (245, 158, 11)
WHITE = (255, 255, 255)

INTRO, OUTRO, FADE = 3.0, 4.5, 0.3

# Phone on the right
PH = 980
PW = round(PH * 1080 / 2340 / 2) * 2
PX, PY = 1260, (H - PH) // 2
RADIUS = 40
CAP_X, CAP_W = 150, 960

CHIP_COLORS = {"orange": ORANGE, "coral": CORAL, "amber": AMBER}


def font(weight, size):
    return ImageFont.truetype(str(FONTS / f"Lexend-{weight}.ttf"), size)


def wrap(draw, text, f, width):
    lines, cur = [], ""
    for word in text.split():
        trial = f"{cur} {word}".strip()
        if draw.textlength(trial, font=f) <= width:
            cur = trial
        else:
            lines.append(cur)
            cur = word
    return lines + [cur]


def chip(draw, x, y, label, color, size=30):
    f = font("SemiBold", size)
    tw = draw.textlength(label, font=f)
    h = size + 28
    draw.rounded_rectangle((x, y, x + tw + 48, y + h), radius=h // 2, fill=color)
    draw.text((x + 24, y + h / 2), label, font=f, fill=WHITE, anchor="lm")
    return y + h


def caption_png(i, label, color, title, sub):
    img = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    ft, fs = font("Bold", 88), font("Regular", 42)
    tlines = wrap(d, title, ft, CAP_W)
    slines = wrap(d, sub, fs, CAP_W - 60)[:3]
    block = 58 + 44 + len(tlines) * 104 + 28 + len(slines) * 60
    y = (H - block) // 2
    y = chip(d, CAP_X, y, label, CHIP_COLORS.get(color, ORANGE)) + 44
    for line in tlines:
        d.text((CAP_X - 4, y), line, font=ft, fill=INK)
        y += 104
    y += 28
    for line in slines:
        d.text((CAP_X, y), line, font=fs, fill=MUTED)
        y += 60
    p = D / f"lcap{i}.png"
    img.save(p)
    return p


def background():
    img = Image.new("RGB", (W, H), BG_TOP)
    d = ImageDraw.Draw(img)
    for y in range(H):
        t = y / (H - 1)
        d.line([(0, y), (W, y)], fill=tuple(round(a + (b - a) * t) for a, b in zip(BG_TOP, BG_BOTTOM)))
    glow = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    gd = ImageDraw.Draw(glow)
    gd.ellipse((-450, -450, 650, 550), fill=(255, 170, 90, 70))
    gd.ellipse((1050, 250, 2350, 1450), fill=(255, 120, 110, 60))
    glow = glow.filter(ImageFilter.GaussianBlur(160))
    img.paste(glow, (0, 0), glow)
    return img


def phone_assets():
    bg = background()
    shadow = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    ImageDraw.Draw(shadow).rounded_rectangle(
        (PX - 6, PY + 18, PX + PW + 6, PY + PH + 30), radius=RADIUS + 10, fill=(120, 50, 20, 90))
    shadow = shadow.filter(ImageFilter.GaussianBlur(30))
    bg.paste(shadow, (0, 0), shadow)
    ImageDraw.Draw(bg).rounded_rectangle(
        (PX - 9, PY - 9, PX + PW + 8, PY + PH + 8), radius=RADIUS + 9, fill=(34, 22, 18))
    bg.save(D / "lstage.png")
    mask = Image.new("L", (PW, PH), 0)
    ImageDraw.Draw(mask).rounded_rectangle((0, 0, PW - 1, PH - 1), radius=RADIUS, fill=255)
    mask.save(D / "lmask.png")


def logo(size):
    return Image.open(LOGO).convert("RGBA").resize((size, size), Image.LANCZOS)


def card(name, build):
    img = background()
    d = ImageDraw.Draw(img)
    build(img, d)
    p = D / f"{name}.png"
    img.save(p)
    return p


def intro(img, d):
    lg = logo(260)
    img.paste(lg, ((W - 260) // 2, 250), lg)
    d.text((W / 2, 660), "The Accountant", font=font("Bold", 120), fill=INK, anchor="mm")
    d.text((W / 2, 790), "Money, brighter.", font=font("Medium", 56), fill=ORANGE, anchor="mm")


def outro(img, d):
    lg = logo(200)
    img.paste(lg, (180, 170), lg)
    d.text((420, 270), "The Accountant", font=font("Bold", 84), fill=INK, anchor="lm")
    items = ["Budgets, goals & subscriptions", "Loans, card bills & plans",
             "An AI money coach", "Encrypted, with Drive backup"]
    fi = font("Medium", 48)
    y = 500
    for t in items:
        d.rounded_rectangle((190, y, 226, y + 36), radius=10, fill=ORANGE)
        d.text((260, y + 18), t, font=fi, fill=INK, anchor="lm")
        y += 95
    bw, bh = 620, 150
    bx, by = 1150, 420
    d.rounded_rectangle((bx, by, bx + bw, by + bh), radius=bh // 2, fill=ORANGE)
    d.text((bx + bw / 2, by + bh / 2), "Try it today", font=font("Bold", 62), fill=WHITE, anchor="mm")
    d.text((bx + bw / 2, by + bh + 70), "on Google Play", font=font("Medium", 40), fill=MUTED, anchor="mm")


def main():
    scenes = json.loads(Path(SCENES).read_text(encoding="utf-8"))["segments"]
    phone_assets()
    caps = [caption_png(i, s["chip"], s.get("color", "orange"), s["title"], s["sub"])
            for i, s in enumerate(scenes)]
    intro_p, outro_p = card("lintro", intro), card("loutro", outro)

    durs = [s["b"] - s["a"] for s in scenes]
    demo_len = sum(durs)
    total = INTRO + demo_len + OUTRO

    srcs = sorted({s["src"] for s in scenes})
    inputs, idx = [], {}
    for sp in srcs:
        idx[sp] = len(idx)
        inputs += ["-i", str(D / sp)]
    n_src = len(srcs)
    inputs += ["-loop", "1", "-i", str(D / "lstage.png")]
    inputs += ["-i", str(D / "lmask.png")]
    inputs += ["-loop", "1", "-t", str(INTRO), "-i", str(intro_p)]
    inputs += ["-loop", "1", "-t", str(OUTRO), "-i", str(outro_p)]
    cap0 = n_src + 4
    for p, du in zip(caps, durs):
        inputs += ["-loop", "1", "-t", f"{du:.3f}", "-i", str(p)]
    music_i = cap0 + len(scenes)
    inputs += ["-stream_loop", "-1", "-i", MUSIC]

    fc = []
    uses = {sp: [i for i, s in enumerate(scenes) if s["src"] == sp] for sp in srcs}
    for sp, ids in uses.items():
        k = idx[sp]
        outs = "".join(f"[r{i}]" for i in ids)
        fc.append(f"[{k}:v]fps=30,split={len(ids)}{outs}" if len(ids) > 1 else f"[{k}:v]fps=30{outs}")
    for i, s in enumerate(scenes):
        fc.append(f"[r{i}]trim={s['a']}:{s['b']},setpts=PTS-STARTPTS[t{i}]")
    fc.append("".join(f"[t{i}]" for i in range(len(scenes))) + f"concat=n={len(scenes)}:v=1:a=0[rec]")
    fc.append(f"[rec]scale={PW}:{PH}:flags=lanczos,format=rgba[ph]")
    fc.append(f"[{n_src + 1}:v]format=gray[mk]")
    fc.append("[ph][mk]alphamerge[phr]")
    fc.append(f"[{n_src}:v]fps=30,trim=0:{demo_len:.3f},setpts=PTS-STARTPTS[stg]")
    fc.append(f"[stg][phr]overlay={PX}:{PY}:shortest=1[a0]")
    last, t = "a0", 0.0
    for i, du in enumerate(durs):
        fades = f"fade=in:st=0:d={FADE}:alpha=1,fade=out:st={du - FADE:.3f}:d={FADE}:alpha=1"
        fc.append(f"[{cap0 + i}:v]format=rgba,{fades},setpts=PTS-STARTPTS+{t:.3f}/TB[c{i}]")
        fc.append(f"[{last}][c{i}]overlay=0:0:eof_action=pass[b{i}]")
        last, t = f"b{i}", t + du
    fc.append(f"color=c=0xF97316:s={W}x8:r=30:d={demo_len:.3f}[bar]")
    fc.append(f"[{last}][bar]overlay=x='-{W}+{W}*t/{demo_len:.3f}':y={H - 8}:shortest=1,"
              f"format=yuv420p,setsar=1[demo]")
    fc.append(f"[{n_src + 2}:v]fps=30,format=yuv420p,fade=in:st=0:d=0.35,fade=out:st={INTRO - 0.35}:d=0.35,setsar=1[in]")
    fc.append(f"[{n_src + 3}:v]fps=30,format=yuv420p,fade=in:st=0:d=0.35,fade=out:st={OUTRO - 0.6}:d=0.6,setsar=1[out]")
    fc.append("[in][demo][out]concat=n=3:v=1:a=0[v]")
    fc.append(f"[{music_i}:a]atrim=0:{total:.3f},asetpts=PTS-STARTPTS,volume=0.8,"
              f"afade=in:st=0:d=0.6,afade=out:st={total - 1.8:.3f}:d=1.8[aud]")

    cmd = [FF, "-hide_banner", "-loglevel", "error", "-y", *inputs, "-filter_complex", ";".join(fc),
           "-map", "[v]", "-map", "[aud]", "-t", f"{total:.2f}", "-c:v", "libx264", "-crf", "19",
           "-preset", "slow", "-pix_fmt", "yuv420p", "-c:a", "aac", "-b:a", "192k",
           "-movflags", "+faststart", OUT]
    subprocess.run(cmd, check=True)
    print("done", round(total, 2))


main()
