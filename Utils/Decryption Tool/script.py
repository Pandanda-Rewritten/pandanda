import os

KEY = "d02adaa4cf8fe4859fda09ae936aadbf138001925203340fa89d6c99b546d97e"

def xor_crypt(data: bytes, key: str) -> bytes:
    key_bytes = key.encode()  # Convert key to bytes
    key_length = len(key_bytes)
    
    return bytes([data[i] ^ key_bytes[i % key_length] for i in range(len(data))])

def process_file(file_path: str, mode: str):
    with open(file_path, 'rb') as f:
        data = f.read()

    processed_data = xor_crypt(data, KEY)

    if mode == 'decrypt':
        new_file = file_path.replace('.swf', '.dec.swf')
        print(f"Decrypting {file_path} to {new_file}")
    else:  # mode == 'encrypt'
        new_file = file_path.replace('.dec.swf', '.swf')
        print(f"Re-encrypting {file_path} to {new_file}")
    
    with open(new_file, 'wb') as f:
        f.write(processed_data)

def find_and_process_swf():
    current_folder = os.getcwd()

    for file_name in os.listdir(current_folder):
        if file_name.endswith('.swf') and not file_name.endswith('.dec.swf'):
            process_file(file_name, mode='decrypt')
            return
        elif file_name.endswith('.dec.swf'):
            process_file(file_name, mode='encrypt')
            return

    print("No .swf or .dec.swf file found in the current directory.")

if __name__ == "__main__":
    find_and_process_swf()
