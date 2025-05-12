import 'package:base_code/app/config/app_color.dart';
import 'package:base_code/app/config/constant.dart';
import 'package:base_code/app/config/router_name.dart';
import 'package:base_code/app/config/text_styles.dart';
import 'package:base_code/widgets/auth_base_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthBaseScreen(
        body: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24).copyWith(bottom: 56),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'welcome'.tr(),
            style: TextStyles.large
                .copyWith(fontSize: 40, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 16),
          Text(
            'splash_welcome'.tr(),
            style: TextStyles.small,
          ),
          const SizedBox(height: 85),
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: () => context.go(RouterName.loginView),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'continue'.tr(),
                    style: TextStyles.small
                        .copyWith(color: AppColor.colorNoteText),
                  ),
                  const SizedBox(width: 14),
                  SvgPicture.asset(SvgAssets.ic_splash_next),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
