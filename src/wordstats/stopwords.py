"""Stop words, which word counts can leave out."""

import string

STOP_WORDS = frozenset({"a", "an", "and", "the", "of", "to"})


def without_stop_words(words):
    """Returns `words` without the stop words, in order."""
    kept = [word for word in words if word.lower() not in STOP_WORDS]
    removed = len(words) - len(kept)
    return kept
