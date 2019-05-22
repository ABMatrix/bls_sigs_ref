#!/usr/bin/env sage
# vim: syntax=python
#
# (C) 2019 Riad S. Wahby <rsw@cs.stanford.edu>
#
# common routines and definitions for G1

# BLS12-381 G1 curve
ell_u = -0xd201000000010000
p = 0x1a0111ea397fe69a4b1ba7b6434bacd764774b84f38512bf6730d2a0f6b0f6241eabfffeb153ffffb9feffffffffaaab
F = GF(p)
Ell = EllipticCurve(F, [0,4])
h = 3 * 11**2 * 10177**2 * 859267**2 * 52437899**2 # co-factor for G1
assert h == (ell_u-1)**2 // 3
assert Ell.order() % h == 0
q = Ell.order() // h
assert q == (ell_u**4 - ell_u**2 + 1)

# the lexically greater of x and p-x is negative
def sgn0(x):
    # is this the base field or the field extension?
    if x.parent().degree() == 1:
        xi_values = (x,)
    else:
        xi_values = x._vector_()

    # return sign if sign is nonzero, else return sign_i
    sign = 0
    def select_sign(sign_i):
        sign_sq = sign * sign  # 1 if sign is nonzero, else 0
        return (1 - sign_sq) * sign_i + sign_sq * sign

    # walk through each element of the vector repr of x to find the sign
    thresh = (x.base_ring().order() - 1) // 2
    for xi in xi_values:
        sign = select_sign(-2 * (xi > thresh) + (xi > 0))
    return select_sign(1)
