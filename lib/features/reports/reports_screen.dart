import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../services/app_data.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  String selectedAccount = "All";
  String selectedMonth = "All";
  String selectedYear = "All";

  static const List<String> monthNames = [
    "Jan", "Feb", "Mar", "Apr", "May", "Jun",
    "Jul", "Aug", "Sep", "Oct", "Nov", "Dec",
  ];

  String monthToNumber(String monthName) {
    if (monthName == "All") return "All";
    int index = monthNames.indexOf(monthName);
    return (index + 1).toString();
  }

  bool allow(tx) {
    bool accountOk = selectedAccount == "All" || tx.account == selectedAccount;
    String monthNumber = monthToNumber(selectedMonth);
    bool monthOk = monthNumber == "All" || tx.date.month.toString() == monthNumber;
    bool yearOk = selectedYear == "All" || tx.date.year.toString() == selectedYear;
    return accountOk && monthOk && yearOk;
  }

  late List<dynamic> _filtered;
  late double _income;
  late double _expense;
  late Map<String, double> _expenseByCategory;
  late Map<String, double> _incomeByCategory;
  late Map<String, int> _accountUsage;
  late List<double> _monthlyData;

  void computeReports() {
    _filtered = AppData.transactions.where((t) => allow(t)).toList();
    _income = 0;
    _expense = 0;
    _expenseByCategory = {};
    _incomeByCategory = {};
    _accountUsage = {};
    _monthlyData = List.filled(12, 0);

    for (var t in _filtered) {
      if (t.type == "Income") {
        _income += t.amount;
        _incomeByCategory[t.category] = (_incomeByCategory[t.category] ?? 0) + t.amount;
      } else {
        _expense += t.amount;
        _expenseByCategory[t.category] = (_expenseByCategory[t.category] ?? 0) + t.amount;
      }

      _accountUsage[t.account] = (_accountUsage[t.account] ?? 0) + 1;

      int m = t.date.month - 1;
      if (t.type == "Income") {
        _monthlyData[m] += t.amount;
      } else {
        _monthlyData[m] -= t.amount;
      }
    }
  }

  List<dynamic> get filtered => _filtered;
  double get income => _income;
  double get expense => _expense;
  double get savings => income - expense;

  double get netBalance {
    double total = 0;
    for (var acc in AppData.accounts) {
      total += acc.balance;
    }
    return total;
  }

  String get highestSpendCategory {
    if (_expenseByCategory.isEmpty) return "N/A";
    String highest = _expenseByCategory.keys.first;
    for (var key in _expenseByCategory.keys) {
      if (_expenseByCategory[key]! > _expenseByCategory[highest]!) {
        highest = key;
      }
    }
    return highest;
  }

  String get highestIncomeCategory {
    if (_incomeByCategory.isEmpty) return "N/A";
    String highest = _incomeByCategory.keys.first;
    for (var key in _incomeByCategory.keys) {
      if (_incomeByCategory[key]! > _incomeByCategory[highest]!) {
        highest = key;
      }
    }
    return highest;
  }

  String get mostUsedAccount {
    if (_accountUsage.isEmpty) return "N/A";
    String most = _accountUsage.keys.first;
    for (var key in _accountUsage.keys) {
      if (_accountUsage[key]! > _accountUsage[most]!) {
        most = key;
      }
    }
    return most;
  }

  double get averageDailyExpense {
    if (filtered.isEmpty) return 0;
    DateTime? earliest;
    DateTime? latest;
    for (var t in filtered) {
      if (earliest == null || t.date.isBefore(earliest)) {
        earliest = t.date;
      }
      if (latest == null || t.date.isAfter(latest)) {
        latest = t.date;
      }
    }
    if (earliest == null || latest == null) return 0;
    int days = latest.difference(earliest).inDays + 1;
    if (days <= 0) return expense;
    return expense / days;
  }

  Widget summaryCard(String label, double amount, Color color) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
            const SizedBox(height: 8),
            Text(
              '${AppData.currency}${amount.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color),
            ),
          ],
        ),
      ),
    );
  }

  void _resetFilters() {
    setState(() {
      selectedAccount = "All";
      selectedMonth = "All";
      selectedYear = "All";
    });
  }

  @override
  Widget build(BuildContext context) {
    computeReports();

    final accounts = [
  "All",
  ...AppData.accounts.map((e) => e.name),
];

final availableMonths = [

  "All",

  ...AppData.transactions

      .where(

        (e) =>

            selectedYear == "All"

                ||

                e.date.year
                        .toString()

                    ==

                    selectedYear,

      )

      .map(
        (e) =>
            monthNames[
                e.date.month -
                    1],
      )

      .toSet()

      .toList(),

];
    final isEmpty = filtered.isEmpty;

    final expByCategory = _expenseByCategory.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    final incByCategory = _incomeByCategory.entries.toList()..sort((a, b) => b.value.compareTo(a.value));

    return Scaffold(
      appBar: AppBar(title: const Text("Reports")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text("OVERVIEW",
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Colors.grey, letterSpacing: 1.2)),
              const SizedBox(height: 12),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                children: [
                  summaryCard("Total Income", income, Colors.green),
                  summaryCard("Total Expense", expense, Colors.red),
                  summaryCard("Savings", savings, savings >= 0 ? Colors.blue : Colors.orange),
                  summaryCard("Net Balance", netBalance, Colors.purple),
                ],
              ),
              const SizedBox(height: 32),
              Align(
                alignment: Alignment.centerLeft,
                child: Text("FILTERS",
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Colors.grey, letterSpacing: 1.2)),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField(
                value: selectedAccount,
                decoration: const InputDecoration(
                  labelText: "Account",
                  border: OutlineInputBorder(),
                ),
                items: accounts.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (v) => setState(() => selectedAccount = v!),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(

  value:
      selectedMonth,

  decoration:

      const InputDecoration(

    labelText:
        "Month",

    border:
        OutlineInputBorder(),

  ),

  items:

      availableMonths

          .map(

            (e)

                =>

                DropdownMenuItem<String>(

              value:
                  e,

              child:

                  Text(

                e == "All"

                    ?

                    "All Months"

                    :

                    e,

              ),

            ),

          )

          .toList(),

  onChanged:

      (v) {

    setState(() {

      selectedMonth =
          v!;

    });

  },

),
              const SizedBox(height: 12),
              DropdownButtonFormField(
                value: selectedYear,
                decoration: const InputDecoration(
                  labelText: "Year",
                  border: OutlineInputBorder(),
                ),
                items: [

  "All",

  ...AppData.transactions

      .map(
        (e) =>
            e.date.year
                .toString(),
      )

      .toSet()

      .toList()

      ..sort(),

]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged:

(v) {

setState(() {

selectedYear =
v as String;

// reset month
selectedMonth =
"All";

});

},
              ),
              const SizedBox(height: 32),
              if (isEmpty)
                Column(
                  children: [
                    SizedBox(height: 60),
                    Icon(Icons.analytics_outlined, size: 64, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text(
                      "No transactions found",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.grey[700], fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Try changing filters",
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _resetFilters,
                      child: const Text("Reset Filters"),
                    ),
                    SizedBox(height: 60),
                  ],
                )
              else
                Column(
                  children: [
                    Align(

alignment:
Alignment.centerLeft,

child:

Text(

"CHARTS",

style:

Theme.of(context)

.textTheme

.titleSmall

?.copyWith(

color:
Colors.grey,

letterSpacing:
1.2,

),

),

),

const SizedBox(
height:
12,
),

if (AppData.accounts.isNotEmpty) ...[

Card(

child:

Padding(

padding:

const EdgeInsets.all(
16,
),

child:

Column(

crossAxisAlignment:
CrossAxisAlignment.start,

children: [

const Text(

"Account Split",

style:

TextStyle(

fontWeight:
FontWeight.bold,

fontSize:
16,

),

),

const SizedBox(
height:
12,
),

...AppData.accounts.map(

(acc) {

double pct =

netBalance == 0

?

0

:

(acc.balance.abs()

/

netBalance.abs())

*

100;

return Padding(

padding:

const EdgeInsets.only(
bottom:
10,
),

child:

Column(

crossAxisAlignment:
CrossAxisAlignment.start,

children: [

Row(

mainAxisAlignment:

MainAxisAlignment
.spaceBetween,

children: [

Text(
acc.name,
),

Text(

"${pct.toStringAsFixed(1)}%",

),

],

),

const SizedBox(
height:
6,
),

LinearProgressIndicator(

value:

pct
/
100,

),

],

),

);

},

),

],

),

),

),

const SizedBox(
height:
24,
),

Card(

child:

Padding(

padding:

const EdgeInsets.all(
16,
),

child:

Column(

crossAxisAlignment:
CrossAxisAlignment.start,

children: [

const Text(

"Cash Flow",

style:

TextStyle(

fontWeight:
FontWeight.bold,

fontSize:
16,

),

),

const SizedBox(
height:
16,
),

ListTile(

title:
const Text(
"Income",
),

trailing:

Text(

"${AppData.currency}${income.toStringAsFixed(0)}",

style:

const TextStyle(

color:
Colors.green,

),

),

),

ListTile(

title:
const Text(
"Expense",
),

trailing:

Text(

"${AppData.currency}${expense.toStringAsFixed(0)}",

style:

const TextStyle(

color:
Colors.red,

),

),

),

ListTile(

title:
const Text(
"Savings",
),

trailing:

Text(

"${AppData.currency}${savings.toStringAsFixed(0)}",

style:

TextStyle(

color:

savings >= 0

?

Colors.blue

:

Colors.orange,

),

),

),

],

),

),

),

const SizedBox(
height:
24,
),

if (filtered.isNotEmpty)

Card(

child:

Padding(

padding:

const EdgeInsets.all(
16,
),

child:

Column(

crossAxisAlignment:
CrossAxisAlignment.start,

children: [

const Text(

"Top Transactions",

style:

TextStyle(

fontWeight:
FontWeight.bold,

fontSize:
16,

),

),

const SizedBox(
height:
12,
),

...([

...filtered,

]

..sort(

(a, b)

=>

b.amount.compareTo(
a.amount,
),

))

.take(
5,
)

.map(

(tx)

=>

ListTile(

dense:
true,

title:

Text(

tx.description
.isEmpty

?

tx.category

:

tx.description,

),

subtitle:

Text(
tx.account,
),

trailing:

Text(

"${AppData.currency}${tx.amount.toStringAsFixed(0)}",

),

),

),
],

),

),

),

const SizedBox(
height:
24,
),

],
                    if (expByCategory.isNotEmpty) ...[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Expense Categories",
                            style: Theme.of(context).textTheme.titleMedium),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 250,
                        child: PieChart(
                          PieChartData(
                            sections: expByCategory
                                .map((entry) {
                                  double percentage = entry.value / expense * 100;
                                  return PieChartSectionData(
                                    value: entry.value,
                                    title:
                                        '${entry.key}\n${AppData.currency}${entry.value.toStringAsFixed(0)}\n${percentage.toStringAsFixed(1)}%',
                                    radius: 100,
                                    titleStyle: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  );
                                })
                                .toList(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                    if (incByCategory.isNotEmpty) ...[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Income Categories",
                            style: Theme.of(context).textTheme.titleMedium),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 250,
                        child: PieChart(
                          PieChartData(
                            sections: incByCategory
                                .map((entry) {
                                  double percentage = entry.value / income * 100;
                                  return PieChartSectionData(
                                    value: entry.value,
                                    title:
                                        '${entry.key}\n${AppData.currency}${entry.value.toStringAsFixed(0)}\n${percentage.toStringAsFixed(1)}%',
                                    radius: 100,
                                    titleStyle: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  );
                                })
                                .toList(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                    SizedBox(
                      height: 250,
                      child: LineChart(
                        LineChartData(
                          gridData: FlGridData(show: true),
                          titlesData: FlTitlesData(
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  int index = value.toInt();
                                  if (index < 0 || index >= 12) {
                                    return const SizedBox.shrink();
                                  }
                                  return Text(monthNames[index],
                                      style: const TextStyle(fontSize: 10));
                                },
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: true),
                            ),
                          ),
                          borderData: FlBorderData(show: true),
                          minX: 0,
                          maxX: 11,
                          minY: _monthlyData.reduce((a, b) => a < b ? a : b),
                          maxY: _monthlyData.reduce((a, b) => a > b ? a : b),
                          lineBarsData: [
                            LineChartBarData(
                              spots: List.generate(
                                12,
                                (index) => FlSpot(index.toDouble(), _monthlyData[index]),
                              ),
                              isCurved: true,
                              color: Colors.blue,
                              barWidth: 2,
                              isStrokeCapRound: true,
                              dotData: FlDotData(show: true),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text("INSIGHTS",
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: Colors.grey, letterSpacing: 1.2)),
                    ),
                    const SizedBox(height: 12),
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      children: [
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Highest Spend",
                                    style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                                const SizedBox(height: 8),
                                Text(highestSpendCategory,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    )),
                              ],
                            ),
                          ),
                        ),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Highest Income",
                                    style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                                const SizedBox(height: 8),
                                Text(highestIncomeCategory,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    )),
                              ],
                            ),
                          ),
                        ),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Most Used Account",
                                    style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                                const SizedBox(height: 8),
                                Text(mostUsedAccount,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    )),
                              ],
                            ),
                          ),
                        ),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Avg Daily Expense",
                                    style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                                const SizedBox(height: 8),
                                Text('${AppData.currency}${averageDailyExpense.toStringAsFixed(0)}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    )),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
