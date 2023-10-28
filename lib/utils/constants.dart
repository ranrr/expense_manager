enum RecordAction { add, edit, delete }

enum RecordType {
  expense("Expense"),
  income("Income");

  final String name;
  const RecordType(this.name);

  RecordType get() {
    return RecordType.expense;
  }
}

enum Period {
  today(0),
  week(1),
  month(2),
  year(3);

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
      default:
        throw IndexError;
    }
  }
}

const allAccountsName = "All";

const selectedAccountProperty = "selectedAccount";
