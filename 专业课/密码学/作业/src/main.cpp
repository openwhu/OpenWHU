#include <bitset>
#include "des.hpp"
#include "rijndael.hpp"
#include "utils.hpp"
#include "zuc.hpp"


int main() {
    using namespace std;

    bitset<64> key("0011000100110010001100110011010000110101001101100011011100111000");
    bitset<64> text("0011000000110001001100100011001100110100001101010011011000110111");
    bitset<64> ciphertext("1000101110110100011110100000110011110000101010010110001001101101");
    DES test;
    test.SetKey(key);

    assert(ciphertext == test.Encrypt(text));
    assert(text == test.Decrypt(ciphertext));


    array<uint8_t, 16> aes_key = {0x54, 0x68, 0x61, 0x74, 0x73, 0x20, 0x6d, 0x79,
                                  0x20, 0x4b, 0x75, 0x6e, 0x67, 0x20, 0x46, 0x75};
    array<uint8_t, 16> aes_message = {0x54, 0x77, 0x6f, 0x20, 0x4f, 0x6e, 0x65, 0x20,
                                      0x4e, 0x69, 0x6e, 0x65, 0x20, 0x54, 0x77, 0x6f};

    array<uint8_t, 16> aes_key2 = {0x00,0x01,0x20,0x01,
                                   0x71,0x01,0x98,0xae,
                                   0xda,0x79,0x17,0x14,
                                   0x60,0x15,0x35,0x94};
    array<uint8_t, 16> aes_message2 = { 0x00,0x01,0x00,0x01,
                                        0x01,0xa1,0x98,0xaf,
                                        0xda,0x78,0x17,0x34,
                                        0x86,0x15,0x35,0x66};

    RijnDael rijndael(aes_key);
    auto rijndael_ciphertext = rijndael.encrypt(aes_message);
    assert (aes_message == rijndael.decrypt(rijndael_ciphertext));

    array<uint8_t, 16> zuc_key = {0x3d, 0x4c, 0x4b, 0xe9,
                                  0x6a, 0x82, 0xfd, 0xae,
                                  0xb5, 0x8f, 0x64, 0x1d,
                                  0xb1, 0x7b, 0x45, 0x5b};
    array<uint8_t, 16> zuc_iv = {0x84, 0x31, 0x9a, 0xa8,
                                 0xde, 0x69, 0x15, 0xca,
                                 0x1f, 0x6b, 0xda, 0x6b,
                                 0xfb, 0xd8, 0xc7, 0x66};
    ZUC zuc;
    zuc.Initialize(zuc_key, zuc_iv);

    return 0;
}
