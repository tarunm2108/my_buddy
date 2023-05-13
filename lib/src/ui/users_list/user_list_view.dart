import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_buddy/app_consts/app_assets.dart';
import 'package:my_buddy/app_consts/constants.dart';
import 'package:my_buddy/app_consts/extension/text_style_extension.dart';
import 'package:my_buddy/service/chat_service.dart';
import 'package:my_buddy/src/ui/users_list/user_list_controller.dart';

class UserListView extends StatelessWidget {
  const UserListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserListController>(
      builder: (controller) => Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: ChatService.instance
              .getAllUser(userId: controller.loginUser?.id ?? ''),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (!snapshot.hasData) {
                return Text(
                  noUserFoundYet,
                  style: const TextStyle().regular,
                );
              }
              return ListView(
                children: _getExpenseItems(snapshot, controller),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
      init: UserListController(),
    );
  }

  _getExpenseItems(
      AsyncSnapshot<QuerySnapshot> snapshot, UserListController controller) {
    final list = snapshot.data?.docs;
    list?.sort((a, b) => a['name'].toString().compareTo(a['name'].toString()));
    return list
        ?.map(
          (doc) => InkWell(
            onTap: () => controller.onItemTap(doc),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: Card(
                      margin: EdgeInsets.zero,
                      clipBehavior: Clip.antiAlias,
                      shape: const CircleBorder(),
                      child: Image.asset(
                        AppAssets.defaultProfile,
                        height: 50,
                      ),
                    ),
                    title: Text(doc["name"]),
                  ),
                  const Divider(
                    color: Colors.black12,
                    height: 14,
                    thickness: 1,
                  )
                ],
              ),
            ),
          ),
        )
        .toList();
  }
}
