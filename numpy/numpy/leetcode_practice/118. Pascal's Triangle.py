"""
https://leetcode.com/problems/pascals-triangle/

118. Pascal's Triangle
Easy
Topics
premium lock icon
Companies
Given an integer numRows, return the first numRows of Pascal's triangle.

In Pascal's triangle, each number is the sum of the two numbers directly above it as shown:




Example 1:

Input: numRows = 5
Output: [[1],[1,1],[1,2,1],[1,3,3,1],[1,4,6,4,1]]
Example 2:

Input: numRows = 1
Output: [[1]]


Constraints:

1 <= numRows <= 30"""

import math


class Solution:
    def generate(self, numRows: int) -> list[list[int]]:
        triangle = []
        for n in range(numRows):
            row = [math.comb(n, k) for k in range(n + 1)]
            triangle.append(row)
        return (triangle)
