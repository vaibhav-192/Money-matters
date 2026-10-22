class TransactionModel {

  final String id;

  final double amount;

  final String type;

  final String category;

  final String description;

  final String account;

  final DateTime date;

  final String? transferTo;

  TransactionModel({

    required this.id,

    required this.amount,

    required this.type,

    required this.category,

    required this.description,

    required this.account,

    required this.date,

    this.transferTo,

  });

  TransactionModel copyWith({

    String? id,

    double? amount,

    String? type,

    String? category,

    String? description,

    String? account,

    DateTime? date,

    String? transferTo,

  }) {

    return TransactionModel(

      id:
          id
          ??
          this.id,

      amount:
          amount
          ??
          this.amount,

      type:
          type
          ??
          this.type,

      category:
          category
          ??
          this.category,

      description:
          description
          ??
          this.description,

      account:
          account
          ??
          this.account,

      date:
          date
          ??
          this.date,

      transferTo:
          transferTo
          ??
          this.transferTo,

    );

  }

}