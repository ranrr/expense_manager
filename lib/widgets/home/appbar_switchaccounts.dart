import 'package:flutter/material.dart';

class AppbarSwitchAccountsIcon extends StatelessWidget {
  final List<String> _accounts;

  const AppbarSwitchAccountsIcon(this._accounts, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20.0),
      child: PopupMenuButton(
        elevation: 20,
        tooltip: "Switch Account",
        icon: const Icon(
          Icons.switch_account,
          size: 25,
        ),
        itemBuilder: (context) {
          return List.generate(
            _accounts.length,
            (index) {
              return PopupMenuItem(
                value: _accounts[index],
                child: Text(_accounts[index]),
              );
            },
          );
        },
        // onSelected: () {},
      ),
    );
  }
}
