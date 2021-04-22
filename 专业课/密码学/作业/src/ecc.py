from __future__ import annotations

from typing import Tuple, List, Union, Optional
from dataclasses import dataclass

from random import SystemRandom


class EllipticCurvePoint:
    """point of certain elliptic curve(y^2 = x^3 + ax + b (mod p)) point"""
    __a: int
    __b: int
    __p: int

    @classmethod
    def config_class_parameters(cls, *,
                                a: int,
                                b: int,
                                p: int) -> None:
        cls.__a = a
        cls.__b = b
        cls.__p = p

    def __init__(self, point: Tuple[int, int]) -> None:
        self._x = point[0]
        self._y = point[1]

    def __add__(self, other: Union[EllipticCurvePoint, int]) -> Union[EllipticCurvePoint, int]:
        if isinstance(other, int):
            if other == 0:
                return self * 1
            else:
                raise ValueError("单位元必须用0表示")
        if self == other:
            l = ((3 * self.x ** 2 + self.ca()) * self.get_inverse(2 * self.y, self.cp())) % self.cp()
            new_x = (l ** 2 - 2 * self.x) % self.cp()
            new_y = (l * (self.x - new_x) - self.y) % self.cp()
        elif self == -other:
            return 0
        else:
            l = ((other.y - self.y) * self.get_inverse((other.x - self.x), self.cp())) % self.cp()
            new_x = (l ** 2 - self.x - other.x) % self.cp()
            new_y = (l * (self.x - new_x) - self.y) % self.cp()

        return EllipticCurvePoint((new_x, new_y))

    def __radd__(self, other: Union[EllipticCurvePoint, int]) -> Union[EllipticCurvePoint, int]:
        return self + other

    def __mul__(self, other: int) -> Union[EllipticCurvePoint, int]:
        if other == 1:
            return EllipticCurvePoint((self.x, self.y))

        mod_point = self * 1
        result = 0

        bit_length = other.bit_length()
        for _ in range(bit_length):
            if other & 1:
                result += mod_point

            mod_point += mod_point
            other >>= 1

        return result

    def __rmul__(self, other: int) -> Union[EllipticCurvePoint, int]:
        return self * other

    @property
    def x(self) -> int:
        return self._x

    @property
    def y(self) -> int:
        return self._y

    @classmethod
    def ca(cls):
        return cls.__a

    @classmethod
    def cb(cls):
        return cls.__b

    @classmethod
    def cp(cls):
        return cls.__p

    def __eq__(self, other: EllipticCurvePoint) -> bool:
        return self.x == other.x and self.y == other.y

    def __neg__(self) -> EllipticCurvePoint:
        return EllipticCurvePoint((self.x, -self.y))

    def __str__(self) -> str:
        return f"x: {self.x}, y: {self.y}, a: {self.ca()}, b: {self.cb()}, p: {self.cp()}"

    def __repr__(self) -> str:
        return f"EllipticCurvePoint(x={self.x}, y={self.y})"

    @staticmethod
    def extended_euclidean(a: int, b: int) -> Tuple[int, int, int]:
        """given integer a and b, calculate s, t and m that satisfy sa + tb = (a, b) = m"""
        # a stack that store (b, modular)
        stack = []

        while b != 0:
            stack.append((a, b))
            a, b = b, a % b
        # m = gcd(a, b)
        m = stack[-1][1]

        s = 1
        t = 0
        while len(stack):
            a, b = stack.pop()
            s, t = t, s - a // b * t

        return s, t, m

    @staticmethod
    def get_inverse(a: int, p: int) -> int:
        """get inverse of a with modular p"""
        return EllipticCurvePoint.extended_euclidean(a, p)[0]


class EllipticCurve:

    def __init__(self, *,
                 a: int,
                 b: int,
                 p: int) -> None:
        """initialize elliptic curve `y^2 = x^3 + ax + b (mod p)` with given parameters"""
        assert 4 * a ** 3 + 27 * b ** 2 != 0

        self._a = a
        self._b = b
        self._p = p

        EllipticCurvePoint.config_class_parameters(a=a, b=b, p=p)

    def make_point(self, point: Tuple[int, int]) -> EllipticCurvePoint:
        return EllipticCurvePoint(point)


@dataclass
class ECCParameters:
    p: int = 0xFFFFFFFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000FFFFFFFFFFFFFFFF
    a: int = 0xFFFFFFFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000FFFFFFFFFFFFFFFC
    b: int = 0x28E9FA9E9D9F5E344D5A9E4BCF6509A7F39789F515AB8F92DDBCBD414D940E93
    n: int = 0xFFFFFFFEFFFFFFFFFFFFFFFFFFFFFFFF7203DF6B21C6052B53BBF40939D54123
    G: Tuple[int, int] = (
        0x32C4AE2C1F1981195F9904466A39C9948FE30BBFF2660BE1715A4589334C74C7,
        0xBC3736A2F4F6779C59BDCEE36B692153D0A9877CC62A474002DF32E52139F0A0
    )


class ECC:

    def __init__(self, *,
                 parameters: Optional[ECCParameters] = None) -> None:
        if not parameters:
            parameters = ECCParameters()

        self._elliptic_curve = EllipticCurve(
            a=parameters.a,
            b=parameters.b,
            p=parameters.p
        )

        self._parameters = parameters

        # private key is a random number `d`
        self._private_key = self._generate_private_key()
        self._public_key = self._generate_public_key()

    def _generate_private_key(self) -> int:
        return SystemRandom().randint(self._parameters.n // 2, self._parameters.n)

    def _generate_public_key(self) -> EllipticCurvePoint:
        return self._private_key * \
               self._elliptic_curve.make_point(self._parameters.G)

    def encrypt(self, plaintext: int) -> Tuple[EllipticCurvePoint, int]:
        k = SystemRandom().randint(self._parameters.n // 2, self._parameters.n)
        x1 = k * self._elliptic_curve.make_point(self._parameters.G)
        x2 = k * self._public_key
        c = (plaintext * x2.x) % self._parameters.n

        return x1, c

    def decrypt(self, ciphertext: Tuple[EllipticCurvePoint, int]) -> int:
        x2 = self._private_key * ciphertext[0]
        inv_x = x2.get_inverse(x2.x, self._parameters.n)

        return (ciphertext[1] * inv_x) % self._parameters.n


if __name__ == '__main__':
    test_ecc = ECC()

    m = 123123123

    assert test_ecc.decrypt(test_ecc.encrypt(m)) == m
