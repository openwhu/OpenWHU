//
// Created by qiufeng on 2020/11/23.
//

#ifndef SRC_DES_HPP
#define SRC_DES_HPP


// DES(Data Encryption Standard) 算法流程
//      1. 子密钥生成
//      2. 初始置换 IP(initial permutation)
//      3. 16 轮加密迭代
//      4. 逆初始置换 IP-1

// 1. 子密钥生成步骤
//      a. 置换选择 1
//      b. 16 轮循环左移 + 置换选择 2

// 2. 初始置换 IP
//      a. 置换表 table: table[i] 表示置换后的第 i 位是原始数据的 table[i] 位

// 3. 加密迭代
//      a. 选择运算 E
//          - 置换操作(32 input, 48 output)
//      b. 8 个 S 盒代替
//          - 6 位输入 b1b2b3b4b5b6 中 b1b6 代表选中的行号, b2b3b4b5 代表选中的列号
//      c. 置换运算 P
//          ...


#include <iostream>
#include <bitset>
#include <vector>
#include <array>
#include <cassert>


class DES {

    // attribute
private:
    // initial key
    std::bitset<64> original_key;
    // sub key
    std::array<std::bitset<48>, 16> sub_keys;

    // method
private:
    void GenSubKey();
    std::bitset<32> F(const std::bitset<48> &original);
    // https://stackoverflow.com/questions/51353648/const-qualification-of-parameters-in-function-declaration
    void IterEncrypt(std::bitset<32> &l, std::bitset<32> &r, int round);

    // template
private:
    // https://raymii.org/s/snippets/Cpp_template_definitions_in_a_cpp_file_instead_of_header.html
    // T is original bitset length, V is permuted table length
    template<size_t T, size_t V>
    std::bitset<V> Permute(const std::bitset<T> &original, const std::array<int, V> &table) {
        std::bitset<V> permuted;

        for (auto i = 0; i != table.size(); i++) {
            // TODO
            // 注意 bitset 是倒过来的
            permuted[V - i - 1] = original[T - table[i]];
        }

        return permuted;
    }

    template<size_t T>
    void RotateLeftInPlace(std::bitset<T> &original, const int length) {
        for (auto i = 1; i <= length; i++) {
            // 啊啊啊!!! 太沙雕了，应该每次判断头部
            bool left_top = original[T - 1];
            original <<= 1;
            original[0] = left_top;
        }
    }

    template<size_t T>
    std::bitset<2 * T> Concatenate(const std::bitset<T> left, const std::bitset<T> right) {
        std::bitset<2 * T> result;

        for (auto i = 0; i != T; i++) {
            result[i] = right[i];
            result[T + i] = left[i];
        }

        return result;
    }

    template<size_t T>
    std::string ToString(const std::bitset<T> &l) {
        std::string result;
        std::string l_str(move(l.to_string()));

        for (auto i = 0; i != T; i++) {
            result.push_back(l_str[i]);
            if (i % 8 == 7) {
                result.push_back(' ');
            }
        }

        return result;
    }

    // interface
public:
    void SetKey(std::bitset<64> key);
    std::bitset<64> Encrypt(std::bitset<64> plaintext);
    std::bitset<64> Decrypt(std::bitset<64> ciphertext);

    // used table
public:
    // 用于子密钥生成的置换表
    const static std::array<int, 28> key_table_c0;
    const static std::array<int, 28> key_table_d0;
    // 循环左移表
    const static std::array<int, 16> key_rotate_left_table;
    // 置换表 2
    const static std::array<int, 48> key_table_2;
    // IP 置换表
    const static std::array<int, 32> ip_table_l0;
    const static std::array<int, 32> ip_table_r0;
    // 选择运算 E
    const static std::array<int, 48> selection_table_e;
    // S 盒
    const static int s_box[8][4][16];
    // 置换运算 P
    const static std::array<int, 32> permutation_table_p;
    // IP 逆置换
    const static std::array<int, 64> reverse_ip_table;

};

#endif //SRC_DES_HPP