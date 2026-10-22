class AccountModel {

  String name;

  double balance;

  String type;

  double creditLimit;

  int? billingDay;

  int? dueDay;

  AccountModel({

    required this.name,

    required this.balance,

    this.type = "Bank",

    this.creditLimit = 0,

    this.billingDay,

    this.dueDay,

  });

  bool get isCard {

    return type == "Credit Card";

  }

  double get outstanding {

    return balance;

  }

  double get available {

    if (!isCard) {

      return balance;

    }

    return creditLimit - balance;

  }

  double get utilization {

    if (

      !isCard ||

      creditLimit <= 0

    ) {

      return 0;

    }

    return (

      balance

      /

      creditLimit

    )

        * 100;

  }

  AccountModel copyWith({

    String? name,

    double? balance,

    String? type,

    double? creditLimit,

    int? billingDay,

    int? dueDay,

  }) {

    return AccountModel(

      name:

          name

          ??

          this.name,

      balance:

          balance

          ??

          this.balance,

      type:

          type

          ??

          this.type,

      creditLimit:

          creditLimit

          ??

          this.creditLimit,

      billingDay:

          billingDay

          ??

          this.billingDay,

      dueDay:

          dueDay

          ??

          this.dueDay,

    );

  }

}