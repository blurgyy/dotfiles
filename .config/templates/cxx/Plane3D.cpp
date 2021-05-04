#include "Plane3D.hpp"

#include <algorithm>
#include <cmath>
#include <fstream>

Plane3D::Plane3D() {}
Plane3D::Plane3D(vec3 const &n, vec3 const &c)
    : normal(glm::normalize(n)), center(c) {}
Plane3D::Plane3D(Eigen::Vector3d const &theta)
    : normal(glm::normalize(vec3(theta[1], theta[2], -1))),
      center(0, 0, theta[0]) {}

flt Plane3D::dist(vec3 const &point) const {
    return std::fabs(glm::dot(point - this->center, this->normal));
}
vec3 Plane3D::project(vec3 const &from) const {
    return from - glm::dot(from - this->center, this->normal) * this->normal;
}

std::pair<vec3, vec3> Plane3D::get_base() const {
    vec3 xaxis = glm::normalize(vec3(-this->normal.z, 0, this->normal.x));
    vec3 yaxis = glm::cross(this->normal, xaxis);
    return {xaxis, yaxis};
}

vec2 Plane3D::get_coord_2d(vec3 const &point) const {
    auto base  = this->get_base();
    vec3 xaxis = base.first;
    vec3 yaxis = base.second;
    return vec2{
        glm::dot(point, xaxis),
        glm::dot(point, yaxis),
    };
}

vec3 Plane3D::get_coord_3d(vec2 const &coord) const {
    auto base  = this->get_base();
    vec3 xaxis = base.first;
    vec3 yaxis = base.second;
    return coord.x * xaxis + coord.y * yaxis +
           glm::dot(this->center, this->normal) * this->normal;
}

bool Plane3D::compute_hull() {
    if (this->points.size() < 3) {
        std::cerr << format("Insufficient points for computing hull in plane "
                            "(expected >3, got {})\n",
                            this->points.size());
        return false;
    }

    std::vector<vec2> coords;
    for (vec3 const &point : this->points) {
        coords.push_back(this->get_coord_2d(point));
    }
    std::sort(coords.begin(), coords.end(),
              [](vec2 const &lhs, vec2 const &rhs) -> bool {
                  return lhs.y == rhs.y ? lhs.x < rhs.x : lhs.y < rhs.y;
              });
    vec2 base  = coords.front();
    using pfv2 = std::pair<flt, vec2>;
    std::vector<pfv2> theta_points;
    for (int i = 1; i < coords.size(); ++i) {
        vec2 dir   = glm::normalize(coords[i] - base);
        flt  theta = std::acos(dir.x);
        if (dir.y < 0) {
            theta = twopi - theta;
        }
        theta_points.emplace_back(theta, coords[i]);
    }
    std::sort(theta_points.begin(), theta_points.end(),
              [](pfv2 const &lhs, pfv2 const &rhs) -> bool {
                  return lhs.first == rhs.first
                             ? lhs.second.y == rhs.second.y
                                   ? lhs.second.x < rhs.second.x
                                   : lhs.second.y < rhs.second.y
                             : lhs.first < rhs.first;
              });
    std::vector<vec2> hull2d;
    hull2d.push_back(base);
    hull2d.push_back(theta_points.front().second);
    // Checks if `p` is inside the triangle(`base` - `a` - `b`)
    auto inside = [base](vec2 const &p, vec2 const &a,
                         vec2 const &b) -> bool {
        vec3 link0 = vec3(p - base, 0);
        vec3 link1 = vec3(p - b, 0);
        vec3 link2 = vec3(p - a, 0);
        return sign(glm::cross(link0, link1)) ==
               sign(glm::cross(link1, link2));
    };
    for (int i = 1; i < theta_points.size(); ++i) {
        vec2 lastpt       = hull2d.back();          // last point in hull2d.
        vec2 newpt        = theta_points[i].second; // new point.
        vec2 secondlastpt = hull2d.end()[-2]; // second last point in hull2d.
        while (inside(lastpt, newpt, secondlastpt)) {
            hull2d.pop_back();
            if (hull2d.size() == 1) {
                break;
            }
            lastpt       = secondlastpt;
            secondlastpt = hull2d.end()[-2];
        }
        hull2d.push_back(newpt);
    }

    for (vec2 const &pt2d : hull2d) {
        this->hull.push_back(this->get_coord_3d(pt2d));
    }
    return true;
}

bool Plane3D::compute_params() {
    if (this->hull.size() < 3) {
        std::cerr << format(
            "Not enough points in plane's hull, minimum required 3, got {}\n",
            this->hull.size());
        return false;
    }
    bool precise = false;
    vec3 link0   = this->hull[1] - this->hull[0];
    vec3 link1;
    for (int i = 2; i < this->hull.size(); ++i) {
        link1 = this->hull[i] - this->hull[1];
        flt absco =
            std::abs(glm::dot(glm::normalize(link0), glm::normalize(link1)));
        /* If `link1` and `link0` forms an angle larger than 10 degrees */
        if (absco < std::cos(10 * degrees)) {
            /* Set normal. */
            this->normal = glm::normalize(glm::cross(link0, link1));
            precise      = true;
            break;
        }
    }
    /* Set center as the first point in hull. */
    this->center = this->hull[0];
    if (!precise) {
        std::cerr << format("Points in plane's hull is not spreaded enough, "
                            "loss of precision may happen.\n");
    }
    return true;
}

bool Plane3D::dump_off(std::string const &filename) const {
    if (this->hull.size() < 3) {
        std::cerr
            << "Compute 2D hull first, then try to dump as .off file.\n";
        return false;
    }

    std::ofstream of;
    of.open(filename);
    if (!of.is_open()) {
        std::cerr << format("Failed opening file '{}' when saving plane\n",
                            filename);
        return false;
    }

    of << "OFF\n";
    of << format("{} 1 0\n", this->hull.size());
    for (vec3 const &point : this->hull) {
        of << format("{} {} {}\n", point.x, point.y, point.z);
    }
    of << format("{}", this->hull.size());
    for (int i = 0; i < this->hull.size(); ++i) {
        of << format(" {}", i);
    }
    of << "\n";

    of.close();
    return true;
}

// Author: Blurgy <gy@blurgy.xyz>
// Date:   Mar 24 2021, 15:15 [CST]
