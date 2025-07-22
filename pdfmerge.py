#!/usr/bin/env python3

import pymupdf
import argparse
import os
import sys
import tkinter as tk
from dataclasses import dataclass, field
from typing import Tuple

@dataclass
class Pdf:
    fullpath     : str
    start_widget : tk.IntVar
    end_widget   : tk.IntVar
    start        : int = 0
    end          : int = 0
    filename     : str = field(init=False)
    def __post_init__(self):
        self.filename = os.path.basename(self.fullpath)

def main():
    paths, start, end = process_argv()
    pdfs = obtain_ranges(paths, start, end)
    generate_pdf(pdfs)

def process_argv() -> Tuple[list[str],int,int]:
    parser = argparse.ArgumentParser(
        description="Merges pdf files given as an argument into one.",
    )
    parser.add_argument('pdfs', nargs='+')
    parser.add_argument('-s', '--start', default=0, type=int, help='Number of pages to drop at the START of the pdf file.')
    parser.add_argument('-e', '--end', default=0, type=int, help='Number of pages to drop at the END of the pdf file.')
    args = parser.parse_args()
    pdfs = []
    for pdf in args.pdfs:
        if not os.path.exists(pdf):
            print(f"ERROR: given argument is not a pdf path: {pdf}")
            usage()
            sys.exit(1)
        pdfs.append(pdf)
    return pdfs, args.start, args.end

def obtain_ranges(pdf_paths: list[str], start: int, end: int) -> list[Pdf]:
    def close_window(event):
        root.destroy()
    pdfs = []
    root = tk.Tk()
    root.title(sys.argv[0])
    root.resizable(False,False)
    root.eval('tk::PlaceWindow . center')
    for idx, pdf_path in enumerate(pdf_paths):
        pdf = Pdf(pdf_path, tk.IntVar(value=start), tk.IntVar(value=end))
        tk.Label(root, text=pdf.filename).grid(row=idx)
        tk.Entry(root, justify="center", width=3, textvariable=pdf.start_widget).grid(row=idx,column=1)
        tk.Entry(root, justify="center", width=3, textvariable=pdf.end_widget).grid(row=idx,column=2)
        pdfs.append(pdf)
    root.bind('<Escape>', close_window)
    root.mainloop()
    for pdf in pdfs:
        pdf.start = pdf.start_widget.get()
        pdf.end   = pdf.end_widget.get()
    return pdfs

def generate_pdf(pdfs: list[Pdf]):
    output = pymupdf.open()
    for pdf in pdfs:
        source_pdf = pymupdf.open(pdf.fullpath)
        to_page = source_pdf.page_count - pdf.end - 1
        output.insert_pdf(source_pdf, from_page=pdf.start, to_page=to_page)
    output.save("output.pdf")
    output.close()

if __name__ == '__main__':
    main()
