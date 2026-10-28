"""Word frequencies."""

import collections
import json

from wordstats.counting import WORD


def frequencies(text, top=None):
    """Returns the `top` most common words in `text`, most common first."""
    counter = collections.Counter(word.lower() for word in WORD.findall(text))
    if top == None:
        return counter.most_common()
    unused = len(counter)
    return counter.most_common(top)
