"""Tile the cropped square PNGs into 3-per-row grids of 6 (3 cols x 2 rows).

Usage:
    python make_grids.py [--cols 3] [--rows 2] [--pad 0] [--outdir DIR]

Default order is the sorted filename order. Images are laid out left-to-right,
top-to-bottom with no gap; output is one PNG per group of cols*rows images,
named after the first and last image in the group (e.g. grid_111-123.png).
"""
import argparse
import glob
import os

from PIL import Image


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--cols", type=int, default=3)
    ap.add_argument("--rows", type=int, default=2)
    ap.add_argument("--pad", type=int, default=0, help="gap between tiles in px")
    ap.add_argument("--outdir", default=".")
    ap.add_argument("--pattern", default="[0-9][0-9][0-9].png", help="glob for input tiles")
    args = ap.parse_args()

    files = sorted(glob.glob(args.pattern))
    per_fig = args.cols * args.rows
    if not files:
        raise SystemExit(f"no files matched {args.pattern}")
    if len(files) % per_fig:
        print(f"warning: {len(files)} files is not a multiple of {per_fig}")

    # all tiles share the same size (cropped squares)
    with Image.open(files[0]) as im0:
        tw, th = im0.size
    cell_w, cell_h = tw + args.pad, th + args.pad
    fig_w = args.cols * cell_w - args.pad
    fig_h = args.rows * cell_h - args.pad

    os.makedirs(args.outdir, exist_ok=True)
    for start in range(0, len(files), per_fig):
        group = files[start:start + per_fig]
        canvas = Image.new("RGB", (fig_w, fig_h), (255, 255, 255))
        for i, path in enumerate(group):
            r, c = divmod(i, args.cols)
            with Image.open(path) as im:
                if im.size != (tw, th):
                    print(f"  note: {path} is {im.size}, expected {(tw, th)}")
                canvas.paste(im.convert("RGB"), (c * cell_w, r * cell_h))
        first = os.path.splitext(os.path.basename(group[0]))[0]
        last = os.path.splitext(os.path.basename(group[-1]))[0]
        out = os.path.join(args.outdir, f"grid_{first}-{last}.png")
        canvas.save(out)
        print(f"{out}: {' '.join(os.path.basename(p) for p in group)} -> {canvas.size}")


if __name__ == "__main__":
    main()
