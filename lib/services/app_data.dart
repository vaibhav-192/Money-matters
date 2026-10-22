import '../models/account_model.dart';
import '../models/category_model.dart';
import '../models/transaction_model.dart';
import '../models/recurring_model.dart';
import '../models/budget_model.dart';

import '../database/storage_service.dart';

class AppData {
  static String currency = "₹";
  static bool darkMode = true;
  static double globalSavings =
    0;
  static double globalDebt =
    0;

static int savingsMonth =
    DateTime.now().month;

static int savingsYear =
    DateTime.now().year;

  static List<TransactionModel> transactions = [];

  static List<RecurringModel> recurring = [];

  static List<AccountModel> accounts = [];

  static List<CategoryModel> categories = [];

  static List<BudgetModel> budgets = [];

  
static void settleBudgetMonth() {

  globalSavings = 0;

  globalDebt = 0;

  final now =
      DateTime.now();

  final currentMonth =
      now.month;

  final currentYear =
      now.year;

  final closedMonths =
<String>{};

for (

final b

in

budgets

) {

int y =
b.startYear;

int m =
b.startMonth;

while (

y < currentYear

||

(

y == currentYear

&&

m < currentMonth

)

) {

closedMonths.add(
"$y-$m",
);

m++;

if (

m > 12

) {

m = 1;

y++;

}

}

}

  for (

    final period

    in

    closedMonths

  ) {

    final split =
        period.split(
          "-",
        );

    final year =
        int.parse(
          split[0],
        );

    final month =
        int.parse(
          split[1],
        );

    for (

      final b

      in

      budgets

    ) {

      final afterStart =

year >
b.startYear

||

(

year
==
b.startYear

&&

month
>=
b.startMonth

);

final beforeEnd =

b.endMonth
==
null

||

b.endYear
==
null

||

year
<
b.endYear!

||

(

year
==
b.endYear!

&&

month
<=
b.endMonth!

);

if (

!(

afterStart

&&

beforeEnd

)

) {

continue;

}

      double spent = 0;

      for (

        final t

        in

        transactions

      ) {

        if (

          t.type
                  ==
                  "Expense"

              &&

              t.category
                  ==
                  b.category

              &&

              t.date.year
                  ==
                  year

              &&

              t.date.month
                  ==
                  month

        ) {

          spent +=
              t.amount;

        }

      }

      final remaining =

          b.monthlyBudget
          -
          spent;

      if (

        remaining
        >
        0

      ) {

        globalSavings +=
            remaining;

      }

      else {

        double extra =

            remaining.abs();

        if (

          globalSavings
          >=
          extra

        ) {

          globalSavings -=
              extra;

        }

        else {

          extra -=
              globalSavings;

          globalSavings =
              0;

          globalDebt +=
              extra;

        }

      }

    }

  }

}



