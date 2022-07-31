import 'dart:convert';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:reorderables/reorderables.dart';
import 'package:pull_common/pull_common.dart';
import 'package:http/http.dart' as http;

class ProfilePhotoField extends ConsumerStatefulWidget {
  const ProfilePhotoField({Key? key}) : super(key: key);

  @override
  ConsumerState<ProfilePhotoField> createState() => _ProfilePhotoFieldState();
}

class _ProfilePhotoFieldState extends ConsumerState<ProfilePhotoField> {
  Directory? _docDir;
  int minProfilePhotos = 2;
  int maxProfilePhotos = 7;



  void getPhotoLimits() async {
    var url = profilePhotoLimitsUri;
    var decoded;
    await http.get(url).then((response) => {
      decoded = json.decode(response.body),
      setState(() {
        print("attemping to set state with new photo limits");
        minProfilePhotos = decoded['minProfilePhotos'];
        maxProfilePhotos = decoded['maxProfilePhotos'];
        populateTiles();
      }),
      print("min" + minProfilePhotos.toString()),
      print("max" + maxProfilePhotos.toString())
    });
  }

  var tiles = <ImageThumbnail>[];

  void populateTiles() {
    //add the correct number of mandatory photos
    for(int i = 0; i < minProfilePhotos; i++){
      tiles.add(ImageThumbnail( imageExists: false, required: true));
    }

    //add the correct number of optional photos
    for(int i = minProfilePhotos; i < maxProfilePhotos; i++){
      tiles.add(ImageThumbnail(imageExists: false, required: false));
    }
  }

  @override
  void initState() {
    //TODO make request to server to get min and max photo limits.
    super.initState();
    getPhotoLimits();
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      ImageThumbnail row = tiles.removeAt(oldIndex);
      //ValueNotifier<int> index = _indexNotifiers.removeAt(oldIndex);

      tiles.insert(newIndex, row);
      //_indexNotifiers.insert(newIndex, index);

      //working, it updates the index within the child.
      //for (int i = 0; i < _indexNotifiers.length; i++) {
      //  _indexNotifiers[i].value = i;
      //}
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              WrapList(
                minProfilePhotos: minProfilePhotos,
                maxProfilePhotos: maxProfilePhotos,
                onReorder: _onReorder,
                tiles: tiles,
              ),
            ],
          ),
        ),
      ),
    );
  }
}



class WrapList extends StatelessWidget {
  List<Widget> tiles;
  int maxProfilePhotos;
  int minProfilePhotos;
  Function(int,int) onReorder;

  WrapList(
      {
        Key? key,
        required int this.minProfilePhotos,
        required int this.maxProfilePhotos,
        required List<Widget> this.tiles,
        required Function(int,int) this.onReorder,
      }) : super(key: key);

  final double _iconSize = 90;

  @override
  Widget build(BuildContext context) {
    return ReorderableWrap(
      spacing: 8.0,
      runSpacing: 4.0,
      //padding: const EdgeInsets.all(8),
      onReorder: onReorder,
      onNoReorder: (int index) {
        debugPrint(
            '${DateTime.now().toString().substring(5, 22)} reorder cancelled. index:$index');
      },
      onReorderStarted: (int index) {
        debugPrint(
            '${DateTime.now().toString().substring(5, 22)} reorder started. index:$index');
      },
      children: tiles,
    );
  }
}



//AFAIK everything below here is depricated
//since I moved all the state logic to the top level.




class PhotoWrapList extends ConsumerStatefulWidget {
  const PhotoWrapList(this.minPhotos, this.maxPhotos, {
    Key? key,
  }) : super(key: key);

  final int maxPhotos;
  final int minPhotos;

  @override
  ConsumerState<PhotoWrapList> createState() =>
      _PhotoWrapListState();
}

class _PhotoWrapListState extends ConsumerState<PhotoWrapList> {
  final double _iconSize = 90;
  List<Widget> _tiles = [];
  List<ValueNotifier<int>> _indexNotifiers = [];

  @override
  void initState() {
    super.initState();
    //_indexNotifiers = <ValueNotifier<int>>[
    //  ValueNotifier(0),
    //  ValueNotifier(1),
    //];

    _tiles = <ImageThumbnail>[];

    //add the correct number of mandatory photos
    for(int i = 0; i < widget.minPhotos; i++){
      _tiles.add(ImageThumbnail( imageExists: false, required: true));
    }

    //add the correct number of optional photos
    for(int i = widget.minPhotos; i < widget.maxPhotos; i++){
      _tiles.add(ImageThumbnail(imageExists: false, required: true));
    }

    //TODO get this to work, I cannot figure it out for the life of me.
    //ref.read(accountCreationProvider.notifier).addImagePath("", 0);
  }

