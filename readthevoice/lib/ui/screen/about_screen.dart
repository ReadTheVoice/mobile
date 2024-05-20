import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:readthevoice/ui/screen/error_screen.dart';
import 'package:scaled_list/scaled_list.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("about_screen_title").tr(),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "🪷 ${tr("read_the_voice_about_title")}",
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontSize: 20),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "read_the_voice_about",
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground),
                textAlign: TextAlign.justify,
              ).tr(),
              const SizedBox(
                height: 10,
              ),
              const Divider(),
              const SizedBox(
                height: 10,
              ),
              Text(
                "🪷 ${tr("read_the_voice_team_title")}",
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontSize: 20),
                textAlign: TextAlign.justify,
              ),
              ScaledList(
                itemCount: teamMembers.length,
                itemColor: (index) {
                  return kMixedColors[index % kMixedColors.length];
                },
                itemBuilder: (index, selectedIndex) {
                  final teamMember = teamMembers[index];
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: selectedIndex == index ? 150 : 100,
                        child: Image.asset(
                          teamMember.image,
                          filterQuality: FilterQuality.high,
                          frameBuilder: (BuildContext context, Widget child,
                              int? frame, bool? wasSynchronouslyLoaded) {
                            return !teamMember.clipImage
                                ? child
                                : Container(
                                    height: 150,
                                    clipBehavior: Clip.antiAlias,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                    ),
                                    child: child);
                          },
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        teamMember.name,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: selectedIndex == index ? 25 : 20),
                      ),
                      Text(
                        teamMember.description,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: selectedIndex == index ? 15 : 10),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(
                height: 10,
              ),
              const Divider(),
              const SizedBox(
                height: 10,
              ),
              Text(
                "🪷 ${tr("read_the_voice_more_title")}",
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontSize: 20),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(
                height: 10,
              ),
              for (var item in acknowledgmentItems)
                RichText(
                    text: TextSpan(
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onBackground),
                        children: [
                      WidgetSpan(
                          child: Text(
                        "⚈ ${item.name}",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onBackground),
                      )),
                      const WidgetSpan(
                          child: SizedBox(
                        width: 5,
                      )),
                      WidgetSpan(
                          child: GestureDetector(
                        child: Text(
                          "read_the_voice_more_link_text",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              decoration: TextDecoration.underline,
                              decorationColor:
                                  Theme.of(context).colorScheme.primary),
                        ).tr(),
                        onTap: () async {
                          if (item.link.isNotEmpty) {
                            if (!await launchUrl(Uri.parse(item.link))) {
                              String errorMessage =
                                  "${tr("could_not_launch_link_text")} ${item.link}";

                              if (mounted) {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        ErrorScreen(text: errorMessage)));
                              }
                            }
                          }
                        },
                      )),
                    ])),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ));
  }

  final List<Color> kMixedColors = [
    const Color(0xff71A5D7),
    const Color(0xff72CCD4),
    const Color(0xff962D17),
  ];

  final List<TeamMember> teamMembers = [
    TeamMember(
      image: "assets/images/bird-6989306_640.jpg",
      name: "Gaëtan",
      description: tr("read_the_voice_team_g"),
    ),
    TeamMember(
        image: "assets/images/chicken-3070851_640.png",
        name: "Loïc",
        description: tr("read_the_voice_team_l"),
        clipImage: false),
    TeamMember(
      image: "assets/images/ai-generated-8754034_640.jpg",
      name: "Sharonn",
      description: tr("read_the_voice_team_s"),
    ),
  ];

  final List<MoreLinksItem> acknowledgmentItems = [
    MoreLinksItem(
        name: "Github (code)", link: "https://github.com/ReadTheVoice/mobile"),
    MoreLinksItem(
        name: "ReadTheVoice Web", link: "https://readthevoice.web.app"),
    MoreLinksItem(name: "Flutter", link: "https://flutter.dev"),
  ];
}

class TeamMember {
  final String image;
  final String name;
  final String description;
  final bool clipImage;

  TeamMember(
      {required this.image,
      required this.name,
      required this.description,
      this.clipImage = true});
}

class MoreLinksItem {
  final String name;
  final String link;

  MoreLinksItem({required this.name, required this.link});
}
