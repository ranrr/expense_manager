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
      child: ExpansionPanelList.radio(
        elevation: 3,
        animationDuration: const Duration(milliseconds: 600),
        children: [
          ExpansionPanelRadio(
            value: "Expense over Time",
            canTapOnHeader: true,
            headerBuilder: (_, isExpanded) {
              return const PanelHeader(
                header: "Expense over Time",
              );
            },
            body: const MonthlyExpenseChart(),
          ),
          ExpansionPanelRadio(
            value: "Income over Time",
            canTapOnHeader: true,
            headerBuilder: (_, isExpanded) {
              return const PanelHeader(
                header: "Income over Time",
              );
            },
            body: const MonthlyIncomeChart(),
          ),
          ExpansionPanelRadio(
            value: "Expense by Category",
            canTapOnHeader: true,
            headerBuilder: (_, isExpanded) {
              return const PanelHeader(
                header: "Expense by Category",
              );
            },
            body: const ExpenseByCategoryChart(),
          ),
          ExpansionPanelRadio(
            value: "Income by Category",
            canTapOnHeader: true,
            headerBuilder: (_, isExpanded) {
              return const PanelHeader(
                header: "Income by Category",
              );
            },
            body: const IncomeByCategory(),
          ),
          ExpansionPanelRadio(
            value: "Expense Category Doughnut",
            canTapOnHeader: true,
            headerBuilder: (_, isExpanded) {
              return const PanelHeader(
                header: "Expense Category Doughnut",
              );
            },
            body: const ExpenseCategoryDoughnutChart(),
          ),
          ExpansionPanelRadio(
            value: "Income Category Doughnut",
            canTapOnHeader: true,
            headerBuilder: (_, isExpanded) {
              return const PanelHeader(
                header: "Income Category Doughnut",
              );
            },
            body: const IncomeCategoryDoughnutChart(),
          ),
          ExpansionPanelRadio(
            value: "Expense Category over Time",
            canTapOnHeader: true,
            headerBuilder: (_, isExpanded) {
              return const PanelHeader(
                header: "Expense Category over Time",
              );
            },
            body: const ExpenseCategoryOverTime(),
          ),
          ExpansionPanelRadio(
            value: "Income Category over Time",
            canTapOnHeader: true,
            headerBuilder: (_, isExpanded) {
              return const PanelHeader(
                header: "Income Category over Time",
              );
            },
            body: const IncomeCategoryOverTime(),
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
