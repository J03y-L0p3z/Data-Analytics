import numpy as np

# Given data
values = np.array([2, 4, 10, 20, 50, 4, 5, 6, 9, 80], dtype=float)
current_avg = np.mean(values)
target_avg = 25  # Try with a value below or above current_avg
num_to_adjust = max(1, int(round(0.2 * len(values))))  # At least 1 value
max_adjustment = 100  # Maximum allowed adjustment per value

# Calculate total sum difference needed
total_sum_needed = target_avg * len(values)
sum_difference = total_sum_needed - np.sum(values)

# Decide which values to adjust
if sum_difference > 0:
    # Need to increase: adjust the lowest values
    adjust_indices = np.argsort(values)[:num_to_adjust]
else:
    # Need to decrease: adjust the highest values
    adjust_indices = np.argsort(values)[-num_to_adjust:]

# Track how much each value has been adjusted
adjusted_amounts = {idx: 0.0 for idx in adjust_indices}

remaining_diff = sum_difference
remaining_indices = list(adjust_indices)

while remaining_indices and abs(remaining_diff) > 1e-8:
    per_value = remaining_diff / len(remaining_indices)
    to_remove = []
    for idx in remaining_indices:
        # Calculate how much more this value can be adjusted (positive or negative)
        remaining_adj = max_adjustment - abs(adjusted_amounts[idx])
        # Cap the adjustment to max_adjustment per value
        adj = np.clip(per_value, -remaining_adj, remaining_adj)
        # Ensure no negative values
        if values[idx] + adj < 0:
            adj = -values[idx]
        # Final check: do not exceed max_adjustment in total
        if abs(adjusted_amounts[idx] + adj) > max_adjustment:
            adj = np.sign(adj) * (max_adjustment - abs(adjusted_amounts[idx]))
        values[idx] += adj
        adjusted_amounts[idx] += adj
        remaining_diff -= adj
        # Remove if max_adjustment reached or value is zero
        if abs(adjusted_amounts[idx]) >= max_adjustment or values[idx] == 0:
            to_remove.append(idx)
    for idx in to_remove:
        remaining_indices.remove(idx)
    if not to_remove:
        break  # No more adjustments possible

new_avg = np.mean(values)

# Output results
print("Adjusted Values:", values)
print("Total adjustments per index:", adjusted_amounts)
print("New Average:", new_avg)
print("Max adjustment actually used:", max(abs(a) for a in adjusted_amounts.values()))