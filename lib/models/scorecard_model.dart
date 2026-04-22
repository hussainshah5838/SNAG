/// Client scorecard model
class ScorecardModel {
  final int offersRedeemed;
  final int userScore;
  final int avgMonthly;
  final String mostSnagged;
  final int streakWeeks;

  const ScorecardModel({
    required this.offersRedeemed,
    required this.userScore,
    required this.avgMonthly,
    required this.mostSnagged,
    required this.streakWeeks,
  });

  factory ScorecardModel.fromJson(Map<String, dynamic> json) => ScorecardModel(
        offersRedeemed: (json['offersRedeemed'] as num?)?.toInt() ?? 0,
        userScore: (json['userScore'] as num?)?.toInt() ?? 0,
        avgMonthly: (json['avgMonthly'] as num?)?.toInt() ?? 0,
        mostSnagged: json['mostSnagged'] as String? ?? 'N/A',
        streakWeeks: (json['streakWeeks'] as num?)?.toInt() ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'offersRedeemed': offersRedeemed,
        'userScore': userScore,
        'avgMonthly': avgMonthly,
        'mostSnagged': mostSnagged,
        'streakWeeks': streakWeeks,
      };
}
