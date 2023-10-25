enum RecordAction { add, edit, delete }

enum RecordType {
  expense("Expense"),
  income("Income");

  final String name;
  const RecordType(this.name);
}

const allAccountsName = "All";

const selectedAccountProperty = "selectedAccount";
