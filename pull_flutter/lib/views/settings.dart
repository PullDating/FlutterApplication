import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

/// Setting page of this app, containing a link for our github and website
class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  ConsumerState<SettingsPage> createState() => _PullSettingsPageState();
}

class _PullSettingsPageState extends ConsumerState<SettingsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
        ),
        body: Material(
          child: ListView(children: [
            for (var i = 0; i < 10; i++)
              ListTile(
                title: Text("Setting $i"),
                textColor: Colors.purpleAccent,
              ),
            ListTile(
              title: Text(
                'Website',
                style: Theme.of(context).textTheme.headline5,
              ),
              onTap: () {
                launchUrl(Uri.parse('https://pulldating.tips'));
              },
            ),
            ListTile(
              title: Text(
                'Licenses',
                style: Theme.of(context).textTheme.headline5,
              ),
              onTap: () {
                showLicensePage(
                  context: context,
                  applicationName: "Pull Dating",
                  applicationIcon: Image.asset("assets/icons/PullLogo.png",
                      width: 40, height: 40),
                );
              },
            ),
            ListTile(
              title: Text(
                'Github',
                style: Theme.of(context).textTheme.headline5,
              ),
              onTap: () {
                launchUrl(Uri.parse(
                    'https://github.com/PullDating/FlutterApplication'));
              },
            )
          ]),
        ));
  }
}
