import 'package:action_chain/model/external/admob.dart';
import 'package:flutter/material.dart';
import 'package:action_chain/constants/theme.dart';
import 'package:action_chain/model/user/setting_data.dart';

class ActionChainBottomNavBar extends StatefulWidget {
  const ActionChainBottomNavBar({Key? key}) : super(key: key);

  @override
  State<ActionChainBottomNavBar> createState() =>
      _ActionChainBottomNavBarState();
}

class _ActionChainBottomNavBarState extends State<ActionChainBottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: (admob.ticketIsActive ? 0 : 50),
      child: DecoratedBox(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(blurRadius: 10, color: Colors.black.withOpacity(0.6))
          ],
          gradient: theme[settingData.selectedTheme]!.gradientOfNavBar,
        ),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: (admob.ticketIsActive ? 75 : 60) *
              MediaQuery.of(context).size.height /
              896,
          child: const BottomAppBar(
            elevation: 0,
            color: Colors.transparent,
            clipBehavior: Clip.hardEdge,
            shape: CircularNotchedRectangle(),
          ),
        ),
      ),
    );
  }
}
