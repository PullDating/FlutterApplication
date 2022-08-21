import 'dart:io';

import 'package:flutter/material.dart';
import 'package:measured_size/measured_size.dart';
import 'package:pull_common/pull_common.dart';

/// A single decorated [Match] card for use in the [MatchCards] widget
class PullMatchCard extends StatelessWidget {
  const PullMatchCard({
    required this.match,
    required this.fromFile,
    Key? key,
  }) : super(key: key);

  final Match match;
  //true if it is from a file on the device, false if not (network probably)
  final bool fromFile;

  @override
  Widget build(BuildContext context) {

    List<Widget> imageTiles = [];
    for(int i = 0; i < match.media.length; i++){
      imageTiles.add(
          DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0)
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.horizontal(left: Radius.circular(12)),
             // borderRadius: BorderRadius.circular(12.0),
              child: (fromFile)? Image.file(File(match.media.elementAt(i).uri.path)) : Image(image: AssetImage(match.media.elementAt(i).uri.toString())),
            ),
          )
      );
    }

    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 84.0),
      child: DecoratedBox(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: [
              BoxShadow(
                  offset: const Offset(0, 2),
                  blurRadius: 8,
                  color: Colors.black12.withAlpha(56))
            ]),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.0),
          child: Container(
            color: Colors.white,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Scrollbar(
                    child: ListView(
                      scrollDirection: Axis.vertical,
                      children: [

                        //intentionally making the photos smaller to detract their importance.
                        //on the left hand side is a column that has the information
                        //on the right hand side is a column that has the photos, laid out one after the other
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //for the profile information
                            Expanded(
                              flex: 3,
                              child: Container(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Text(
                                              "${match.displayName}",
                                            style: TextStyle(
                                              fontSize: 32
                                            ),
                                          ),
                                          Text(
                                            "${match.age}",
                                            style: TextStyle(
                                              fontSize: 22
                                            ),
                                          ),

                                          if(match.bio.isNotEmpty)
                                            Text(match.bio),
                                          if(match.bodyType != null)
                                            Row(
                                              children: [
                                                Icon(Icons.man),
                                                Text("${match.bodyType}")
                                              ],
                                            ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            //for the photos.
                            Expanded(
                              flex: 2,
                              child: Column(
                                children: imageTiles,
                                // children: [
                                //   Text("This is where the photos will go")
                                // ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                /*
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(14),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: <Color>[
                          Colors.black12.withOpacity(0),
                          Colors.black12.withOpacity(.2),
                          Colors.black12.withOpacity(.66),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12),
                      Text(
                        "${match.displayName}, ${match.age}",
                        style: theme.textTheme.headline6!.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                */
              ],
            ),
          ),
        ),
      ),
    );
  }
}
