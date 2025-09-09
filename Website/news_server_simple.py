#!/usr/bin/env python3
"""
Simple News Server for Henry's Blog
Serves dynamic news content without admin routes
"""

import json
import os
import http.server
import socketserver
import urllib.parse
from pathlib import Path
from datetime import datetime

class SimpleNewsHandler(http.server.SimpleHTTPRequestHandler):
    """Simple handler for serving dynamic news content only"""
    
    def do_GET(self):
        """Handle GET requests"""
        
        # Parse the URL
        parsed_path = urllib.parse.urlparse(self.path)
        path = parsed_path.path
        
        # Handle different endpoints
        if path == '/blog' or path == '/blog/':
            self.serve_dynamic_news()
        elif path == '/api/news':
            self.serve_news_api()
        elif path == '/api/news.json':
            self.serve_news_json()
        else:
            # Serve static files from blog directory
            self.serve_static_file()
    
    def serve_dynamic_news(self):
        """Serve the dynamic news page"""
        try:
            # Load news data
            news_data = self.load_news_data()
            if not news_data:
                self.send_error(500, "Could not load news data")
                return
            
            # Generate news HTML
            articles = news_data.get('articles', [])
            news_html = self.generate_news_section(articles)
            
            # Read the template
            template_path = Path("blog/news_dynamic.htm")
            if not template_path.exists():
                self.send_error(404, "Template file not found")
                return
            
            with open(template_path, 'r', encoding='utf-8', errors='ignore') as f:
                content = f.read()
            
            # Replace the news section
            start_marker = '<!-- right column-->'
            end_marker = '<!-- old blog links -->'
            
            start_pos = content.find(start_marker)
            end_pos = content.find(end_marker)
            
            if start_pos == -1 or end_pos == -1:
                self.send_error(500, "Could not find news section markers")
                return
            
            # Extract header and add Ruffle support if not already present
            header = content[:start_pos + len(start_marker)]
            
            # Add Ruffle support to header if not already present
            if 'ruffle' not in header.lower():
                # Find the head section and add Ruffle script
                head_pos = header.find('<head>')
                if head_pos != -1:
                    head_end = header.find('</head>')
                    if head_end != -1:
                        ruffle_script = """
    <script src="https://unpkg.com/@ruffle-rs/ruffle"></script>
    <script>
        window.RufflePlayer = window.RufflePlayer || {};
        window.RufflePlayer.config = {
            "autoplay": "on",
            "unmuteOverlay": "hidden",
            "preferredRenderer": "webgl"
        };
    </script>"""
                        # Insert Ruffle script before closing head tag
                        header = header.replace('</head>', ruffle_script + '\n</head>')
            
            # Find the end of the main content (before the ticker and footer)
            main_end_marker = '</div><!-- end main -->'
            main_end_pos = content.find(main_end_marker)
            
            if main_end_pos == -1:
                self.send_error(500, "Could not find main content end marker")
                return
            
            # Extract the ticker and footer section
            ticker_start = content.find('<div id="ticker">')
            if ticker_start == -1:
                self.send_error(500, "Could not find ticker section")
                return
            
            # Get everything from ticker onwards (including footer and scripts)
            ticker_and_footer = content[ticker_start:]
            
            # Create dynamic content
            dynamic_content = header + "\n\t\t\t\t\t\t<!-- right column-->\n\t\t\t\t\t\t<table border=0; cellspacing=0; cellpadding=0;>\n\n" + news_html + "\n\n\t\t\t\t\t\t</table>\n\t\t\t\t\t</td>\n\t\t\t\t</tr>\n\t\t\t</table>\n\t\t</td>\n\t</tr> <!-- end FAQ entry-->\n\t\t<tr>\n\t\t\t<td width=\"878\" height=\"40\" valign=\"top\"></td>\n\t\t</tr>\n\n\t</table>\n</div><!-- end main -->" + ticker_and_footer
            
            # Send response
            self.send_response(200)
            self.send_header('Content-type', 'text/html; charset=utf-8')
            self.end_headers()
            self.wfile.write(dynamic_content.encode('utf-8'))
            
        except Exception as e:
            self.send_error(500, f"Error generating dynamic news: {str(e)}")
    
    def serve_news_api(self):
        """Serve news data as JSON API"""
        try:
            news_data = self.load_news_data()
            if not news_data:
                self.send_error(500, "Could not load news data")
                return
            
            # Send JSON response
            self.send_response(200)
            self.send_header('Content-type', 'application/json; charset=utf-8')
            self.send_header('Access-Control-Allow-Origin', '*')
            self.end_headers()
            
            json_data = json.dumps(news_data, indent=2, ensure_ascii=False)
            self.wfile.write(json_data.encode('utf-8'))
            
        except Exception as e:
            self.send_error(500, f"Error serving news API: {str(e)}")
    
    def serve_news_json(self):
        """Serve raw news JSON file"""
        try:
            json_path = Path("blog/news_articles.json")
            if not json_path.exists():
                self.send_error(404, "News JSON file not found")
                return
            
            with open(json_path, 'r', encoding='utf-8') as f:
                json_content = f.read()
            
            self.send_response(200)
            self.send_header('Content-type', 'application/json; charset=utf-8')
            self.send_header('Access-Control-Allow-Origin', '*')
            self.end_headers()
            self.wfile.write(json_content.encode('utf-8'))
            
        except Exception as e:
            self.send_error(500, f"Error serving news JSON: {str(e)}")
    
    def serve_static_file(self):
        """Serve static files from blog directory"""
        try:
            # Remove leading slash and construct path
            file_path = self.path.lstrip('/')
            if not file_path:
                file_path = 'news.htm'
            
            # Construct full path in blog directory
            full_path = Path("blog") / file_path
            
            if not full_path.exists():
                self.send_error(404, "File not found")
                return
            
            # Determine content type
            if file_path.endswith('.css'):
                content_type = 'text/css'
            elif file_path.endswith('.js'):
                content_type = 'application/javascript'
            elif file_path.endswith('.gif'):
                content_type = 'image/gif'
            elif file_path.endswith('.jpg') or file_path.endswith('.jpeg'):
                content_type = 'image/jpeg'
            elif file_path.endswith('.png'):
                content_type = 'image/png'
            elif file_path.endswith('.swf'):
                content_type = 'application/x-shockwave-flash'
            elif file_path.endswith('.htm') or file_path.endswith('.html'):
                content_type = 'text/html'
            else:
                content_type = 'application/octet-stream'
            
            # Read and serve the file
            with open(full_path, 'rb') as f:
                content = f.read()
            
            self.send_response(200)
            self.send_header('Content-type', content_type)
            self.send_header('Content-length', str(len(content)))
            self.end_headers()
            self.wfile.write(content)
            
        except Exception as e:
            self.send_error(500, f"Error serving file: {str(e)}")
    
    def load_news_data(self, json_file="blog/news_articles.json"):
        """Load news articles from JSON file"""
        try:
            with open(json_file, 'r', encoding='utf-8') as f:
                data = json.load(f)
            return data
        except FileNotFoundError:
            print(f"Error: {json_file} not found!")
            return None
        except json.JSONDecodeError as e:
            print(f"Error parsing JSON: {e}")
            return None
    
    def generate_article_html(self, article):
        """Generate HTML for a single article"""
        
        # Determine article type and corresponding CSS classes
        if article.get('type') == 'blue':
            top_corners = 'images/hb_blue_top_corners.gif'
            bottom_corners = 'images/hb_blue_btm_corners.gif'
            table_class = 'TableBlogEntryBlue'
        else:  # white
            # White articles don't use corner images - they have clean edges
            top_corners = ''
            bottom_corners = ''
            table_class = 'TableBlogEntryWhite'
        
        # Generate HTML based on article type
        if article.get('type') == 'blue':
            html = f"""
    <!-- blog entry start-->
    <tr>
        <td width="621" height="15" valign="top"><img src="{top_corners}" width="621" height="15" alt="pandanda henry's blog"></td>
    </tr>
    <tr>
        <td width="621" valign="top">
            <table border=0; cellspacing=0; cellpadding=0; class="{table_class}">
                <tr>
                    <td width="621" height="30" valign="top">
                        <table border=0; cellspacing=0; cellpadding=0;>
                            <tr>
                                <td width="421" height="30" valign="top">
                                    <font class="TextTitleBlue">{article['title']}</font>
                                </td>
                                <td width="200" height="30" valign="top" align="right">
                                    <font class="TextTitleBlue">{article['date']}</font>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td width="621" height="70" valign="top">"""
        else:  # white article
            html = f"""
    <!-- blog entry start-->
    <tr>
        <td width="621" valign="top">
            <table border=0; cellspacing=0; cellpadding=0; class="{table_class}">
                <tr>
                    <td width="621" height="30" valign="top">
                        <table border=0; cellspacing=0; cellpadding=0;>
                            <tr>
                                <td width="421" height="30" valign="top">
                                    <font class="TextTitleBlue">{article['title']}</font>
                                </td>
                                <td width="200" height="30" valign="top" align="right">
                                    <font class="TextTitleBlue">{article['date']}</font>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td width="621" height="70" valign="top">"""
        
        # Add images if present
        if article.get('has_image') and article.get('images'):
            images_html = self.generate_images_html(article['images'], article['content'], article.get('auto_size', 'auto'))
            html += images_html
        else:
            # Regular content without images
            html += f"""
                        {article['content']}"""
        
        # Add closing HTML based on article type
        if article.get('type') == 'blue':
            html += f"""
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td width="621" height="40" valign="top"><img src="{bottom_corners}" width="621" height="15" alt="pandanda henry's blog"></td>
    </tr>
    <!-- blog entry end -->"""
        else:  # white article
            html += f"""
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <!-- blog entry end -->"""
        
        return html
    
    def generate_images_html(self, images, content, auto_size='auto'):
        """Generate HTML for multiple images with different placements and content using image tags"""
        
        def get_image_dimensions(placement, auto_size):
            """Get width and height based on placement and auto-sizing"""
            if auto_size == 'custom':
                return None, None  # Will use custom dimensions if provided
            
            # Auto-sizing dimensions based on placement
            dimensions = {
                'full-width': (585, 'auto'),
                'left-half': (310, 'auto'),
                'right-half': (310, 'auto'),
                'center': (400, 'auto'),
                'small-left': (200, 'auto'),
                'small-right': (200, 'auto')
            }
            return dimensions.get(placement, (310, 'auto'))
        
        def generate_single_image_html(image, placement, auto_size):
            """Generate HTML for a single image"""
            width, height = get_image_dimensions(placement, auto_size)
            
            # Create image tag
            img_tag = f'<img src="{image["src"]}" alt="{image.get("alt", "Pandanda")}" border=0'
            if width:
                img_tag += f' width="{width}"'
            if height and height != 'auto':
                img_tag += f' height="{height}"'
            img_tag += '>'
            
            # Wrap in link if provided
            if image.get('link'):
                img_tag = f'<a href="{image["link"]}">{img_tag}</a>'
            
            # Add caption if provided
            caption_html = ''
            if image.get('caption'):
                caption_html = f'<br/><br/><font class="TextCaption">{image["caption"]}</font>'
            
            return img_tag + caption_html
        
        def process_content_with_image_tags(content, images):
            """Process content and replace image tags with actual image HTML"""
            import re
            
            # Check if content contains image tags
            if not re.search(r'#image\d+', content):
                # No image tags found, return content as-is
                return content
            
            # Split content into parts based on image tags
            parts = re.split(r'(#image\d+)', content)
            processed_parts = []
            pending_table_close = None
            
            for i, part in enumerate(parts):
                if re.match(r'#image\d+', part):
                    # This is an image tag
                    image_num = int(part.replace('#image', '')) - 1  # Convert to 0-based index
                    
                    if 0 <= image_num < len(images):
                        image = images[image_num]
                        placement = image.get('placement', 'full-width')
                        image_html = generate_single_image_html(image, placement, auto_size)
                        
                        # Close any pending table from previous image
                        if pending_table_close:
                            processed_parts.append(pending_table_close)
                            pending_table_close = None
                        
                        # Create the replacement HTML based on placement
                        if placement == 'full-width':
                            replacement_html = f"""
                        <table border=0; cellspacing=0; cellpadding=0;>
                            <tr>
                                <td width="621" align="center" valign="center">
                                    <br/><br/>{image_html}<br/><br/>
                                </td>
                            </tr>
                        </table>"""
                            processed_parts.append(replacement_html)
                            
                        elif placement == 'center':
                            replacement_html = f"""
                        <table border=0; cellspacing=0; cellpadding=0;>
                            <tr>
                                <td width="621" align="center" valign="center">
                                    <br/><br/>{image_html}<br/><br/>
                                </td>
                            </tr>
                        </table>"""
                            processed_parts.append(replacement_html)
                            
                        elif placement == 'left-half':
                            # Left half image with text flowing on the right using CSS float
                            replacement_html = f"""
                        <div style="float: left; margin: 0 15px 15px 0; width: 310px;">
                            {image_html}
                        </div>"""
                            processed_parts.append(replacement_html)
                            # No pending table close needed for CSS float
                            
                        elif placement == 'right-half':
                            # Right half image with text flowing on the left using CSS float
                            replacement_html = f"""
                        <div style="float: right; margin: 0 0 15px 15px; width: 310px;">
                            {image_html}
                        </div>"""
                            processed_parts.append(replacement_html)
                            # No pending table close needed for CSS float
                            
                        elif placement == 'small-left':
                            # Small left image with text wrapping around it using CSS float
                            replacement_html = f"""
                        <div style="float: left; margin: 0 15px 15px 0;">
                            {image_html}
                        </div>"""
                            processed_parts.append(replacement_html)
                            # No pending table close needed for CSS float
                            
                        elif placement == 'small-right':
                            # Small right image with text wrapping around it using CSS float
                            replacement_html = f"""
                        <div style="float: right; margin: 0 0 15px 15px;">
                            {image_html}
                        </div>"""
                            processed_parts.append(replacement_html)
                            # No pending table close needed for CSS float
                            
                        else:
                            # Default to full-width
                            replacement_html = f"""
                        <table border=0; cellspacing=0; cellpadding=0;>
                            <tr>
                                <td width="621" align="center" valign="center">
                                    <br/><br/>{image_html}<br/><br/>
                                </td>
                            </tr>
                        </table>"""
                            processed_parts.append(replacement_html)
                    else:
                        # Invalid image number, keep the tag as-is
                        processed_parts.append(part)
                else:
                    # This is text content
                    if part.strip():  # Only add non-empty parts
                        processed_parts.append(part)
            
            # Close any pending table
            if pending_table_close:
                processed_parts.append(pending_table_close)
            
            # Add clearfix div if we have any floating elements
            if any('float: left' in part or 'float: right' in part for part in processed_parts):
                processed_parts.append('<div style="clear: both;"></div>')
            
            # Join all parts together
            return ''.join(processed_parts)
        
        # Process content with image tags
        processed_content = process_content_with_image_tags(content, images)
        
        # Return the processed content
        return processed_content
    
    def generate_news_section(self, articles):
        """Generate the complete news section HTML"""
        news_html = ""
        
        for i, article in enumerate(articles):
            # Add the article HTML
            news_html += self.generate_article_html(article)
            
            # Add spacing between articles (except after the last one)
            if i < len(articles) - 1:
                news_html += """
    <!-- Article spacing -->
    <tr>
        <td width="621" height="40" valign="top"></td>
    </tr>
    <tr>
        <td width="621" height="20" valign="top"></td>
    </tr>"""
        
        return news_html

