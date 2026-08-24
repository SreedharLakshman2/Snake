#!/usr/bin/env python3
"""Original looping Lottie: one continuous snake that slithers toward an apple."""

from __future__ import annotations

import json
import math
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
OUT = ROOT / "Snake" / "Resources" / "PixelSnake.json"

W, H = 512, 320
FPS = 30
FRAMES = 90
SPINE_PTS = 28
BODY_LEN = 300.0
BASE_Y = 168.0

OUTLINE = (16, 58, 28)
BODY = (64, 178, 72)
BODY_LIGHT = (118, 214, 102)
STRIPE = (28, 92, 40)
BELLY = (198, 230, 140)
HEAD = (76, 192, 82)
EYE_WHITE = (250, 255, 242)
PUPIL = (12, 16, 12)
TONGUE = (214, 46, 68)
APPLE = (226, 56, 56)
LEAF = (96, 186, 74)
STEM = (88, 58, 32)


def color(rgb, a=1.0):
    r, g, b = rgb
    return [round(r / 255, 4), round(g / 255, 4), round(b / 255, 4), a]


def fill(rgb, a=1.0):
    return {"ty": "fl", "c": {"a": 0, "k": color(rgb, a)}, "o": {"a": 0, "k": 100}, "r": 1, "nm": "Fill"}


def stroke(width, rgb):
    return {
        "ty": "st",
        "c": {"a": 0, "k": color(rgb)},
        "o": {"a": 0, "k": 100},
        "w": {"a": 0, "k": width},
        "lc": 2,
        "lj": 2,
        "ml": 4,
        "nm": "Stroke",
    }


def ellipse(w, h):
    return {"ty": "el", "p": {"a": 0, "k": [0, 0]}, "s": {"a": 0, "k": [w, h]}, "nm": "Ellipse"}


def round_rect(w, h, r=3):
    return {
        "ty": "rc",
        "d": 1,
        "s": {"a": 0, "k": [w, h]},
        "p": {"a": 0, "k": [0, 0]},
        "r": {"a": 0, "k": r},
        "nm": "Rect",
    }


def identity_tr():
    return {
        "ty": "tr",
        "p": {"a": 0, "k": [0, 0, 0]},
        "a": {"a": 0, "k": [0, 0, 0]},
        "s": {"a": 0, "k": [100, 100, 100]},
        "r": {"a": 0, "k": 0},
        "o": {"a": 0, "k": 100},
        "sk": {"a": 0, "k": 0},
        "sa": {"a": 0, "k": 0},
    }


def snake_point(u, t):
    """u=0 head (right), u=1 tail (left). t is 0..1."""
    crawl = math.sin(t * math.pi * 2.0) * 16.0
    # One travelling S-curve along the body.
    wave = math.sin(u * math.pi * 2.05 - t * math.pi * 4.0)
    amp = 38.0 * (0.72 + 0.28 * (1.0 - u))
    x = 92.0 + (1.0 - u) * BODY_LEN + crawl
    y = BASE_Y + wave * amp
    return x, y


def heading_at(u, t):
    x0, y0 = snake_point(max(0.0, u - 0.02), t)
    x1, y1 = snake_point(min(1.0, u + 0.02), t)
    return math.atan2(y0 - y1, x0 - x1)


def spine(t):
    return [snake_point(i / (SPINE_PTS - 1), t) for i in range(SPINE_PTS)]


def open_path(pts):
    n = len(pts)
    vs, ins, outs = [], [], []
    for idx in range(n):
        p = pts[idx]
        prev = pts[idx - 1] if idx else pts[idx]
        nxt = pts[idx + 1] if idx < n - 1 else pts[idx]
        tx = (nxt[0] - prev[0]) / 6.0
        ty = (nxt[1] - prev[1]) / 6.0
        vs.append([round(p[0], 2), round(p[1], 2)])
        ins.append([round(-tx, 2), round(-ty, 2)])
        outs.append([round(tx, 2), round(ty, 2)])
    return {"c": False, "v": vs, "i": ins, "o": outs}


