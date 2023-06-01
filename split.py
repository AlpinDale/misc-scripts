import random
import argparse
import jsonlines

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Split data into training and validation sets.")
    parser.add_argument("--input", type=str, help="Input file to split.")
    parser.add_argument("--split_ratio", type=str, help="Ratio of data to use for training and validation sets in the format 'train_ratio,val_ratio'")
    args = parser.parse_args()

    # Parse the split ratios
    try:
        train_ratio, val_ratio = [float(x) for x in args.split_ratio.split(",")]
    except ValueError:
        print("Invalid split_ratio format. Please use 'train_ratio,val_ratio'")
        exit()

    # Check that the ratios are valid
    if train_ratio <= 0 or val_ratio <= 0:
        print("Invalid ratios. train_ratio and val_ratio must be greater than 0.")
        exit()

    total_ratio = train_ratio + val_ratio

    with jsonlines.open(args.input, 'r') as fin, \
            jsonlines.open("train.jsonl", 'w') as train_out, \
            jsonlines.open("val.jsonl", 'w') as val_out:
        for line in fin:
            r = random.uniform(0, total_ratio)
            if r < train_ratio:
                train_out.write(line)
            else:
                val_out.write(line)