  @override
  Widget build(BuildContext context) {
    void _onReorder(int oldIndex, int newIndex) {
      setState(() {
        Widget row = _tiles.removeAt(oldIndex);
        ValueNotifier<int> index = _indexNotifiers.removeAt(oldIndex);

        _tiles.insert(newIndex, row);
        _indexNotifiers.insert(newIndex, index);

        //working, it updates the index within the child.
        for (int i = 0; i < _indexNotifiers.length; i++) {
          _indexNotifiers[i].value = i;
        }
      });
    }

    var wrap = ReorderableWrap(
      spacing: 8.0,
      runSpacing: 4.0,
      //padding: const EdgeInsets.all(8),
      onReorder: _onReorder,
      onNoReorder: (int index) {
        debugPrint(
            '${DateTime.now().toString().substring(5, 22)} reorder cancelled. index:$index');
      },
      onReorderStarted: (int index) {
        debugPrint(
            '${DateTime.now().toString().substring(5, 22)} reorder started. index:$index');
      },
      children: _tiles,
    );

    var column = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
          child: Text('Hold and drag to reorder.'),
        ),
        wrap,
        ButtonBar(
          alignment: MainAxisAlignment.start,
          children: [
            IconButton(
              iconSize: 50,
              icon: const Icon(Icons.add_circle),
              color: Colors.deepOrange,
              padding: const EdgeInsets.all(0.0),
              onPressed: () {
                var newTile = Icon(Icons.filter_9_plus, size: _iconSize);
                setState(() {
                  _tiles.add(newTile);
                });
              },
            ),
            IconButton(
              iconSize: 50,
              icon: const Icon(Icons.remove_circle),
              color: Colors.teal,
              padding: const EdgeInsets.all(0.0),
              onPressed: () {
                setState(() {
                  _tiles.removeAt(0);
                });
              },
            )
          ],
        )
      ],
    );

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: column,
      ),
    );
  }
}

class ImageThumbnail extends ConsumerStatefulWidget {
  ImageThumbnail({
    Key? key,
    required this.imageExists,
    this.image,
    this.required = false,
    //required this.index,
  }) : super(key: key);

  bool imageExists;
  File? image;
  final bool required;
  //final ValueListenable<int> index;

  @override
  ConsumerState<ImageThumbnail> createState() => _ImageThumbnailState();
}

class _ImageThumbnailState extends ConsumerState<ImageThumbnail> {
  final size = 40.0;

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);

      if (image == null) return;

      final imageTemp = File(image.path);

      setState(() {
        widget.image = imageTemp;
        widget.imageExists = true;
      });

      //now update the riverpods notifier
      //ref.read(accountCreationProvider.notifier).addImagePath(widget.image!.path, how to get index here?);

    } on PlatformException catch (e) {
      print("Failed to pick image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.imageExists) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: Container(
          width: 3 * size,
          height: 4 * size,
          //decoration: BoxDecoration(
          //  color: Colors.orange,
          //    borderRadius: BorderRadius.all(Radius.circular(20))
          //),
          child: FittedBox(child: Image.file(widget.image!), fit: BoxFit.fill),
        ),
      );
    } else {
      if (widget.required) {
        return Container(
          width: 3 * size,
          height: 4 * size,
          decoration: const BoxDecoration(
              color: Colors.lightBlueAccent,
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: Stack(
            children: [
              //Text('${widget.index.value.toString()}'),
              Center(
                child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(100))),
                  child: IconButton(
                      onPressed: () {
                        pickImage();
                      },
                      color: Colors.lightBlueAccent,
                      icon: const Icon(Icons.add)),
                ),
              ),
            ],
          ),
        );
      } else {
        //if it is not required, thus it should be a dotted border
        return DottedBorder(
          strokeWidth: 2,
          dashPattern: [6, 6],
          color: Colors.lightBlueAccent,
          borderType: BorderType.RRect,
          radius: const Radius.circular(20.0),
          child: Container(
            width: 3 * size,
            height: 4 * size,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Stack(
              children: [
                Center(
                  child: Container(
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(100))),
                    child: IconButton(
                        onPressed: () {
                          pickImage();
                        },
                        color: Colors.lightBlueAccent,
                        icon: const Icon(Icons.add)),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    }
  }
}
