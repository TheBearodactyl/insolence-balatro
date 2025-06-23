from PIL import Image, ImageDraw
import os
import argparse


def round_corners(tile, radius):
    width, height = tile.size
    mask = Image.new("L", (width, height), 0)
    draw = ImageDraw.Draw(mask)
    draw.rounded_rectangle([(0, 0), (width, height)], radius=radius, fill=255)

    rounded = Image.new("RGBA", (width, height))
    rounded.paste(tile.convert("RGBA"), (0, 0), mask)

    return rounded


def process_image(img_path, twidth, theight, corner_radius):
    image = Image.open(img_path).convert("RGBA")
    ow, oh = image.size

    tsx = ow // twidth
    tsy = oh // theight

    new_image = Image.new("RGBA", (tsx * twidth, tsy * theight), color=(0, 0, 0, 0))

    for y in range(tsy):
        for x in range(tsx):
            left = x * twidth
            upper = y * theight
            right = left + twidth
            lower = upper + theight

            tile = image.crop((left, upper, right, lower))
            rounded_tile = round_corners(tile, corner_radius)
            new_image.paste(rounded_tile, (left, upper), rounded_tile)

    base_name = os.path.splitext(img_path)[0]
    output_path = f"{base_name}_rounded.png"
    new_image.save(output_path)
    print(f"Saved result to {output_path}")


def main():
    parser = argparse.ArgumentParser(
        description="Split an image into rounded-corner tiles and reassemble."
    )
    parser.add_argument("image", help="Path to the input image")
    parser.add_argument(
        "--tile-width", type=int, default=71, help="Width of each tile in pixels"
    )
    parser.add_argument(
        "--tile-height", type=int, default=95, help="Height of each tile in pixels"
    )
    parser.add_argument(
        "--radius", type=int, default=10, help="Radius for rounded corners in pixels"
    )

    args = parser.parse_args()
    process_image(args.image, args.tile_width, args.tile_height, args.radius)


if __name__ == "__main__":
    main()
