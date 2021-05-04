#pragma once

#include "globla.hpp"

#include <Eigen/Eigen>

struct Plane3D {
    /* Plane normal. */
    vec3 normal;
    /* Plane center. */
    vec3 center;

    /* Points on plane. */
    std::vector<vec3> points;
    /* Points on plane's border. */
    std::vector<vec3> hull;

    /* Default constructor */
    Plane3D();
    /* Construct plane with normal vector and center point */
    Plane3D(vec3 const &normal, vec3 const &center);
    /* Construct plane with parameter `theta`, all points p(x, y, z) in plane
     * satisfies:
     *  \theta_0 + \theta_1 x + \theta_2 y = z.
     */
    Plane3D(Eigen::Vector3d const &theta);

    /* Get distance from `point` to this plane. */
    flt dist(vec3 const &point) const;
    /* Get projection of `point` on this plane. */
    vec3 project(vec3 const &from) const;
    /* Get the bases of this plane */
    std::pair<vec3, vec3> get_base() const;
    /* Get 2D coordinate of `point` (inside this plane). */
    vec2 get_coord_2d(vec3 const &point) const;
    /* Get 3D location of given coordinate (3d vector) */
    vec3 get_coord_3d(vec2 const &coord) const;
    /* Compute plane border, need member `points` to be non-empty. */
    bool compute_hull();
    /* Compute `normal` and `center` based on the points from this `plane` 's
     * hull.
     */
    bool compute_params();

    bool dump_off(std::string const &filename) const;
};

// Author: Blurgy <gy@blurgy.xyz>
// Date:   Mar 24 2021, 14:08 [CST]
