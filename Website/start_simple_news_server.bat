@echo off
echo ========================================
echo   Henry's Blog Simple News Server
echo ========================================
echo.
echo Starting simple news server...
echo.
echo The server will be available at:
echo   - http://localhost:8002/ (News page)
echo   - http://localhost:8002/api/news (JSON API)
echo.
echo No admin routes - just serves news content!
echo.
echo Press Ctrl+C to stop the server
echo.
python news_server_simple.py
