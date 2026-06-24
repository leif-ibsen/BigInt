# About Division

How rounding is done

##

If an integer `x` divided by `d` gives quotient `q` and remainder `r`, then it is true that

* x = d * q + r
* |r| < |d|

For given x and d, if the remainder is not zero, there will be two possible (q, r) pairs. For example:

11 / 4 = (2, 3) and 11 / 4 = (3, -1)

and

-11 / 4 = (-2, -3) and -11 / 4 = (-3, 1)

The `quotientAndRemainder(dividingBy:)` methods return the quotient rounded towards zero and the corresponding remainder.

The `quotientAndRemainderCeil(dividingBy:)` methods return the quotient rounded towards `+Infinity` and the corresponding remainder.

The `quotientAndRemainderFloor(dividingBy:)` methods return the quotient rounded towards `-Infinity` and the corresponding remainder.

If the remainder is in fact zero, the methods return the same quotient.
