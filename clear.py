import os
import shutil

import_dir = "./.import"
extensions = [".tscn-", ".tmp", ".cfg", ".save", ".dmp", ".md5", ".ctex"]

if os.path.exists(import_dir):
    shutil.rmtree(import_dir)
    print(f"Removed: {import_dir}")

for root, dirs, files in os.walk("."):
    for file in files:
        if any(file.endswith(ext) for ext in extensions):
            file_path = os.path.join(root, file)
            os.remove(file_path)
            print(f"Removed: {file_path}")