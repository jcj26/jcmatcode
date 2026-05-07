# colourAtla — Colormap Extraction & Export Tool

A MATLAB GUI tool for extracting colormaps from images via k-means clustering, with multi-format import/export support for COMSOL, Origin, Tecplot, and MATLAB.

## Features

- **Extract colors from images** — Load any JPG/PNG/TIF/GIF image and extract dominant colors using k-means clustering (2–12 colors)
- **Smart color ordering** — Nearest-neighbor sorting algorithm for visually pleasing color sequences
- **Multi-format export** — Export colormaps to:
  - **COMSOL** `.txt` — Continuous color table with normalized RGB (0–1)
  - **Origin** `.pal` — JASC-PAL format with integer RGB (0–255)
  - **Tecplot** `.map` — Macro format with named colormap and control points
  - **MATLAB** `.m` — Function file with `interp1` interpolation
- **Multi-format import** — Import colormap files from COMSOL, Origin, Tecplot, MATLAB `.m`, and MATLAB `.mat` with automatic format detection
- **Color naming** — Assign names to Tecplot and MATLAB colormap exports
- **Editable color table** — Directly edit RGB values (0–255) with real-time preview
- **Reverse order** — Flip the color sequence with one click
- **Multiple display formats** — View colors as `[0 1]` float, `[0 255]` integer, `#hex`, or HSV

## Requirements

- MATLAB R2018a or later (uses uifigure components)
- Image Processing Toolbox (for `rgb2ind`)

## Usage

1. Open MATLAB and run:
   ```matlab
   colourAtla
   ```
2. **Load an image** — Click "Load Img" and select a color palette image
3. **Extract colors** — Set the desired color count (2–12) and click "RUN"
4. **Edit colors** — Modify RGB values directly in the table, or click "Reverse" to flip the order
5. **Export** — Choose the target format from the dropdown, optionally enter a name, and click "Export"
6. **Import** — Click "Import Map" to load an existing colormap file from any supported format

## Supported Formats

| Software | Extension | RGB Range | Naming | File Structure |
|----------|-----------|-----------|--------|---------------|
| COMSOL | `.txt` | 0–1 | No | `% Continuous` header + space-separated floats |
| Origin | `.pal` | 0–255 | No | `JASC-PAL` header + count + integer RGB |
| Tecplot | `.map` | 0–255 | Yes (`Name =`) | `#!MC 1410` + `$!CreateColorMap` + control points |
| MATLAB | `.m` | 0–1 | Yes (function name) | Function returning m×3 colormap via `interp1` |
| MATLAB | `.mat` | 0–1 | Yes (variable name) | Binary MAT-file (import only) |

## File Structure

```
colourAtla.m          — Main application (MATLAB GUI)
map1.jpg              — Sample palette image
map2.jpg              — Sample palette image
comsolmap1.txt        — Sample COMSOL colormap export
comsolmap2.txt        — Sample COMSOL colormap export
README.md             — This file
```

## Author

- **GUI & algorithm**: slandarer
- **Multi-format support**: jc
