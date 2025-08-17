import os
import cv2

def crop_with_click(input_folder, output_folder, patch_size=DIM):#DIM= Your own value
    os.makedirs(output_folder, exist_ok=True)
    half_patch = patch_size // 2

    def mouse_callback(event, x, y, flags, param):
        if event == cv2.EVENT_LBUTTONDOWN:
            param[:] = [(x, y)]

    for filename in os.listdir(input_folder):
        if not filename.lower().endswith((".jpg", ".jpeg", ".png")):
            continue
        img_path = os.path.join(input_folder, filename)
        img = cv2.imread(img_path)
        if img is None:
            continue

        h, w = img.shape[:2]
        scale = 1024 / h
        resized = cv2.resize(img, (int(w * scale), 1024))

        pts = []
        cv2.namedWindow("crop")
        cv2.setMouseCallback("crop", mouse_callback, pts)

        while True:
            display = resized.copy()
            if pts:
                x, y = pts[0]
                cv2.rectangle(display, (x - half_patch, y - half_patch),
                              (x + half_patch, y + half_patch), (DIM, 0, 0), 2)
            cv2.imshow("crop", display)
            key = cv2.waitKey(1)
            if key == 13 and pts:  # Enter
                break
            if key == 27:  # Escape
                pts = []
                break

        cv2.destroyAllWindows()
        if not pts:
            continue

        x, y = pts[0]
        x1 = max(0, min(resized.shape[1] - patch_size, x - half_patch))
        y1 = max(0, min(resized.shape[0] - patch_size, y - half_patch))
        patch = resized[y1:y1 + patch_size, x1:x1 + patch_size]
        cv2.imwrite(os.path.join(output_folder, filename), patch)
        print(f"Saved patch: {filename}")

if __name__ == "__main__":
    input_dir = r"path\to\resized_folder"
    output_dir = r"path\to\cropped_folder"
    crop_with_click(input_dir, output_dir, patch_size=DIM)#DIM= Your own value