#!/usr/bin/env python3

import datetime
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
            for i in range(self.start, len(self.posts)):
                post = self.posts[i]
                post_time = datetime.datetime.utcfromtimestamp(post['time'])
                timezone_offset = -5 # "puzzles unlock at midnight EST/UTC-5"
                if i - self.start > 10 and post_time.hour + timezone_offset == 0 and post_time.minute == 0:
                    self.end = i
                    print(f"WARNING: exit early ({i}) due change of day", file=sys.stderr)
                    print(post, file=sys.stderr)
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
    thread = Thread(sys.argv[1].replace("\\", ""))
    thread.download()
    thread.load()
    for link in thread.get_media_links():
        print(link)

if __name__ == '__main__':
    main()
