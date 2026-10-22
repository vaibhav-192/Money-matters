import 'package:cloud_firestore/cloud_firestore.dart';

import 'app_data.dart';

class CloudService {

static final db =

FirebaseFirestore.instance;

static Future<void> uploadBackup(

String uid,

) async {

await db

.collection(
"users",
)

.doc(
uid,
)

.set({

"currency":
AppData.currency,

"darkMode":
AppData.darkMode,

"globalSavings":
AppData.globalSavings,

"globalDebt":
AppData.globalDebt,

"transactions":

AppData.transactions

.map(

(e)=>

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

"accounts":

AppData.accounts

.map(

(e)=>

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

"categories":

AppData.categories

.map(
(e)=>e.toMap(),
)

.toList(),

"budgets":

AppData.budgets

.map(

(e)=>

e.toMap(),

)

.toList(),

"updatedAt":

Timestamp.now(),

"lastBackup":

DateTime.now()

.toIso8601String(),

});

}

static Future<bool> restoreBackup(

String uid,

) async {

final doc =

await db

.collection(
"users",
)

.doc(
uid,
)

.get();

if (

!doc.exists

) {

return false;

}

final data =
doc.data();

if (

data
==
null

){

return false;

}

AppData.currency =

data[
"currency"
]

??

AppData.currency;

AppData.darkMode =

data[
"darkMode"
]

??

true;

AppData.save();

return true;

}

}