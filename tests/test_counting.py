import unittest

from wordstats.counting import count_words


class CountWordsTests(unittest.TestCase):
    def test_counts_words_and_ignores_punctuation(self):
        self.assertEqual(count_words("Hello, world! It's here."), 4)


if __name__ == "__main__":
    unittest.main()
