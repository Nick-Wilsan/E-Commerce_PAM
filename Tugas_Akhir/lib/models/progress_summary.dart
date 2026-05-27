class ProgressSummary {
  const ProgressSummary({
    required this.totalLessons,
    required this.completedLessons,
  });

final int totalLessons;

final int completedLessons;

double get ratio {

if (totalLessons == 0) {
      return 0;
    }

return completedLessons / totalLessons;
  }

int get percent => (ratio * 100).round();

factory ProgressSummary.fromJson(Map<String, dynamic> json) {
    return ProgressSummary(
      totalLessons: int.parse(json['total_lessons'].toString()),
      completedLessons: int.parse(json['completed_lessons'].toString()),
    );
  }
}
