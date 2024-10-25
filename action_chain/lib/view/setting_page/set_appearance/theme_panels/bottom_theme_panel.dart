import 'package:flutter/material.dart';
import 'package:action_chain/constants/theme.dart';
import 'package:action_chain/model/user/setting_data.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';

class BottomThemePanel extends StatelessWidget {
  final int relevantThemeIndex;
  const BottomThemePanel({Key? key, required this.relevantThemeIndex})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
      child: GestureDetector(
        onTap: () {
          SettingData.shared.confirmToChangeTheme(
              context: context, relevantThemeIndex: relevantThemeIndex);
        },
        child: SizedBox(
          width: deviceWidth - 50,
          height: 90,
          // グラデーションと丸角
          child: DecoratedBox(
            decoration: BoxDecoration(
                gradient: acTheme[relevantThemeIndex].gradientOfNavBar,
                borderRadius: BorderRadius.circular(10)),
            // ガラス
            child: GlassContainer(
              // カードを中央に配置
              child: Align(
                alignment: Alignment.center,
                // toDoカードを表示
                child: SizedBox(
                  height: 70,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Card(
                      // 色
                      color: acTheme[relevantThemeIndex].panelColor,
                      // 浮き具合
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 18, right: 8.0),
                            child: Icon(
                              FontAwesomeIcons.square,
                              color: acTheme[relevantThemeIndex].checkmarkColor,
                            ),
                          ),
                          Text(
                            acTheme[SettingData.shared.selectedThemeIndex]
                                .themeName,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color:
                                    acTheme[relevantThemeIndex].checkmarkColor,
                                fontSize: 20,
                                letterSpacing: 2,
                                fontWeight: FontWeight.w800),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
