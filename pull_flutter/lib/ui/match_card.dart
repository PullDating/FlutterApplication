import 'dart:io';

import 'package:flutter/material.dart';
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
          child: Stack(
            children: [
              Positioned.fill(
                child: Scrollbar(
                  child: ListView(
                    scrollDirection: Axis.vertical,
                    children: [
                      (fromFile)? Image.file(File(match.media.first.uri.path)) : Image(image: AssetImage(match.media.first.uri.toString())),
                      if (match.bio.isNotEmpty)
                        Container(
                          color: theme.canvasColor,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 24),
                            child: Text(match.bio),
                          ),
                        )
                    ],
                  ),
                ),
              ),
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
                      match.displayName,
                      style: theme.textTheme.headline6!.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
