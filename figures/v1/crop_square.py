"""Crop all PNGs in this folder to a horizontally centered square, keeping the height.

Usage:
    python crop_square.py [--dry-run] [--outdir DIR]

Default overwrites the images in place. Use --outdir to write copies elsewhere.
"""
import argparse
import glob
import os

from PIL import Image


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--dry-run", action="store_true", help="only report the crop boxes")
    ap.add_argument("--outdir", default=None, help="write results here instead of in place")
    ap.add_argument("--pattern", default="*.png")
    args = ap.parse_args()

    files = sorted(glob.glob(args.pattern))
    if args.outdir:
        os.makedirs(args.outdir, exist_ok=True)

    for path in files:
        with Image.open(path) as im:
            w, h = im.size
            if w == h:
                print(f"skip (already square): {path} {w}x{h}")
                continue
            if w > h:  # crop left/right, keep height
                left = (w - h) // 2
                box = (left, 0, left + h, h)
            else:      # taller than wide: crop top/bottom, keep width
                top = (h - w) // 2
                box = (0, top, w, top + w)
            print(f"{path}: {w}x{h} -> {box[2]-box[0]}x{box[3]-box[1]} box={box}")
            if args.dry_run:
                continue
            out = os.path.join(args.outdir, os.path.basename(path)) if args.outdir else path
            im.crop(box).save(out)
    print(f"done, {len(files)} file(s)")


if __name__ == "__main__":
    main()
