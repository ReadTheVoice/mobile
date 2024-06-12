import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:readthevoice/ui/screen/master_screen.dart';

class ErrorScreen extends StatefulWidget {
  final String text;

  const ErrorScreen({super.key, required this.text});

  @override
  State<ErrorScreen> createState() => _ErrorScreenState();
}

class _ErrorScreenState extends State<ErrorScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "error_screen_title",
          style: TextStyle(fontSize: 17),
        ).tr(),
        centerTitle: true,
      ),
      body: Center(
          child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Column(
          children: [
            SvgPicture.asset(
              "assets/images/svg/error_screen_img.svg",
              height: 200,
              width: 200,
            ),
            Expanded(
                child: Text(
              widget.text,
              textAlign: TextAlign.justify,
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onBackground,
                  fontSize: 13),
            )),
            MaterialButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const MasterScreen()));
              },
              color: Theme.of(context).colorScheme.surface,
              textColor: Theme.of(context).colorScheme.onSurface,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: const Text("retry").tr(),
            ),
          ],
        ),
      )),
    );
  }
}
