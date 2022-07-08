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
import 'package:pull_common/src/model/provider/create_account.dart';

//state variables for the page:
int numPhotos = 0;
int maxPhotos = 8;
int minPhotos = 3;

class ProfilePhotoField extends ConsumerStatefulWidget {
  const ProfilePhotoField({Key? key}) : super(key: key);

  @override
  ConsumerState<ProfilePhotoField> createState() => _ProfilePhotoFieldState();
}

class _ProfilePhotoFieldState extends ConsumerState<ProfilePhotoField> {
  final Storage storage = Storage();
  String? state;
  Future<Directory>? _appDocDir;

  @override
  void initState() {
    super.initState();
    storage.readData().then((String value) => {
          setState(() {
            state = value;
            print("State ${state}");
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Container(
          width: double.infinity,
          child: Column(
            children: [
              Text('${state ?? "File is Empty"}'),
              ElevatedButton(
                  onPressed: () {
                    state = "ma name jeff.";
                    print("the text in state is now: ${state}");
                  },
                  child: Text("Press to change text")),
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _appDocDir = getApplicationDocumentsDirectory();
                      //print("application directory: ${_appDocDir}");
                    });
                  },
                  child: Text("Press to read data directory")),
              FutureBuilder<Directory>(
                future: _appDocDir,
                builder:
                    (BuildContext context, AsyncSnapshot<Directory> snapshot) {
                  Text text = Text('');
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      text = Text('Error: ${snapshot.error}');
                    } else if (snapshot.hasData) {
                      text = Text('Path: ${snapshot.data!.path}');
                    } else {
                      text = Text('unavailable');
                    }
                  }
                  return new Container(
                    child: text,
                  );
                },
              ),
              ElevatedButton(
                  onPressed: () {
                    setState(() async {
                      state = await storage.readData();
                      print("got ${state} from the file system");
                    });
                  },
                  child: Text("Press to read data")),
              ElevatedButton(
                onPressed: () {
                  storage.writeData(state ?? "Nothing to write");
                },
                child: Text('Write the data to the database'),
              ),
              PhotoWrapList(),
            ],
          ),
        ),
      ),
    );
  }
}

class PhotoWrapList extends ConsumerStatefulWidget {
  const PhotoWrapList({Key? key}) : super(key: key);

  @override
  ConsumerState<PhotoWrapList> createState() => _PhotoWrapListState();
}

class _PhotoWrapListState extends ConsumerState<PhotoWrapList> {
  final double _iconSize = 90;
  List<Widget> _tiles = [];
  List<ValueNotifier<int>> _indexNotifiers = [];

  @override
  void initState() {
    super.initState();
    _indexNotifiers = <ValueNotifier<int>>[
      ValueNotifier(0),
      ValueNotifier(1),
    ];
    _tiles = <ImageThumbnail>[
      ImageThumbnail(
        imageExists: false,
        index: _indexNotifiers[0],
        required: true,
      ),
      ImageThumbnail(
        imageExists: false,
        index: _indexNotifiers[1],
        required: true,
      ),
    ];

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
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
          child: Text('Hold and drag to reorder.'),
        ),
        wrap,
        ButtonBar(
          alignment: MainAxisAlignment.start,
          children: [
            IconButton(
              iconSize: 50,
              icon: Icon(Icons.add_circle),
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
              icon: Icon(Icons.remove_circle),
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
    required this.index,
  }) : super(key: key);

  bool imageExists;
  File? image;
  final bool required;
  final ValueListenable<int> index;

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
              Text('${widget.index.value.toString()}'),
              Center(
                child: Container(
                  decoration: BoxDecoration(
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
          radius: Radius.circular(20.0),
          child: Container(
            width: 3 * size,
            height: 4 * size,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Stack(
              children: [
                Center(
                  child: Container(
                    decoration: BoxDecoration(
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

class Storage {
  Future<String> get localPath async {
    final dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }

  Future<File> get localFile async {
    final path = await localPath;
    return File('$path/db.txt');
  }

  Future<String> readData() async {
    try {
      final file = await localFile;
      String body = await file.readAsString();
      return body;
    } catch (e) {
      return e.toString();
    }
  }

  Future<File> writeData(String data) async {
    final file = await localFile;
    return file.writeAsString("$data");
  }
}
