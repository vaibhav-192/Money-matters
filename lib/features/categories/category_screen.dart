import 'package:flutter/material.dart';

import '../../services/app_data.dart';
import '../../models/category_model.dart';

class CategoryScreen
    extends StatefulWidget {

  const CategoryScreen({
    super.key,
  });

  @override
  State<CategoryScreen>
      createState()

          =>

          _CategoryScreenState();

}

class _CategoryScreenState
    extends State<
        CategoryScreen> {

  void addCategory()
  async {

    final controller =
        TextEditingController();

    String type =
        "Expense";

    await showDialog(

      context:
          context,

      builder:
          (_) {

        return StatefulBuilder(

          builder:

              (
            context,
            setLocal,
          ) {

            return AlertDialog(

              title:

                  const Text(
                "Add Category",
              ),

              content:

                  Column(

                mainAxisSize:
                    MainAxisSize.min,

                children: [

                  TextField(

                    controller:
                        controller,

                    decoration:

                        const InputDecoration(

                      labelText:
                          "Category",

                    ),

                  ),

                  const SizedBox(
                    height:
                        12,
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

                      "Income",

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
                            v
                                as String;

                      });

                    },

                  ),

                ],

              ),

              actions: [

                ElevatedButton(

                  onPressed:
                      () {

                    if (

                      controller
                          .text
                          .trim()
                          .isEmpty

                    ) {

                      return;

                    }

                    AppData
                        .categories
                        .add(

                      CategoryModel(

                        name:

                            controller
                                .text,

                        type:
                            type,

                      ),

                    );

                    AppData.save();

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

    final income =

        AppData.categories

            .where(
              (
                e,
              ) =>
                  e.isIncome,
            )

            .toList();

    final expense =

        AppData.categories

            .where(
              (
                e,
              ) =>
                  e.isExpense,
            )

            .toList();

    Widget section(
      String title,
      List items,
    ) {

      return Column(

        children: [

          Padding(

            padding:

                const EdgeInsets
                    .all(
              16,
            ),

            child:

                Text(

              title,

              style:

                  const TextStyle(

                fontSize:
                    20,

                fontWeight:
                    FontWeight.bold,

              ),

            ),

          ),

          ...items.map(

            (
              e,
            ) {

              return ListTile(

                title:

                    Text(
                  e.name,
                ),

                trailing:

                    e.isDefault

                        ?

                        const Icon(
                          Icons.lock,
                        )

                        :

                        IconButton(

                          icon:

                              const Icon(
                            Icons.delete,
                          ),

                          onPressed:
                              () {

                            AppData
                                .categories
                                .remove(
                              e,
                            );

                            AppData.save();

                            setState(
                              () {},
                            );

                          },

                        ),

              );

            },

          ),

        ],

      );

    }

    return Scaffold(

      appBar:

          AppBar(

        title:

            const Text(
          "Categories",
        ),

      ),

      floatingActionButton:

          FloatingActionButton(

        onPressed:
            addCategory,

        child:

            const Icon(
          Icons.add,
        ),

      ),

      body:

          ListView(

        children: [

          section(
            "Income",
            income,
          ),

          section(
            "Expense",
            expense,
          ),

        ],

      ),

    );

  }

}