def main():
    """Start the simple news server"""
    
    PORT = 8002
    
    print("🚀 Starting Simple News Server for Henry's Blog...")
    print("=" * 60)
    print(f"🌐 Server running on: http://localhost:{PORT}")
    print("\n📋 Available endpoints:")
    print(f"  • http://localhost:{PORT}/          - Dynamic news page")
    print(f"  • http://localhost:{PORT}/news      - Dynamic news page")
    print(f"  • http://localhost:{PORT}/api/news  - News data as JSON API")
    print(f"  • http://localhost:{PORT}/api/news.json - Raw JSON file")
    print("\n🎯 Features:")
    print("  ✅ Dynamic news generation from JSON")
    print("  ✅ JSON API for external integration")
    print("  ✅ Automatic static file serving")
    print("  ✅ No bottom section (ticker/footer removed)")
    print("  ✅ Clean white and blue article styling")
    print("\n📝 To create articles:")
    print("  • Use the news generator: python news_generator_local.py")
    print("  • Or edit blog/news_articles.json directly")
    print("\n🛑 Press Ctrl+C to stop the server")
    print("=" * 60)
    
    try:
        with socketserver.TCPServer(("", PORT), SimpleNewsHandler) as httpd:
            httpd.serve_forever()
    except KeyboardInterrupt:
        print("\n\n🛑 Server stopped by user")
    except Exception as e:
        print(f"❌ Server error: {e}")

if __name__ == "__main__":
    main()
