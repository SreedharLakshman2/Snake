# App Store screenshots

Canva-style posters: bold gradient title, titanium iPhone Pro, live Snakelet UI.

Upload **only** iPhone 6.9" in App Store Connect. Snakelet is iPhone-only.

| Connect slot | Size | Folder |
| --- | --- | --- |
| iPhone 6.9" | 1320 × 2868 | `iPhone-6.9/` |

Upload `01`–`03` in that order.

## Rebuild

```
python3 Tools/capture_store_screenshots.py
python3 Tools/compose_store_posters.py
```

3D icon (1024 RGB, no alpha):

```
python3 Tools/make_icon.py
```

## Poster copy

1. **Eat. Grow. Beat your best.** — Classic Snake on a glowing LCD.
2. **Chase the fruit.** — Grow longer. Speed up. Don't hit the wall.
3. **Make it yours.** — Eight colors. Eight fruits. Easy to Hard.
