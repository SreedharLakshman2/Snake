#!/usr/bin/env python3
"""Capture live Snakelet screens (ads hidden) from the iOS Simulator."""

from __future__ import annotations

import subprocess
import time
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
RAW = ROOT / "AppStore" / "Screenshots" / "raw"
BUNDLE = "com.sreeo.snake"
SCHEME = "Snake"
DERIVED = ROOT / ".store-derived"

SHOTS = [
    ("menu", "01-menu.png", 2.4),
    ("game", "02-game.png", 1.6),
    ("settings", "03-settings.png", 1.4),
]


def run(cmd: list[str], check: bool = True, cwd: Path | None = None) -> subprocess.CompletedProcess:
    print("+", " ".join(cmd))
    return subprocess.run(cmd, check=check, cwd=cwd)


def simulator_udid() -> str:
    listing = subprocess.check_output(["xcrun", "simctl", "list", "devices", "available"], text=True)
    for name in ("iPhone 16 Pro Max", "iPhone 17 Pro Max", "iPhone 16 Pro", "iPhone 15 Pro Max"):
        for line in listing.splitlines():
            if name in line and "unavailable" not in line.lower():
                start = line.find("(")
                end = line.find(")", start)
                if start != -1 and end != -1:
                    return line[start + 1 : end]
    raise SystemExit("No iPhone Pro Max simulator is available")


def app_path() -> Path:
    products = DERIVED / "Build" / "Products" / "Debug-iphonesimulator" / "Snake.app"
    if not products.exists():
        raise SystemExit(f"Missing {products}")
    return products


def main() -> None:
    RAW.mkdir(parents=True, exist_ok=True)
    udid = simulator_udid()
    print("simulator", udid)
    run(
        [
            "xcodebuild",
            "-scheme",
            SCHEME,
            "-destination",
            f"id={udid}",
            "-derivedDataPath",
            str(DERIVED),
            "-quiet",
            "build",
        ],
        cwd=ROOT,
    )
    run(["xcrun", "simctl", "boot", udid], check=False)
    run(["xcrun", "simctl", "bootstatus", udid, "-b"])
    run(["xcrun", "simctl", "install", udid, str(app_path())])
    for shot, filename, wait in SHOTS:
        run(["xcrun", "simctl", "terminate", udid, BUNDLE], check=False)
        run(["xcrun", "simctl", "launch", udid, BUNDLE, "-hideAds", "-shot", shot])
        time.sleep(wait)
        dest = RAW / filename
        run(["xcrun", "simctl", "io", udid, "screenshot", str(dest)])
        print("captured", dest.name)


if __name__ == "__main__":
    main()
