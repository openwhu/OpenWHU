//
// Created by qiufeng on 2020/11/30.
//

#ifndef SRC_RIJNDAEL_HPP
#define SRC_RIJNDAEL_HPP


// AES(Advanced Encryption Standard) or Rijndael 算法流程
//      1. 轮密钥生成
//      2. 初始轮密钥加
//      3. 轮函数

// 轮密钥生成算法
//      1. 密钥扩展
//      2. 轮密钥选择


// 轮函数
//      1. S盒变换(ByteSub)
//      2. 行移位变换(ShiftRow)
//      3. 列混合变换(MixColumn)
//      4. 轮密钥加变换(AddRoundKey)
// **最后一轮的轮函数没有第三步列混合变换**


#include <array>
#include <iostream>
#include <string>


class RijndaelPredefinedArrays {
public:

    const static std::array<uint8_t, 256> s_box;
    const static std::array<uint8_t, 256> inv_s_box;
    const static std::array<uint8_t, 256> rcon;
    // 下面两个表是为了在 MixColumns 中加速运算
    // 2t, t \in [0, 255] 的剩余系
    const static std::array<uint8_t, 256> mul2;
    // 3t, t \in [0, 255] 的剩余系
    const static std::array<uint8_t, 256> mul3;
    // 下面四个表是为了在 InvMixColumns 中加速运算
    // 9t, t \in [0, 255] 的剩余系
    const static std::array<uint8_t, 256> mul9;
    // 11t, t \in [0, 255] 的剩余系
    const static std::array<uint8_t, 256> mul11;
    // 13t, t \in [0, 255] 的剩余系
    const static std::array<uint8_t, 256> mul13;
    // 14t, t \in [0, 255] 的剩余系
    const static std::array<uint8_t, 256> mul14;
};

// 密钥扩展
class KeyExpansionHelper {
private:
    std::array<uint8_t, 16> original_key;
    std::array<uint8_t, 176> expansion_key;

    void expansion();
    void expansion_core(std::array<uint8_t, 4> &in, size_t i);

public:
    KeyExpansionHelper(std::array<uint8_t, 16> key) { SetKey(key); };
    KeyExpansionHelper(const uint8_t key[]) { SetKey(key); };

    void SetKey(std::array<uint8_t, 16> key);
    void SetKey(const uint8_t *key);

    std::array<uint8_t, 16> GetExpansionKey(size_t index);
    std::array<uint8_t, 16> operator[] (size_t index) { return GetExpansionKey(index); };

    void PrintKey();
};


class RijnDael {
private:
    KeyExpansionHelper key;

    void SubBytes(std::array<uint8_t, 16> &state);
    void ShiftRows(std::array<uint8_t, 16> &state);
    void MixColumns(std::array<uint8_t, 16> &state);
    void AddRoundKey(std::array<uint8_t, 16> &state, const std::array<uint8_t, 16> &round_key);

    void Round(std::array<uint8_t, 16> &state, const std::array<uint8_t, 16> &round_key);
    void FinalRound(std::array<uint8_t, 16> &state, const std::array<uint8_t, 16> &round_key);


    void InvSubBytes(std::array<uint8_t, 16> &state);
    void InvShiftRows(std::array<uint8_t, 16> &state);
    void InvMixColumns(std::array<uint8_t, 16> &state);

    void InvRound(std::array<uint8_t, 16> &state, const std::array<uint8_t, 16> &round_key);
    void InvFinalRound(std::array<uint8_t, 16> &state, const std::array<uint8_t, 16> &round_key);


public:
    RijnDael(std::array<uint8_t, 16> k) : key(k) {};

    void SetKey(std::array<uint8_t, 16> k) {
        key.SetKey(k);
    }

    void SetKey(const uint8_t *k) {
        key.SetKey(k);
    }

    std::array<uint8_t, 16> encrypt(std::array<uint8_t, 16> plaintext);
    std::array<uint8_t, 16> decrypt(std::array<uint8_t, 16> ciphertext);
};

#endif //SRC_RIJNDAEL_HPP
