import 'package:flutter/material.dart';

import '../../models/account_model.dart';
import '../../services/app_data.dart';

import 'transfer_screen.dart';

class AccountsScreen extends StatefulWidget {

  const AccountsScreen({
    super.key,
  });

  @override
  State<AccountsScreen> createState() =>
      _AccountsScreenState();

}

class _AccountsScreenState
    extends State<AccountsScreen> {

  bool showBanks = true;

  bool showCards = true;

  Future openTransfer()
  async {

    await Navigator.push(

      context,

      MaterialPageRoute(

        builder:
            (_)

                =>

                const TransferScreen(),

      ),

    );

    setState(() {});

  }

  Future openEditor({
    AccountModel? account,
  }) async {

    final isNew =
        account == null;

    account ??= AccountModel(

      name: "",

      balance: 0,

    );

    final name =
        TextEditingController(
      text:
          account.name,
    );

    final balance =
        TextEditingController(
      text:
          account.balance
              .toString(),
    );

    final limit =
        TextEditingController(
      text:
          account.creditLimit
              .toString(),
    );

    final billing =
        TextEditingController(
      text:

          account
                  .billingDay

                  ?.toString()

              ??

              "",

    );

    final due =
        TextEditingController(
      text:

          account
                  .dueDay

                  ?.toString()

              ??

              "",

    );

    String type =
        account.type;

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

                  Text(

                isNew

                    ?

                    "Add Account"

                    :

                    "Edit Account",

              ),

              content:

                  SingleChildScrollView(

                child:

                    Column(

                  children: [

                    TextField(

                      controller:
                          name,

                      decoration:

                          const InputDecoration(

                        labelText:
                            "Account Name",

                      ),

                    ),

                    DropdownButtonFormField(

                      value:
                          type,

                      decoration:

                          const InputDecoration(

                        labelText:
                            "Account Type",

                      ),

                      items:

                          [

                        "Bank",

                        "Credit Card",

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

                    TextField(

                      controller:
                          balance,

                      keyboardType:
                          TextInputType
                              .number,

                      decoration:

                          InputDecoration(

                        labelText:

                            type
                                    ==
                                    "Credit Card"

                                ?

                                "Outstanding"

                                :

                                "Starting Balance",

                      ),

                    ),

                    if (
                        type
                        ==
                        "Credit Card"
                    ) ...[

                      TextField(

                        controller:
                            limit,

                        keyboardType:
                            TextInputType
                                .number,

                        decoration:

                            const InputDecoration(

                          labelText:
                              "Credit Limit",

                        ),

                      ),

                      TextField(

                        controller:
                            billing,

                        keyboardType:
                            TextInputType
                                .number,

                        decoration:

                            const InputDecoration(

                          labelText:
                              "Billing Day",

                        ),

                      ),

                      TextField(

                        controller:
                            due,

                        keyboardType:
                            TextInputType
                                .number,

                        decoration:

                            const InputDecoration(

                          labelText:
                              "Due Day",

                        ),

                      ),

                    ],

                  ],

                ),

              ),

              actions: [

                if (!isNew)

                  IconButton(

                    icon:

                        const Icon(
                      Icons.delete,
                    ),

                    onPressed:
                        () {

                      AppData.accounts
                          .remove(
                        account,
                      );

                      AppData.save();

                      Navigator.pop(
                        context,
                      );

                      setState(
                        () {},
                      );

                    },

                  ),

                ElevatedButton(

                  onPressed:
                      () {

                    final updated =
                        account!
                            .copyWith(

                      name:
                          name.text,

                      balance:

                          double.tryParse(
                                balance.text,
                              )
                              ??
                              0,

                      type:
                          type,

                      creditLimit:

                          double.tryParse(
                                limit.text,
                              )
                              ??
                              0,

                      billingDay:

                          int.tryParse(
                            billing.text,
                          ),

                      dueDay:

                          int.tryParse(
                            due.text,
                          ),

                    );

                    if (

                      isNew

                    ) {

                      AppData.accounts
                          .add(
                        updated,
                      );

                    }

                    else {

                      final i =

                          AppData
                              .accounts
                              .indexOf(
                            account,
                          );

                      AppData.accounts[
                          i] = updated;

                    }

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

  Widget section({

  required String title,

  required List<AccountModel> items,

  required bool open,

  required VoidCallback toggle,

}) {

  Color utilizationColor(
      double value) {

    if (value >= 70) {
      return Colors.red;
    }

    if (value >= 30) {
      return Colors.orange;
    }

    return Colors.green;

  }

  Future payCard(
      AccountModel card)
  async {

    final banks =

        AppData.accounts
            .where(
              (e) => !e.isCard,
            )
            .toList();

    if (
        banks.isEmpty
    ) {
      return;
    }

    String bank =
        banks.first.name;

    final amount =
        TextEditingController();

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

                  Text(
                "Pay ${card.name}",
              ),

              content:

                  Column(

                mainAxisSize:
                    MainAxisSize.min,

                children: [

                  DropdownButtonFormField(

                    value:
                        bank,

                    decoration:

                        const InputDecoration(

                      labelText:
                          "Pay From",

                    ),

                    items:

                        banks
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

                        (v) {

                      bank =
                          v!;

                    },

                  ),

                  const SizedBox(
                    height:
                        16,
                  ),

                  TextField(

                    controller:
                        amount,

                    keyboardType:
                        TextInputType
                            .number,

                    decoration:

                        InputDecoration(

                      labelText:
                          "Amount",

                      prefixText:
                          "${AppData.currency} ",

                    ),

                  ),

                ],

              ),

              actions: [

                ElevatedButton(

                  onPressed:
                      () {

                    final value =

                        double.tryParse(
                              amount.text,
                            )
                            ??
                            0;

                    if (
                        value <= 0
                    ) {

                      return;

                    }

                    final source =

                        AppData.accounts
                            .firstWhere(

                          (e)

                              =>

                              e.name
                              ==
                              bank,

                        );

                    if (
                        source.balance
                        <
                        value
                    ) {

                      return;

                    }

                    source.balance -=
                        value;

                    card.balance -=
                        value;

                    if (
                        card.balance
                        <
                        0
                    ) {

                      card.balance =
                          0;

                    }

                    AppData.save();

                    Navigator.pop(
                      context,
                    );

                    setState(() {});

                  },

                  child:

                      const Text(
                    "Pay",
                  ),

                ),

              ],

            );

          },

        );

      },

    );

  }

  return Column(

    children: [

      ListTile(

        title:
            Text(
          title,
        ),

        trailing:

            Icon(

          open

              ?

              Icons.expand_less

              :

              Icons.expand_more,

        ),

        onTap:
            toggle,

      ),

      if (open)

        ...items.map(

          (account) {

            final dueSoon =

                account.isCard

                    &&

                    account.dueDay != null

                    &&

                    account.dueDay! <= 3;

            return Card(

              child:

                  Padding(

                padding:

                    const EdgeInsets
                        .all(
                  12,
                ),

                child:

                    Column(

                  children: [

                    ListTile(

                      leading:

                          Icon(

                        account.isCard

                            ?

                            Icons.credit_card

                            :

                            Icons.account_balance,

                      ),

                      title:

                          Text(
                        account.name,
                      ),

                      subtitle:

                          account.isCard

                              ?

                              Column(

                                  crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,

                                  children: [

                                    Text(
                                      "Outstanding ${AppData.currency}${account.balance.toStringAsFixed(0)}",
                                    ),

                                    Text(
                                      "Limit ${AppData.currency}${account.creditLimit.toStringAsFixed(0)}",
                                    ),

                                    const SizedBox(
                                      height:
                                          8,
                                    ),

                                    LinearProgressIndicator(

                                      value:

                                          account.creditLimit
                                                  ==
                                                  0

                                              ?

                                              0

                                              :

                                              account.balance /

                                                  account.creditLimit,

                                      color:

                                          utilizationColor(

                                        account.utilization,

                                      ),

                                    ),

                                    const SizedBox(
                                      height:
                                          6,
                                    ),

                                    Text(

                                      "Utilization ${account.utilization.toStringAsFixed(1)}%",

                                    ),

                                    Text(

                                      "Available ${AppData.currency}${account.available.toStringAsFixed(0)}",

                                    ),

                                    Text(

                                      "Bill ${account.billingDay ?? "-"} • Due ${account.dueDay ?? "-"}",

                                    ),

                                    if (dueSoon)

                                      const Text(

                                        "⚠ Pay soon",

                                      ),

                                  ],

                                )

                              :

                              Text(

                                  "${AppData.currency}${account.balance.toStringAsFixed(2)}"),

                      onTap:
                          () {

                        openEditor(
                          account:
                              account,
                        );

                      },

                    ),

                    if (account.isCard)

                      Align(

                        alignment:
                            Alignment
                                .centerRight,

                        child:

                            ElevatedButton.icon(

                          icon:

                              const Icon(
                            Icons.payment,
                          ),

                          label:

                              const Text(
                            "PAY",
                          ),

                          onPressed:
                              () {

                            payCard(
                              account,
                            );

                          },

                        ),

                      ),

                  ],

                ),

              ),

            );

          },

        ),

    ],

  );

}

  @override
  Widget build(
      BuildContext context) {

    final banks =

        AppData.accounts

            .where(

              (e)

                  =>

                  !e.isCard,

            )

            .toList();

    final cards =

        AppData.accounts

            .where(

              (e)

                  =>

                  e.isCard,

            )

            .toList();

    return Scaffold(

      appBar:

          AppBar(

        title:

            const Text(
          "Accounts",
        ),

        actions: [

          IconButton(

            icon:

                const Icon(
              Icons.swap_horiz,
            ),

            onPressed:
                openTransfer,

          ),

        ],

      ),

      floatingActionButton:

          Column(

        mainAxisAlignment:
            MainAxisAlignment
                .end,

        children: [

          FloatingActionButton(

            heroTag:
                "add",

            child:

                const Icon(
              Icons.add,
            ),

            onPressed:
                () {

              openEditor();

            },

          ),

          const SizedBox(
            height:
                12,
          ),

          FloatingActionButton(

            heroTag:
                "transfer",

            child:

                const Icon(
              Icons.swap_horiz,
            ),

            onPressed:
                openTransfer,

          ),

        ],

      ),

      body:

          ListView(

        children: [

          section(

            title:
                "🏦 Bank Accounts",

            items:
                banks,

            open:
                showBanks,

            toggle:
                () {

              setState(() {

                showBanks =
                    !showBanks;

              });

            },

          ),

          section(

            title:
                "💳 Cards",

            items:
                cards,

            open:
                showCards,

            toggle:
                () {

              setState(() {

                showCards =
                    !showCards;

              });

            },

          ),

        ],

      ),

    );

  }

}