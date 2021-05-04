#include "Model.hpp"

Model::Model() {}
Model::Model(std::vector<vec3> const &vs, std::vector<vec3> const &ns)
    : vertices(vs), normals(ns) {}

void Model::clear() {
    this->vertices.clear();
    this->normals.clear();
    this->planes.clear();
}

bool Model::load_obj(std::string const &filename) {
    this->clear();
    if (!std::filesystem::is_regular_file(filename)) {
        std::cerr << format(
            "Path '{}' does not exist or not a regular file\n", filename);
        return false;
    }
    std::ifstream from(filename);
    if (from.fail()) {
        std::cerr << format("Failed opening file '{}'\n", filename);
        return false;
    }
    for (std::string line; std::getline(from, line);) {
        std::istringstream input(line);
        std::string        token;
        input >> token;
        if (token.length() == 0 || token[0] == '#') {
            continue;
        } else if (token == "v") {
            // First space-separated token is "v"
            flt x, y, z;
            input >> x >> y >> z;
            vec3 vert(x, y, z);
            this->vertices.push_back(vec3{x, y, z});
        } else if (token == "vn") {
            // First space-separated token is "vn" (normal)
            flt nx, ny, nz;
            input >> nx >> ny >> nz;
            vec3 normal(nx, ny, nz);
            this->normals.push_back(normal);
        }
        // This does not handle other inputs
    }
    from.close();
    return true;
}

bool Model::dump_obj(std::string const &filename) const {
    std::ofstream to(filename);
    if (to.fail()) {
        std::cerr << format("Failed opening file '{}'\n", filename.c_str());
        return false;
    }
    for (vec3 const &v : this->vertices) {
        to << format("v {} {} {}\n", v.x, v.y, v.z);
    }
    for (vec3 const &n : this->normals) {
        to << format("vn {} {} {}\n", n.x, n.y, n.z);
    }
    to.close();
    return true;
}

bool Model::load_off(std::string const &filename) {
    // OFF
    // 8 6 0
    // -0.500000 -0.500000 0.500000
    // 0.500000 -0.500000 0.500000
    // -0.500000 0.500000 0.500000
    // 0.500000 0.500000 0.500000
    // -0.500000 0.500000 -0.500000
    // 0.500000 0.500000 -0.500000
    // -0.500000 -0.500000 -0.500000
    // 0.500000 -0.500000 -0.500000
    // 4 0 1 3 2
    // 4 2 3 5 4
    // 4 4 5 7 6
    // 4 6 7 1 0
    // 4 1 7 5 3
    // 4 6 0 2 4
    this->clear();
    if (!std::filesystem::is_regular_file(filename)) {
        std::cerr << format(
            "Path '{}' does not exist or not a regular file\n", filename);
        return false;
    }
    std::ifstream from;
    from.open(filename);
    if (from.fail()) {
        std::cerr << format("Failed opening file '{}'", filename);
        return false;
    }
    std::string line;
    std::getline(from, line);
    std::istringstream in(line);
    std::string        token;
    in >> token;
    if (token != "OFF") {
        std::cerr << format("Bad initialization string ({}) for OFF format\n",
                            token);
        return false;
    }
    int n_verts, n_faces, n_edges;
    std::getline(from, line);
    in = std::istringstream(line);
    in >> n_verts >> n_faces >> n_edges;

    for (int i = 0; i < n_verts; ++i) {
        // while (std::getline(from, line)) {
        in = std::istringstream(line);
        vec3 vert;
        in >> vert.x >> vert.y >> vert.z;
        this->vertices.push_back(vert);
    }
    for (int i = 0; i < n_faces; ++i) {
        int     n_points, ptid;
        Plane3D plane;
        in = std::istringstream(line);
        in >> n_points;
        while (n_points--) {
            in >> ptid;
            plane.hull.push_back(this->vertices[ptid]);
        }
        plane.compute_params();
        this->planes.push_back(plane);
    }

    from.close();
    return true;
}

bool Model::dump_off(std::string const &filename) const {
    std::ofstream to;
    to.open(filename);

    if (to.fail()) {
        std::cerr << format("Failed opening file '{}'\n", filename);
        return false;
    }

    to << "OFF\n";
    std::string verts_buf;
    std::string planes_buf;
    for (vec3 const &v : this->vertices) {
        verts_buf += format("{} {} {}\n", v.x, v.y, v.z);
    }
    int acc = this->vertices.size();
    for (Plane3D const &plane : this->planes) {
        planes_buf += format("{}", plane.hull.size());
        for (int i = 0; i < plane.hull.size(); ++i) {
            vec3 const &v = plane.hull[i];
            verts_buf += format("{} {} {}\n", v.x, v.y, v.z);
            planes_buf += format(" {}", acc + i);
        }
        planes_buf += "\n";
        acc += plane.hull.size();
    }
    to << format("{} {} 0\n", acc, this->planes.size());
    to << verts_buf << planes_buf;

    to.close();
    return true;
}

Model Model::intersect(BBox const &bbox) const {
    std::vector<vec3> vs, ns;

    if (this->vertices.size() == this->normals.size()) {
        for (std::size_t i = 0; i < this->vertices.size(); ++i) {
            vec3 const &v = this->vertices[i];
            vec3 const &n = this->normals[i];
            if (bbox.contains(v)) {
                vs.push_back(v);
                ns.push_back(n);
            }
        }
    } else {
        for (std::size_t i = 0; i < this->vertices.size(); ++i) {
            vec3 const &v = this->vertices[i];
            if (bbox.contains(v)) {
                vs.push_back(v);
            }
        }
    }

    return Model(vs, ns);
}

// Author: Blurgy <gy@blurgy.xyz>
// Date:   Mar 24 2021, 20:19 [CST]
