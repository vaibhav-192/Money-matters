class BudgetModel {

String category;

double monthlyBudget;

double savings;

double debt;

bool carryForward;

final int startMonth;

final int startYear;

int? endMonth;

int? endYear;

BudgetModel({

required this.category,

required this.monthlyBudget,

this.savings = 0,

this.debt = 0,

this.carryForward = true,

required this.startMonth,

required this.startYear,

this.endMonth,

this.endYear,

});

Map<String,dynamic> toMap() {

return {

"category":
category,

"monthlyBudget":
monthlyBudget,

"savings":
savings,

"debt":
debt,

"carryForward":
carryForward,

"startMonth":
startMonth,

"startYear":
startYear,

"endMonth":
endMonth,

"endYear":
endYear,

};

}

factory BudgetModel.fromMap(
Map map,
) {

return BudgetModel(

category:

map[
"category"
]

??

"",

monthlyBudget:

(

map[
"monthlyBudget"
]

??

0

)

.toDouble(),

savings:

(

map[
"savings"
]

??

0

)

.toDouble(),

debt:

(

map[
"debt"
]

??

0

)

.toDouble(),

carryForward:

map[
"carryForward"
]

??

true,

startMonth:

map[
"startMonth"
]

??

DateTime.now().month,

startYear:

map[
"startYear"
]

??

DateTime.now().year,

endMonth:

map[
"endMonth"
],

endYear:

map[
"endYear"
],

);

}

}