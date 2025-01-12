import 'package:action_chain/component/dialog/ac_single_option_dialog.dart';
import 'package:action_chain/constants/global_keys.dart';
import 'package:action_chain/model/ac_workspace/edit_acworkspace_dialog.dart';
import 'package:action_chain/model/ac_todo/ac_category.dart';
import 'package:action_chain/model/ac_todo/ac_chain.dart';
import 'package:action_chain/model/ac_workspace/ac_workspaces.dart';
import 'package:action_chain/model/external/ac_vibration.dart';
import 'package:action_chain/model/external/ac_pref.dart';
import 'package:action_chain/model/ac_theme.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class ACWorkspace {
  static ACWorkspace currentWorkspace =
      acWorkspaces[ACWorkspace.currentWorkspaceIndex];
  // workspace
  static int currentWorkspaceIndex = 0;
  // 現在実行中のActionChain
  static ACChain? runningActionChain;

  String name;
  List<ACCategory> chainCategories;
  Map<String, List<ACChain>> savedChains;
  Map<String, List<ACChain>> keepedChains;

  ACWorkspace(
      {required this.name,
      required this.chainCategories,
      required this.savedChains,
      required this.keepedChains});

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "chainCategories": chainCategories.map((chainCategory) {
        return chainCategory.toJson();
      }).toList(),
      "savedChains": savedChains.map((chainName, actodos) {
        final mappedACToDos =
            actodos.map((actodoData) => actodoData.toJson()).toList();
        return MapEntry(chainName, mappedACToDos);
      }),
      "keepedChains": keepedChains.map((chainName, actodos) {
        final mappedACToDos =
            actodos.map((actodoData) => actodoData.toJson()).toList();
        return MapEntry(chainName, mappedACToDos);
      }),
    };
  }

  factory ACWorkspace.fromJson(Map<String, dynamic> jsonData) {
    return ACWorkspace(
      name: jsonData["name"] as String,
      chainCategories: (jsonData["chainCategories"] as List<dynamic>?)
              ?.map((chainCategory) => ACCategory.fromJson(chainCategory))
              .toList() ??
          [],
      savedChains: (jsonData["savedChains"] as Map<String, dynamic>).map(
        (chainName, actionChains) {
          final createdActionChains = (actionChains as List<dynamic>)
              .map((jsonActionChainData) =>
                  ACChain.fromJson(jsonActionChainData))
              .toList();
          return MapEntry(chainName, createdActionChains);
        },
      ),
      keepedChains: (jsonData["keepedChains"] as Map<String, dynamic>).map(
        (chainName, actionChains) {
          final createdActionChains = (actionChains as List<dynamic>)
              .map((jsonActionChainData) =>
                  ACChain.fromJson(jsonActionChainData))
              .toList();
          return MapEntry(chainName, createdActionChains);
        },
      ),
    );
  }

  static void addWorkspaceAlert({required BuildContext context}) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return const EditACWorkspaceDialog(oldWorkspaceIndex: null);
        });
  }

  static void notifyWorkspaceIsAdded(
      {required BuildContext context, required String newWorkspaceName}) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          final ACThemeData _acThemeData = ACTheme.of(context);
          return Dialog(
            backgroundColor: _acThemeData.alertColor,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.5),
                        fontWeight: FontWeight.w600,
                      ),
                      children: [
                        TextSpan(
                          text: "workspaceに\n",
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.5),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextSpan(
                          text: newWorkspaceName,
                          style: TextStyle(
                            color: _acThemeData.accentColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        TextSpan(
                          text: "\nを追加しました!",
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.5),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("OK"),
                  ),
                ],
              ),
            ),
          );
        });
  }

  static void editWorkspaceAlert(
      {required BuildContext context, required int selectedWorkspaceIndex}) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return EditACWorkspaceDialog(
              oldWorkspaceIndex: selectedWorkspaceIndex);
        });
  }

  static void deleteWorkspaceAlert({
    required BuildContext context,
    required int indexInStringWorkspaces,
  }) {
    final ACWorkspace willDeletedWorkspace =
        acWorkspaces[indexInStringWorkspaces];
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          final ACThemeData _acThemeData = ACTheme.of(context);
          return Dialog(
            backgroundColor: _acThemeData.alertColor,
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // workspaceの削除
                  Text(
                    "workspaceの削除",
                    style: TextStyle(
                        color: Colors.black.withOpacity(0.5),
                        fontWeight: FontWeight.w600,
                        fontSize: 13),
                  ),
                  // workspaceを表示
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 5, bottom: 15.0, left: 10, right: 10),
                    child: Text(
                      willDeletedWorkspace.name,
                      style: TextStyle(
                          color: _acThemeData.accentColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ),
                  Text(
                    "※ workspaceに含まれる\n  Chainも削除されます",
                    style: TextStyle(
                        color: Colors.black.withOpacity(0.5),
                        fontWeight: FontWeight.w600,
                        fontSize: 13),
                  ),
                  // はい、いいえボタン
                  OverflowBar(
                    alignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // いいえボタン
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("戻る")),
                      // はいボタン
                      TextButton(
                          onPressed: () {
                            // acWorkspacesから削除
                            ACPref().getPref.then((pref) {
                              if (ACWorkspace.currentWorkspaceIndex >
                                  indexInStringWorkspaces) {
                                ACWorkspace.currentWorkspaceIndex--;
                                pref.setInt("currentWorkspaceIndex",
                                    ACWorkspace.currentWorkspaceIndex);
                              }
                              acWorkspaces.removeAt(indexInStringWorkspaces);
                              drawerForWorkspaceKey.currentState
                                  ?.setState(() {});
                              manageWorkspacePageKey.currentState
                                  ?.setState(() {});
                              // このアラートを消して thank you アラートを表示する
                              Navigator.pop(context);
                              ACVibration.vibrate();
                              ACSingleOptionDialog.show(
                                  context: context,
                                  title: "削除することに\n成功しました！",
                                  message: null);
                              // セーブする
                              ACWorkspace.saveACWorkspaces();
                            });
                          },
                          child: const Text("削除"))
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  static void changeCurrentWorkspace({required int newWorkspaceIndex}) {
    ACWorkspace.currentWorkspaceIndex = newWorkspaceIndex;
    currentWorkspace = acWorkspaces[newWorkspaceIndex];
    ACPref().getPref.then((pref) {
      pref.setInt("currentWorkspaceIndex", ACWorkspace.currentWorkspaceIndex);
    });
  }

  // --- save ---
  static Future<void> readWorkspaces() async {
    await ACPref().getPref.then((pref) {
      ACWorkspace.currentWorkspaceIndex =
          pref.getInt("currentWorkspaceIndex") ?? 0;
      if (pref.getString("acWorkspaces") != null) {
        acWorkspaces =
            (json.decode(pref.getString("acWorkspaces")!) as List<dynamic>)
                .map((acworkspaceJsonData) {
          return ACWorkspace.fromJson(acworkspaceJsonData);
        }).toList();
      }
      if (pref.getString("runningActionChain") != null) {
        ACWorkspace.runningActionChain = ACChain.fromJson(
            json.decode(pref.getString("runningActionChain")!));
      }
    });
  }

  static void saveCurrentChain() => ACPref().getPref.then((pref) => pref
      .setString("currentChain", json.encode(ACWorkspace.runningActionChain)));

  static void saveACWorkspaces() async {
    ACPref().getPref.then((pref) => pref.setString(
        "acWorkspaces",
        json.encode(acWorkspaces.map((acworkspace) {
          return acworkspace.toJson();
        }).toList())));
  }

  static void saveCurrentWorkspace(
      {required int selectedWorkspaceIndex,
      required ACWorkspace selectedWorkspace}) {
    acWorkspaces[selectedWorkspaceIndex] = currentWorkspace;
    ACWorkspace.saveACWorkspaces();
  }
  // --- save ---
}
