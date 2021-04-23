//
// Created by qiufeng on 2020/12/4.
//

#include "utils.hpp"
#include <array>
#include <iostream>


char HexToChar(uint8_t h) {
    if (h < 10) {
        return h + '0';
    } else if (h < 16) {
        return h - 10 + 'A';
    }
    throw;
}


std::string ByteToHexString(uint8_t k) {
    std::string s;

    int remainder = k & 15;
    int factor = k / 16;

    s.push_back(HexToChar(factor));
    s.push_back(HexToChar(remainder));

    return s;
}



