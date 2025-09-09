#!/usr/bin/env python3
"""
News Generator with Live Preview for Henry's Blog
A beautiful, modern web interface with real-time preview
"""

import json
import os
import http.server
import socketserver
import urllib.parse
from pathlib import Path
from datetime import datetime

class NewsGeneratorWithPreviewHandler(http.server.SimpleHTTPRequestHandler):
    """Handler for news generation interface with live preview"""
    
    def do_GET(self):
        """Handle GET requests"""
        
        # Parse the URL
        parsed_path = urllib.parse.urlparse(self.path)
        path = parsed_path.path
        
        # Handle different endpoints
        if path == '/' or path == '/generator':
            self.serve_generator_form()
        elif path == '/preview':
            self.serve_preview_page()
        else:
            self.send_error(404, "Page not found")
    
    def do_POST(self):
        """Handle POST requests"""
        
        # Parse the URL
        parsed_path = urllib.parse.urlparse(self.path)
        path = parsed_path.path
        
        if path == '/generate':
            self.generate_article()
        else:
            self.send_error(404, "Endpoint not found")
    
    def serve_generator_form(self):
        """Serve the generator form with live preview"""
        
        html_content = f"""
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>📰 Henry's Blog News Generator with Live Preview</title>
    <style>
        * {{
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }}
        
        body {{
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
            line-height: 1.6;
        }}
        
        .container {{
            max-width: 1400px;
            margin: 0 auto;
            background: white;
            border-radius: 20px;
            box-shadow: 0 25px 50px rgba(0,0,0,0.15);
            overflow: hidden;
            backdrop-filter: blur(10px);
            display: flex;
            min-height: calc(100vh - 40px);
        }}
        
        .generator-panel {{
            flex: 1;
            padding: 40px;
            border-right: 1px solid #e2e8f0;
            overflow-y: auto;
            max-height: calc(100vh - 40px);
        }}
        
        .preview-panel {{
            flex: 1;
            background: #f8f9fa;
            padding: 20px;
            overflow-y: auto;
            max-height: calc(100vh - 40px);
        }}
        
        .header {{
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 30px;
            text-align: center;
            position: relative;
            overflow: hidden;
            margin: -40px -40px 30px -40px;
        }}
        
        .header::before {{
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: radial-gradient(circle, rgba(255,255,255,0.1) 0%, transparent 70%);
            animation: float 6s ease-in-out infinite;
        }}
        
        @keyframes float {{
            0%, 100% {{ transform: translateY(0px) rotate(0deg); }}
            50% {{ transform: translateY(-20px) rotate(180deg); }}
        }}
        
        .header h1 {{
            margin: 0;
            font-size: 2.2em;
            font-weight: 700;
            position: relative;
            z-index: 1;
            text-shadow: 0 2px 4px rgba(0,0,0,0.3);
        }}
        
        .header p {{
            margin: 10px 0 0 0;
            font-size: 1em;
            opacity: 0.9;
            position: relative;
            z-index: 1;
        }}
        
        .preview-header {{
            background: linear-gradient(135deg, #48bb78 0%, #38a169 100%);
            color: white;
            padding: 20px;
            text-align: center;
            margin: -20px -20px 20px -20px;
            border-radius: 0 0 15px 15px;
        }}
        
        .preview-header h2 {{
            margin: 0;
            font-size: 1.5em;
            font-weight: 600;
        }}
        
        .form-section {{
            margin-bottom: 25px;
            padding: 25px;
            background: linear-gradient(145deg, #f8f9fa 0%, #ffffff 100%);
            border-radius: 16px;
            border: 1px solid rgba(102, 126, 234, 0.1);
            box-shadow: 0 8px 25px rgba(0,0,0,0.05);
            transition: all 0.3s ease;
        }}
        
        .form-section:hover {{
            transform: translateY(-2px);
            box-shadow: 0 12px 35px rgba(0,0,0,0.08);
        }}
        
        .form-section h3 {{
            margin-top: 0;
            color: #2d3748;
            font-size: 1.2em;
            font-weight: 600;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 8px;
        }}
        
        .form-group {{
            margin-bottom: 20px;
        }}
        
        .form-group label {{
            display: block;
            margin-bottom: 6px;
            font-weight: 600;
            color: #4a5568;
            font-size: 0.9em;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }}
        
        .form-group input,
        .form-group select,
        .form-group textarea {{
            width: 100%;
            padding: 12px 16px;
            border: 2px solid #e2e8f0;
            border-radius: 10px;
            font-size: 14px;
            transition: all 0.3s ease;
            background: white;
            font-family: inherit;
        }}
        
        .form-group input:focus,
        .form-group select:focus,
        .form-group textarea:focus {{
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
            transform: translateY(-1px);
        }}
        
        .form-group textarea {{
            min-height: 100px;
            resize: vertical;
            line-height: 1.6;
        }}
        
        .btn {{
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 15px 30px;
            border: none;
            border-radius: 10px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            width: 100%;
            text-transform: uppercase;
            letter-spacing: 1px;
            position: relative;
            overflow: hidden;
        }}
        
        .btn::before {{
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
            transition: left 0.5s;
        }}
        
        .btn:hover::before {{
            left: 100%;
        }}
        
        .btn:hover {{
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(102, 126, 234, 0.4);
        }}
        
        .btn:active {{
            transform: translateY(-1px);
        }}
        
        .btn-add {{
            background: linear-gradient(135deg, #48bb78 0%, #38a169 100%);
            color: white;
            padding: 12px 20px;
            border: none;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            margin: 5px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }}
        
        .btn-add:hover {{
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(72, 187, 120, 0.4);
        }}
        
        .content-element {{
            background: linear-gradient(145deg, #ffffff 0%, #f7fafc 100%);
            border: 2px solid #e2e8f0;
            border-radius: 12px;
            padding: 15px;
            margin: 10px 0;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }}
        
        .content-element-info {{
            flex: 1;
        }}
        
        .content-element-title {{
            font-weight: 600;
            color: #2d3748;
            margin-bottom: 5px;
        }}
        
        .content-element-details {{
            font-size: 0.9em;
            color: #4a5568;
        }}
        
        .content-element-actions {{
            display: flex;
            gap: 10px;
        }}
        
        .btn-edit {{
            background: #667eea;
            color: white;
            border: none;
            border-radius: 6px;
            padding: 8px 12px;
            cursor: pointer;
            font-size: 12px;
            transition: all 0.3s ease;
        }}
        
        .btn-edit:hover {{
            background: #5a67d8;
            transform: translateY(-1px);
        }}
        
        .btn-remove {{
            background: #e53e3e;
            color: white;
            border: none;
            border-radius: 6px;
            padding: 8px 12px;
            cursor: pointer;
            font-size: 12px;
            transition: all 0.3s ease;
        }}
        
        .btn-remove:hover {{
            background: #c53030;
            transform: translateY(-1px);
        }}
        
        /* Modal Styles */
        .modal {{
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.5);
            backdrop-filter: blur(5px);
        }}
        
        .modal-content {{
            background-color: white;
            margin: 5% auto;
            padding: 30px;
            border-radius: 20px;
            width: 80%;
            max-width: 600px;
            box-shadow: 0 25px 50px rgba(0,0,0,0.3);
            animation: modalSlideIn 0.3s ease;
        }}
        
        @keyframes modalSlideIn {{
            from {{ transform: translateY(-50px); opacity: 0; }}
            to {{ transform: translateY(0); opacity: 1; }}
        }}
        
        .modal-header {{
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
            padding-bottom: 15px;
            border-bottom: 2px solid #e2e8f0;
        }}
        
        .modal-title {{
            font-size: 1.5em;
            font-weight: 600;
            color: #2d3748;
        }}
        
        .close {{
            color: #aaa;
            font-size: 28px;
            font-weight: bold;
            cursor: pointer;
            transition: color 0.3s ease;
        }}
        
        .close:hover {{
            color: #e53e3e;
        }}
        
        .modal-footer {{
            display: flex;
            justify-content: flex-end;
            gap: 15px;
            margin-top: 25px;
            padding-top: 15px;
            border-top: 2px solid #e2e8f0;
        }}
        
        .btn-modal {{
            padding: 12px 24px;
            border: none;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
        }}
        
        .btn-modal-primary {{
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }}
        
        .btn-modal-secondary {{
            background: #e2e8f0;
            color: #4a5568;
        }}
        
        .btn-modal:hover {{
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(0,0,0,0.2);
        }}
        
        .hidden {{
            display: none;
        }}
        
        .image-field-group {{
            background: linear-gradient(145deg, #ffffff 0%, #f7fafc 100%);
            border: 2px solid #e2e8f0;
            border-radius: 12px;
            padding: 20px;
            margin: 15px 0;
            transition: all 0.3s ease;
        }}
        
        .image-field-group:hover {{
            border-color: #667eea;
            box-shadow: 0 6px 20px rgba(102, 126, 234, 0.1);
        }}
        
        .image-field-group h4 {{
            margin-top: 0;
            color: #667eea;
            border-bottom: 2px solid #e2e8f0;
            padding-bottom: 10px;
            font-size: 1em;
            font-weight: 600;
        }}
        
        .help-text {{
            background: linear-gradient(145deg, #f7fafc 0%, #edf2f7 100%);
            border: 1px solid #e2e8f0;
            border-radius: 10px;
            padding: 15px;
            margin-top: 10px;
            font-size: 0.85em;
            line-height: 1.5;
        }}
        
        .help-text code {{
            background: #2d3748;
            color: #68d391;
            padding: 3px 6px;
            border-radius: 4px;
            font-family: 'SF Mono', Monaco, 'Cascadia Code', 'Roboto Mono', Consolas, 'Courier New', monospace;
            font-size: 0.8em;
        }}
        
        .help-text ul {{
            margin: 10px 0;
            padding-left: 20px;
        }}
        
        .help-text li {{
            margin: 5px 0;
            color: #4a5568;
        }}
        
        .help-text p {{
            margin: 8px 0;
            color: #4a5568;
        }}
        
        .help-text strong {{
            color: #2d3748;
        }}
        
        /* Blog Preview Styles - Exact Match to Henry's Blog */
        .blog-preview {{
            background: #0083D6;
            border-radius: 15px;
            box-shadow: 0 8px 25px rgba(0,0,0,0.1);
            overflow: hidden;
            font-family: Arial, sans-serif;
            width: 621px;
            margin: 0 auto;
        }}
        
        .blog-preview .article {{
            padding: 0;
        }}
        
        .blog-preview .article-white {{
            background-color: white;
            padding: 15px;
            color: #0083D6;
            font-family: Arial;
            font-size: 11pt;
        }}
        
        .blog-preview .article-blue {{
            background-color: #e6f4fd;
            padding: 15px;
            color: #0083D6;
            font-family: Arial;
            font-size: 11pt;
        }}
        
        .blog-preview .article-title {{
            font-size: 13pt;
            font-weight: bold;
            color: #0083D6;
            font-family: Arial;
            margin-bottom: 0;
            display: inline-block;
            width: 421px;
        }}
        
        .blog-preview .article-date {{
            font-size: 13pt;
            font-weight: bold;
            color: #0083D6;
            font-family: Arial;
            text-align: right;
            display: inline-block;
            width: 200px;
            margin-bottom: 0;
        }}
        
        .blog-preview .article-content {{
            line-height: 1.4;
            color: #0083D6;
            font-family: Arial;
            font-size: 11pt;
            margin-top: 10px;
        }}
        
        .blog-preview .article-content img {{
            max-width: 100%;
            height: auto;
            border: 0;
            margin: 5px 0;
        }}
        
        .blog-preview .article-content .image-full {{
            width: 100%;
            display: block;
            margin: 10px 0;
        }}
        
        .blog-preview .article-content .image-left {{
            float: left;
            margin: 0 15px 10px 0;
            width: 200px;
        }}
        
        .blog-preview .article-content .image-right {{
            float: right;
            margin: 0 0 10px 15px;
            width: 200px;
        }}
        
        .blog-preview .article-content .image-left-half {{
            float: left;
            margin: 0 15px 10px 0;
            width: 310px;
        }}
        
        .blog-preview .article-content .image-right-half {{
            float: right;
            margin: 0 0 10px 15px;
            width: 310px;
        }}
        
        .blog-preview .article-content .image-center {{
            display: block;
            margin: 10px auto;
            width: 400px;
        }}
        
        .blog-preview .article-content .clearfix {{
            clear: both;
        }}
        
        .blog-preview .article-content .image-caption {{
            font-size: 10pt;
            color: #0083D6;
            text-align: center;
            margin-top: 5px;
            font-style: italic;
            font-family: Arial;
        }}
        
        .blog-preview .article-content a {{
            color: #5d4299;
            text-decoration: none;
        }}
        
        .blog-preview .article-content a:hover {{
            text-decoration: underline;
        }}
        
        .blog-preview .title-row {{
            height: 30px;
            display: flex;
            align-items: center;
        }}
        
        .blog-preview .article-blue {{
            position: relative;
        }}
        
        .blog-preview .article-blue::before {{
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 15px;
            background: url('data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7') no-repeat;
            background-size: 100% 15px;
        }}
        
        .blog-preview .article-blue::after {{
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            right: 0;
            height: 15px;
            background: url('data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7') no-repeat;
            background-size: 100% 15px;
        }}
        
        .preview-placeholder {{
            text-align: center;
            color: #0083D6;
            padding: 40px;
            font-style: italic;
            font-family: Arial;
            font-size: 11pt;
            background-color: white;
            margin: 15px;
        }}
        
        /* Responsive design */
        @media (max-width: 1200px) {{
            .container {{
                flex-direction: column;
                max-width: 900px;
            }}
            
            .generator-panel,
            .preview-panel {{
                flex: none;
                border-right: none;
                border-bottom: 1px solid #e2e8f0;
            }}
            
            .preview-panel {{
                border-bottom: none;
            }}
        }}
        
        @media (max-width: 768px) {{
            .container {{
                margin: 10px;
                border-radius: 16px;
            }}
            
            .generator-panel,
            .preview-panel {{
                padding: 20px;
            }}
            
            .header {{
                margin: -20px -20px 20px -20px;
                padding: 20px;
            }}
            
            .header h1 {{
                font-size: 1.8em;
            }}
        }}
        
        /* Loading animation */
        .loading {{
            display: inline-block;
            width: 16px;
            height: 16px;
            border: 2px solid rgba(255,255,255,.3);
            border-radius: 50%;
            border-top-color: #fff;
            animation: spin 1s ease-in-out infinite;
        }}
        
        @keyframes spin {{
            to {{ transform: rotate(360deg); }}
        }}
    </style>
</head>
<body>
    <div class="container">
        <div class="generator-panel">
            <div class="header">
                <h1>📰 News Generator</h1>
                <p>Create beautiful articles with live preview</p>
            </div>
            
            <form action="/generate" method="post" id="articleForm">
                <div class="form-section">
                    <h3>📝 Article Information</h3>
                    
                    <div class="form-group">
                        <label for="title">Article Title</label>
                        <input type="text" id="title" name="title" required placeholder="Enter your article title..." oninput="updatePreview()">
                    </div>
                    
                    <div class="form-group">
                        <label for="date">Publication Date</label>
                        <input type="text" id="date" name="date" required placeholder="January 9th, 2025" oninput="updatePreview()">
                    </div>
                    
                    <div class="form-group">
                        <label for="type">Article Type</label>
                        <select id="type" name="type" required onchange="updatePreview()">
                            <option value="white">White (Clean background)</option>
                            <option value="blue">Blue (Blue background with corners)</option>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label for="content">Content (line breaks will be automatically converted to HTML)</label>
                        <textarea id="content" name="content" required placeholder="Hey Everyone!

Just a quick note to remind you all about our Mega Halloween Party tomorrow...

Use placement tags to position content:
• #image1, #image2, etc. for images

Example: This is some text before the image. #image1 This text will appear after the image.

You can use GIFs for animated content by adding them as images." oninput="updatePreview()"></textarea>
                    </div>
                    
                    <!-- Hidden input for content elements -->
                    <input type="hidden" id="content_elements_data" name="content_elements_data" value="">
                    
                    <div class="form-group">
                        <label for="content_help">💡 Content Help</label>
                        <div class="help-text">
                            <p><strong>Image Placement Tags:</strong></p>
                            <ul>
                                <li><code>#image1</code> - Place first image here</li>
                                <li><code>#image2</code> - Place second image here</li>
                                <li><code>#image3</code> - Place third image here</li>
                                <li><code>#image4</code> - Place fourth image here</li>
                            </ul>
                            <p><strong>Example:</strong></p>
                            <p><code>Welcome to our blog!

#image1

This text will appear after the first image. You can place images anywhere in your content using the #image tags.

Just use normal line breaks - they'll be converted automatically!</code></p>
                        </div>
                    </div>
                </div>
                
                <div class="form-section">
                    <h3>🖼️ Content Elements</h3>
                    
                    <div class="form-group">
                        <button type="button" class="btn-add" onclick="addImage()">
                            ➕ Add Image
                        </button>
                    </div>
                    
                    <div id="content_elements">
                        <!-- Content elements will be added here -->
                    </div>
                </div>
                
                <button type="submit" class="btn">
                    <span id="btnText">Generate Article</span>
                    <span id="btnLoading" class="loading hidden"></span>
                </button>
            </form>
        </div>
        
        <div class="preview-panel">
            <div class="preview-header">
                <h2>👁️ Live Preview</h2>
            </div>
            
            <div id="preview-content" class="blog-preview">
                <div class="preview-placeholder">
                    Start typing to see your article preview here...
                </div>
            </div>
        </div>
    </div>
    
    <!-- Image Edit Modal -->
    <div id="imageModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h2 class="modal-title">🖼️ Edit Image</h2>
                <span class="close" onclick="closeModal('imageModal')">&times;</span>
            </div>
            
            <div class="form-group">
                <label for="modal_image_src">Image URL</label>
                <input type="text" id="modal_image_src" placeholder="https://example.com/image.jpg or ./images/blog/image.jpg">
            </div>
            
            <div class="form-group">
                <label for="modal_image_placement">Image Placement</label>
                <select id="modal_image_placement">
                    <option value="full-width">Full Width (585px) - Above text</option>
                    <option value="left-half">Left Half (310px) - Text on right</option>
                    <option value="right-half">Right Half (310px) - Text on left</option>
                    <option value="center">Center (400px) - Text above/below</option>
                    <option value="small-left">Small Left (200px) - Text wraps around</option>
                    <option value="small-right">Small Right (200px) - Text wraps around</option>
                </select>
            </div>
            
            <div class="form-group">
                <label for="modal_image_alt">Image Alt Text</label>
                <input type="text" id="modal_image_alt" placeholder="Pandanda online game for kids">
            </div>
            
            <div class="form-group">
                <label for="modal_image_link">Image Link URL (optional)</label>
                <input type="text" id="modal_image_link" placeholder="https://example.com">
            </div>
            
            <div class="form-group">
                <label for="modal_image_caption">Image Caption (optional)</label>
                <input type="text" id="modal_image_caption" placeholder="Caption text that appears below the image">
            </div>
            
            <div class="modal-footer">
                <button type="button" class="btn-modal btn-modal-secondary" onclick="closeModal('imageModal')">Cancel</button>
                <button type="button" class="btn-modal btn-modal-primary" onclick="saveImage()">Save Image</button>
            </div>
        </div>
    </div>
    
    
    <script>
        let contentElements = [];
        let editingElementId = null;
        
        function addImage() {{
            const elementId = 'img_' + Date.now();
            const element = {{
                id: elementId,
                type: 'image',
                src: '',
                placement: 'full-width',
                alt: '',
                link: '',
                caption: ''
            }};
            
            contentElements.push(element);
            renderContentElements();
            openImageModal(elementId);
        }}
        
        
        function renderContentElements() {{
            const container = document.getElementById('content_elements');
            container.innerHTML = '';
            
            contentElements.forEach((element, index) => {{
                const elementDiv = document.createElement('div');
                elementDiv.className = 'content-element';
                
                if (element.type === 'image') {{
                    elementDiv.innerHTML = `
                        <div class="content-element-info">
                            <div class="content-element-title">🖼️ Image ${{index + 1}}</div>
                            <div class="content-element-details">
                                ${{element.src || 'No image URL set'}} | ${{element.placement}} | ${{element.alt || 'No alt text'}}
                            </div>
                        </div>
                        <div class="content-element-actions">
                            <button class="btn-edit" onclick="openImageModal('${{element.id}}')">✏️ Edit</button>
                            <button class="btn-remove" onclick="removeElement('${{element.id}}')">🗑️ Remove</button>
                        </div>
                    `;
                
                container.appendChild(elementDiv);
            }});
            
            updatePreview();
        }}
        
        function removeElement(elementId) {{
            contentElements = contentElements.filter(el => el.id !== elementId);
            renderContentElements();
        }}
        
        function openImageModal(elementId) {{
            editingElementId = elementId;
            const element = contentElements.find(el => el.id === elementId);
            
            if (element) {{
                document.getElementById('modal_image_src').value = element.src || '';
                document.getElementById('modal_image_placement').value = element.placement || 'full-width';
                document.getElementById('modal_image_alt').value = element.alt || '';
                document.getElementById('modal_image_link').value = element.link || '';
                document.getElementById('modal_image_caption').value = element.caption || '';
            }}
            
            document.getElementById('imageModal').style.display = 'block';
        }}
        
        
        function closeModal(modalId) {{
            document.getElementById(modalId).style.display = 'none';
            editingElementId = null;
        }}
        
        function saveImage() {{
            if (!editingElementId) return;
            
            const element = contentElements.find(el => el.id === editingElementId);
            if (element) {{
                element.src = document.getElementById('modal_image_src').value;
                element.placement = document.getElementById('modal_image_placement').value;
                element.alt = document.getElementById('modal_image_alt').value;
                element.link = document.getElementById('modal_image_link').value;
                element.caption = document.getElementById('modal_image_caption').value;
            }}
            
            closeModal('imageModal');
            renderContentElements();
        }}
        
        
        // Close modal when clicking outside
        window.onclick = function(event) {{
            const imageModal = document.getElementById('imageModal');
            
            if (event.target === imageModal) {{
                closeModal('imageModal');
            }}
        }}
        
        function updatePreview() {{
            const title = document.getElementById('title').value;
            const date = document.getElementById('date').value;
            const type = document.getElementById('type').value;
            const content = document.getElementById('content').value;
            
            if (!title && !date && !content && contentElements.length === 0) {{
                document.getElementById('preview-content').innerHTML = `
                    <div class="preview-placeholder">
                        Start typing to see your article preview here...
                    </div>
                `;
                return;
            }}
            
            let previewHtml = `
                <div class="article article-${{type}}">
                    <div class="title-row">
                        <div class="article-title">${{title || 'Your Article Title'}}</div>
                        <div class="article-date">${{date || 'Publication Date'}}</div>
                    </div>
                    <div class="article-content">
            `;
            
            // Process content with placement tags
            let processedContent = content;
            
            // Replace placement tags with actual content
            contentElements.forEach((element, index) => {{
                const tag = `#image${{index + 1}}`;
                
                if (element.type === 'image' && element.src) {{
                    let imageHtml = `<img src="${{element.src}}" alt="${{element.alt || 'Image'}}"`;
                    
                    // Add placement class
                    switch(element.placement) {{
                        case 'full-width':
                            imageHtml += ' class="image-full"';
                            break;
                        case 'left-half':
                            imageHtml += ' class="image-left-half"';
                            break;
                        case 'right-half':
                            imageHtml += ' class="image-right-half"';
                            break;
                        case 'center':
                            imageHtml += ' class="image-center"';
                            break;
                        case 'small-left':
                            imageHtml += ' class="image-left"';
                            break;
                        case 'small-right':
                            imageHtml += ' class="image-right"';
                            break;
                    }}
                    
                    imageHtml += '>';
                    
                    if (element.caption) {{
                        imageHtml += `<div class="image-caption">${{element.caption}}</div>`;
                    }}
                    
                    if (element.link) {{
                        imageHtml = `<a href="${{element.link}}">${{imageHtml}}</a>`;
                    }}
                    
                    // Replace the tag in content
                    processedContent = processedContent.replace(new RegExp(tag, 'g'), imageHtml);
                }}
            }});
            
            // Convert line breaks to HTML
            processedContent = processedContent.replace(/\\r\\n/g, '\\n').replace(/\\n/g, '<br/>');
            
            previewHtml += processedContent;
            previewHtml += `
                    </div>
                </div>
            `;
            
            document.getElementById('preview-content').innerHTML = previewHtml;
        }}
        
        // Form submission with loading state
        document.getElementById('articleForm').addEventListener('submit', function(e) {{
            const btnText = document.getElementById('btnText');
            const btnLoading = document.getElementById('btnLoading');
            
            // Set content elements data
            document.getElementById('content_elements_data').value = JSON.stringify(contentElements);
            
            // Show loading state
            btnText.classList.add('hidden');
            btnLoading.classList.remove('hidden');
            
            // Disable form to prevent double submission
            this.querySelector('button[type="submit"]').disabled = true;
        }});
        
        // Clear form fields on page load
        function clearForm() {{
            document.getElementById('title').value = '';
            document.getElementById('date').value = '';
            document.getElementById('type').value = 'white';
            document.getElementById('content').value = '';
            
            // Clear content elements
            contentElements = [];
            renderContentElements();
            
            // Reset button state
            const btnText = document.getElementById('btnText');
            const btnLoading = document.getElementById('btnLoading');
            const submitBtn = document.querySelector('button[type="submit"]');
            
            btnText.classList.remove('hidden');
            btnLoading.classList.add('hidden');
            submitBtn.disabled = false;
            
            // Reset preview
            updatePreview();
        }}
        
        // Clear form when page loads
        window.addEventListener('load', clearForm);
        
        // Clear form when page is refreshed or navigated to
        window.addEventListener('pageshow', function(event) {{
            if (event.persisted) {{
                // Page was loaded from cache (back/forward button)
                clearForm();
            }}
        }});
        
        // Initial preview update
        updatePreview();
    </script>
</body>
</html>
        """
        
        self.send_response(200)
        self.send_header('Content-type', 'text/html; charset=utf-8')
        self.end_headers()
        self.wfile.write(html_content.encode('utf-8'))
    
    def serve_preview_page(self):
        """Serve the preview page"""
        
        # Load the latest generated data
        json_path = Path("blog/news_articles.json")
        
        if json_path.exists():
            with open(json_path, 'r', encoding='utf-8') as f:
                data = json.load(f)
            
            articles_html = ""
            for article in data.get('articles', []):
                image_count = len(article.get('images', []))
                articles_html += f"""
                <div class="article-item">
                    <div class="article-title">{article['title']}</div>
                    <div class="article-meta">
                        Date: {article['date']} | Type: {article['type']} | Images: {image_count}
                    </div>
                </div>
                """
            
            html_content = f"""
            <!DOCTYPE html>
            <html lang="en">
            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>📰 Article Preview</title>
                <style>
                    body {{ font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; margin: 20px; background: #f8f9fa; }}
                    .container {{ max-width: 1200px; margin: 0 auto; background: white; padding: 30px; border-radius: 10px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); }}
                    h1 {{ color: #007acc; border-bottom: 3px solid #007acc; padding-bottom: 15px; text-align: center; }}
                    .btn {{ padding: 10px 20px; margin: 10px 5px; text-decoration: none; border-radius: 5px; border: none; cursor: pointer; font-size: 14px; }}
                    .btn-primary {{ background: #007acc; color: white; }}
                    .btn-success {{ background: #28a745; color: white; }}
                    .article-item {{ background: #e9ecef; padding: 15px; margin: 10px 0; border-radius: 5px; border-left: 4px solid #007acc; }}
                    .article-title {{ font-weight: bold; color: #007acc; margin-bottom: 5px; }}
                    .article-meta {{ color: #6c757d; font-size: 0.9em; }}
                    .actions {{ text-align: center; margin: 20px 0; }}
                    pre {{ white-space: pre-wrap; word-wrap: break-word; }}
                </style>
            </head>
            <body>
                <div class="container">
                    <h1>📰 Generated Articles Preview</h1>
                    
                    <div class="actions">
                        <a href="/generator" class="btn btn-primary">Create New Article</a>
                        <a href="http://localhost:8002/" class="btn btn-success" target="_blank">View Live Site</a>
                    </div>
                    
                    <h2>Articles ({len(data.get('articles', []))} total):</h2>
                    {articles_html}
                    
                    <h2>Raw JSON Data:</h2>
                    <pre>{json.dumps(data, indent=2, ensure_ascii=False)}</pre>
                </div>
            </body>
            </html>
            """
        else:
            html_content = """
            <!DOCTYPE html>
            <html lang="en">
            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>📰 No Articles Found</title>
            </head>
            <body>
                <div style="text-align: center; padding: 50px; font-family: Arial, sans-serif;">
                    <h1>No articles found</h1>
                    <p>Create your first article using the generator.</p>
                    <a href="/generator" style="background: #007acc; color: white; padding: 10px 20px; text-decoration: none; border-radius: 5px;">Create Article</a>
                </div>
            </body>
            </html>
            """
        
        self.send_response(200)
        self.send_header('Content-type', 'text/html; charset=utf-8')
        self.end_headers()
        self.wfile.write(html_content.encode('utf-8'))
    
    def generate_article(self):
        """Generate article from form data"""
        
        try:
            # Parse form data
            content_length = int(self.headers['Content-Length'])
            post_data = self.rfile.read(content_length)
            form_data = urllib.parse.parse_qs(post_data.decode('utf-8'))
            
            # Extract form data
            title = form_data.get('title', [''])[0]
            date = form_data.get('date', [''])[0]
            article_type = form_data.get('type', ['white'])[0]
            content = form_data.get('content', [''])[0]
            content_elements_data = form_data.get('content_elements_data', ['[]'])[0]
            
            if not title or not date or not content:
                self.send_error(400, "Missing required fields")
                return
            
            # Convert line breaks to HTML
            content_html = self.convert_line_breaks_to_html(content)
            
            # Parse content elements
            try:
                content_elements = json.loads(content_elements_data)
            except:
                content_elements = []
            
            # Process image content
            images = []
            
            for element in content_elements:
                if element.get('type') == 'image' and element.get('src'):
                    images.append({
                        "src": element.get('src', ''),
                        "placement": element.get('placement', 'full-width'),
                        "alt": element.get('alt', ''),
                        "link": element.get('link', ''),
                        "caption": element.get('caption', '')
                    })
            
            # Create article object
            article = {
                "id": title.lower().replace(" ", "_").replace("!", "").replace("?", "").replace(",", ""),
                "title": title,
                "date": date,
                "type": article_type,
                "content": content_html
            }
            
            if images:
                article.update({
                    "has_image": True,
                    "images": images
                })
            
            
            # Load existing data or create new
            json_path = Path("blog/news_articles.json")
            json_path.parent.mkdir(exist_ok=True)
            
            if json_path.exists():
                with open(json_path, 'r', encoding='utf-8') as f:
                    data = json.load(f)
            else:
                data = {
                    "articles": [],
                    "metadata": {
                        "last_updated": datetime.now().strftime("%Y-%m-%d"),
                        "total_articles": 0,
                        "description": "Henry's Blog news articles for Pandanda",
                        "source": "news_generator_with_preview.py"
                    }
                }
            
            # Add new article at the beginning (most recent first)
            data['articles'].insert(0, article)
            data['metadata']['total_articles'] = len(data['articles'])
            data['metadata']['last_updated'] = datetime.now().strftime("%Y-%m-%d")
            
            # Save to JSON file
            with open(json_path, 'w', encoding='utf-8') as f:
                json.dump(data, f, indent=2, ensure_ascii=False)
            
            # Redirect to preview page
            self.send_response(302)
            self.send_header('Location', '/preview')
            self.end_headers()
                
        except Exception as e:
            self.send_error(500, f"Error generating article: {str(e)}")
    
    def convert_line_breaks_to_html(self, content):
        """Convert line breaks to HTML br tags"""
        import re
        
        # Convert \r\n to \n first (Windows line endings)
        content = content.replace('\r\n', '\n')
        
        # Convert single \n to <br/>
        content = content.replace('\n', '<br/>')
        
        # Clean up multiple consecutive <br/> tags
        # Replace 3 or more consecutive <br/> with 2 <br/> (for paragraph spacing)
        content = re.sub(r'(<br/>){3,}', '<br/><br/>', content)
        
        return content

def main():
    """Start the news generator with live preview"""
    
    PORT = 8004
    
    print("🚀 Starting News Generator with Live Preview...")
    print("=" * 60)
    print(f"🌐 Generator running on: http://localhost:{PORT}")
    print("\n📋 Available pages:")
    print(f"  • http://localhost:{PORT}/generator  - Generator with live preview")
    print(f"  • http://localhost:{PORT}/preview    - JSON preview")
    print("\n🎯 Features:")
    print("  ✅ Live preview as you type")
    print("  ✅ Beautiful, modern UI design")
    print("  ✅ Automatic line break conversion")
    print("  ✅ Image placement with tags")
    print("  ✅ Responsive design")
    print("  ✅ Real-time preview updates")
    print("\n🛑 Press Ctrl+C to stop the generator")
    print("=" * 60)
    
    try:
        with socketserver.TCPServer(("", PORT), NewsGeneratorWithPreviewHandler) as httpd:
            httpd.serve_forever()
    except KeyboardInterrupt:
        print("\n\n🛑 Generator stopped by user")
    except Exception as e:
        print(f"❌ Generator error: {e}")

if __name__ == "__main__":
    main()
