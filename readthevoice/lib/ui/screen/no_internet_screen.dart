import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:readthevoice/ui/component/no_data_widget.dart';
import 'package:readthevoice/utils/utils.dart';

class NoInternetScreen extends StatefulWidget {
  const NoInternetScreen({super.key});

  @override
  State<NoInternetScreen> createState() => _NoInternetScreenState();
}

class _NoInternetScreenState extends State<NoInternetScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("app_name").tr(),
        centerTitle: true,
      ),
      body: const NoDataWidget(currentScreen: AvailableScreens.noInternetConnection),
    );
  }
}
