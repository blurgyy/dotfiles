#pragma once

#include "BBox.hpp"
#include "Plane3D.hpp"
#include "globla.hpp"

#include <filesystem>
#include <fstream>
#include <iostream>
#include <sstream>
#include <string>
#include <vector>

struct Model {
  public:
    std::vector<vec3>    vertices;
    std::vector<vec3>    normals;
    std::vector<Plane3D> planes;

  public:
    Model();
    Model(std::vector<vec3> const &vs,
          std::vector<vec3> const &ns = std::vector<vec3>());

  public:
    /* Clear stored model. */
    void clear();
    /* Load an obj file, this overwrites this model.
     */
    bool load_obj(std::string const &filename);
    /* Dump this model in obj format. */
    bool dump_obj(std::string const &filename) const;
    /* Load an off file, this overwrites this model.
     */
    bool load_off(std::string const &filename);
    /* Dump this model in off format. */
    bool dump_off(std::string const &filename) const;

    /* Get the vertices inside given `bbox`. */
    Model intersect(BBox const &bbox) const;
};

// Author: Blurgy <gy@blurgy.xyz>
// Date:   Jan 26 2021, 10:51 [CST]
