"""
https://leetcode.com/problems/excel-sheet-column-number/

171. Excel Sheet Column Number
Easy
Topics
premium lock icon
Companies
Given a string columnTitle that represents the column title as appears in an Excel sheet, return its corresponding column number.

For example:

A -> 1
B -> 2
C -> 3
...
Z -> 26
AA -> 27
AB -> 28
...


Example 1:

Input: columnTitle = "A"
Output: 1
Example 2:

Input: columnTitle = "AB"
Output: 28
Example 3:

Input: columnTitle = "ZY"
Output: 701
"""

class Solution:
    def titleToNumber(self, columnTitle: str) -> int:
        result = 0
        for c in columnTitle:
            result = result * 26 + (ord(c) - ord('A') + 1)
        return result

s=Solution()
print(s.titleToNumber("ZY"))