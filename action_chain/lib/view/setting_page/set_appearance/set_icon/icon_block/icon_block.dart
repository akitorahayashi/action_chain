import 'package:action_chain/main.dart';
import 'package:action_chain/view/setting_page/set_appearance/set_icon/icon_block/icon_card.dart';
import 'package:action_chain/model/user/setting_data.dart';
import 'package:action_chain/constants/icons_for_checkbox.dart';
import 'package:action_chain/constants/theme.dart';
import 'package:flutter/material.dart';

class IconBlock extends StatelessWidget {
  final String iconRarity;
  final String categoryNameForIcons;
  const IconBlock(
      {Key? key, required this.iconRarity, required this.categoryNameForIcons})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: theme[settingData.selectedTheme]!.myPagePanelColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          children: iconsForCheckBox[categoryNameForIcons]![iconRarity]!
              .keys
              .map((iconName) => IconCard(
                    isEarned: adIsClosed
                        ? true
                        : settingData.earnedIcons[categoryNameForIcons] !=
                                null &&
                            settingData.earnedIcons[categoryNameForIcons]!
                                .contains(iconName),
                    iconCategoryName: categoryNameForIcons,
                    selectedIconRarity: iconRarity,
                    iconName: iconName,
                  ))
              .toList(),
        ),
      ),
    );
  }
}
