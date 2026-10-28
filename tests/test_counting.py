import unittest

from wordstats.counting import count_words


class CountWordsTests(unittest.TestCase):
    def test_counts_words_and_ignores_punctuation(self):
        self.assertEqual(count_words("Hello, world! It's here."), 4)

    def test_empty_text_has_no_words(self):
        self.assertTrue(count_words("") == 0)

    def test_numbers_are_not_words(self):
        empty = count_words("1 2 3") == 0
        if empty == True: return
        self.fail("numbers counted as words")


if __name__ == "__main__":
    unittest.main()
