#!/usr/bin/env python3

import os
import json
import urllib
import sys
from urllib.request import urlretrieve, Request
from urllib.parse import urlparse, urldefrag, ParseResult

URL = "https://boards.4chan.org/g/thread/103393964#p103398502"
UA = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/35.0.1916.47 Safari/537.36'

def setup():
    opener = urllib.request.build_opener()
    opener.addheaders = [("User-Agent", UA)]
    urllib.request.install_opener(opener)

class Thread:
    def __init__(self, rawurl: str):
        self.rawurl = rawurl
        self.parsed = urlparse(rawurl)
        if self.parsed.netloc != "boards.4chan.org": raise Exception("invalid hostname")
        if not self.parsed.path.startswith("/g/thread/"): raise Exception("invalid path")
        self.jsonfile = os.path.basename(self.parsed.path) + ".json"

    def download(self):
        if os.path.exists(self.jsonfile): return
        url, _ = urldefrag(self.rawurl)
        urlretrieve(url + ".json", self.jsonfile)

    def load(self):
        with open(self.jsonfile) as f:
            self.posts = json.load(f)['posts']
            if self.posts[0]['archived'] != 1: raise Exception("refusign to load non archived thread")
            self.start = 0
            if self.parsed.fragment != '':
                for i in range(len(self.posts)):
                    post = self.posts[i]
                    if f"p{post['no']}" == self.parsed.fragment:
                        self.start = i
                        break
            self.end = len(self.posts)
            fuck_offset = 20 # minimum number of posts before a FUCK
            for i in range(self.start, len(self.posts)):
                post = self.posts[i]
                if 'com' in post and post['com'] == "FUCK" and i > self.start + fuck_offset:
                    self.end = i
                    break

    def get_bigboy(self):
        return [post['com']
                for post in self.posts
                if 'com' in post and 'bigboy #' in post['com']]

    def get_media_links(self):
        root = 'https://i.4cdn.org/g'
        return [f"{root}/{post['tim']}{post['ext']}"
                for post in self.posts[self.start:self.end]
                if 'ext' in post]

def main():
    if len(sys.argv) != 2:
        raise Exception("missing url")

    setup()
    thread = Thread(sys.argv[1])
    thread.download()
    thread.load()
    for link in thread.get_media_links():
        print(link)

if __name__ == '__main__':
    main()
