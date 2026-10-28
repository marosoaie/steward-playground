"""Word frequencies."""

import collections

from wordstats.counting import WORD


def frequencies(text, top=None):
    """Returns the `top` most common words in `text`, most common first."""
    counter = collections.Counter(word.lower() for word in WORD.findall(text))
    if top is None:
        return counter.most_common()
    return counter.most_common(top)
