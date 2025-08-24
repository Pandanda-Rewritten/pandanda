import os
import cv2

def resize_images(input_folder, output_folder, target_height=1024):
    os.makedirs(output_folder, exist_ok=True)
    for filename in os.listdir(input_folder):
        if not filename.lower().endswith((".jpg", ".jpeg", ".png")):
            continue
        img_path = os.path.join(input_folder, filename)
        img = cv2.imread(img_path)
        if img is None:
            continue

        h, w = img.shape[:2]
        scale = target_height / h
        resized = cv2.resize(img, (int(w * scale), target_height))
        cv2.imwrite(os.path.join(output_folder, filename), resized)
        print(f"Saved resized: {filename}")

if __name__ == "__main__":
    input_dir = r"path\to\input_folder"
    output_dir = r"path\to\output_folder"
    resize_images(input_dir, output_dir, target_height=1024)