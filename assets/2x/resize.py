from PIL import Image
import os


def upscale_pixel_art(input_image, output_directory, input_image_path):
    new_size = (int(input_image.width * 0.5), int(input_image.height * 0.5))
    resized_image = input_image.resize(new_size, Image.Resampling.NEAREST)

    filename = os.path.basename(input_image_path)
    output_image_path = os.path.join(output_directory, filename)
    resized_image.save(output_image_path)
