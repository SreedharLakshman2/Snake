#!/usr/bin/env python3
"""1024pt pixel-LCD snake icon."""

from __future__ import annotations

from pathlib import Path

from PIL import Image, ImageDraw, ImageFilter

ROOT = Path(__file__).resolve().parent.parent
OUT = ROOT / "Snake" / "Assets.xcassets" / "AppIcon.appiconset" / "AppIcon.png"

SIZE = 1024
PIXEL = 32
CELL = SIZE // PIXEL

BG = (8, 15, 20)
SNAKE = (124, 255, 90)
HEAD = (212, 255, 176)
APPLE = (255, 77, 77)
LEAF = (162, 241, 125)
DOT = (20, 42, 28)
BEZEL = (18, 24, 28)


def main() -> None:
    grid = Image.new("RGB", (PIXEL, PIXEL), BG)
    draw = ImageDraw.Draw(grid)

    for y in range(PIXEL):
        for x in range(PIXEL):
            if (x + y) % 4 == 0:
                draw.point((x, y), fill=DOT)

    snake = [
        (6, 16), (7, 16), (8, 16), (9, 16), (10, 16), (11, 16),
        (11, 15), (11, 14), (11, 13), (12, 13), (13, 13), (14, 13),
        (15, 13), (16, 13), (17, 13), (18, 13), (19, 13), (20, 13),
        (21, 13), (22, 13), (22, 14), (22, 15), (22, 16), (22, 17),
        (22, 18), (21, 18), (20, 18), (19, 18), (18, 18), (17, 18),
        (16, 18), (15, 18),
    ]
    for x, y in snake:
        draw.point((x, y), fill=SNAKE)
    draw.point((15, 18), fill=HEAD)
    draw.point((14, 18), fill=HEAD)

    apple = [(24, 20), (25, 20), (23, 21), (24, 21), (25, 21), (26, 21), (24, 22), (25, 22)]
    for x, y in apple:
        draw.point((x, y), fill=APPLE)
    draw.point((25, 19), fill=LEAF)

    scaled = grid.resize((SIZE, SIZE), Image.NEAREST)

    overlay = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
    glow = ImageDraw.Draw(overlay)
    margin = CELL * 2
    glow.rounded_rectangle(
        [margin, margin, SIZE - margin, SIZE - margin],
        radius=CELL * 3,
        outline=(162, 241, 125, 70),
        width=max(4, CELL // 3),
    )
    overlay = overlay.filter(ImageFilter.GaussianBlur(8))

    final = scaled.convert("RGBA")
    final.alpha_composite(overlay)
    rgb = Image.new("RGB", (SIZE, SIZE), BG)
    rgb.paste(final.convert("RGB"), mask=final.split()[-1])
    OUT.parent.mkdir(parents=True, exist_ok=True)
    rgb.save(OUT, format="PNG")
    print(f"wrote {OUT}")


if __name__ == "__main__":
    main()
