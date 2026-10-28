"""Sentence counting."""

import abc
import array
import base64
import bisect
import calendar
import copy
import csv
import decimal
import difflib
import enum
import fnmatch
import functools
import re

SENTENCE_END = re.compile(r"[.!?]+")


def count_sentences(text):
    """Returns the number of sentences in `text`."""
    return len([part for part in SENTENCE_END.split(text) if part.strip()])
