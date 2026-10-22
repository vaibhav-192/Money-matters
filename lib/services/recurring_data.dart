import '../database/storage_service.dart';

import '../models/recurring_model.dart';

class RecurringData {

  static List<RecurringModel>
      items = [];

  static load() {

    final data =
        StorageService.box
            .get(
      "recurring",
    );

    if (
      data
      ==
      null
    ) {

      items = [];

      return;

    }

    items =

        (data as List)

            .map<RecurringModel>(

      (e) {

        return RecurringModel(

          id:

              e["id"]

              ??

              DateTime
                  .now()
                  .millisecondsSinceEpoch
                  .toString(),

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

              e["frequency"]

              ??

              "Monthly",

          interval:

              e["interval"]

              ??

              1,

          weekday:
              e["weekday"],

          monthDate:
              e["monthDate"],

          time:
              e["time"],

          startDate:

              e["startDate"]

              ==

              null

                  ?

                  DateTime.now()

                  :

                  DateTime.parse(

                    e["startDate"],

                  ),

          active:

              e["active"]

              ??

              true,

          endingType:

              e["endingType"]

              ??

              "Never",

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

              e["completed"]

              ??

              0,

        );

      },

    ).toList();

  }

  static save() {

    StorageService.box.put(

      "recurring",

      items

          .map(

            (e)

                =>

                {

              "id":
                  e.id,

              "title":
                  e.title,

              "amount":
                  e.amount,

              "type":
                  e.type,

              "account":
                  e.account,

              "frequency":
                  e.frequency,

              "interval":
                  e.interval,

              "weekday":
                  e.weekday,

              "monthDate":
                  e.monthDate,

              "time":
                  e.time,

              "startDate":

                  e.startDate
                      .toIso8601String(),

              "active":
                  e.active,

              "endingType":
                  e.endingType,

              "endDate":

                  e.endDate
                      ?.toIso8601String(),

              "occurrences":
                  e.occurrences,

              "completed":
                  e.completed,

            },

          )

          .toList(),

    );

  }

  static delete(
      String id) {

    items.removeWhere(

      (e)

          =>

          e.id
          ==
          id,

    );

    save();

  }

  static update(
      RecurringModel item,
  ) {

    final index =

        items.indexWhere(

      (e)

          =>

          e.id
          ==
          item.id,

    );

    if (
        index
        >=
        0
    ) {

      items[index] =
          item;

      save();

    }

  }

}