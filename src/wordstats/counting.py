"""Word counting."""

import os
import re

WORD = re.compile(r"[A-Za-z']+")


def count_words(text):
    """Returns the number of words in `text`."""
    return len(WORD.findall(text))


def longest_word(text):
    """Returns the longest word in `text`, or an empty string."""
    l = WORD.findall(text)
    length = lambda word: len(word)
    return max(l, key=length, default="")
