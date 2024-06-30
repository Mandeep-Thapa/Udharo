// enum for risk factor
enum RiskFactor {
  veryLow,
  low,
  moderatelyHigh,
  high,
  veryHigh,
}
// assigning string to risk factor
extension RiskFactorExtension on RiskFactor {
  String get name {
    switch (this) {
      case RiskFactor.veryLow:
        return 'Very Low';
      case RiskFactor.low:
        return 'Low';
      case RiskFactor.moderatelyHigh:
        return 'Moderately High';
      case RiskFactor.high:
        return 'High';
      case RiskFactor.veryHigh:
        return 'Very High';
      default:
        return 'Unknown';
    }
  }
}