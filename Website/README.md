# Pandanda Blog & News Generator

A comprehensive system for managing and serving Henry's Blog content from the archived Pandanda.com website, featuring dynamic news generation, modern web interfaces, and Flash content support via Ruffle emulation.

## 📋 Table of Contents

- [Overview](#overview)
- [Project Structure](#project-structure)
- [Quick Start](#quick-start)
- [Core Components](#core-components)
- [Scripts Documentation](#scripts-documentation)
- [Usage Examples](#usage-examples)
- [API Reference](#api-reference)
- [Deployment](#deployment)
- [Troubleshooting](#troubleshooting)

## 🎯 Overview

This project recreates and modernizes the Henry's Blog section from the archived Pandanda.com website (November 19, 2011). It provides:

- **Dynamic News System**: JSON-based article management with real-time updates
- **Modern Web Interface**: Beautiful, responsive generator with live preview
- **Flash Support**: Ruffle emulation for legacy SWF content
- **Multiple Server Options**: Simple, complete, and preview-enabled servers

## 📁 Project Structure

```
├── Blog/                          # Henry's Blog content
│   ├── news_articles.json         # Article data (JSON format)
│   ├── news_dynamic.htm           # Generated static news page
│   ├── news.htm                   # Original news template
│   ├── css/                       # Blog styling
│   ├── images/                    # Blog images and assets
│   ├── flash/                     # Flash content (SWF files)
│   └── js/                        # JavaScript files
├── Homepage/                      # Main Pandanda homepage (static)
│   ├── index.html                 # Homepage with Flash content
│   ├── css/                       # Homepage styling
│   ├── images/                    # Homepage assets
│   └── flash/                     # Homepage Flash content
├── Play/                          # Game section (static)
│   ├── index.html                 # Game interface
│   └── css/                       # Game styling
├── news_generator_with_preview.py # Main generator with live preview
├── news_server_simple.py          # Simple news server
└── README.md                      # This file
```

## 🚀 Quick Start

### 1. Start the News Generator (Recommended)

```bash
# Start the modern generator with live preview
python news_generator_with_preview.py

# Or use the batch file (Windows)
start_generator_with_preview.bat
```

Visit: **http://localhost:8004/generator**

### 2. Start the News Server

```bash
# Start the simple news server
python news_server_simple.py

# Or use the batch file (Windows)
start_simple_news_server.bat
```

Visit: **http://localhost:8002/blog**

### 3. View Static Content

The homepage and Play section are static HTML files that can be opened directly in your browser:

- **Homepage**: Open `Homepage/index.html` in your browser
- **Play Section**: Open `Play/index.html` in your browser

## 🛠️ Core Components

### News Generator with Live Preview

**File**: `news_generator_with_preview.py`

A modern, beautiful web interface for creating news articles with:
- Real-time preview as you type
- Image placement with tags (`#image1`, `#image2`, etc.)
- Automatic line break conversion
- Responsive design
- Article type selection (white/blue)

**Features**:
- Live preview panel
- Image management with placement options
- Form validation
- JSON data export

### News Servers

#### Simple News Server
**File**: `news_server_simple.py`

- Serves dynamic news from JSON
- JSON API endpoints
- Static file serving
- No admin interface

### Content Management

#### JSON Article Format
```json
{
  "id": "unique_article_id",
  "title": "Article Title",
  "date": "October 30th, 2009",
  "type": "white",  // or "blue"
  "content": "HTML content with <br/> for line breaks",
  "has_image": true,
  "images": [
    {
      "src": "path/to/image.jpg",
      "placement": "full-width",  // or "left-half", "right-half", etc.
      "alt": "Alt text",
      "link": "optional_link_url",
      "caption": "Optional caption"
    }
  ]
}
```

#### Article Types
- **White Articles**: Clean background, no corner decorations
- **Blue Articles**: Blue background with decorative corners

## 📚 Core Scripts

### News Generator

| Script | Purpose | Port | Features |
|--------|---------|------|----------|
| `news_generator_with_preview.py` | Main generator with live preview | 8004 | Live preview, modern UI, image placement |

### News Servers

| Script | Purpose | Port | Features |
|--------|---------|------|----------|
| `news_server_simple.py` | Simple news server | 8002 | Dynamic content, JSON API |

## 💡 Usage Examples

### Creating a New Article

1. **Using the Web Generator**:
   ```bash
   python news_generator_with_preview.py
   # Visit http://localhost:8004/generator
   ```

2. **Manual JSON Edit**:
   ```bash
   # Edit blog/news_articles.json directly
   # The news server will automatically serve the updated content
   ```

### Image Placement

Use placement tags in your content:
```
Welcome to our blog!

#image1

This text will appear after the first image.

#image2

You can place multiple images throughout your content.
```

### Starting Different Servers

```bash
# Simple news server (recommended for viewing)
python news_server_simple.py

## 🔌 API Reference

### News API Endpoints

| Endpoint | Method | Description | Response |
|----------|--------|-------------|----------|
| `/` | GET | Dynamic news page | HTML |
| `/news` | GET | Dynamic news page | HTML |
| `/api/news` | GET | News data as JSON | JSON |
| `/api/news.json` | GET | Raw JSON file | JSON |

### JSON Response Format

```json
{
  "articles": [
    {
      "id": "article_id",
      "title": "Article Title",
      "date": "Publication Date",
      "type": "white|blue",
      "content": "HTML content",
      "has_image": true,
      "images": [...]
    }
  ],
  "metadata": {
    "last_updated": "2025-01-09",
    "total_articles": 1,
    "description": "Henry's Blog news articles"
  }
}
```

## 🚀 Deployment

### Local Development

1. **Clone/Download** the project
2. **Install Python 3.6+**
3. **Start the generator**:
   ```bash
   python news_generator_with_preview.py
   ```
4. **Start the server**:
   ```bash
   python news_server_simple.py
   ```

### Production Deployment

1. **Upload files** to your server:
   ```
   news_server_simple.py
   blog/ (entire folder)
   homepage/ (entire folder)
   Play/ (entire folder)
   ```

2. **Start the server**:
   ```bash
   python news_server_simple.py
   ```

3. **Configure port** (optional):
   Edit `PORT = 8002` in the script

### Cloud Deployment

The servers work on any platform supporting Python:
- **Heroku**: Add `Procfile` with `web: python news_server_simple.py`
- **DigitalOcean**: Upload and run the script
- **AWS EC2**: Install Python and run
- **VPS**: Any VPS with Python support

## 🛠️ Troubleshooting

### Common Issues

1. **Port Already in Use**:
   ```bash
   # Change port in script
   PORT = 8003  # Use different port
   ```

2. **Flash Content Not Loading**:
   - Ensure Ruffle script is included
   - Check browser console for errors
   - Verify SWF file paths

3. **Images Not Displaying**:
   - Check image URLs in JSON
   - Verify file paths are correct
   - Ensure images are accessible

4. **JSON Parse Errors**:
   - Validate JSON syntax
   - Check for missing commas or brackets
   - Use a JSON validator

### Debug Mode

Enable debug output by modifying scripts:
```python
# Add at the top of scripts
import logging
logging.basicConfig(level=logging.DEBUG)
```

### Testing

Test the system by:
1. Starting the news server: `python news_server_simple.py`
2. Visiting: `http://localhost:8002/`
3. Creating articles with the generator: `python news_generator_with_preview.py`

## 📝 Requirements

- **Python 3.6+**
- **Modern web browser** (for Flash emulation)
- **Internet connection** (for Ruffle CDN)

### Optional Dependencies

```bash
pip install requests beautifulsoup4 lxml
```

## 🤝 Contributing

1. **Fork** the project
2. **Create** a feature branch
3. **Make** your changes
4. **Test** thoroughly
5. **Submit** a pull request

## 📄 License

This project recreates content from the archived Pandanda.com website for educational and preservation purposes.

## 🙏 Acknowledgments

- **Pandanda.com** - Original website and content
- **Wayback Machine** - For preserving the archived content
- **Ruffle** - For Flash emulation support
- **Archive.org** - For web archiving services

---

**Note**: This project is for educational and preservation purposes. All original content belongs to the respective copyright holders.
