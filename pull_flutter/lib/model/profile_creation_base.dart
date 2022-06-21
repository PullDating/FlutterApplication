import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pull_common/src/model/provider/create_account.dart';

class ProfileCreationTemplate extends ConsumerStatefulWidget {
  const ProfileCreationTemplate({Key? key}) : super(key: key);

  @override
  ConsumerState <ProfileCreationTemplate> createState() => _ProfileCreationTemplateState();
}

class _ProfileCreationTemplateState extends ConsumerState<ProfileCreationTemplate> {
  @override
  void initState() {
    super.initState();
    final profile = ref.read(accountCreationProfile);
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(accountCreationProfile);
    return Test();
  }
}

class Test extends StatelessWidget {
  const Test({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text("hello");
  }
}
