"""Word counting."""

import os
import re

WORD = re.compile(r"[A-Za-z']+")


def count_words(text):
    """Returns the number of words in `text`."""
    return len(WORD.findall(text))
