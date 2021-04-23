//
// Created by qiufeng on 2020/12/14.
//

// ZUC(祖冲之)算法的流程如下
//      1. 密钥装入
//      2. 初始化
//          - 比特重组
//          - W = F(x0, x1, x2)
//          - LFSRWithInitialisationMode(u)
//      3. 工作
//          - 比特重组
//          - F(x0, x1, x2)
//          - LFSRWithWorkMode()


#ifndef SRC_ZUIC_HPP
#define SRC_ZUIC_HPP

#include <iostream>
#include <vector>
#include <array>
#include <deque>


class ZUCPredefinedArrays {

public:
    const static std::array<uint16_t, 16> d;
    const static std::array<uint8_t, 256> s0_box;
    const static std::array<uint8_t, 256> s1_box;
};


class LFSR {

private:
    std::deque<uint32_t> state;

    constexpr static uint32_t KShift = 31;
    constexpr static uint32_t KBase = 1 << KShift;
    constexpr static uint32_t KMod = KBase - 1;

private:
    inline uint32_t AddUint31(const uint32_t x, const uint32_t y) {
        uint32_t c = x + y;
        return (c & 0x7FFFFFFF) + (c >> 31);
    }

    inline static uint32_t RotlUint31(const uint32_t x, const int32_t shift) {
        return ((x << shift) | (x >> (31 - shift))) & 0x7FFFFFFF;
    }

public:

    LFSR(const std::array<uint32_t, 16>& s) : state(s.begin(), s.end()) {}
    LFSR() = default;

    inline void LoadState(const std::array<uint32_t, 16>& s) {
        for (auto i = 0; i < s.size(); i++) {
            if (i >= state.size()) state.push_back(s[i]);
            else state[i] = s[i];
        }
    }

    inline std::array<uint32_t, 4> BitReconstruction() {
        std::array<uint32_t, 4> x = { 0 };

        x[0] = ((state[15] & 0x7fff8000) << 1) | (state[14] & 0x0000ffff);
        x[1] = (state[11] << 16) | (state[9] >> 15);
        x[2] = (state[7] << 16) | (state[5] >> 15);
        x[3] = (state[2] << 16) | (state[0] >> 15);

        return x;
    }

    inline uint32_t Next(uint32_t u = 0) {
        uint32_t n = state[0];
        n = AddUint31(n, RotlUint31(state[0], 8));
        n = AddUint31(n, RotlUint31(state[4], 20));
        n = AddUint31(n, RotlUint31(state[10], 21));
        n = AddUint31(n, RotlUint31(state[13], 17));
        n = AddUint31(n, RotlUint31(state[15], 15));
        n = AddUint31(n, u);

        state.pop_front();
        state.push_back(n);

        return n;
    }

};


class ZUC {

private:
    LFSR lfsr;

    std::array<uint32_t, 2> r;

private:
    inline static uint32_t MakeUint31(uint8_t k, uint16_t d, uint8_t iv) {
        return (static_cast<uint32_t>(k) << 23) | (static_cast<uint32_t>(d) << 8) | iv;
    }
    std::array<uint32_t, 16> ExpendKey(const std::array<uint8_t , 16>& initial_key,
                                       const std::array<uint8_t , 16>& initial_vector);

    inline static uint32_t RotlUint32(const uint32_t x, const int32_t shift) {
        return (x << shift) | ((x >> (32 - shift))) & 0xFFFFFFFF;
    }

    inline static uint32_t MakeUint32(const uint8_t a, const uint8_t b, const uint8_t c, const uint8_t d) {
        return (static_cast<uint32_t>(a) << 24) | (static_cast<uint32_t>(b) << 16) | (static_cast<uint32_t>(c) << 8) | d;
    }

    inline static uint32_t L1(const uint32_t x) {
        return (x ^ RotlUint32(x, 2) ^ RotlUint32(x, 10) ^ RotlUint32(x, 18) ^ RotlUint32(x, 24));
    }

    inline static uint32_t L2(uint32_t x) {
        return (x ^ RotlUint32(x, 8) ^ RotlUint32(x, 14) ^ RotlUint32(x, 22) ^ RotlUint32(x, 30));
    }

    uint32_t F(uint32_t x0, uint32_t x1, uint32_t x2);

public:
    void Initialize(const std::array<uint8_t , 16>& initial_key,
                    const std::array<uint8_t , 16>& initial_vector) {
        auto initial_state = ExpendKey(initial_key, initial_vector);
        lfsr.LoadState(initial_state);
        r[0] = r[1] = 0;

        for (auto i = 0; i < 32; i++) {
            auto x = lfsr.BitReconstruction();
            auto w = F(x[0], x[1], x[2]);

            lfsr.Next(w >> 1);
        }
    }

    uint32_t GenerateWord() {
        auto x = lfsr.BitReconstruction();
        uint32_t z = F(x[0], x[1], x[2]) ^ x[3];
        lfsr.Next();

        return z;
    }
};

#endif //SRC_ZUIC_HPP
