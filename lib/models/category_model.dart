class CategoryModel {

  String name;

  String type;

  bool isDefault;

  CategoryModel({

    required this.name,

    required this.type,

    this.isDefault = false,

  });

  bool get isIncome {

    return type == "Income";

  }

  bool get isExpense {

    return type == "Expense";

  }

  CategoryModel copyWith({

    String? name,

    String? type,

    bool? isDefault,

  }) {

    return CategoryModel(

      name:

          name

          ??

          this.name,

      type:

          type

          ??

          this.type,

      isDefault:

          isDefault

          ??

          this.isDefault,

    );

  }

  Map<String, dynamic> toMap() {

    return {

      "name":
          name,

      "type":
          type,

      "isDefault":
          isDefault,

    };

  }

  factory CategoryModel.fromMap(
    Map map,
  ) {

    return CategoryModel(

      name:
          map["name"],

      type:
          map["type"],

      isDefault:

          map["isDefault"]

          ??

          false,

    );

  }

}