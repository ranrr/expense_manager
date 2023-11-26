import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

var formatter = NumberFormat('#,##,##0');

enum RecordAction { add, edit, delete }

enum RecordType {
  expense("Expense"),
  income("Income");

  final String name;
  const RecordType(this.name);
}

enum Period {
  today(0),
  week(1),
  month(2),
  year(3),
  custom(4);

  final int indx;
  const Period(this.indx);

  static Period get(int index) {
    switch (index) {
      case 0:
        return Period.today;
      case 1:
        return Period.week;
      case 2:
        return Period.month;
      case 3:
        return Period.year;
      case 4:
        return Period.custom;
      default:
        throw IndexError;
    }
  }
}

const allAccountsName = "All";

const selectedAccountProperty = "selectedAccount";

const dbBackupPath = "dbBackupPath";

const accountDeleteHeader = 'Confirm Account Delete';

const accountDeleteMessage =
    'This will delete the Account and all its transactions. Please confirm.';

const accountRenameHeader = 'Rename Account';

const accountRenameMessage = 'Enter new Account name';

const accountAddHeader = 'Add Account';

const accountAddMessage = 'Enter Account name';

const subCategoryAddHeader = 'Add Sub-Category';

const subCategoryAddMessage = 'Enter Sub-Category Name';

const categoryRenameHeader = 'Rename Category';

const categoryRenameMessage = 'Enter Category name';

const categoryDeleteHeader = 'Confirm Category Delete';

const categoryDeleteMessage =
    'This will delete the category and all its transactions. Please confirm.';

const subCategoryRenameHeader = 'Rename Sub-Category';

const subCategoryRenameMessage = 'Enter Sub-category name';

const subCategoryDeleteHeader = 'Confirm Sub-Category Delete';

const subCategoryDeleteMessage =
    'This will delete sub-category and all transactions. Please confirm.';

const incomeCategoryAddHeader = 'Add Income Category';

const incomeCategoryAddMessage = 'Enter Category Name';

const autoFillHeader = 'Create Auto-Fill';

const autoFillMessage =
    'This will create an auto-fill template from this transaction. Please provide a name. ';

const autoFillDeleteHeader = 'Confirm Auto-Fill Delete';

const autoFillDeleteMessage =
    'This will delete the Auto-Fill template. Please confirm.';
