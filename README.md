# Batch Image Binarization for Droplet Collision Experiments

This computational script performs **batch thresholding and binarization** of droplet experiment images for multiple collision outcome categories.

It reads `.tif` images from organized experiment folders, converts them into binary images using a fixed threshold, and saves the processed images into corresponding output directories.

The script is useful as a **preprocessing step** before droplet detection, contour extraction, or collision analysis.

---

## Overview

The script processes experimental images for four droplet collision outcome types:

- **bouncing**
- **coalescence**
- **reflecting**
- **stretching**

For each category, it:

1. Scans all time-sequence folders
2. Reads each `.tif` image
3. Converts the image to double precision
4. Applies a fixed binary threshold
5. Saves the binary result into a processed output folder

---

## Features

- Batch processing of large image datasets
- Supports multiple collision regime folders
- Fixed-threshold image binarization
- Preserves original filenames
- Organized output into matching time folders

---

## Folder Structure

The script expects a folder structure like this:

```text
path/
├── original/
│   ├── bouncing/
│   │   ├── time1/
│   │   │   ├── *.tif
│   │   ├── time2/
│   │   └── ...
│   ├── coalescence/
│   ├── reflecting/
│   └── stretching/
│
└── PROCESS/
    ├── bouncing/
    │   ├── time1/
    │   │   └── add1/
    │   ├── time2/
    │   └── ...
    ├── coalescence/
    ├── reflecting/
    └── stretching/
