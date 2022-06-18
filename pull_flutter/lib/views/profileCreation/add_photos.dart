import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class AddPhotosPage extends StatefulWidget {
  const AddPhotosPage({Key? key}) : super(key: key);

  @override
  State<AddPhotosPage> createState() => _AddPhotosPageState();
}

class _AddPhotosPageState extends State<AddPhotosPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        child: TextField(
          decoration: InputDecoration(
            labelText: 'hello',
          ),
        ),
      ),
    );
  }
}
