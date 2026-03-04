#!/usr/bin/env python3

import pymupdf
import sys
import os


def debug(msg):
    print(msg, file=sys.stderr)


def usage():
    debug("Lists all links found in pdf. NO OCR.")
    debug("Usage:")
    debug(f"\t{os.path.basename(sys.argv[0])} PDF_FILE")


def main():
    doc = pymupdf.open(sys.argv[1])
    ulinks = set()
    for page in doc:
        for link in page.get_links():
            match link["kind"]:
                case 2:
                    ulinks.add(link["uri"])
                case 3:
                    ulinks.add(link["file"])
                case 1 | 4 | 5:
                    continue
                case _:
                    print("?????", link)
    if len(ulinks) == 0:
        debug("No links found!")
    else:
        for link in sorted(ulinks):
            print(link)


if __name__ == "__main__":
    if len(sys.argv) != 2:
        usage()
        sys.exit(1)
    main()
