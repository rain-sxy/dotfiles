config.load_autoconfig()
c.url.searchengines = {
    'DEFAULT': 'https://lite.duckduckgo.com/lite?q={}',
    '!yt': 'https://www.youtube.com?q={}',
    '!git': 'https://github.com?q={}',
    '!mail': 'https://mail.google.com?q={}',
}
