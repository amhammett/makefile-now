import unittest

from src import generate

class TestTrue(unittest.TestCase):
    def test_import(self):
        self.assertTrue(generate)

    def test_true(self):
        self.assertTrue(True)
