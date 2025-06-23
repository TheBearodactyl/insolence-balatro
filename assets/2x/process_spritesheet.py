import argparse
import os

from PIL import Image
from fixcardsprites import process_image
from resize import upscale_pixel_art


def main():
    parser = argparse.ArgumentParser(description="The Cardinator 2000")

    parser.add_argument("input_image", help="Path to the spritesheet to process")

    parser.add_argument(
        "-w",
        "--width",
        type=int,
        default=144,
        help="Width of each tile in pixels (default: 144)",
    )

    parser.add_argument(
        "-l",
        "--height",
        type=int,
        default=190,
        help="Height of each tile in pixels (default: 190)",
    )

    parser.add_argument(
        "-r",
        "--radius",
        type=int,
        default=10,
        help="Corner radius for each tile in pixels (default: 10)",
    )

    args = parser.parse_args()

    if not os.path.exists(args.input_image):
        print(f"[ERROR]: Input file '{args.input_image}' does not exist!")
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
        print("[ERROR]: Failed to process image!")
        return 1

    try:
        result.save(output_path, "PNG")
        print(f"[SUCCESS]: Saved to {output_path}")
    except Exception as e:
        print(f"[ERROR]: Saving image failed: {e}")
        return 1

    input_image_path = args.input_image
    in_img = Image.open(input_image_path)
    output_dir = "../1x/"

    upscale_pixel_art(in_img, output_dir, input_image_path)

    return 0


if __name__ == "__main__":
    exit(main())
