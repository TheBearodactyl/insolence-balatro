"""
Cardinator 2000:
Iterates over spritesheet tiles and rounds each tiles
corners to better resemble a card
"""

import argparse
import os
from PIL import Image, ImageDraw


def create_rounded_mask(width, height, radius):
    mask = Image.new("L", (width, height), 0)
    draw = ImageDraw.Draw(mask)

    draw.rounded_rectangle([0, 0, width, height], radius=radius, fill=255)

    return mask


def round_tile_corners(tile, radius):
    rounded_tile = Image.new("RGBA", tile.size, (0, 0, 0, 0))

    if tile.mode != "RGBA":
        tile = tile.convert("RGBA")

    mask = create_rounded_mask(tile.size[0], tile.size[1], radius)

    rounded_tile.paste(tile, (0, 0))
    rounded_tile.putalpha(mask)

    return rounded_tile


def process_image(input_path, tile_width, tile_height, corner_radius):
    try:
        img = Image.open(input_path)
    except Exception as e:
        print(f"Error opening image: {e}")
        return None

    if img.mode != "RGBA":
        img = img.convert("RGBA")

    img_width, img_height = img.size
    tiles_x = img_width // tile_width
    tiles_y = img_height // tile_height

    print(f"Image size: {img_width}x{img_height}")
    print(f"Tile size: {tile_width}x{tile_height}")
    print(f"Number of tiles: {tiles_x}x{tiles_y}")

    output_img = Image.new(
        "RGBA", (tiles_x * tile_width, tiles_y * tile_height), (0, 0, 0, 0)
    )

    for y in range(tiles_y):
        for x in range(tiles_x):
            left = x * tile_width
            top = y * tile_height
            right = left + tile_width
            bottom = top + tile_height
            tile = img.crop((left, top, right, bottom))
            rounded_tile = round_tile_corners(tile, corner_radius)

            output_img.paste(rounded_tile, (left, top), rounded_tile)

    return output_img


def main():
    parser = argparse.ArgumentParser(description="The Cardinator 2000")

    parser.add_argument("input_image", help="Path to the input image")

    dw, dh = 144, 190

    parser.add_argument(
        "-w",
        "--width",
        type=int,
        default=dw,
        help=f"Width of each tile in pixels (default: {dw})",
    )

    parser.add_argument(
        "-t",
        "--height",
        type=int,
        default=dh,
        help=f"Height of each tile in pixels (default: {dh})",
    )

    parser.add_argument(
        "-r",
        "--radius",
        type=int,
        default=10,
        help="Corner radius in pixels (default: 10)",
    )

    args = parser.parse_args()

    if not os.path.exists(args.input_image):
        print(f"Error: Input file '{args.input_image}' does not exist")
        return 1

    input_path = args.input_image
    name, _ = os.path.splitext(input_path)
    output_path = f"{name}_rounded.png"

    print(f"Processing: {input_path}")
    print(f"Output: {output_path}")
    print(f"Tile size: {args.width}x{args.height}")
    print(f"Corner radius: {args.radius} pixels")

    result = process_image(input_path, args.width, args.height, args.radius)

    if result is None:
        print("Failed to process image")
        return 1

    try:
        result.save(output_path, "PNG")
        print(f"Success! Saved to: {output_path}")
    except Exception as e:
        print(f"Error saving image: {e}")
        return 1

    return 0


if __name__ == "__main__":
    exit(main())
