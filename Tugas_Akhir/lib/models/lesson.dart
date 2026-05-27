class Lesson {
  const Lesson({
    required this.id,
    required this.title,
    required this.description,
    required this.content,
    required this.durationMinutes,
    required this.isCompleted,
  });

final int id;

final String title;

final String description;

final String content;

final int durationMinutes;

final bool isCompleted;

factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: int.parse(json['id'].toString()),
      title: json['title'].toString(),
      description: json['description'].toString(),
      content: json['content'].toString(),
      durationMinutes: int.parse(json['duration_minutes'].toString()),

isCompleted:
          json['is_completed'].toString() == '1' ||
          json['is_completed'] == true,
    );
  }

Lesson copyWith({bool? isCompleted}) {
    return Lesson(
      id: id,
      title: title,
      description: description,
      content: content,
      durationMinutes: durationMinutes,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
