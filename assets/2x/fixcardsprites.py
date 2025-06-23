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
