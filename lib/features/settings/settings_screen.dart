import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../services/cloud_service.dart';
import '../../main.dart';
import '../../services/app_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SettingsScreen
    extends StatefulWidget {

  const SettingsScreen({
    super.key,
  });

  @override
  State<SettingsScreen>
      createState()

          =>

          _SettingsScreenState();

}

class _SettingsScreenState
    extends State<
        SettingsScreen> {

  Future openCurrency()
  async {

    String selected =
        AppData.currency;

    await showDialog(

      context:
          context,

      builder:
          (_) {

        return StatefulBuilder(

          builder:

              (
            context,
            setDialog,
          ) {

            return AlertDialog(

              title:

                  const Text(
                "Select Currency",
              ),

              content:

                  DropdownButtonFormField<String>(

value:

[

"₹",

"\$",

"€",

"£",

]

.contains(
selected,
)

?

selected

:

"₹",

items:

const [

DropdownMenuItem(

value:
"₹",

child:

Text(
"₹",
),

),

DropdownMenuItem(

value:
"\$",

child:

Text(
"\$",
),

),

DropdownMenuItem(

value:
"€",

child:

Text(
"€",
),

),

DropdownMenuItem(

value:
"£",

child:

Text(
"£",
),

),

],

onChanged:

(v){

if(

v
==
null

)

return;

setDialog((){

selected =
v;

});

},

),

              actions: [

                ElevatedButton(

                  onPressed:
                      () {

                    AppData.currency =
selected;

AppData.save();

Navigator.pop(
context,
);

Navigator.pushReplacement(

context,

MaterialPageRoute(

builder:

(_)

=>

const MoneyMattersApp(),

),

);

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
    final user =
AuthService.currentUser();
    return Scaffold(

      appBar:

          AppBar(

        title:

            const Text(
          "Settings",
        ),

      ),

      body:

          ListView(

        children: [

          ListTile(

            leading:

                const Icon(
              Icons.currency_exchange,
            ),

            title:

                const Text(
              "Currency",
            ),

            subtitle:

                Text(
              AppData.currency,
            ),

            onTap:
                openCurrency,

          ),

          SwitchListTile(

            secondary:

                const Icon(
              Icons.dark_mode,
            ),

            title:

                const Text(
              "Dark Mode",
            ),

            value:
                AppData.darkMode,

            onChanged:

                (v) {

              AppData.darkMode =
                  v;

              AppData.save();

              Navigator.pushReplacement(

                context,

                MaterialPageRoute(

                  builder:

                      (_)

                          =>

                      const MoneyMattersApp(),

                ),

              );

            },

          ),
          Container(

margin:

const EdgeInsets.only(
bottom:
12,
),

padding:

const EdgeInsets.all(
12,
),

decoration:

BoxDecoration(

color:

AuthService.currentUser()
!=
null

?

Colors.green
.withValues(
alpha:
0.1,
)

:

Colors.orange
.withValues(
alpha:
0.1,
),

borderRadius:

BorderRadius.circular(
12,
),

),

child:

Row(

children:[

Icon(

AuthService.currentUser()
!=
null

?

Icons.cloud_done

:

Icons.cloud_off,

),

const SizedBox(
width:
10,
),

Expanded(

child:

Column(

crossAxisAlignment:

CrossAxisAlignment.start,

children:[

Text(

AuthService.currentUser()
!=
null

?

"Cloud Connected"

:

"Cloud Disconnected",

style:

const TextStyle(

fontWeight:

FontWeight.bold,

),

),

Text(

AuthService.currentUser()

?.email

??

"Sign in to enable backups",

),

],

),

),

],

),

),

FutureBuilder(

future:

FirebaseFirestore.instance

.collection(
"users",
)

.doc(

AuthService.currentUser()

?.uid,

)

.get(),

builder:

(

context,
snapshot,

){

if (

!snapshot.hasData

){

return const SizedBox();

}

final data =

snapshot.data!.data();

if (

data
==
null

||

data[
"lastBackup"
]
==
null

){

return const SizedBox();

}

return Padding(

padding:

const EdgeInsets.only(
bottom:
12,
),

child:

Text(

"Last backup: ${data["lastBackup"]}",

),

);

},
),

          const SizedBox(
height:
20,
),

const Text(

"Cloud",

style:

TextStyle(

fontSize:
18,

fontWeight:
FontWeight.bold,

),

),

ListTile(

leading:

CircleAvatar(

child:

Text(

user
!=
null

?

user.email![0]
.toUpperCase()

:

"?",

),

),

title:

Text(

user
!=
null

?

user.email!

:

"Not signed in",

),

subtitle:

Text(

user
!=
null

?

"Connected"

:

"Tap Sign In",

),

onTap: () async {

if (

user
!=
null

){

return;

}

final result =

await AuthService.signIn();

setState(() {});

},

),

ListTile(

leading:

const Icon(
Icons.cloud_upload,
),

title:

const Text(
"Backup Now",
),

onTap: () async {

final user =

AuthService.currentUser();

if (

user
==
null

){

return;

}

await CloudService.uploadBackup(

user.uid,

);

if (

context.mounted

) {

ScaffoldMessenger.of(
context,
)

.showSnackBar(

const SnackBar(

content:

Text(
"Backup complete",
),

),

);

}

},

),

ListTile(

leading:

const Icon(
Icons.cloud_download,
),

title:

const Text(
"Restore Backup",
),

onTap: () async {

final user =

AuthService.currentUser();

if (

user
==
null

){

ScaffoldMessenger.of(
context,
)

.showSnackBar(

const SnackBar(

content:

Text(
"Please sign in first",
),

),

);

return;

}

showDialog(

context:
context,

barrierDismissible:
false,

builder:

(_)=>

const Center(

child:

CircularProgressIndicator(),

),

);

try {

await CloudService.restoreBackup(

user.uid,

);

await AppData.load();

if (

context.mounted

){

Navigator.pop(
context,
);

setState(() {});

ScaffoldMessenger.of(
context,
)

.showSnackBar(

const SnackBar(

content:

Text(
"Backup restored",
),

),

);

}

}

catch (

e

){

if (

context.mounted

){

Navigator.pop(
context,
);

ScaffoldMessenger.of(
context,
)

.showSnackBar(

SnackBar(

content:

Text(

"Restore failed: $e",

),

),

);

}

}

},

),

ListTile(

leading:

const Icon(
Icons.logout,
),

title:

const Text(
"Logout",
),

onTap: () async {

await AuthService.signOut();

if (

context.mounted

){

setState(() {});

}

ScaffoldMessenger.of(
context,
)

.showSnackBar(

const SnackBar(

content:

Text(
"Logged out",
),

),

);

},

),
          ListTile(

            leading:

                const Icon(
              Icons.analytics,
            ),

            title:

                const Text(
              "Diagnostics",
            ),

            onTap:
                () {

              showDialog(

                context:
                    context,

                builder:
                    (_) {

                  return AlertDialog(

                    title:

                        const Text(
                      "Diagnostics",
                    ),

                    content:

                        Column(

                      mainAxisSize:
                          MainAxisSize.min,

                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,

                      children: [

                        Text(
                          "Transactions: ${AppData.transactions.length}",
                        ),

                        Text(
                          "Accounts: ${AppData.accounts.length}",
                        ),

                        Text(
                          "Categories: ${AppData.categories.length}",
                        ),

                        Text(
                          "Budgets: ${AppData.budgets.length}",
                        ),

                        Text(
                          "Recurring: ${AppData.recurring.length}",
                        ),

                        const SizedBox(
                          height:
                              12,
                        ),

                        Text(
                          "Savings ${AppData.currency}${AppData.globalSavings.toStringAsFixed(0)}",
                        ),

                        Text(
                          "Debt ${AppData.currency}${AppData.globalDebt.toStringAsFixed(0)}",
                        ),

                      ],

                    ),

                    actions: [

                      TextButton(

                        onPressed:
                            () {

                          Navigator.pop(
                            context,
                          );

                        },

                        child:

                            const Text(
                          "Close",
                        ),

                      ),

                    ],

                  );

                },

              );

            },

          ),

        ],

      ),

    );

  }

}