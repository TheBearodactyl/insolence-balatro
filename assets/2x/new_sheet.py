import argparse
from PIL import Image


def create_transparent_sprite_sheet(
    tile_width, tile_height, columns, rows, output_file
):
    """
    Creates a transparent PNG sprite sheet with the specified dimensions.

    Args:
        tile_width (int): Width of each tile in pixels
        tile_height (int): Height of each tile in pixels
        columns (int): Number of columns in the sprite sheet
        rows (int): Number of rows in the sprite sheet
        output_file (str): Output filename (default: "sprite_sheet.png")
    """
    total_width = tile_width * columns
    total_height = tile_height * rows

    # Create a new image with RGBA mode (A for alpha channel)
    img = Image.new("RGBA", (total_width, total_height), (0, 0, 0, 0))

    # Save the image
    img.save(output_file)
    print(f"Created transparent sprite sheet: {output_file}")
    print(f"Dimensions: {total_width}x{total_height} pixels")
    print(f"Tiles: {columns}x{rows} ({columns * rows} total)")
    print(f"Tile size: {tile_width}x{tile_height} pixels")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description="Create a transparent PNG sprite sheet."
    )
    parser.add_argument(
        "--twidth", type=int, required=True, help="Tile width in pixels"
    )
    parser.add_argument(
        "--theight", type=int, required=True, help="Tile height in pixels"
    )
    parser.add_argument("--columns", type=int, required=True, help="Number of columns")
    parser.add_argument("--rows", type=int, required=True, help="Number of rows")
    parser.add_argument(
        "--output",
        type=str,
        default="sprite_sheet.png",
        help="Output filename (default: sprite_sheet.png)",
    )

    args = parser.parse_args()

    create_transparent_sprite_sheet(
        tile_width=args.twidth,
        tile_height=args.theight,
        columns=args.columns,
        rows=args.rows,
        output_file=args.output,
    )