  static load() {
    currency =

StorageService.box.get(
"currency",
)

??

"${AppData.currency}";
    darkMode =

StorageService.box.get(
"darkMode",
)

??

true;
    globalDebt =

StorageService.box.get(

"globalDebt",

defaultValue:
0.0,

);
    globalSavings =

StorageService.box.get(
  "globalSavings",
  defaultValue:
      0.0,
);

savingsMonth =

StorageService.box.get(
  "savingsMonth",
  defaultValue:
      DateTime.now().month,
);

savingsYear =

StorageService.box.get(
  "savingsYear",
  defaultValue:
      DateTime.now().year,
);

    final tx =
        StorageService.box.get(
      "transactions",
    );

    if (tx != null) {

      transactions =

          (tx as List)

              .map<TransactionModel>(

        (e) {

          return TransactionModel(

            id:
                e["id"],

            amount:
                (e["amount"] as num)
                    .toDouble(),

            type:
                e["type"],

            category:
                e["category"],

            description:
                e["description"],

            account:
                e["account"],

            transferTo:
                e["transferTo"],

            date:

                e["date"] == null

                    ?

                    DateTime.now()

                    :

                    DateTime.parse(
                      e["date"],
                    ),

          );

        },

      ).toList();

    }

    final acc =

        StorageService.box.get(
      "accounts",
    );

    if (acc != null) {

      accounts =

          (acc as List)

              .map<AccountModel>(

        (e) {

          return AccountModel(

            name:
                e["name"],

            balance:

                (
                  e["balance"]
                      as num
                )

                    .toDouble(),

            type:

                e["type"]

                ??

                "Bank",

            creditLimit:

                (
                  e["creditLimit"]

                      ??

                      0

                  as num

                )

                    .toDouble(),

            billingDay:
                e["billingDay"],

            dueDay:
                e["dueDay"],

          );

        },

      ).toList();

    }

    final cat =

        StorageService.box.get(
      "categories",
    );

    if (cat != null) {

      categories =

          (cat as List)

              .map<CategoryModel>(

        (e) {

          return CategoryModel.fromMap(
            e,
          );

        },

      ).toList();

    }
    if (

categories.isEmpty

) {

categories = [

CategoryModel(

name:
"Food",

type:
"Expense",

isDefault:
true,

),

CategoryModel(

name:
"Shopping",

type:
"Expense",

isDefault:
true,

),

CategoryModel(

name:
"Bills",

type:
"Expense",

isDefault:
true,

),

CategoryModel(

name:
"Travel",

type:
"Expense",

isDefault:
true,

),

CategoryModel(

name:
"Other",

type:
"Expense",

isDefault:
true,

),

CategoryModel(

name:
"Salary",

type:
"Income",

isDefault:
true,

),

CategoryModel(

name:
"Bonus",

type:
"Income",

isDefault:
true,

),

CategoryModel(

name:
"Other",

type:
"Income",

isDefault:
true,

),

];

save();

}

    final rec =

        StorageService.box.get(
      "recurring",
    );

    if (rec != null) {

      recurring =

          (rec as List)

              .map<RecurringModel>(

        (e) {

          return RecurringModel(

            id:
                e["id"],

            title:
                e["title"],

            amount:

                (
                  e["amount"]
                      as num
                )

                    .toDouble(),

            type:
                e["type"],

            account:
                e["account"],

            category:
e["category"]
??
"Other",

            frequency:
                e["frequency"],

            interval:
                e["interval"],

            weekday:
                e["weekday"],

            monthDate:
                e["monthDate"],

            time:
                e["time"],

            startDate:

                DateTime.parse(
                  e["startDate"],
                ),

            active:
                e["active"],

            endingType:
                e["endingType"],

            endDate:

                e["endDate"]

                ==

                null

                    ?

                    null

                    :

                    DateTime.parse(
                      e["endDate"],
                    ),

            occurrences:
                e["occurrences"],

            completed:
                e["completed"],

          );

        },

      ).toList();

    }

    final bud =

        StorageService.box.get(
      "budgets",
    );

    if (bud != null) {

      budgets =

          (bud as List)

              .map<BudgetModel>(

        (e) {

          return BudgetModel(

category:

e[
"category"
]

??

"",

monthlyBudget:

(

e[
"monthlyBudget"
]

??

0

)

.toDouble(),

savings:

(

e[
"savings"
]

??

0

)

.toDouble(),

debt:

(

e[
"debt"
]

??

0

)

.toDouble(),

carryForward:

e[
"carryForward"
]

is bool

?

e[
"carryForward"
]

:

true,

startMonth:

e[
"startMonth"
]

??

DateTime.now().month,

startYear:

e[
"startYear"
]

??

DateTime.now().year,

endMonth:

e[
"endMonth"
],

endYear:

e[
"endYear"
],

);

        },

      ).toList();

    }
    settleBudgetMonth();

  }

  static double effectiveBudget(
double budget,
) {

if (

globalDebt
<=
0

)

return budget;

final adjusted =

budget
-
globalDebt;

return adjusted > 0
? adjusted
: 0;

}

  static save() {
    StorageService.box.put(

"currency",

currency,

);
    StorageService.box.put(

"darkMode",

darkMode,

);
    settleBudgetMonth();

    StorageService.box.put(

"globalDebt",

globalDebt,

);
    StorageService.box.put(
  "globalSavings",
  globalSavings,
);

StorageService.box.put(
  "savingsMonth",
  savingsMonth,
);

StorageService.box.put(
  "savingsYear",
  savingsYear,
);

    StorageService.box.put(

      "transactions",

      transactions

          .map(

            (e)

                =>

                {

              "id":
                  e.id,

              "amount":
                  e.amount,

              "type":
                  e.type,

              "category":
                  e.category,

              "description":
                  e.description,

              "account":
                  e.account,

              "transferTo":
                  e.transferTo,

              "date":

                  e.date
                      .toIso8601String(),

            },

          )

          .toList(),

    );

    StorageService.box.put(

      "accounts",

      accounts

          .map(

            (e)

                =>

                {

              "name":
                  e.name,

              "balance":
                  e.balance,

              "type":
                  e.type,

              "creditLimit":
                  e.creditLimit,

              "billingDay":
                  e.billingDay,

              "dueDay":
                  e.dueDay,

            },

          )

          .toList(),

    );

    StorageService.box.put(

      "categories",

      categories

          .map(

            (e)

                =>

                e.toMap(),

          )

          .toList(),

    );

    StorageService.box.put(

      "budgets",

      budgets

          .map(

            (e)

                =>

                {

"category":
e.category,

"startMonth":
e.startMonth,

"startYear":
e.startYear,

"endMonth":
e.endMonth,

"endYear":
e.endYear,

"monthlyBudget":
e.monthlyBudget,

"savings":
e.savings,

"debt":
e.debt,

"carryForward":
e.carryForward,

},

          )

          .toList(),

    );

  }

}
