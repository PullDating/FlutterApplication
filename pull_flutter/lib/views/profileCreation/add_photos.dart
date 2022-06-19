import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:reorderables/reorderables.dart';

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
      child: Center(
        child: Container(
          width: double.infinity,
          child: PhotoWrapList(),
        ),
      ),
    );
  }
}

class PhotoWrapList extends StatefulWidget {
  const PhotoWrapList({Key? key}) : super(key: key);

  @override
  State<PhotoWrapList> createState() => _PhotoWrapListState();
}

class _PhotoWrapListState extends State<PhotoWrapList> {
  final double _iconSize = 90;
  List<Widget> _tiles = [];

  @override
  void initState() {
    super.initState();
    _tiles = <Widget>[
      ImageThumbnail(imageExists: false),
    ];
  }

  @override
  Widget build(BuildContext context) {

    void _onReorder(int oldIndex, int newIndex){
      setState(() {
        Widget row = _tiles.removeAt(oldIndex);
        _tiles.insert(newIndex, row);
      });
    }

    var wrap = ReorderableWrap(
      spacing: 8.0,
      runSpacing: 4.0,
      //padding: const EdgeInsets.all(8),
      onReorder: _onReorder,
      onNoReorder: (int index){
        debugPrint('${DateTime.now().toString().substring(5,22)} reorder cancelled. index:$index');
      },
      onReorderStarted: (int index){
        debugPrint('${DateTime.now().toString().substring(5,22)} reorder started. index:$index');
      },
      children: _tiles,
    );

    var column = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
          child: Text('Hold and drag to reorder your photos.'),
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

class ImageThumbnail extends StatefulWidget {
  const ImageThumbnail({
    Key? key,
    required this.imageExists,
    this.image,
    this.required = false,
  }) : super(key: key);

  final bool imageExists;
  final Image? image;
  final bool required;

  @override
  State<ImageThumbnail> createState() => _ImageThumbnailState();
}

class _ImageThumbnailState extends State<ImageThumbnail> {
  final size = 40.0;
  final ImagePicker _picker = ImagePicker();

  pickImage() {
    debugPrint("Selecting an image...");
  }

  @override
  Widget build(BuildContext context) {
    if(widget.imageExists) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: Container(
          width: 3*size,
          height: 4*size,
          //decoration: BoxDecoration(
          //  color: Colors.orange,
          //    borderRadius: BorderRadius.all(Radius.circular(20))
          //),
          child: FittedBox(child: widget.image, fit:BoxFit.fill),
        ),
      );
    }else{
      if(widget.required){
        return Container(
          width: 3*size,
          height: 4*size,
          decoration: const BoxDecoration(
              color: Colors.lightBlueAccent,
              borderRadius: BorderRadius.all(Radius.circular(20))
          ),
          child: Stack(

            children: [
              Center(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(100))
                  ),
                  child: IconButton(
                      onPressed: () {
                        pickImage();
                      },
                      color: Colors.lightBlueAccent,
                      icon: const Icon(Icons.add)
                  ),
                ),
              ),
            ],
          ),
        );
      }else{ //if it is not required, thus it should be a dotted border
        return DottedBorder(
          strokeWidth: 2,
          dashPattern: [6,6],
          color: Colors.lightBlueAccent,
          borderType: BorderType.RRect,
          radius: Radius.circular(20.0),
          child: Container(
            width: 3*size,
            height: 4*size,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Stack(

              children: [
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(100))
                    ),
                    child: IconButton(
                        onPressed: () {
                          pickImage();
                        },
                        color: Colors.lightBlueAccent,
                        icon: const Icon(Icons.add)
                    ),
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

