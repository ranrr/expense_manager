import 'package:expense_manager/model/autofill.dart';
import 'package:expense_manager/utils/constants.dart';
import 'package:expense_manager/utils/widget_utils.dart';
import 'package:expense_manager/widgets/util/confirm_alert.dart';
import 'package:expense_manager/widgets/util/snack_bar.dart';
import 'package:flutter/material.dart';

class AutoFillSettings extends StatelessWidget {
  const AutoFillSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 10),
      children: const [
        AutoFillSettingsInfoText(),
        AutoFillListWithActions(),
      ],
    );
  }
}

class AutoFillSettingsInfoText extends StatelessWidget {
  const AutoFillSettingsInfoText({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(30, 0, 0, 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              padding: const EdgeInsets.fromLTRB(0, 0, 25, 0),
              child: const Text(
                  "Auto-Fill template can be created from any transaction by tapping on it.")),
        ],
      ),
    );
  }
}

class AutoFillListWithActions extends StatefulWidget {
  const AutoFillListWithActions({super.key});

  @override
  State<AutoFillListWithActions> createState() =>
      _AutoFillListWithActionsState();
}

class _AutoFillListWithActionsState extends State<AutoFillListWithActions> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<AutoFill>>(
      future: getAllAutoFillRecords(),
      builder: (BuildContext context, AsyncSnapshot<List<AutoFill>> snapshot) {
        Widget widget;
        if (snapshot.hasData) {
          List<AutoFill> records = snapshot.data!;
          if (records.isEmpty) {
            widget = const Center(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "No Auto-Fill Templates",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            );
          } else {
            widget = ListView.builder(
              shrinkWrap: true,
              itemCount: records.length,
              physics: const ClampingScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                var autoFillRecord = records[index];
                return Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 25),
                  child: Card(
                    child: ListTile(
                      leading: Text(
                        autoFillRecord.name,
                        style: const TextStyle(fontSize: 16),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              var value = await showDialog<bool?>(
                                context: context,
                                builder: (BuildContext context) {
                                  return const AutoFillDeleteAlert();
                                },
                              );
                              if (value ?? false) {
                                await deleteAutoFill(autoFillRecord.name);
                                showSnackBar("Auto-Fill template deleted. ");
                                setState(() {});
                              }
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(Icons.delete),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        } else if (snapshot.hasError) {
          widget = Container();
        } else {
          widget = Container();
        }
        return widget;
      },
    );
  }
}

class AutoFillDeleteAlert extends StatelessWidget {
  const AutoFillDeleteAlert({super.key});

  @override
  Widget build(BuildContext context) {
    return const ConfirmAlertDialog(
        header: autoFillDeleteHeader, message: autoFillDeleteMessage);
  }
}
