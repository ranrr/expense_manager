import 'package:expense_manager/widgets/reports/charts/expense_by_category.dart';
import 'package:expense_manager/widgets/reports/charts/expense_category_over_time.dart';
import 'package:expense_manager/widgets/reports/charts/expense_doughnut.dart';
import 'package:expense_manager/widgets/reports/charts/income_by_category.dart';
import 'package:expense_manager/widgets/reports/charts/income_category_over_time.dart';
import 'package:expense_manager/widgets/reports/charts/income_doughnut.dart';
import 'package:expense_manager/widgets/reports/charts/monthly_expense.dart';
import 'package:expense_manager/widgets/reports/charts/monthly_income.dart';
import 'package:flutter/material.dart';

class Charts extends StatelessWidget {
  const Charts({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: ListView(
        shrinkWrap: true,
        children: const [
          ExpenseOverTime(),
          IncomeOverTime(),
          ExpenseByCategory(),
          IncomeByCategory(),
          ExpenseByCategoryCircle(),
          IncomeByCategoryCircle(),
          ExpenseCategoryOverTimeLineChart(),
          IncomeCategoryOverTimeLineChart(),
        ],
      ),
    );
  }
}

class ExpenseOverTime extends StatelessWidget {
  const ExpenseOverTime({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Scaffold(
                appBar: AppBar(title: const Text('Expense over Time')),
                body: const MonthlyExpenseChart()),
          ),
        );
      },
      title: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Expense over Time',
            style: TextStyle(fontSize: 20),
          ),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 15),
                child: Icon(Icons.bar_chart_rounded),
              ),
              Padding(
                padding: EdgeInsets.only(left: 15),
                child: Icon(Icons.stacked_line_chart_rounded),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class IncomeOverTime extends StatelessWidget {
  const IncomeOverTime({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Scaffold(
                appBar: AppBar(title: const Text('Income over Time')),
                body: const MonthlyIncomeChart()),
          ),
        );
      },
      title: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Income over Time',
            style: TextStyle(fontSize: 20),
          ),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 15),
                child: Icon(Icons.bar_chart_rounded),
              ),
              Padding(
                padding: EdgeInsets.only(left: 15),
                child: Icon(Icons.stacked_line_chart_rounded),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ExpenseByCategory extends StatelessWidget {
  const ExpenseByCategory({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Scaffold(
                appBar: AppBar(title: const Text('Expense by Category')),
                body: const ExpenseByCategoryChart()),
          ),
        );
      },
      title: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Expense by Category',
            style: TextStyle(fontSize: 20),
          ),
          Padding(
            padding: EdgeInsets.only(left: 15),
            child: Icon(Icons.bar_chart_rounded),
          ),
        ],
      ),
    );
  }
}

class IncomeByCategory extends StatelessWidget {
  const IncomeByCategory({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Scaffold(
                appBar: AppBar(title: const Text('Income by Category')),
                body: const IncomeByCategoryChart()),
          ),
        );
      },
      title: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Income by Category',
            style: TextStyle(fontSize: 20),
          ),
          Padding(
            padding: EdgeInsets.only(left: 15),
            child: Icon(Icons.bar_chart_rounded),
          ),
        ],
      ),
    );
  }
}

class ExpenseByCategoryCircle extends StatelessWidget {
  const ExpenseByCategoryCircle({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Scaffold(
                appBar: AppBar(title: const Text('Expense by Category')),
                body: const ExpenseCategoryDoughnutChart()),
          ),
        );
      },
      title: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Expense by Category',
            style: TextStyle(fontSize: 20),
          ),
          Padding(
            padding: EdgeInsets.only(left: 15),
            child: Icon(Icons.pie_chart_outline_rounded),
          ),
        ],
      ),
    );
  }
}

class IncomeByCategoryCircle extends StatelessWidget {
  const IncomeByCategoryCircle({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Scaffold(
                appBar: AppBar(title: const Text('Income by Category')),
                body: const IncomeCategoryDoughnutChart()),
          ),
        );
      },
      title: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Income by Category',
            style: TextStyle(fontSize: 20),
          ),
          Padding(
            padding: EdgeInsets.only(left: 15),
            child: Icon(Icons.pie_chart_outline_rounded),
          ),
        ],
      ),
    );
  }
}

class ExpenseCategoryOverTimeLineChart extends StatelessWidget {
  const ExpenseCategoryOverTimeLineChart({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Scaffold(
                appBar: AppBar(title: const Text('Expense Category over Time')),
                body: const ExpenseCategoryOverTime()),
          ),
        );
      },
      title: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Expense Category over Time',
            style: TextStyle(fontSize: 20),
          ),
          Padding(
            padding: EdgeInsets.only(left: 15),
            child: Icon(Icons.stacked_line_chart_rounded),
          ),
        ],
      ),
    );
  }
}

class IncomeCategoryOverTimeLineChart extends StatelessWidget {
  const IncomeCategoryOverTimeLineChart({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Scaffold(
                appBar: AppBar(title: const Text('Income Category over Time')),
                body: const IncomeCategoryOverTime()),
          ),
        );
      },
      title: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Income Category over Time',
            style: TextStyle(fontSize: 20),
          ),
          Padding(
            padding: EdgeInsets.only(left: 15),
            child: Icon(Icons.stacked_line_chart_rounded),
          ),
        ],
      ),
    );
  }
}

class PanelHeader extends StatelessWidget {
  final String header;
  const PanelHeader({
    required this.header,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
      child: Text(
        header,
        style: const TextStyle(fontSize: 20),
      ),
    );
  }
}
