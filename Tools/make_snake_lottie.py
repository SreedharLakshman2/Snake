#!/usr/bin/env python3
"""Original looping pixel-snake Lottie (Bodymovin 5.7)."""

from __future__ import annotations

import json
import math
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
OUT = ROOT / "Snake" / "Resources" / "PixelSnake.json"

W, H = 512, 320
FPS = 30
FRAMES = 90


def color(rgb, a=1):
    r, g, b = rgb
    return [round(r / 255, 4), round(g / 255, 4), round(b / 255, 4), a]


def fill(rgb, a=1):
    return {"ty": "fl", "c": {"a": 0, "k": color(rgb, a)}, "o": {"a": 0, "k": 100}, "r": 1, "nm": "Fill"}


def round_rect(w, h, r=6):
    return {
        "ty": "rc",
        "d": 1,
        "s": {"a": 0, "k": [w, h]},
        "p": {"a": 0, "k": [0, 0]},
        "r": {"a": 0, "k": r},
        "nm": "Rect",
    }


def pos_keyframes(points):
    keys = []
    for i, (t, x, y) in enumerate(points):
        key = {"t": t, "s": [x, y, 0], "i": {"x": [0.5], "y": [1]}, "o": {"x": [0.5], "y": [0]}}
        if i == len(points) - 1:
            key = {"t": t, "s": [x, y, 0]}
        keys.append(key)
    return {"a": 1, "k": keys}


def scale_pulse(base=100, peak=124):
    return {
        "a": 1,
        "k": [
            {"t": 0, "s": [base, base, 100], "i": {"x": [0.42], "y": [1]}, "o": {"x": [0.58], "y": [0]}},
            {"t": 22, "s": [peak, peak, 100], "i": {"x": [0.42], "y": [1]}, "o": {"x": [0.58], "y": [0]}},
            {"t": 45, "s": [base, base, 100], "i": {"x": [0.42], "y": [1]}, "o": {"x": [0.58], "y": [0]}},
            {"t": 68, "s": [peak - 6, peak - 6, 100], "i": {"x": [0.42], "y": [1]}, "o": {"x": [0.58], "y": [0]}},
            {"t": FRAMES, "s": [base, base, 100]},
        ],
    }


def transform(anchor, position, scale=None, opacity=100):
    tr = {
        "ty": "tr",
        "p": position if isinstance(position, dict) else {"a": 0, "k": [position[0], position[1], 0]},
        "a": {"a": 0, "k": [anchor[0], anchor[1], 0]},
        "s": scale if scale is not None else {"a": 0, "k": [100, 100, 100]},
        "r": {"a": 0, "k": 0},
        "o": opacity if isinstance(opacity, dict) else {"a": 0, "k": opacity},
        "sk": {"a": 0, "k": 0},
        "sa": {"a": 0, "k": 0},
    }
    return tr


def shape_layer(index, name, shapes, position, scale=None, opacity=100):
    return {
        "ddd": 0,
        "ind": index,
        "ty": 4,
        "nm": name,
        "sr": 1,
        "ks": transform((0, 0), position, scale, opacity),
        "ao": 0,
        "shapes": shapes,
        "ip": 0,
        "op": FRAMES,
        "st": 0,
        "bm": 0,
    }


def snake_path(t, lag):
    u = (t - lag) % 1.0
    x = 86 + u * 250
    y = 168 + math.sin(u * math.pi * 2.0) * 48
    y += math.sin(u * math.pi * 4.0) * 8
    return x, y


def main() -> None:
    layers = []
    idx = 1

    glow_opacity = {
        "a": 1,
        "k": [
            {"t": 0, "s": [28], "i": {"x": [0.5], "y": [1]}, "o": {"x": [0.5], "y": [0]}},
            {"t": 45, "s": [48], "i": {"x": [0.5], "y": [1]}, "o": {"x": [0.5], "y": [0]}},
            {"t": FRAMES, "s": [28]},
        ],
    }
    layers.append(
        shape_layer(
            idx,
            "Glow",
            [
                {
                    "ty": "el",
                    "p": {"a": 0, "k": [0, 0]},
                    "s": {"a": 0, "k": [420, 180]},
                    "nm": "GlowEllipse",
                },
                fill((0, 255, 136), 1),
            ],
            (W / 2, H / 2 + 10),
            opacity=glow_opacity,
        )
    )
    idx += 1

    apple = (392, 150)
    layers.append(
        shape_layer(
            idx,
            "Apple",
            [round_rect(34, 34, 8), fill((255, 77, 77))],
            apple,
            scale=scale_pulse(100, 118),
        )
    )
    idx += 1
    layers.append(
        shape_layer(
            idx,
            "AppleShine",
            [round_rect(8, 8, 3), fill((255, 220, 220))],
            (apple[0] - 8, apple[1] - 8),
        )
    )
    idx += 1
    layers.append(
        shape_layer(
            idx,
            "Leaf",
            [round_rect(12, 8, 3), fill((162, 241, 125))],
            (apple[0] + 10, apple[1] - 22),
        )
    )
    idx += 1

    segment_count = 12
    for i in reversed(range(segment_count)):
        lag = i / (segment_count + 6)
        is_head = i == 0
        size = 26 if is_head else 22
        rgb = (212, 255, 176) if is_head else (124, 255, 90)
        points = []
        for frame in range(0, FRAMES + 1, 3):
            t = frame / FRAMES
            x, y = snake_path(t, lag)
            points.append((frame, x, y))
        layers.append(
            shape_layer(
                idx,
                "Head" if is_head else f"Seg{i}",
                [round_rect(size, size, 5 if is_head else 4), fill(rgb)],
                pos_keyframes(points),
            )
        )
        idx += 1
        if is_head:
            eye_points = []
            for frame in range(0, FRAMES + 1, 3):
                t = frame / FRAMES
                x, y = snake_path(t, 0)
                eye_points.append((frame, x + 6, y - 5))
            layers.append(
                shape_layer(
                    idx,
                    "Eye",
                    [round_rect(5, 5, 2), fill((8, 15, 20))],
                    pos_keyframes(eye_points),
                )
            )
            idx += 1

    for n, (sx, sy) in enumerate(((430, 92), (454, 128), (418, 188), (468, 168))):
        op = {
            "a": 1,
            "k": [
                {"t": n * 8, "s": [0]},
                {"t": n * 8 + 16, "s": [80], "i": {"x": [0.5], "y": [1]}, "o": {"x": [0.5], "y": [0]}},
                {"t": n * 8 + 36, "s": [0]},
                {"t": FRAMES, "s": [0]},
            ],
        }
        layers.append(
            shape_layer(
                idx,
                f"Spark{n}",
                [round_rect(6, 6, 1), fill((255, 77, 77))],
                (sx, sy),
                opacity=op,
            )
        )
        idx += 1

    data = {
        "v": "5.7.4",
        "fr": FPS,
        "ip": 0,
        "op": FRAMES,
        "w": W,
        "h": H,
        "nm": "PixelSnake",
        "ddd": 0,
        "assets": [],
        "layers": list(reversed(layers)),
    }
    OUT.parent.mkdir(parents=True, exist_ok=True)
    OUT.write_text(json.dumps(data, separators=(",", ":")))
    print(f"wrote {OUT} ({OUT.stat().st_size / 1024:.1f} KB)")


if __name__ == "__main__":
    main()
