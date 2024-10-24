import 'package:action_chain/model/ac_workspace/ac_workspace.dart';
import 'package:action_chain/model/ac_workspace/ac_workspaces.dart';
import 'package:action_chain/model/external/ac_vibration.dart';
import 'package:action_chain/model/user/setting_data.dart';
import 'package:action_chain/model/ac_category.dart';
import 'package:action_chain/constants/global_keys.dart';
import 'package:action_chain/constants/theme.dart';
import 'package:action_chain/alerts/simple_alert.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class EditACWorkspaceDialog extends StatefulWidget {
  final String? oldWorkspaceCategoryId;
  final int? oldWorkspaceIndex;
  const EditACWorkspaceDialog(
      {Key? key,
      required this.oldWorkspaceCategoryId,
      required this.oldWorkspaceIndex})
      : super(key: key);

  @override
  State<EditACWorkspaceDialog> createState() => _EditACWorkspaceDialogState();
}

class _EditACWorkspaceDialogState extends State<EditACWorkspaceDialog> {
  bool isInitialized = false;
  final TextEditingController _workspaceNameInputController =
      TextEditingController();
  @override
  Widget build(BuildContext context) {
    if (widget.oldWorkspaceCategoryId != null && !isInitialized) {
      isInitialized = true;
      _workspaceNameInputController.text =
          json.decode(acWorkspaces[widget.oldWorkspaceIndex!])["name"];
    }
    return Dialog(
      backgroundColor: theme[settingData.selectedTheme]!.alertColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // スペーサー
          const SizedBox(
            height: 30,
          ),
          // 新しいworkspace名を入力するTextFormField
          Padding(
            padding: const EdgeInsets.only(bottom: 30.0),
            child: SizedBox(
                width: 230,
                child: TextField(
                  autofocus: true,
                  controller: _workspaceNameInputController,
                  style: TextStyle(
                      color: Colors.black.withOpacity(0.5),
                      fontWeight: FontWeight.w600),
                  decoration: InputDecoration(
                    hintText: "Workspace",
                    hintStyle: TextStyle(
                        color: Colors.black.withOpacity(0.35),
                        fontWeight: FontWeight.w600),
                  ),
                )),
          ),
          // 閉じる 追加するボタン
          OverflowBar(
            alignment: MainAxisAlignment.spaceEvenly,
            children: [
              // カテゴリーを作らずにアラートを閉じるボタン
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("閉じる")),
              // workspaceを追加するボタン
              TextButton(
                  onPressed: () {
                    if (_workspaceNameInputController.text.trim().isNotEmpty) {
                      final String _enteredWorkspaceName =
                          _workspaceNameInputController.text;
                      // アラートを閉じる
                      Navigator.pop(context);
                      // workspacesを更新
                      if (widget.oldWorkspaceCategoryId == null) {
                        // add action
                        acWorkspaces.add(json.encode(ACWorkspace(
                            name: _enteredWorkspaceName,
                            chainCategories: [
                              ACCategory(id: noneId, title: "なし")
                            ],
                            savedChains: {
                              noneId: []
                            },
                            keepedChains: {
                              noneId: []
                            }).toJson()));
                        ACWorkspace.notifyWorkspaceIsAdded(
                            context: context,
                            newWorkspaceName: _enteredWorkspaceName);
                      } else {
                        // edit action
                        final ACWorkspace editedWorkspace =
                            ACWorkspace.fromJson(json.decode(
                                acWorkspaces[widget.oldWorkspaceIndex!]));
                        editedWorkspace.name = _enteredWorkspaceName;
                        // 消していれる
                        acWorkspaces.removeAt(widget.oldWorkspaceIndex!);
                        acWorkspaces.insert(widget.oldWorkspaceIndex!,
                            json.encode(editedWorkspace.toJson()));
                        simpleAlert(
                            context: context,
                            title: "変更することに\n成功しました",
                            message: null,
                            buttonText: "OK");
                      }
                      drawerForWorkspaceKey.currentState?.setState(() {});
                      manageWorkspacePageKey.currentState?.setState(() {});
                      homePageKey.currentState?.setState(() {});
                      ACVibration.vibrate();
                      // workspacesをセーブする
                      ACWorkspace.saveStringWorkspaces();
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  child:
                      Text(widget.oldWorkspaceCategoryId == null ? "追加" : "編集"))
            ],
          )
        ],
      ),
    );
  }
}
