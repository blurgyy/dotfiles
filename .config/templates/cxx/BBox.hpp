#pragma once

#include "globla.hpp"

#include <glm/glm.hpp>

#include <cmath>
#include <iostream>

class BBox {
  private:
    // Center of bbox.
    vec3 c;
    // Rotation matrix of bbox.
    mat3 r;
    // Scaling factors of bbox.
    std::array<flt, 3> s;
    // 3 Axes
    std::array<vec3, 3> axes;

  private:
    mat3 _getrot(flt const &rad, char const &axis) const;

  public:
    BBox();
    BBox(std::array<flt, 3> const &position,
         std::array<flt, 3> const &euler_angles,
         std::array<flt, 3> const &scaling_factors);

    // Determines if a point `p` is inside this bounding box.
    bool contains(vec3 const &p) const;

    /* Get methods */

    vec3 const &              center() const;
    mat3 const &              rotation() const;
    std::array<flt, 3> const &scaling() const;
};

inline mat3 BBox::_getrot(flt const &rad, char const &axis) const {
    flt co = std::cos(rad);
    flt si = std::sin(rad);
    // clang-format off
    if (axis == 'x') {
        return mat3{
            1, 0, 0,
            0, co, -si,
            0, si, co,
        };
    } else if (axis == 'y') {
        return mat3{
            co, 0, si,
            0, 1, 0,
            -si, 0, co,
        };
    } else if (axis == 'z') {
        return mat3{
            co, -si, 0,
            si, co, 0,
            0, 0, 1,
        };
    }
    // clang-format on
    std::cerr << format("Invalid axis '{}'\n", axis);
    return mat3(1);
}

inline BBox::BBox()
    : c{0}, r{0}, s{0}, axes{
                            vec3(1, 0, 0),
                            vec3(0, 1, 0),
                            vec3(0, 0, 1),
                        } {}
inline BBox::BBox(std::array<flt, 3> const &position,
                  std::array<flt, 3> const &euler_angles,
                  std::array<flt, 3> const &scaling_factors)
    : c{position[0], position[1], position[2]},
      r{this->_getrot(euler_angles[0], 'x') *
        this->_getrot(euler_angles[1], 'y') *
        this->_getrot(euler_angles[2], 'z')},
      s{scaling_factors[0], scaling_factors[1], scaling_factors[2]},
      axes{vec3(1, 0, 0), vec3(0, 1, 0), vec3(0, 0, 1)} {
    for (int i = 0; i < 3; ++i) {
        this->axes[i] = this->axes[i] * this->r;
    }
}

inline bool BBox::contains(vec3 const &p) const {
    for (int i = 0; i < 3; ++i) {
        flt proj = std::abs(glm::dot(this->axes[i], (p - this->c)));
        if (proj > .5 * this->s[i]) {
            return false;
        }
    }
    return true;
}

inline vec3 const &              BBox::center() const { return this->c; }
inline mat3 const &              BBox::rotation() const { return this->r; }
inline std::array<flt, 3> const &BBox::scaling() const { return this->s; }

// Author: Blurgy <gy@blurgy.xyz>
// Date:   Jan 26 2021, 12:04 [CST]
