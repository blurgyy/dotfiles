#pragma once

#include "globla.hpp"

#include <chrono>

class Timer {
    using clk = std::chrono::steady_clock;

  private:
    std::chrono::time_point<clk> start_time;
    std::chrono::time_point<clk> end_time;

  public:
    Timer() : start_time{std::chrono::time_point<clk>()} {}

    // Start the timer.
    void start() { this->start_time = clk::now(); }
    // Pause the timer
    void end() { this->end_time = clk::now(); }
    // Get elapsed time in miliseconds.
    double elapsedms() {
        return std::chrono::duration_cast<std::chrono::milliseconds>(
                   this->end_time - this->start_time)
            .count();
    }
};

// Author: Blurgy <gy@blurgy.xyz>
// Date:   Dec 18 2020, 23:39 [CST]
