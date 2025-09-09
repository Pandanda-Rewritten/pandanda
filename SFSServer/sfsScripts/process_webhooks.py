#!/usr/bin/env python3
import json
import requests
import time
import os
import sys

def send_single_webhook(webhook_data):
    """Send a single webhook to Discord"""
    try:
        response = requests.post(
            webhook_data['url'],
            headers=webhook_data['headers'],
            json=webhook_data['payload'],
            timeout=10
        )
        
        if response.status_code >= 200 and response.status_code < 300:
            print(f"SUCCESS: Webhook sent successfully (Status: {response.status_code})")
            return True
        else:
            print(f"ERROR: Webhook failed (Status: {response.status_code})")
            print(f"   Response: {response.text}")
            return False
            
    except Exception as e:
        print(f"ERROR: Error sending webhook: {e}")
        return False

def process_webhook_queue():
    """Process webhook queue file and send to Discord"""
    queue_file = "logs/webhook_queue.json"
    
    if not os.path.exists(queue_file):
        print("No webhook queue file found")
        return
    
    try:
        with open(queue_file, 'r') as f:
            lines = f.readlines()
        
        if not lines:
            print("No webhooks in queue")
            return
        
        print(f"Processing {len(lines)} webhook(s)...")
        
        for i, line in enumerate(lines):
            if line.strip():
                try:
                    webhook_data = json.loads(line.strip())
                    send_single_webhook(webhook_data)
                        
                except Exception as e:
                    print(f"ERROR: Error processing webhook {i+1}: {e}")
        
        # Clear the queue file after processing
        with open(queue_file, 'w') as f:
            f.write("")
        print("SUCCESS: Queue processed and cleared")
        
    except Exception as e:
        print(f"Error reading queue file: {e}")

if __name__ == "__main__":
    # Check if a specific file was passed as argument (called from SFS)
    if len(sys.argv) > 1:
        temp_file = sys.argv[1]
        if os.path.exists(temp_file):
            try:
                with open(temp_file, 'r') as f:
                    webhook_data = json.load(f)
                success = send_single_webhook(webhook_data)
                sys.exit(0 if success else 1)
            except Exception as e:
                print(f"ERROR: Error processing temp file: {e}")
                sys.exit(1)
        else:
            print(f"ERROR: Temp file not found: {temp_file}")
            sys.exit(1)
    else:
        # Process queue file normally
        process_webhook_queue()