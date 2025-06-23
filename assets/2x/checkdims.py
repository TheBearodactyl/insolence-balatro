import sys
from PIL import Image


def main():
    if len(sys.argv) != 4:
        print("Usage: python3 checkdims.py <image path> <tile width> <tile height>")
        return

    image_path = sys.argv[1]
    boxw = int(sys.argv[2])
    boxh = int(sys.argv[3])

    try:
        with Image.open(image_path) as img:
            imgw, imgh = img.size
    except Exception as e:
        print(f"Error opening image at {image_path}: {e}")
        return

    boxes_x = imgw // boxw
    boxes_y = imgh // boxh

    print(f"X: {boxes_x - 1}\nY: {boxes_y - 1}\n")


if __name__ == "__main__":
    main()
