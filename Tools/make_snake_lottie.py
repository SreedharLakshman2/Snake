#!/usr/bin/env python3
"""Original looping Lottie: a coiled snake orbits a cycling fruit."""

from __future__ import annotations

import json
import math
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
OUT = ROOT / "Snake" / "Resources" / "PixelSnake.json"

W, H = 512, 320
FPS = 30
FRAMES = 120
CX, CY = 256.0, 158.0
RADIUS = 78.0
SEGMENTS = 14


def color(rgb, a=1):
    r, g, b = rgb
    return [round(r / 255, 4), round(g / 255, 4), round(b / 255, 4), a]


def fill(rgb, a=1):
    return {"ty": "fl", "c": {"a": 0, "k": color(rgb, a)}, "o": {"a": 0, "k": 100}, "r": 1, "nm": "Fill"}


def fill_cycle(frames_colors):
    keys = []
    for i, (t, rgb) in enumerate(frames_colors):
        key = {"t": t, "s": color(rgb), "i": {"x": [0.42], "y": [1]}, "o": {"x": [0.58], "y": [0]}}
        if i == len(frames_colors) - 1:
            key = {"t": t, "s": color(rgb)}
        keys.append(key)
    return {"ty": "fl", "c": {"a": 1, "k": keys}, "o": {"a": 0, "k": 100}, "r": 1, "nm": "Fill"}


def round_rect(w, h, r=6):
    return {
        "ty": "rc",
        "d": 1,
        "s": {"a": 0, "k": [w, h]},
        "p": {"a": 0, "k": [0, 0]},
        "r": {"a": 0, "k": r},
        "nm": "Rect",
    }


def ellipse(w, h):
    return {
        "ty": "el",
        "p": {"a": 0, "k": [0, 0]},
        "s": {"a": 0, "k": [w, h]},
        "nm": "Ellipse",
    }


def pos_keyframes(points):
    keys = []
    for i, (t, x, y) in enumerate(points):
        key = {"t": t, "s": [x, y, 0], "i": {"x": [0.5], "y": [1]}, "o": {"x": [0.5], "y": [0]}}
        if i == len(points) - 1:
            key = {"t": t, "s": [x, y, 0]}
        keys.append(key)
    return {"a": 1, "k": keys}


def rot_keyframes(points):
    keys = []
    for i, (t, deg) in enumerate(points):
        key = {"t": t, "s": [deg], "i": {"x": [0.5], "y": [1]}, "o": {"x": [0.5], "y": [0]}}
        if i == len(points) - 1:
            key = {"t": t, "s": [deg]}
        keys.append(key)
    return {"a": 1, "k": keys}


def scale_pulse(base=100, peak=122):
    return {
        "a": 1,
        "k": [
            {"t": 0, "s": [base, base, 100], "i": {"x": [0.42], "y": [1]}, "o": {"x": [0.58], "y": [0]}},
            {"t": 18, "s": [peak, peak, 100], "i": {"x": [0.42], "y": [1]}, "o": {"x": [0.58], "y": [0]}},
            {"t": 36, "s": [base, base, 100], "i": {"x": [0.42], "y": [1]}, "o": {"x": [0.58], "y": [0]}},
            {"t": 54, "s": [8, 8, 100], "i": {"x": [0.42], "y": [1]}, "o": {"x": [0.58], "y": [0]}},
            {"t": 62, "s": [peak + 8, peak + 8, 100], "i": {"x": [0.42], "y": [1]}, "o": {"x": [0.58], "y": [0]}},
            {"t": 80, "s": [base, base, 100], "i": {"x": [0.42], "y": [1]}, "o": {"x": [0.58], "y": [0]}},
            {"t": 98, "s": [peak, peak, 100], "i": {"x": [0.42], "y": [1]}, "o": {"x": [0.58], "y": [0]}},
            {"t": 114, "s": [8, 8, 100], "i": {"x": [0.42], "y": [1]}, "o": {"x": [0.58], "y": [0]}},
            {"t": FRAMES, "s": [base, base, 100]},
        ],
    }


def transform(anchor, position, scale=None, opacity=100, rotation=None):
    tr = {
        "ty": "tr",
        "p": position if isinstance(position, dict) else {"a": 0, "k": [position[0], position[1], 0]},
        "a": {"a": 0, "k": [anchor[0], anchor[1], 0]},
        "s": scale if scale is not None else {"a": 0, "k": [100, 100, 100]},
        "r": rotation if rotation is not None else {"a": 0, "k": 0},
        "o": opacity if isinstance(opacity, dict) else {"a": 0, "k": opacity},
        "sk": {"a": 0, "k": 0},
        "sa": {"a": 0, "k": 0},
    }
    return tr


def shape_layer(index, name, shapes, position, scale=None, opacity=100, rotation=None):
    return {
        "ddd": 0,
        "ind": index,
        "ty": 4,
        "nm": name,
        "sr": 1,
        "ks": transform((0, 0), position, scale, opacity, rotation),
        "ao": 0,
        "shapes": shapes,
        "ip": 0,
        "op": FRAMES,
        "st": 0,
        "bm": 0,
    }


def orbit(frame, index):
    t = frame / FRAMES
    gap = 2.0 * math.pi / (SEGMENTS + 3)
    angle = t * 2.0 * math.pi + index * gap
    pulse = 8.0 * math.sin(t * 2.0 * math.pi)
    r = RADIUS + pulse - index * 0.6
    x = CX + math.cos(angle) * r
    y = CY + math.sin(angle) * r * 0.78
    deg = math.degrees(angle) + 90
    return x, y, deg


