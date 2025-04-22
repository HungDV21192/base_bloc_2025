import 'package:base_code/features/settings/settings_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsCubit = context.read<SettingsCubit>();

    return Scaffold(
      appBar: AppBar(title: const Text('settings')),
      body: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          return ListView(
            children: [
              const ListTile(
                  title: Text('settings',
                      style: TextStyle(fontWeight: FontWeight.bold))),
              RadioListTile<ThemeMode>(
                title: const Text('system'),
                value: ThemeMode.system,
                groupValue: state.themeMode,
                onChanged: (value) => settingsCubit.updateTheme,
              ),
              RadioListTile<ThemeMode>(
                title: Text('light'.tr()),
                value: ThemeMode.light,
                groupValue: state.themeMode,
                onChanged: (value) => settingsCubit.updateTheme,
              ),
              RadioListTile<ThemeMode>(
                title: Text('dark'.tr()),
                value: ThemeMode.dark,
                groupValue: state.themeMode,
                onChanged: (value) => settingsCubit.updateTheme,
              ),
              const Divider(),
              ListTile(
                  title: Text('language'.tr(),
                      style: const TextStyle(fontWeight: FontWeight.bold))),
              RadioListTile<Locale>(
                title: const Text("English"),
                value: const Locale('en'),
                groupValue: state.locale,
                onChanged: (locale) {
                  if (locale != null) {
                    context.setLocale(locale);
                    settingsCubit.updateLanguage(locale);
                  }
                },
              ),
              RadioListTile<Locale>(
                title: const Text("Tiếng Việt"),
                value: const Locale('vi'),
                groupValue: state.locale,
                onChanged: (locale) {
                  if (locale != null) {
                    context.setLocale(locale);
                    settingsCubit.updateLanguage(locale);
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
