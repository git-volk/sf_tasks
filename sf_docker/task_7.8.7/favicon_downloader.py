import requests
import os

# URL сайта, с которого нужно скачать favicon
site_url = os.getenv('SITE_URL', 'http://example.com')

# Формируем URL для favicon
favicon_url = f"{site_url.rstrip('/')}/favicon.ico"

# Скачиваем favicon
response = requests.get(favicon_url, stream=True)

output_path = '/output/favicon.ico'

if response.status_code == 200:
    with open(output_path, 'wb') as f:
        for chunk in response.iter_content(1024):
            f.write(chunk)
    print(f"Favicon downloaded from {favicon_url} and saved to {output_path}")
else:
    print(f"Failed to download favicon from {favicon_url}. Status code: {response.status_code}")
