#!/usr/bin/env python3

import sys
import os.path
from bs4 import BeautifulSoup
from urllib.parse import urlparse, urldefrag
from urllib.request import urlopen

def usage():
    print("List internal and external links in an url.")
    print("Usage:")
    print(f"\t{os.path.basename(sys.argv[0])} URL")


def main():
    url = sys.argv[1]
    html = urlopen(url).read()
    soup = BeautifulSoup(html, 'html.parser')
    ulinks = set()
    dirname = os.path.dirname(url)

    for a in soup.find_all('a'):
        href = a.get('href')
        if not href or href.startswith("#"):
            continue
        if urlparse(href).scheme:
            link, _ = urldefrag(href)
            ulinks.add(link)
        else:
            ulinks.add(dirname + "/" + href)

    for link in sorted(ulinks,key=lambda x: urlparse(x).netloc):
        print(link)


if __name__ == "__main__":
    if len(sys.argv) != 2:
        usage()
        sys.exit(1)
    main()
