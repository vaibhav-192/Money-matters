import '../models/transaction_model.dart';

import 'app_data.dart';
import 'recurring_data.dart';

class RecurringEngine {

  static run() {

    final now =
        DateTime.now();

    bool changed =
        false;

    for (

      int i = 0;

      i < RecurringData.items.length;

      i++

    ) {

      var recurring =
          RecurringData.items[i];

      if (

        !recurring.active

      ) {

        continue;

      }

      DateTime next =
          recurring.startDate;

      while (

        next.isBefore(
          now,
        )

      ) {

        if (

          recurring.endingType
              ==
              "Date"

        ) {

          if (

            recurring.endDate
                    !=
                    null

                &&

                next.isAfter(
                  recurring.endDate!,
                )

          ) {

            break;

          }

        }

        if (

          recurring.endingType
              ==
              "Occurrences"

        ) {

          if (

            recurring.occurrences
                    !=
                    null

                &&

                recurring.completed
                    >=
                    recurring.occurrences!

          ) {

            break;

          }

        }

        final exists =

AppData.transactions.any(

(t) {

return

t.description
==
recurring.title

&&

t.account
==
recurring.account

&&

t.amount
==
recurring.amount

&&

t.date.year
==
next.year

&&

t.date.month
==
next.month

&&

t.date.day
==
next.day;

},

);

        if (

          !exists

        ) {

          AppData.transactions.add(

            TransactionModel(

              id:

                  DateTime
                      .now()
                      .microsecondsSinceEpoch
                      .toString(),

              amount:
                  recurring.amount,

              type:
                  recurring.type,

              category:
recurring.category,

              description:
                  recurring.title,

              account:
                  recurring.account,

              date:
                  next,

            ),

          );

          final account =

              AppData
                  .accounts
                  .firstWhere(

            (a)

                =>

                a.name
                ==
                recurring.account,

          );

          if (

            recurring.type
                ==
                "Income"

          ) {

            account.balance +=
                recurring.amount;

          }

          else {

            account.balance -=
                recurring.amount;

          }

          recurring =
              recurring.copyWith(

            completed:
                recurring.completed +
                    1,

          );

          RecurringData.items[i] =
              recurring;

          changed =
              true;

        }

        switch (
            recurring.frequency
        ) {

          case "Daily":

            next =
                next.add(

              Duration(

                days:
                    recurring.interval,

              ),

            );

            break;

          case "Weekly":

          case "Weeks":

            next =
                next.add(

              Duration(

                days:
                    recurring.interval *
                        7,

              ),

            );

            break;

          case "Monthly":

          case "Months":

            next =
                DateTime(

              next.year,

              next.month +
                  recurring.interval,

              recurring.monthDate
                  ??
                  next.day,

            );

            break;

          default:

            next =
                next.add(

              Duration(

                days:
                    recurring.interval,

              ),

            );

        }

      }

    }

    if (

      changed

    ) {

      AppData.save();

      RecurringData.save();

    }

  }

}