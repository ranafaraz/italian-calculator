class HistoryEntry {
  const HistoryEntry({
    required this.id,
    required this.expression,
    required this.result,
    required this.createdAt,
    this.isPinned = false,
  });

  final String id;
  final String expression;
  final String result;
  final DateTime createdAt;
  final bool isPinned;

  HistoryEntry copyWith({
    String? expression,
    String? result,
    DateTime? createdAt,
    bool? isPinned,
  }) {
    return HistoryEntry(
      id: id,
      expression: expression ?? this.expression,
      result: result ?? this.result,
      createdAt: createdAt ?? this.createdAt,
      isPinned: isPinned ?? this.isPinned,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'expression': expression,
      'result': result,
      'createdAt': createdAt.toIso8601String(),
      'isPinned': isPinned,
    };
  }

  factory HistoryEntry.fromJson(Map<String, Object?> json) {
    return HistoryEntry(
      id: json['id'] as String,
      expression: json['expression'] as String,
      result: json['result'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      isPinned: json['isPinned'] as bool? ?? false,
    );
  }
}
