import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_buddy/app_consts/app_assets.dart';
import 'package:my_buddy/app_consts/extension/space.dart';
import 'package:my_buddy/app_consts/extension/text_style_extension.dart';
import 'package:my_buddy/src/ui/chat_list/drawer/drawer_controller.dart';
import 'package:my_buddy/src/widgets/load_image_widget.dart';

class DrawerView extends StatelessWidget {
  const DrawerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DrawerViewController>(
      builder: (controller) => Drawer(
        child: Column(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.purple,
              ),
              child: Row(
                children: [
                  Card(
                    margin: EdgeInsets.zero,
                    clipBehavior: Clip.antiAlias,
                    shape: const CircleBorder(),
                    child: LoadImageWidget(
                      imagePath: controller.loginUser?.profileUrl ?? '',
                      imageType: ImageType.network,
                      width: 80,
                      height: 80,
                      errorWidget: Image.asset(
                        AppAssets.defaultProfile,
                        width: 80,
                        height: 80,
                      ),
                    ),
                  ),
                  10.toSpace(),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.loginUser?.name ?? 'User',
                          style: const TextStyle().bold.copyWith(
                                color: Colors.white,
                                fontSize: 21,
                              ),
                        ),
                        6.toSpace(),
                        Text(
                          controller.loginUser?.mobile ?? '',
                          style: const TextStyle().regular.copyWith(
                                color: Colors.white,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemBuilder: (_, index) {
                  return _item(index, controller);
                },
                itemCount: controller.drawerMenuList.length,
                padding: EdgeInsets.zero,
                shrinkWrap: true,
              ),
            ),
          ],
        ),
      ),
      init: DrawerViewController(),
    );
  }

  Widget _item(int index, DrawerViewController controller) {
    final item = controller.drawerMenuList[index];
    return ListTile(
      leading: item.icon,
      dense: true,horizontalTitleGap: 5,
      onTap: () {
        controller.back();
        item.onTap();
      },
      title: Text(
        item.title,
        style: const TextStyle().bold.copyWith(
              color: Colors.black,
              fontSize: 18,
            ),
      ),
      subtitle: item.subtitle != null
          ? Text(
              item.subtitle!,
              style: const TextStyle().regular.copyWith(
                    color: Colors.black54,
                    fontSize: 14,
                  ),
            )
          : null,
      trailing: item.trailing != null
          ? Text(
              item.trailing!,
              style: const TextStyle().regular.copyWith(
                    color: Colors.black38,
                    fontSize: 13,
                  ),
            )
          : null,
    );
  }
}
