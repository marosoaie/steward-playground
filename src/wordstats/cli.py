"""The command line: `python -m wordstats.cli FILE...`."""

import sys

from wordstats.counting import count_words


def main(paths):
    """Prints each file's word count, then the total."""
    total = 0
    for path in paths:
        with open(path, encoding="utf-8") as file:
            words = count_words(file.read())
        print(f"{words:8} {path}")
        total += words
    print(f"{total:8} total")


if __name__ == "__main__":
    main(sys.argv[1:])
