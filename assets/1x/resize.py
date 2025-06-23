import sys
from PIL import Image
import os


def upscale_pixel_art(input_image, output_directory, input_image_path):
    new_size = (int(input_image.width * 2), int(input_image.height * 2))
    resized_image = input_image.resize(new_size, Image.Resampling.NEAREST)

    filename = os.path.basename(input_image_path)
    output_image_path = os.path.join(output_directory, filename)
    resized_image.save(output_image_path)


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: py resize.py <input_image>")
        sys.exit(1)

    input_image_path = sys.argv[1]
    input_image = Image.open(input_image_path)

    output_directory = "../2x/"
    upscale_pixel_art(input_image, output_directory, input_image_path)
