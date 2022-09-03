import 'dart:convert';
import 'dart:io';
import 'dart:math';

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
import 'package:fluttertoast/fluttertoast.dart';

class ProfilePhotoField extends ConsumerStatefulWidget {
  const ProfilePhotoField({Key? key}) : super(key: key);

  @override
  ConsumerState<ProfilePhotoField> createState() => _ProfilePhotoFieldState();
}

class _ProfilePhotoFieldState extends ConsumerState<ProfilePhotoField> {

  int minProfilePhotos = 2;
  int maxProfilePhotos = 7;

  List<File?> imageList = [];


  void deleteImageCallback(int index){ //for when a thumbnail deletes an image.
    ref.read(ProfilePhotosProvider.notifier).removeImage(index);
  }

  Future pickImage(int index) async {
    try {
      print("trying to pick image.");
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null){
        print("image was null, didn't pick image.");
        return;
      }
      ref.read(ProfilePhotosProvider.notifier).setImage(File(image.path), index);
    } on PlatformException catch (e) {
      print("Failed to pick image: $e");
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  @override
  void initState() {
    //TODO make request to server to get min and max photo limits.
    super.initState();
    //imageList = List<File?>.filled(7, null);
    //imageList = ref.watch(ProfilePhotosProvider).images;
  }



  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      //check to make sure they aren't arranging the empty ones
      if(imageList[oldIndex] == null){
        print("cannot move an empty image tile.");
        return;
      }

      File? temp = imageList[oldIndex];
      imageList[oldIndex] = imageList[newIndex];
      imageList[newIndex] = temp;
      //TODO check to make sure the rearrange is working properly. It doesn't seem to be here


    });
  }

  @override
  Widget build(BuildContext context) {

    List<File?> imageList = ref.watch(ProfilePhotosProvider).images;
    print("image list in build method" + imageList.toString());
    int maxProfilePhotos = ref.watch(ProfilePhotosProvider).max;
    print("maxProfilePhotos: " + maxProfilePhotos.toString());
    int minProfilePhotos = ref.watch(ProfilePhotosProvider).min;
    print("minProfilePhotos: " + minProfilePhotos.toString());
    bool mandatoryFilled = ref.watch(ProfilePhotosProvider).mandatoryFilled;
    print("mandatoryFilled: " + mandatoryFilled.toString());
    int totalFilled = ref.watch(ProfilePhotosProvider).numFilled;
    print("Total Filled: " + totalFilled.toString());

    var tiles = <ImageThumbnailV2>[];
    for(int i = 0; i < minProfilePhotos; i++){
      tiles.add(ImageThumbnailV2(
        image: imageList[i],
        pickImage: pickImage,
        deleteImageCallback: deleteImageCallback,
        index: i,
        required: true,
        mandatoryFilled: mandatoryFilled,
      ));
    }

    //add the correct number of optional photos
    //print("must be less than: ${min(max(minProfilePhotos+1, totalFilled+1),maxProfilePhotos)}");
    print("image list length: ${imageList.length}");

    //shouldn't it just be the difference between the total possible number and the number you have now.
    for(int i = minProfilePhotos; i < min(max(minProfilePhotos+1, totalFilled+1),maxProfilePhotos); i++){
      print("i: $i");

      if(imageList.length > i){
        tiles.add(ImageThumbnailV2(
          image: imageList[i],
          pickImage: pickImage,
          deleteImageCallback: deleteImageCallback,
          index: i,
          required: false,
          mandatoryFilled: mandatoryFilled,
        ));
      } else {
        tiles.add(ImageThumbnailV2(
          image: null,
          pickImage: pickImage,
          deleteImageCallback: deleteImageCallback,
          index: i,
          required: false,
          mandatoryFilled: mandatoryFilled,
        ));
      }


    }

    return Material(
      child: Center(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: WrapList(
                  onReorder: _onReorder,
                  tiles: tiles,
                ),
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
  Function(int,int) onReorder;
  WrapList(
      {
        Key? key,
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

class ImageThumbnailV2 extends StatelessWidget {
  ImageThumbnailV2({
    Key? key,
    required this.pickImage,
    required this.deleteImageCallback,
    this.image,
    required this.index,
    required this.required,
    required this.mandatoryFilled,
  }) : super(key: key);

  //functions in the parent to call
  Function pickImage;
  Function deleteImageCallback;

  //payload
  File? image;

  //relevant state variables
  int index;
  bool required;
  bool mandatoryFilled;

  @override
  Widget build(BuildContext context) {
    final size = 40.0; //just a variable to determine size of the tiles.

    if (image != null) {
      //print("image was not null");
      return ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: Container(
          width: 3 * size,
          height: 4 * size,
          //decoration: BoxDecoration(
          //  color: Colors.orange,
          //    borderRadius: BorderRadius.all(Radius.circular(20))
          //),
          child: Stack(
            children: [
              SizedBox(
                width: 3 * size,
                height: 4 * size,
                child: FittedBox(child: Image.file(image!), fit: BoxFit.fitWidth),
              ),
              //FittedBox(child: Image.file(image!), fit: BoxFit.fill),
              IconButton(
                icon: const Icon(Icons.delete),
                tooltip: "delete photo",
                onPressed: () {
                  deleteImageCallback(index);
                },
              )
            ],
          ),
        ),
      );
    } else {
      if (required) {
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
                      onPressed: () async {
                        await pickImage(index);
                      },
                      color: Colors.lightBlueAccent,
                      icon: const Icon(Icons.add)),
                ),
              ),
            ],
          ),
        );
      } else {
        //print("image does not exist.");
        //if it is not required, thus it should be a dotted border
        return Container(
          width: 3 * size,
          height: 4 * size,
          child: DottedBorder(
            strokeWidth: 2,
            dashPattern: [6, 6],
            color: Colors.lightBlueAccent,
            borderType: BorderType.RRect,
            radius: const Radius.circular(20.0),
            child: Container(
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
                          onPressed: () async {
                            if(mandatoryFilled){ //only allow them to pick these ones if the mandatory ones are already filled.
                              await pickImage(index);
                            }else{
                              Fluttertoast.showToast(
                                  msg: "You have to add the mandatory photos first!",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.SNACKBAR,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.pinkAccent,
                                  textColor: Colors.white,
                                  fontSize: 16.0
                              );
                            }
                          },
                          color: Colors.lightBlueAccent,
                          icon: const Icon(Icons.add)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    }
  }
}

//AFAIK PhotoWrapList here is depricated
//since I moved all the state logic to the top level, call the other one.


/*
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
*/








/*
class ImageThumbnail extends ConsumerStatefulWidget {
  ImageThumbnail({
    Key? key,
    required this.imageExists,
    this.image,
    this.required = false,
    required this.mandatoryFilled,
    required this.index,
    required this.selectImageCallback,
    required this.deleteImageCallback,
    //required this.index,
  }) : super(key: key);

  Function deleteImageCallback;
  Function selectImageCallback;
  int index;
  bool imageExists;
  File? image;
  final bool required;
  bool mandatoryFilled; //tells if the first minProfilePhotos have been filled in the current state.
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
      widget.selectImageCallback(widget.index);
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
        return Container(
          width: 3 * size,
          height: 4 * size,
          child: DottedBorder(
            strokeWidth: 2,
            dashPattern: [6, 6],
            color: Colors.lightBlueAccent,
            borderType: BorderType.RRect,
            radius: const Radius.circular(20.0),
            child: Container(
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
                            if(widget.mandatoryFilled){ //only allow them to pick these ones if the mandatory ones are already filled.
                              pickImage();
                            }else{
                              Fluttertoast.showToast(
                                  msg: "You have to add the mandatory photos first!",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.SNACKBAR,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.pinkAccent,
                                  textColor: Colors.white,
                                  fontSize: 16.0
                              );
                            }
                          },
                          color: Colors.lightBlueAccent,
                          icon: const Icon(Icons.add)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    }
  }
}

 */
