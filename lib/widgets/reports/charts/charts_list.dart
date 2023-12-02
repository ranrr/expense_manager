import 'package:expense_manager/widgets/reports/charts/monthly_expense.dart';
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
            value: "Expense by Month",
            canTapOnHeader: true,
            headerBuilder: (_, isExpanded) {
              return const PanelHeader(
                header: "Expense by Month",
              );
            },
            body: const MonthlyExpenseChart(),
          ),
          ExpansionPanelRadio(
            value: "Income by Month",
            canTapOnHeader: true,
            headerBuilder: (_, isExpanded) {
              return const PanelHeader(
                header: "Income by Month",
              );
            },
            body: const SizedBox.square(),
          ),
          ExpansionPanelRadio(
            value: "Expense Pie Chart",
            canTapOnHeader: true,
            headerBuilder: (_, isExpanded) {
              return const PanelHeader(
                header: "Expense Pie Chart",
              );
            },
            body: const SizedBox.square(),
          ),
          ExpansionPanelRadio(
            value: "Expense by Category",
            canTapOnHeader: true,
            headerBuilder: (_, isExpanded) {
              return const PanelHeader(
                header: "Expense by Category",
              );
            },
            body: const SizedBox.square(),
          ),
          ExpansionPanelRadio(
            value: "Expense by Sub-Category",
            canTapOnHeader: true,
            headerBuilder: (_, isExpanded) {
              return const PanelHeader(
                header: "Expense by Sub-Category",
              );
            },
            body: const SizedBox.square(),
          ),
          ExpansionPanelRadio(
            value: "Category Expense By Time",
            canTapOnHeader: true,
            headerBuilder: (_, isExpanded) {
              return const PanelHeader(
                header: "Category Expense By Time",
              );
            },
            body: const SizedBox.square(),
          ),
          ExpansionPanelRadio(
            value: "Sub-Category Expense By Time",
            canTapOnHeader: true,
            headerBuilder: (_, isExpanded) {
              return const PanelHeader(
                header: "Sub-Category Expense By Time",
              );
            },
            body: const SizedBox.square(),
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
        style: const TextStyle(fontSize: 18),
      ),
    );
  }
}
