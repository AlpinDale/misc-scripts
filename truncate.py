#!/usr/bin/env python3
import argparse
import json

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Dataset Creator')
    parser.add_argument('--input-file', help='Input SFT filepath.', required=True)
    parser.add_argument('--output-file', help='Path to write the trimmed file to.', required=True)
    parser.add_argument('--min-word-count', type=int, help='Trim examples where example is below this word count.', required=True)
    parser.add_argument('--start-dropping-from', type=int, help='Only trim examples after this index.', required=True)
    args = parser.parse_args()

    with open(args.input_file, "r", encoding="utf-8") as infile, \
        open(args.output_file, "w", encoding="utf-8") as outfile:
        for idx, line in enumerate(infile):
            if idx < args.start_dropping_from:
                # Keep already-seen training examples as-is.
                outfile.write(line)
            else:
                # Do the magic on all the following ones, though.
                example = json.loads(line)
                wc = len(example["output"].split(" "))
                if wc < args.min_word_count:
                    continue
                outfile.write(line.strip() + "\n")
