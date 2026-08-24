#!/usr/bin/env python3
"""1024pt neon LCD snake icon."""

from __future__ import annotations

from pathlib import Path

from PIL import Image, ImageDraw, ImageFilter

ROOT = Path(__file__).resolve().parent.parent
OUT = ROOT / "Snake" / "Assets.xcassets" / "AppIcon.appiconset" / "AppIcon.png"

SIZE = 1024
PIXEL = 40
CELL = SIZE // PIXEL

BG = (6, 12, 16)
LCD = (7, 20, 12)
SNAKE = (124, 255, 90)
HEAD = (220, 255, 186)
APPLE = (255, 72, 72)
LEAF = (162, 241, 125)
DOT = (18, 48, 28)
BEZEL = (22, 28, 34)
HIGHLIGHT = (70, 90, 80)


def lerp(a, b, t):
    return tuple(int(a[i] + (b[i] - a[i]) * t) for i in range(3))


def main() -> None:
    canvas = Image.new("RGB", (SIZE, SIZE), BG)
    draw = ImageDraw.Draw(canvas)
    for y in range(SIZE):
        draw.line([(0, y), (SIZE, y)], fill=lerp((4, 8, 12), (10, 22, 16), y / SIZE))

    grid = Image.new("RGBA", (PIXEL, PIXEL), (0, 0, 0, 0))
    g = ImageDraw.Draw(grid)
    g.rectangle([2, 2, PIXEL - 3, PIXEL - 3], fill=LCD)
    for y in range(PIXEL):
        for x in range(PIXEL):
            if 3 <= x <= PIXEL - 4 and 3 <= y <= PIXEL - 4 and (x + y) % 3 == 0:
                g.point((x, y), fill=DOT + (180,))

    snake = [
        (7, 20), (8, 20), (9, 20), (10, 20), (11, 20),
        (11, 19), (11, 18), (11, 17), (12, 17), (13, 17), (14, 17),
        (15, 17), (16, 17), (17, 17), (18, 17), (19, 17), (20, 17),
        (21, 17), (22, 17), (23, 17), (24, 17), (25, 17),
        (25, 18), (25, 19), (25, 20), (25, 21), (25, 22),
        (24, 22), (23, 22), (22, 22), (21, 22), (20, 22),
        (19, 22), (18, 22),
    ]
    for x, y in snake:
        g.point((x, y), fill=SNAKE + (255,))
    g.point((18, 22), fill=HEAD + (255,))
    g.point((17, 22), fill=HEAD + (255,))
    g.point((18, 21), fill=(8, 15, 20, 255))

    apple = [
        (28, 24), (29, 24), (27, 25), (28, 25), (29, 25), (30, 25),
        (27, 26), (28, 26), (29, 26), (30, 26), (28, 27), (29, 27),
    ]
    for x, y in apple:
        g.point((x, y), fill=APPLE + (255,))
    g.point((29, 23), fill=LEAF + (255,))
    g.point((30, 23), fill=LEAF + (255,))
    g.point((28, 25), fill=(255, 210, 210, 255))

    pixel = grid.resize((SIZE, SIZE), Image.NEAREST)

    glow = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
    gd = ImageDraw.Draw(glow)
    gd.ellipse([SIZE * 0.18, SIZE * 0.22, SIZE * 0.82, SIZE * 0.78], fill=(0, 255, 136, 70))
    glow = glow.filter(ImageFilter.GaussianBlur(90))

    snake_glow = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
    mask = pixel.split()[-1]
    tint = Image.new("RGBA", (SIZE, SIZE), (124, 255, 90, 90))
    snake_glow.paste(tint, mask=mask)
    snake_glow = snake_glow.filter(ImageFilter.GaussianBlur(28))

    bezel = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
    bd = ImageDraw.Draw(bezel)
    inset = int(SIZE * 0.055)
    bd.rounded_rectangle(
        [inset, inset, SIZE - inset, SIZE - inset],
        radius=int(SIZE * 0.16),
        outline=(162, 241, 125, 160),
        width=int(SIZE * 0.018),
    )
    bd.rounded_rectangle(
        [inset + 10, inset + 10, SIZE - inset - 10, SIZE - inset - 10],
        radius=int(SIZE * 0.14),
        outline=(255, 255, 255, 28),
        width=3,
    )

    out = canvas.convert("RGBA")
    out.alpha_composite(glow)
    out.alpha_composite(snake_glow)
    out.alpha_composite(pixel)
    out.alpha_composite(bezel.filter(ImageFilter.GaussianBlur(1)))

    scan = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
    sd = ImageDraw.Draw(scan)
    for y in range(0, SIZE, 4):
        sd.line([(0, y), (SIZE, y)], fill=(0, 0, 0, 28))
    out.alpha_composite(scan)

    rgb = Image.new("RGB", (SIZE, SIZE), BG)
    rgb.paste(out.convert("RGB"), mask=out.split()[-1])
    OUT.parent.mkdir(parents=True, exist_ok=True)
    rgb.save(OUT, format="PNG")
    print(f"wrote {OUT}")


if __name__ == "__main__":
    main()