def closed_path(pts):
    n = len(pts)
    vs, ins, outs = [], [], []
    for idx in range(n):
        p = pts[idx]
        prev = pts[(idx - 1) % n]
        nxt = pts[(idx + 1) % n]
        tx = (nxt[0] - prev[0]) / 6.0
        ty = (nxt[1] - prev[1]) / 6.0
        vs.append([round(p[0], 2), round(p[1], 2)])
        ins.append([round(-tx, 2), round(-ty, 2)])
        outs.append([round(tx, 2), round(ty, 2)])
    return {"c": True, "v": vs, "i": ins, "o": outs}


HEAD_SHAPE = closed_path(
    [
        (26, 0),
        (16, -6),
        (4, -12),
        (-10, -13),
        (-22, -6),
        (-24, 0),
        (-22, 6),
        (-10, 13),
        (4, 12),
        (16, 6),
    ]
)


def path_keyframes(step=3):
    keys = []
    frames = list(range(0, FRAMES, step)) + [FRAMES]
    for i, frame in enumerate(frames):
        t = frame / FRAMES
        path = open_path(spine(t))
        key = {
            "t": frame,
            "s": [path],
            "i": {"x": [0.42], "y": [1]},
            "o": {"x": [0.58], "y": [0]},
        }
        if i == len(frames) - 1:
            key = {"t": frame, "s": [path]}
        keys.append(key)
    return {"a": 1, "k": keys}


def trim(end_pct):
    return {
        "ty": "tm",
        "s": {"a": 0, "k": 0},
        "e": {"a": 0, "k": end_pct},
        "o": {"a": 0, "k": 0},
        "m": 1,
        "nm": "Trim",
    }


def stroke_group(name, path_ks, width, rgb, end_pct=100):
    items = [{"ty": "sh", "nm": "Spine", "ks": path_ks}]
    if end_pct < 100:
        items.append(trim(end_pct))
    items.append(stroke(width, rgb))
    items.append(identity_tr())
    return {"ty": "gr", "nm": name, "it": items, "np": 3, "cix": 2, "bm": 0, "ix": 1, "mn": "", "hd": False}


def layer(index, name, shapes, ks=None):
    return {
        "ddd": 0,
        "ind": index,
        "ty": 4,
        "nm": name,
        "sr": 1,
        "ks": ks if ks is not None else {
            "o": {"a": 0, "k": 100},
            "r": {"a": 0, "k": 0},
            "p": {"a": 0, "k": [0, 0, 0]},
            "a": {"a": 0, "k": [0, 0, 0]},
            "s": {"a": 0, "k": [100, 100, 100]},
            "sk": {"a": 0, "k": 0},
            "sa": {"a": 0, "k": 0},
        },
        "ao": 0,
        "shapes": shapes,
        "ip": 0,
        "op": FRAMES,
        "st": 0,
        "bm": 0,
    }


def pos_kf(points):
    keys = []
    for i, (t, x, y) in enumerate(points):
        key = {
            "t": t,
            "s": [round(x, 2), round(y, 2), 0],
            "i": {"x": [0.4], "y": [1]},
            "o": {"x": [0.6], "y": [0]},
        }
        if i == len(points) - 1:
            key = {"t": t, "s": [round(x, 2), round(y, 2), 0]}
        keys.append(key)
    return {"a": 1, "k": keys}


def rot_kf(points):
    keys = []
    prev = points[0][1]
    unwrapped = []
    for t, deg in points:
        while deg - prev > 180:
            deg -= 360
        while deg - prev < -180:
            deg += 360
        unwrapped.append((t, deg))
        prev = deg
    for i, (t, deg) in enumerate(unwrapped):
        key = {
            "t": t,
            "s": [round(deg, 2)],
            "i": {"x": [0.4], "y": [1]},
            "o": {"x": [0.6], "y": [0]},
        }
        if i == len(unwrapped) - 1:
            key = {"t": t, "s": [round(deg, 2)]}
        keys.append(key)
    return {"a": 1, "k": keys}


