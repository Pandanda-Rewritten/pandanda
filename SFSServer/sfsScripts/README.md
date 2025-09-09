# SFS Scripts

This folder contains Python scripts used by the SmartFoxServer extensions.

## Setup

1. Install Python 3.6 or higher
2. Install required dependencies:
   ```bash
   pip install -r requirements.txt
   ```

## Scripts

### process_webhooks.py
Handles sending Discord webhooks for player reports.

**Usage:**
- Called automatically by SFS Server when reports are submitted
- Can also be run manually to process queued webhooks:
  ```bash
  python process_webhooks.py
  ```

**Dependencies:**
- `requests` - For HTTP requests to Discord webhooks
