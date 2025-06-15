#include <iostream>
#include <vector>
#include <algorithm>
#include <numeric>
#include <cmath>

int main() {
    // Given data
    std::vector<double> values = {2, 4, 10, 20, 50, 4, 5, 6, 9, 80};
    double current_sum = std::accumulate(values.begin(), values.end(), 0.0);
    double current_avg = current_sum / values.size();
    double target_avg = 15; // Try with a value below or above current_avg
    int num_to_adjust = std::max(1, static_cast<int>(std::round(0.2 * values.size())));

    // Calculate total sum difference needed
    double total_sum_needed = target_avg * values.size();
    double sum_difference = total_sum_needed - current_sum;

    // Decide which values to adjust
    std::vector<int> adjust_indices(values.size());
    std::iota(adjust_indices.begin(), adjust_indices.end(), 0);

    if (sum_difference > 0) {
        // Need to increase: adjust the lowest values
        std::sort(adjust_indices.begin(), adjust_indices.end(),
            [&values](int i, int j) { return values[i] < values[j]; });
    } else {
        // Need to decrease: adjust the highest values
        std::sort(adjust_indices.begin(), adjust_indices.end(),
            [&values](int i, int j) { return values[i] > values[j]; });
    }

    adjust_indices.resize(num_to_adjust);

    // Distribute the difference among chosen values, ensuring no negative values
    double remaining_diff = sum_difference;
    std::vector<int> remaining_indices = adjust_indices;

    while (!remaining_indices.empty() && std::abs(remaining_diff) > 1e-8) {
        double per_value = remaining_diff / remaining_indices.size();
        std::vector<int> to_remove;
        for (int idx : remaining_indices) {
            if (values[idx] + per_value < 0) {
                // Only bring it down to zero
                remaining_diff -= values[idx];
                values[idx] = 0;
                to_remove.push_back(idx);
            } else {
                values[idx] += per_value;
                remaining_diff -= per_value;
            }
        }
        // Remove indices that have been set to zero
        for (int idx : to_remove) {
            remaining_indices.erase(std::remove(remaining_indices.begin(), remaining_indices.end(), idx), remaining_indices.end());
        }
        if (to_remove.empty()) break; // No more negatives, done
    }

    // Calculate new average
    double new_avg = std::accumulate(values.begin(), values.end(), 0.0) / values.size();

    // Output results
    std::cout << "Adjusted Values: ";
    for (double v : values) std::cout << v << " ";
    std::cout << std::endl;
    std::cout << "New Average: " << new_avg << std::endl;

    return 0;
}