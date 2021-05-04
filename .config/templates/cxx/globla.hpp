#pragma once

#include <cmath>
#include <cstdio>
#include <filesystem>
#include <iostream>
#include <string>

using flt = double;

#include <fmt/core.h>
using fmt::format;

#include <glm/glm.hpp>
#include <glm/gtc/quaternion.hpp>
using quat = glm::qua<flt, glm::defaultp>;
using vec3 = glm::vec<3, flt, glm::defaultp>;
using vec2 = glm::vec<2, flt, glm::defaultp>;
using mat3 = glm::mat<3, 3, flt, glm::defaultp>;

flt const pi      = std::acos(-1.0);
flt const twopi   = pi * 2.0;
flt const degrees = pi / 180;

// message functions `debugm` (debug messages), `errorm` (error messages)
// Reference: https://gcc.gnu.org/onlinedocs/cpp/Variadic-Macros.html
#ifndef NDEBUG
#define DEBUGGING -1
#else
#define DEBUGGING 0
#endif
#define dprintf(fmt, ...)                                                    \
    do {                                                                     \
        if (DEBUGGING)                                                       \
            fprintf(stdout, " [*] %s::%d::%s(): " fmt, __FILE__, __LINE__,   \
                    __func__, ##__VA_ARGS__);                                \
    } while (0)
#define eprintf(fmt, ...)                                                    \
    do {                                                                     \
        if (DEBUGGING)                                                       \
            fprintf(stderr, " [X] %s::%d::%s(): " fmt, __FILE__, __LINE__,   \
                    __func__, ##__VA_ARGS__);                                \
        else                                                                 \
            fprintf(stderr, " [X] " fmt, ##__VA_ARGS__);                     \
        exit(-1);                                                            \
    } while (0)
#define vprintf(fmt, ...)                                                    \
    do {                                                                     \
        fprintf(stderr, " [v] " fmt, ##__VA_ARGS__);                         \
    } while (0)

/* Functions */

template <typename T> T sq(T const &x) { return x * x; }

inline void clear_console() { printf("\33[2K\r"); }

inline std::string headless(std::string const &filename) {
    return static_cast<std::string>(
        std::filesystem::path(filename).filename());
}
inline std::string tailess(std::string const &filename) {
    return static_cast<std::string>(
        std::filesystem::path(filename).replace_extension());
}
template <typename __T>
std::vector<__T> merge(std::vector<__T> const &a, std::vector<__T> const &b) {
    std::vector<__T> AB;
    AB.reserve(a.size() + b.size());
    AB.insert(AB.end(), a.begin(), a.end());
    AB.insert(AB.end(), b.begin(), b.end());
    return AB;
}

// Author: Blurgy <gy@blurgy.xyz>
// Date:   Jan 25 2021, 18:43 [CST]
