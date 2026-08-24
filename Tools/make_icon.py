#!/usr/bin/env python3
"""Flatten the 3D Snakelet icon to 1024 RGB (no alpha) for Xcode and App Store Connect."""

from __future__ import annotations

from pathlib import Path

from PIL import Image

ROOT = Path(__file__).resolve().parent.parent
SRC = ROOT / "AppStore" / "assets" / "snakelet-icon-3d.png"
APPICON = ROOT / "Snake" / "Assets.xcassets" / "AppIcon.appiconset" / "AppIcon.png"
STORE = ROOT / "AppStore" / "icons" / "AppIcon-1024.png"
BG = (8, 15, 20)
SIZE = 1024


def flatten_icon(src: Path) -> Image.Image:
    im = Image.open(src).convert("RGBA")
    side = min(im.size)
    left = (im.width - side) // 2
    top = (im.height - side) // 2
    im = im.crop((left, top, left + side, top + side))
    im = im.resize((SIZE, SIZE), Image.Resampling.LANCZOS)
    rgb = Image.new("RGB", (SIZE, SIZE), BG)
    rgb.paste(im.convert("RGB"), mask=im.split()[-1])
    return rgb


def main() -> None:
    if not SRC.exists():
        raise SystemExit(f"Missing 3D icon at {SRC}")
    icon = flatten_icon(SRC)
    APPICON.parent.mkdir(parents=True, exist_ok=True)
    STORE.parent.mkdir(parents=True, exist_ok=True)
    icon.save(APPICON, "PNG")
    icon.save(STORE, "PNG")
    print(f"wrote {APPICON} {icon.mode} {icon.size}")
    print(f"wrote {STORE}")


if __name__ == "__main__":
    main()