def main() -> None:
    layers = []
    idx = 1

    glow_opacity = {
        "a": 1,
        "k": [
            {"t": 0, "s": [18], "i": {"x": [0.5], "y": [1]}, "o": {"x": [0.5], "y": [0]}},
            {"t": 30, "s": [36], "i": {"x": [0.5], "y": [1]}, "o": {"x": [0.5], "y": [0]}},
            {"t": 60, "s": [22], "i": {"x": [0.5], "y": [1]}, "o": {"x": [0.5], "y": [0]}},
            {"t": 90, "s": [40], "i": {"x": [0.5], "y": [1]}, "o": {"x": [0.5], "y": [0]}},
            {"t": FRAMES, "s": [18]},
        ],
    }
    layers.append(
        shape_layer(
            idx,
            "Glow",
            [ellipse(260, 220), fill((0, 255, 136), 1)],
            (CX, CY),
            opacity=glow_opacity,
        )
    )
    idx += 1

    fruit_colors = [
        (0, (255, 77, 77)),
        (30, (251, 191, 36)),
        (60, (168, 85, 247)),
        (90, (251, 113, 133)),
        (FRAMES, (255, 77, 77)),
    ]
    layers.append(
        shape_layer(
            idx,
            "Fruit",
            [round_rect(42, 42, 12), fill_cycle(fruit_colors)],
            (CX, CY),
            scale=scale_pulse(100, 118),
        )
    )
    idx += 1
    layers.append(
        shape_layer(
            idx,
            "FruitShine",
            [round_rect(10, 10, 4), fill((255, 255, 255), 0.7)],
            (CX - 9, CY - 10),
        )
    )
    idx += 1
    layers.append(
        shape_layer(
            idx,
            "Leaf",
            [round_rect(14, 8, 3), fill((162, 241, 125))],
            (CX + 12, CY - 24),
        )
    )
    idx += 1

    for i in reversed(range(SEGMENTS)):
        is_head = i == 0
        size = 30 if is_head else 22 - min(6, i // 3)
        rgb = (212, 255, 176) if is_head else (124, 255, 90)
        points = []
        for frame in range(0, FRAMES + 1, 2):
            x, y, _ = orbit(frame, i)
            points.append((frame, x, y))
        layers.append(
            shape_layer(
                idx,
                "Head" if is_head else f"Seg{i}",
                [round_rect(size, size, 7 if is_head else 5), fill(rgb)],
                pos_keyframes(points),
            )
        )
        idx += 1

        if is_head:
            eye_points = []
            tongue_points = []
            tongue_rot = []
            for frame in range(0, FRAMES + 1, 2):
                x, y, deg = orbit(frame, 0)
                rad = math.radians(deg - 90)
                eye_points.append((frame, x + math.cos(rad + 0.5) * 7, y + math.sin(rad + 0.5) * 7))
                tongue_points.append((frame, x + math.cos(rad) * 22, y + math.sin(rad) * 22))
                tongue_rot.append((frame, deg))
            layers.append(
                shape_layer(
                    idx,
                    "Eye",
                    [round_rect(5, 5, 2), fill((8, 15, 20))],
                    pos_keyframes(eye_points),
                )
            )
            idx += 1
            tongue_opacity = {
                "a": 1,
                "k": [
                    {"t": 0, "s": [0]},
                    {"t": 10, "s": [100], "i": {"x": [0.5], "y": [1]}, "o": {"x": [0.5], "y": [0]}},
                    {"t": 18, "s": [0]},
                    {"t": 48, "s": [0]},
                    {"t": 54, "s": [100], "i": {"x": [0.5], "y": [1]}, "o": {"x": [0.5], "y": [0]}},
                    {"t": 64, "s": [0]},
                    {"t": 100, "s": [0]},
                    {"t": 108, "s": [100], "i": {"x": [0.5], "y": [1]}, "o": {"x": [0.5], "y": [0]}},
                    {"t": FRAMES, "s": [0]},
                ],
            }
            layers.append(
                shape_layer(
                    idx,
                    "Tongue",
                    [round_rect(16, 6, 3), fill((255, 77, 120))],
                    pos_keyframes(tongue_points),
                    opacity=tongue_opacity,
                    rotation=rot_keyframes(tongue_rot),
                )
            )
            idx += 1

    sparks = ((CX + 40, CY - 36), (CX - 36, CY + 28), (CX + 48, CY + 18), (CX - 44, CY - 22))
    spark_colors = ((255, 77, 77), (251, 191, 36), (168, 85, 247), (96, 165, 250))
    for n, ((sx, sy), rgb) in enumerate(zip(sparks, spark_colors)):
        start = 50 + n * 4
        op = {
            "a": 1,
            "k": [
                {"t": 0, "s": [0]},
                {"t": start, "s": [0]},
                {"t": start + 8, "s": [90], "i": {"x": [0.5], "y": [1]}, "o": {"x": [0.5], "y": [0]}},
                {"t": start + 22, "s": [0]},
                {"t": 110, "s": [0]},
                {"t": 114, "s": [80], "i": {"x": [0.5], "y": [1]}, "o": {"x": [0.5], "y": [0]}},
                {"t": FRAMES, "s": [0]},
            ],
        }
        layers.append(
            shape_layer(
                idx,
                f"Spark{n}",
                [round_rect(8, 8, 2), fill(rgb)],
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
        "nm": "CoilSnake",
        "ddd": 0,
        "assets": [],
        "layers": list(reversed(layers)),
    }
    OUT.parent.mkdir(parents=True, exist_ok=True)
    OUT.write_text(json.dumps(data, separators=(",", ":")))
    print(f"wrote {OUT} ({OUT.stat().st_size / 1024:.1f} KB)")


if __name__ == "__main__":
    main()
