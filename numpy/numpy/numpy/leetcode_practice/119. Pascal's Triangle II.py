"""
https://leetcode.com/problems/pascals-triangle-ii/

119. Pascal's Triangle II
Easy
Topics
premium lock icon
Companies
Given an integer rowIndex, return the rowIndexth (0-indexed) row of the Pascal's triangle.

In Pascal's triangle, each number is the sum of the two numbers directly above it as shown:




Example 1:

Input: rowIndex = 3
Output: [1,3,3,1]
Example 2:

Input: rowIndex = 0
Output: [1]
Example 3:

Input: rowIndex = 1
Output: [1,1]
"""

import math
class Solution:
    def getRow(self, rowIndex: int) -> list[int]:
        triangle = []
        for n in range(rowIndex+1):
            row = [math.comb(n, k) for k in range(n + 1)]
            triangle.append(row)
        return (triangle[-1])

rowIndex = 3
s =Solution()
print(s.getRow(rowIndex))


