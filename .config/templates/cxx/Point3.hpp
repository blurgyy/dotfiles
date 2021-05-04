#pragma once

#include <array>
#include <cmath>

#include "globla.hpp"

struct Point3 {
    Point3(flt const &value = 0) : x{value}, y{value}, z{value} {}
    Point3(flt const &x, flt const &y, flt const &z) : x{x}, y{y}, z{z} {}
    Point3(std::array<flt, 3> values)
        : x{values[0]}, y{values[1]}, z{values[2]} {}

    flt  sqnorm() const { return sq(this->x) + sq(this->y) + sq(this->z); }
    flt  norm() const { return std::sqrt(this->sqnorm()); }
    void normalize() {
        flt len = this->norm();
        this->x /= len;
        this->y /= len;
        this->z /= len;
    }
    flt dot(Point3 const &rhs) const {
        return this->x * rhs.x + this->y * rhs.y + this->z * rhs.z;
    }

    // Operator overloads
    Point3 operator+(Point3 const &rhs) const {
        return Point3(this->x + rhs.x, this->y + rhs.y, this->z + rhs.z);
    }
    Point3 operator+=(Point3 const &rhs) {
        this->x += rhs.x;
        this->y += rhs.y;
        this->z += rhs.z;
        return *this;
    }
    Point3 friend operator-(Point3 const &rhs) {
        return Point3(-rhs.x, -rhs.y, -rhs.z);
    }
    Point3 operator-(Point3 const &rhs) const { return *this + -(rhs); }
    Point3 operator/(flt const &rhs) const {
        return Point3(this->x / rhs, this->y / rhs, this->z / rhs);
    }
    Point3 operator/=(flt const &rhs) {
        this->x /= rhs;
        this->y /= rhs;
        this->z /= rhs;
        return *this;
    }

    flt x, y, z;
};

// Author: Blurgy <gy@blurgy.xyz>
// Date:   Jan 25 2021, 18:41 [CST]
