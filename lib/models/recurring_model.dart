class RecurringModel {

  final String id;

  final String title;

  final double amount;

  final String type;

  final String account;

  final String category;

  final String frequency;

  final int interval;

  final int? weekday;

  final int? monthDate;

  final String? time;

  final DateTime startDate;

  final bool active;

  final String endingType;

  final DateTime? endDate;

  final int? occurrences;

  final int completed;

  RecurringModel({

    required this.id,

    required this.title,

    required this.amount,

    required this.type,

    required this.account,

    required this.category,

    required this.frequency,

    required this.interval,

    required this.startDate,

    required this.active,

    required this.endingType,

    required this.completed,

    this.weekday,

    this.monthDate,

    this.time,

    this.endDate,

    this.occurrences,

  });

  RecurringModel copyWith({

    String? id,

    String? title,

    double? amount,

    String? type,

    String? account,

    String? category,

    String? frequency,

    int? interval,

    int? weekday,

    int? monthDate,

    String? time,

    DateTime? startDate,

    bool? active,

    String? endingType,

    DateTime? endDate,

    int? occurrences,

    int? completed,

  }) {

    return RecurringModel(

      id: id ?? this.id,

      title: title ?? this.title,

      amount: amount ?? this.amount,

      type: type ?? this.type,

      account: account ?? this.account,

      category:
category
??
this.category,

      frequency:
          frequency
          ??
          this.frequency,

      interval:
          interval
          ??
          this.interval,

      weekday:
          weekday
          ??
          this.weekday,

      monthDate:
          monthDate
          ??
          this.monthDate,

      time:
          time
          ??
          this.time,

      startDate:
          startDate
          ??
          this.startDate,

      active:
          active
          ??
          this.active,

      endingType:
          endingType
          ??
          this.endingType,

      endDate:
          endDate
          ??
          this.endDate,

      occurrences:
          occurrences
          ??
          this.occurrences,

      completed:
          completed
          ??
          this.completed,

    );

  }

}