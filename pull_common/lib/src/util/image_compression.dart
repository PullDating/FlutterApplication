import 'dart:io';
import 'dart:math';

import 'package:flutter_image_compress/flutter_image_compress.dart';

final int targetWidth = 750;
final int targetHeight = 1334;

Future<List<File?>> compressProfilePhotos(List<File?> images) async {
  int i = 0;
  List<File?> newImages = [];
  compresscallback(File? value) async {
    //print("entered callback with value: ${value.toString()}");
    newImages.add(value);
    i++;
    if (i < images.length) {
      //print("${i} was less than images.length, continuing");
      //keep going down the list.
      if (images[i] != null) {
        print("images[i] was not null");
        //if it isn't an empty file
        await compressProfilePhoto(images[i]!).then((value) async {
          //print("called callback with value: " + value.toString())
          await compresscallback(value);
        });
      } else {
        //print("images[i] was null");
        compresscallback(null);
      }
    } else {
      //print("i was greater than or equal to images.length");
      //this is the final one.
      return newImages;
    }
  }

  if (images[0] != null) {
    await compressProfilePhoto(images[0]!)
        .then((value) async {await compresscallback(value);});
  } else {
    throw Exception("The profile list entered for compression was invalid.");
  }

  return newImages;
}

Future<File> compressProfilePhoto(File image) async {
  final imageUri = Uri.parse(image.path);
  //final String outputUri = imageUri.resolve('./output.webp').toString();
  //print(imageUri.toFilePath());

  //print("imagepath: " + image.absolute.path);

  // //var cacheManager = await DefaultCacheManager();
  // final splitted = image.absolute.path.split('/cache/');
  //
  // String newpath = splitted[0] + '/cache/compressed/' + splitted[1];
  //
  // //find position of last . because that will be the file extension.
  // int? index = null;
  // for(int i = newpath.length-1; i > 0; i--){
  //   if(newpath[i] == '.'){
  //     index = i;
  //     break;
  //   }
  // }

  //
  // newpath  = newpath.substring(0, index);
  // print("new image path: " + newpath);

  var result;
  //result = new File('compressed/${image.path}');
  try {
    String salt = getRandomString(15);
    final String outputUri = imageUri.resolve('./compressionoutput${salt}.webp').toString();
    //print("trying with webp");
    result = await FlutterImageCompress.compressAndGetFile(
      image.absolute.path,
      outputUri,
      quality: 88,
      format: CompressFormat.webp,
      minWidth: targetWidth,
      minHeight: targetHeight,
      inSampleSize: 1,
    ).then((value) {
      //print("finished with image compression.");
      //print(image.lengthSync());
      //print(value!.lengthSync());
      //print("value path: " + value.path);
      //print("value: " + value.toString());
      return value;
    });
    return result;
  } on UnsupportedError catch (e) {
    print(e);
    //print("webp didn't work, trying with jpeg.");
    String salt = getRandomString(15);
    final String outputUri = imageUri.resolve('./compressionoutput${salt}.jpeg').toString();
    result = await FlutterImageCompress.compressAndGetFile(
      image.absolute.path,
      outputUri,
      quality: 88,
      format: CompressFormat.jpeg,
      minWidth: targetWidth,
      minHeight: targetHeight,
      inSampleSize: 1,
    ).then((value) {
      print(image.lengthSync());
      print(value!.lengthSync());
      return value;
    });
  } catch (e) {
    print(e);
    throw Exception("Couldn't compress image.");
  }

  // if (result == null) {
  //   print("Couldn't compress image. No result returned.");
  //   throw Exception("Error compressing images.");
  // } else {
  //   print("Results of image compression");
  //
  //   print(result!.lengthSync());
  //   return result;
  // }
  throw Exception("Got to end of compression function, which shouldn't happen");
}

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
Random _rnd = Random();

String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));