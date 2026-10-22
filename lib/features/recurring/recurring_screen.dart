import 'package:flutter/material.dart';

import '../../models/recurring_model.dart';
import '../../services/app_data.dart';
import '../../services/recurring_data.dart';

class RecurringScreen extends StatefulWidget {
  const RecurringScreen({super.key});

  @override
  State<RecurringScreen> createState() =>
      _RecurringScreenState();
}

class _RecurringScreenState
    extends State<RecurringScreen> {

  @override
  void initState() {
    super.initState();
    RecurringData.load();
  }

  Future<void> openEditor({
    RecurringModel? item,
  }) async {

    final isNew =
        item == null;

    item ??= RecurringModel(
      id: DateTime.now()
          .millisecondsSinceEpoch
          .toString(),
      title: "",
      amount: 0,
      type: "Expense",
      account:

AppData.accounts.isNotEmpty

?

AppData.accounts.first.name

:

"Cash",
      category:

AppData.categories.isNotEmpty

?

AppData.categories.first.name

:

"General",
      frequency: "Daily",
      interval: 1,
      weekday: 1,
      monthDate: 1,
      time: "09:00",
      startDate: DateTime.now(),
      active: true,
      endingType: "Never",
      endDate: null,
      occurrences: null,
      completed: 0,
    );

    final title =
        TextEditingController(
      text: item.title,
    );

    final amount =
        TextEditingController(
      text:
          item.amount.toString(),
    );

    final interval =
        TextEditingController(
      text:
          item.interval.toString(),
    );

    final occurrence =
        TextEditingController(
      text:
          item.occurrences
                  ?.toString()
              ??
              "",
    );

    String type =
        item.type;

    String account =

AppData.accounts.any(

(e)=>

e.name
==
item?.account,

)

?

item!.account

:

AppData.accounts.isNotEmpty

?

AppData.accounts.first.name

:

"Cash";

String category =

AppData.categories.any(

(e)=>

"${e.type}|${e.name}"

==

item?.category,

)

?

item!.category

:

AppData.categories.isNotEmpty

?

"${AppData.categories.first.type}|${AppData.categories.first.name}"

:

"Expense|Other";

String frequency =
    item.frequency;

    String ending =
        item.endingType;

    bool active =
        item.active;

    int weekday =
        item.weekday ?? 1;

    int monthDate =
        item.monthDate ?? 1;

    DateTime? endDate =
        item.endDate;

    String time =
        item.time ??
            "09:00";

    String customUnit =
        "Days";

    await showDialog(

      context: context,

      builder: (_) {

        return StatefulBuilder(

          builder:

              (
            context,
            setLocal,
          ) {

            Future pickTime()
            async {

              final picked =
                  await showTimePicker(

                context:
                    context,

                initialTime:
                    TimeOfDay.now(),

              );

              if (

                picked
                !=
                null

              ) {

                setLocal(() {

                  time =
                      picked.format(
                    context,
                  );

                });

              }

            }

            Future pickDate()
            async {

              final picked =
                  await showDatePicker(

                context:
                    context,

                initialDate:
                    endDate ??
                        DateTime.now(),

                firstDate:
                    DateTime(
                        2020),

                lastDate:
                    DateTime(
                        2100),

              );

              if (

                picked
                !=
                null

              ) {

                setLocal(() {

                  endDate =
                      picked;

                });

              }

            }

            return AlertDialog(

              title: Text(

                isNew

                    ?

                    "Add Recurring"

                    :

                    "Edit Recurring",

              ),

              content:
                  SingleChildScrollView(

                child:
                    Column(

                  children: [

                    TextField(
                      controller:
                          title,
                      decoration:
                          const InputDecoration(
                        labelText:
                            "Title",
                      ),
                    ),

                    TextField(
                      controller:
                          amount,
                      keyboardType:
                          TextInputType
                              .number,
                      decoration:
                          const InputDecoration(
                        labelText:
                            "Amount",
                      ),
                    ),

                    DropdownButtonFormField(

                      value:
                          type,

                      decoration:
                          const InputDecoration(
                        labelText:
                            "Type",
                      ),

                      items:

                          [
                        "Expense",
                        "Income"
                      ]

                              .map(

                                (e)

                                    =>

                                    DropdownMenuItem(

                                  value:
                                      e,

                                  child:
                                      Text(
                                    e,
                                  ),

                                ),

                              )

                              .toList(),

                      onChanged:
                          (v) {

                        setLocal(() {

                          type =
                              v!;

                        });

                      },

                    ),

                    DropdownButtonFormField(

                      value:

AppData.accounts.any(

(e)=>

e.name
==
account,

)

?

account

:

null,

                      decoration:
                          const InputDecoration(
                        labelText:
                            "Account",
                      ),

                      items:

                          AppData
                              .accounts
                              .map(

                                (e)

                                    =>

                                    DropdownMenuItem(

                                  value:
                                      e.name,

                                  child:
                                      Text(
                                    e.name,
                                  ),

                                ),

                              )

                              .toList(),

                      onChanged:

(v){

if(
v
!=
null
){

setLocal((){

account =
v;

});

}

},

                    ),

                    DropdownButtonFormField<String>(

value:

AppData.categories.any(

(e)=>

"${e.type}|${e.name}"

==
category,

)

?

category

:

null,

decoration:

const InputDecoration(

labelText:
"Category",

),

items:

AppData.categories

.map(

(e)

=>

DropdownMenuItem<String>(

value:

"${e.type}|${e.name}",

child:

Text(

"${e.type} • ${e.name}",

),

),

)

.toList(),

onChanged:

(v){

if(
v
!=
null
){

setLocal((){

category =
v;

});

}

},

),

                    DropdownButtonFormField(

                      value:
                          frequency,

                      decoration:
                          const InputDecoration(
                        labelText:
                            "Frequency",
                      ),

                      items:

                          [
                        "Daily",
                        "Weekly",
                        "Monthly",
                        "Custom"
                      ]

                              .map(

                                (e)

                                    =>

                                    DropdownMenuItem(

                                  value:
                                      e,

                                  child:
                                      Text(
                                    e,
                                  ),

                                ),

                              )

                              .toList(),

                      onChanged:
                          (v) {

                        setLocal(() {

                          frequency =
                              v!;

                        });

                      },

                    ),

                    if (
                        frequency
                        ==
                        "Custom"
                    ) ...[

                      TextField(
                        controller:
                            interval,
                        decoration:
                            const InputDecoration(
                          labelText:
                              "Number",
                        ),
                      ),

                      DropdownButtonFormField(

                        value:
                            customUnit,

                        items:

                            [
                          "Days",
                          "Weeks",
                          "Months"
                        ]

                                .map(

                                  (e)

                                      =>

                                      DropdownMenuItem(

                                    value:
                                        e,

                                    child:
                                        Text(
                                      e,
                                    ),

                                  ),

                                )

                                .toList(),

                        onChanged:
                            (v) {

                          setLocal(() {

                            customUnit =
                                v!;

                          });

                        },

                      ),

                    ],

                    if (
                        frequency ==
                            "Daily" ||
                        customUnit ==
                            "Days"
                    )

                      ListTile(

                        title:
                            Text(
                          "Time: $time",
                        ),

                        onTap:
                            pickTime,

                      ),

                    if (
                        frequency ==
                            "Weekly" ||
                        customUnit ==
                            "Weeks"
                    )

                      DropdownButtonFormField(

                        value:
                            weekday,

                        decoration:
                            const InputDecoration(
                          labelText:
                              "Day",
                        ),

                        items: [

  "Sunday",

  "Monday",

  "Tuesday",

  "Wednesday",

  "Thursday",

  "Friday",

  "Saturday",

]

.asMap()

.entries

.map(

  (e)

      =>

      DropdownMenuItem(

    value:
        e.key + 1,

    child:
        Text(
      e.value,
    ),

  ),

)

.toList(),

                        onChanged:
                            (v) {

                          setLocal(() {

                            weekday =
                                v!;

                          });

                        },

                      ),

                    if (
                        frequency ==
                            "Monthly" ||
                        customUnit ==
                            "Months"
                    )

                      TextField(

                        decoration:
                            InputDecoration(

                          labelText:
                              "Date",

                          hintText:
                              monthDate
                                  .toString(),

                        ),

                        onChanged:
                            (v) {

                          monthDate =
                              int.tryParse(
                                    v,
                                  )
                                  ??
                                  1;

                        },

                      ),

                    SwitchListTile(

                      value:
                          active,

                      title:
                          const Text(
                        "Active",
                      ),

                      onChanged:
                          (v) {

                        setLocal(() {

                          active =
                              v;

                        });

                      },

                    ),

                    DropdownButtonFormField(

                      value:
                          ending,

                      items:

                          [
                        "Never",
                        "Date",
                        "Occurrences"
                      ]

                              .map(

                                (e)

                                    =>

                                    DropdownMenuItem(

                                  value:
                                      e,

                                  child:
                                      Text(
                                    e,
                                  ),

                                ),

                              )

                              .toList(),

                      onChanged:
                          (v) {

                        setLocal(() {

                          ending =
                              v!;

                        });

                      },

                    ),

                    if (
                        ending ==
                        "Date"
                    )

                      ListTile(

                        title:
                            Text(

                          endDate ==
                                  null

                              ?

                              "Select End Date"

                              :

                              endDate
                                  .toString()
                                  .split(
                                      " ")[0],

                        ),

                        onTap:
                            pickDate,

                      ),

                    if (
                        ending ==
                        "Occurrences"
                    )

                      TextField(

                        controller:
                            occurrence,

                        decoration:
                            const InputDecoration(
                          labelText:
                              "Occurrences",
                        ),

                      ),

                  ],

                ),

              ),

              actions: [

                if (!isNew)

                  IconButton(

                    onPressed: () {

                      RecurringData.delete(
                        item!.id,
                      );

                      Navigator.pop(
                        context,
                      );

                      setState(() {});

                    },

                    icon:
                        const Icon(
                      Icons.delete,
                    ),

                  ),

                ElevatedButton(

                  onPressed: () {

                    final updated =
                        item!.copyWith(

                      title:
                          title.text,

                      amount:

                          double.tryParse(
                                amount.text,
                              )
                              ??
                              0,
                      
                      category:
category.split("|")[1],

                      type:
                          type,

                      account:
                          account,

                      frequency:

                          frequency ==
                                  "Custom"

                              ?

                              customUnit

                              :

                              frequency,

                      interval:

                          int.tryParse(
                                interval.text,
                              )
                              ??
                              1,

                      weekday:
                          weekday,

                      monthDate:
                          monthDate,

                      time:
                          time,

                      active:
                          active,

                      endingType:
                          ending,

                      endDate:
                          endDate,

                      occurrences:

                          int.tryParse(
                            occurrence.text,
                          ),

                    );

                    if (isNew) {
                      RecurringData.items
                          .add(
                        updated,
                      );
                    } else {
                      RecurringData
                          .update(
                        updated,
                      );
                    }

                    RecurringData
                        .save();

                    Navigator.pop(
                      context,
                    );

                    setState(() {});
                  },

                  child:
                      const Text(
                    "Save",
                  ),

                ),

              ],

            );

          },

        );

      },

    );

  }

  @override
  Widget build(
      BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title:
            const Text(
          "Recurring",
        ),
      ),

      floatingActionButton:
          FloatingActionButton(

        onPressed:
            () {

          openEditor();

        },

        child:
            const Icon(
          Icons.add,
        ),

      ),

      body:
          ListView.builder(

        itemCount:
            RecurringData
                .items
                .length,

        itemBuilder:

            (
          context,
          index,
        ) {

          final item =
              RecurringData
                  .items[index];

          return ListTile(

            title:
                Text(
              item.title,
            ),

            subtitle:
                Text(
              "${item.frequency} • ${AppData.currency}${item.amount}",
            ),

            trailing:
                Icon(

              item.active

                  ?

                  Icons.repeat

                  :

                  Icons.pause,

            ),

            onTap:
                () {

              openEditor(
                item: item,
              );

            },

          );

        },

      ),

    );

  }

}