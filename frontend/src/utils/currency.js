/**
 * Formats a number to Indian Rupee (INR) currency representation.
 * Examples:
 *  1299 -> ₹1,299
 *  24999 -> ₹24,999
 *  105000 -> ₹1,05,000
 *  149990 -> ₹1,49,990
 */
export function formatINR(amount, includeDecimals = false) {
  if (amount === null || amount === undefined || isNaN(amount)) {
    return '₹0';
  }

  const num = Number(amount);
  const formatted = num.toLocaleString('en-IN', {
    maximumFractionDigits: includeDecimals ? 2 : 0,
    minimumFractionDigits: includeDecimals ? 2 : 0
  });

  return `₹${formatted}`;
}
