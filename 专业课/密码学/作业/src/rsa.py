from dataclasses import dataclass
from typing import Optional, Tuple, Iterable
from random import SystemRandom


@dataclass
class PublicKey:
    # n = p * q where p, q are primes
    n: int
    # 1 < e < \phi(n) and ed = 1 mod (\phi(n))
    e: int


@dataclass
class PrivateKey:
    # prime p
    p: int
    # prime q
    q: int
    # \phi(n) = (p-1)(q-1)
    phi_n: int
    # ed = 1 mod (\phi(n))
    d: int


@dataclass
class KeyManager:
    public_key: PublicKey
    private_key: PrivateKey


class RSA:
    _random: SystemRandom = SystemRandom()

    def __init__(self, key: Optional[KeyManager] = None):
        if not key:
            self._key = self.generate_key()
        elif not isinstance(key, KeyManager):
            raise ValueError(f"must pass type {KeyManager.__name__}")
        else:
            self._key = key

    def encrypt(self, m: int) -> int:
        """encrypt plain integer m and return cipher integer c"""
        return pow(m, self._key.public_key.e, self._key.public_key.n)

    def decrypt(self, c: int) -> int:
        """decrypt cipher integer c and return plain integer m"""
        return pow(c, self._key.private_key.d, self._key.public_key.n)

    @staticmethod
    def generate_key(n: int = 1024) -> KeyManager:
        """generate key with n bit length"""
        p = RSA.generate_nbit_prime(n)
        q = RSA.generate_nbit_prime(n)
        n = p * q
        phi_n = (p - 1) * (q - 1)
        e = 65537
        d = RSA.extended_euclidean(e, phi_n)[0] % phi_n

        public_key = PublicKey(n=n, e=e)
        private_key = PrivateKey(p=p, q=q, phi_n=phi_n, d=d)

        return KeyManager(public_key=public_key, private_key=private_key)

    @staticmethod
    def is_prime(n: int) -> bool:
        """test if n is prime"""
        if n < 10:
            return n in {2, 3, 5, 7}

        if not (n & 1):
            return False

        return RSA.miller_rabin_test(n, {2, 3, 5, 7, 9, 11})

    @staticmethod
    def miller_rabin_test(n: int, test_list: Iterable[int]) -> bool:
        """use an iterated list to test whether n is prime"""
        if n < 2:
            return False

        # calculate r, d s.t. 2^r * d = n - 1
        d = n - 1
        r = 0

        while not (d & 1):
            r += 1
            d >>= 1

        for a in test_list:
            x = pow(a, d, n)

            if x == 1 or x == n - 1:
                continue

            for _ in range(r - 1):
                x = pow(x, 2, n)
                if x == 1:
                    return False
                if x == n - 1:
                    break
            else:
                return False

        return True

    @staticmethod
    def generate_nbit_odd(n: int) -> int:
        """generate an odd integer with n bit length"""
        return RSA._random.randint(1 << n, (1 << (n + 1)) - 1) | 1

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
    def generate_nbit_prime(n: int) -> int:
        """generate a prime with n bit length"""
        while True:
            random_odd = RSA.generate_nbit_odd(n)
            if RSA.is_prime(random_odd):
                return random_odd


if __name__ == '__main__':
    
    rsa = RSA()

    m = 1231231235313123523113
    assert rsa.decrypt(rsa.encrypt(m)) == m
