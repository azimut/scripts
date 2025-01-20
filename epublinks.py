#!/usr/bin/env python3
import bs4
import os
import sys
import zipfile


def usage():
    print("Lists external links found in given EPUB.\n")
    print(f"Usage:\n\t{os.path.basename(sys.argv[0])} URL")

def err(msg):
    print(f"ERROR: {msg}", file=sys.stderr)

def main(epub):
    links = []
    with zipfile.ZipFile(epub, 'r') as z:
        htmls = [ h for h in z.namelist() if h.endswith('.html') or h.endswith('.xhtml') ]
        for html in htmls:
            soup = bs4.BeautifulSoup(z.read(html), "html.parser")
            for anchor in soup.find_all('a'):
                href = anchor.get('href')
                if href.startswith('http'):
                    links.append(href)

    for link in sorted(set(links)):
        print(link)


if __name__ == '__main__':

    if len(sys.argv) != 2:
        err("missing URL argument :/")
        usage()
        sys.exit(1)

    epub = sys.argv[1]
    if not zipfile.is_zipfile(epub):
        err("${epub} is not a valid epub file :/")
        usage()
        sys.exit(1)

    main(epub)