def follow(u, forward=0, side=0, extra_deg=0, step=3):
    pos, rot = [], []
    frames = list(range(0, FRAMES, step)) + [FRAMES]
    for frame in frames:
        t = frame / FRAMES
        x, y = snake_point(u, t)
        ang = heading_at(u, t)
        fx, fy = math.cos(ang), math.sin(ang)
        px, py = -fy, fx
        pos.append((frame, x + fx * forward + px * side, y + fy * forward + py * side))
        rot.append((frame, math.degrees(ang) + extra_deg))
    return pos, rot


def head_motion(forward, side, extra_deg=0, step=3):
    return follow(0.0, forward, side, extra_deg, step)


def xf(position, rotation=None, scale=None, opacity=100):
    return {
        "o": opacity if isinstance(opacity, dict) else {"a": 0, "k": opacity},
        "r": rotation if rotation is not None else {"a": 0, "k": 0},
        "p": position if isinstance(position, dict) else {"a": 0, "k": [position[0], position[1], 0]},
        "a": {"a": 0, "k": [0, 0, 0]},
        "s": scale if scale is not None else {"a": 0, "k": [100, 100, 100]},
        "sk": {"a": 0, "k": 0},
        "sa": {"a": 0, "k": 0},
    }


def main() -> None:
    path_ks = path_keyframes()
    layers = []
    idx = 1

    glow_op = {
        "a": 1,
        "k": [
            {"t": 0, "s": [12], "i": {"x": [0.5], "y": [1]}, "o": {"x": [0.5], "y": [0]}},
            {"t": 45, "s": [22], "i": {"x": [0.5], "y": [1]}, "o": {"x": [0.5], "y": [0]}},
            {"t": FRAMES, "s": [12]},
        ],
    }
    layers.append(
        layer(
            idx,
            "Glow",
            [ellipse(440, 200), fill((0, 255, 136))],
            xf((256, 168), opacity=glow_op),
        )
    )
    idx += 1

    apple = (446, 150)
    apple_scale = {
        "a": 1,
        "k": [
            {"t": 0, "s": [100, 100, 100], "i": {"x": [0.42], "y": [1]}, "o": {"x": [0.58], "y": [0]}},
            {"t": 26, "s": [110, 110, 100], "i": {"x": [0.42], "y": [1]}, "o": {"x": [0.58], "y": [0]}},
            {"t": 46, "s": [100, 100, 100], "i": {"x": [0.42], "y": [1]}, "o": {"x": [0.58], "y": [0]}},
            {"t": 62, "s": [12, 12, 100], "i": {"x": [0.3], "y": [1]}, "o": {"x": [0.7], "y": [0]}},
            {"t": 72, "s": [112, 112, 100], "i": {"x": [0.42], "y": [1]}, "o": {"x": [0.58], "y": [0]}},
            {"t": FRAMES, "s": [100, 100, 100]},
        ],
    }
    layers.append(layer(idx, "AppleShadow", [ellipse(36, 13), fill((0, 0, 0), 0.28)], xf((apple[0], apple[1] + 22))))
    idx += 1
    layers.append(layer(idx, "Apple", [ellipse(33, 35), fill(APPLE)], xf(apple, scale=apple_scale)))
    idx += 1
    layers.append(layer(idx, "AppleShine", [ellipse(8, 11), fill((255, 255, 255), 0.5)], xf((apple[0] - 8, apple[1] - 8))))
    idx += 1
    layers.append(layer(idx, "Stem", [round_rect(3.4, 11, 1.4), fill(STEM)], xf((apple[0] + 1, apple[1] - 23))))
    idx += 1
    layers.append(layer(idx, "Leaf", [ellipse(15, 8), fill(LEAF)], xf((apple[0] + 12, apple[1] - 25))))
    idx += 1

    # Continuous tapered body: round-capped strokes of decreasing length.
    layers.append(
        layer(
            idx,
            "Snake",
            [
                stroke_group("OutlineFull", path_ks, 20, OUTLINE, 100),
                stroke_group("OutlineMid", path_ks, 25, OUTLINE, 74),
                stroke_group("OutlineHead", path_ks, 29, OUTLINE, 40),
                stroke_group("BodyFull", path_ks, 13, BODY, 100),
                stroke_group("BodyMid", path_ks, 18, BODY, 74),
                stroke_group("BodyHead", path_ks, 22, BODY, 40),
                stroke_group("Belly", path_ks, 7, BELLY, 78),
                stroke_group("Stripe", path_ks, 4, STRIPE, 90),
                stroke_group("Highlight", path_ks, 3, BODY_LIGHT, 36),
            ],
        )
    )
    idx += 1

    hp, hr = head_motion(4, 0)
    layers.append(
        layer(
            idx,
            "Head",
            [{"ty": "sh", "nm": "Skull", "ks": {"a": 0, "k": HEAD_SHAPE}}, fill(HEAD)],
            xf(pos_kf(hp), rotation=rot_kf(hr)),
        )
    )
    idx += 1
    jp, jr = head_motion(2, 5)
    layers.append(layer(idx, "Jaw", [ellipse(20, 9), fill(BELLY)], xf(pos_kf(jp), rotation=rot_kf(jr))))
    idx += 1

    for i, u in enumerate((0.14, 0.22, 0.30, 0.38, 0.46, 0.54, 0.62, 0.70, 0.78, 0.86)):
        sp, sr = follow(u, 0, 0)
        size = 12 - i * 0.7
        layers.append(
            layer(
                idx,
                f"Scale{i}",
                [ellipse(size, size * 0.55), fill(STRIPE, 0.9)],
                xf(pos_kf(sp), rotation=rot_kf(sr)),
            )
        )
        idx += 1

    for name, side in (("EyeL", -6.5), ("EyeR", 6)):
        ep, er = head_motion(6, side)
        layers.append(layer(idx, name, [ellipse(5.4, 5), fill(EYE_WHITE)], xf(pos_kf(ep), rotation=rot_kf(er))))
        idx += 1
        pp, pr = head_motion(8, side * 0.88)
        layers.append(layer(idx, name + "Pupil", [ellipse(2.6, 2.6), fill(PUPIL)], xf(pos_kf(pp), rotation=rot_kf(pr))))
        idx += 1

    tongue_op = {
        "a": 1,
        "k": [
            {"t": 0, "s": [0]},
            {"t": 9, "s": [100], "i": {"x": [0.5], "y": [1]}, "o": {"x": [0.5], "y": [0]}},
            {"t": 17, "s": [0]},
            {"t": 50, "s": [0]},
            {"t": 56, "s": [100], "i": {"x": [0.5], "y": [1]}, "o": {"x": [0.5], "y": [0]}},
            {"t": 66, "s": [0]},
            {"t": FRAMES, "s": [0]},
        ],
    }
    for name, extra in (("TongueL", -18), ("TongueR", 18)):
        tp, tr = head_motion(28, extra * 0.06, extra_deg=extra)
        layers.append(
            layer(
                idx,
                name,
                [ellipse(18, 3.6), fill(TONGUE)],
                xf(pos_kf(tp), rotation=rot_kf(tr), opacity=tongue_op),
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
        "nm": "SlitherSnake",
        "ddd": 0,
        "assets": [],
        "layers": list(reversed(layers)),
    }
    OUT.parent.mkdir(parents=True, exist_ok=True)
    OUT.write_text(json.dumps(data, separators=(",", ":")))
    print(f"wrote {OUT} ({OUT.stat().st_size / 1024:.1f} KB) layers={len(layers)}")


if __name__ == "__main__":
    main()
