//
// Created by qiufeng on 2020/12/4.
//

#ifndef SRC_UTILS_HPP
#define SRC_UTILS_HPP

#include <array>
#include <cstdint>
#include <iostream>


std::string ByteToHexString(uint8_t k);

template<size_t T>
void PrintByteBuffer(const std::array<uint8_t, T> buffer) {
    for (auto &x : buffer) {
        std::cout << ByteToHexString(x) << " ";
    }
}

#endif //SRC_UTILS_HPP
