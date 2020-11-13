import unittest
from sample_codes import *

class MyTest(unittest.TestCase):
	def testsquare_function(self):
		self.assertEqual(permutations1(3), None)

	def test_power(self):
		self.assertEqual(power(2, 0), 1)
		self.assertEqual(power(2, 1), 2)
		self.assertEqual(power(2, 2), 4)
		self.assertEqual(power(2, 10), 1024)
		self.assertEqual(power(3, 0), 1)
		self.assertEqual(power(3, 3), 27)
if __name__ == '__main__':
	unittest.main()
