import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_common/src/model/entity/match.dart';
import 'package:pull_common/src/model/provider/config.dart';
import 'package:pull_common/src/model/provider/match_stream.dart';
import 'package:swipable_stack/swipable_stack.dart';

/// A [ThemeExtension] that allows theming the [MatchCards] widget
class MatchCardsTheme extends ThemeExtension<MatchCardsTheme> {
  const MatchCardsTheme(
      {this.rewindColor = Colors.orange, this.swipeLeftColor = Colors.red, this.swipeRightColor = Colors.green});

  /// The color of the rewind button
  final Color rewindColor;

  /// The color of the left swipe button
  final Color swipeLeftColor;

  /// The color of the right swipe button
  final Color swipeRightColor;

  @override
  ThemeExtension<MatchCardsTheme> copyWith({Color? rewindColor, Color? swipeLeftColor, Color? swipeRightColor}) {
    return MatchCardsTheme(
        rewindColor: rewindColor ?? this.rewindColor,
        swipeLeftColor: swipeLeftColor ?? this.swipeLeftColor,
        swipeRightColor: swipeRightColor ?? this.swipeRightColor);
  }

  @override
  ThemeExtension<MatchCardsTheme> lerp(ThemeExtension<MatchCardsTheme>? other, double t) {
    final _other = other is MatchCardsTheme ? other : null;
    return MatchCardsTheme(
      rewindColor: Color.lerp(this.rewindColor, _other?.rewindColor, t) ?? this.rewindColor,
      swipeLeftColor: Color.lerp(this.swipeLeftColor, _other?.swipeLeftColor, t) ?? this.swipeLeftColor,
      swipeRightColor: Color.lerp(this.swipeRightColor, _other?.swipeRightColor, t) ?? this.swipeRightColor,
    );
  }
}

/// Displays a swipeable stack of cards built from a list of [Match]es, along with an overlay of button
/// actions.
class MatchCards extends ConsumerStatefulWidget {
  const MatchCards({Key? key}) : super(key: key);

  @override
  _MatchCardsState createState() => _MatchCardsState();
}

class _MatchCardsState extends ConsumerState<MatchCards> {
  late final SwipableStackController _controller;
  late final List<Match?> matches;
  late final int pageSize;

  /// [MatchCards] uses a circular buffer to store the list of suggested matches. [bufferIndex] keeps track of our
  /// current position in it
  int bufferIndex = 0;

  int lastSwipeIndex = -3;
  int expectedCard = 0;

  void _listenController() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    print('insi');
    _controller = SwipableStackController()..addListener(_listenController);

    pageSize = ref.read(matchPageSizeProvider);

    /// Create the match list as 2x the page size
    matches = List.filled(pageSize * 2, null);

    /// Listen for new match suggestions and update the list
    ref.listenOnce<AsyncValue<Iterable<Match>>>(matchStreamProvider, (previous, next) {
      next.whenData((value) {
        setState(() {
          expectedCard = bufferIndex = (lastSwipeIndex + 3) % matches.length;
          for (final m in value) {
            matches[bufferIndex++] = m;
            bufferIndex = bufferIndex % matches.length;
          }
          for (var i = 0; i < pageSize - 1; i++) {
            print(bufferIndex);
            matches[bufferIndex++] = null;
            bufferIndex = bufferIndex % matches.length;
          }
        });
      });
    });

    ref.read(matchStreamRefreshProvider)();
  }

  @override
  void dispose() {
    super.dispose();
    _controller
      ..removeListener(_listenController)
      ..dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (matches[expectedCard] == null) {
      return Material(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Stack(
      children: [
        Positioned.fill(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: SwipableStack(
              controller: _controller,
              stackClipBehaviour: Clip.none,
              allowVerticalSwipe: false,
              onWillMoveNext: (index, swipeDirection) {
                final itemIndex = index % matches.length;
                final match = matches[itemIndex];
                if (match == null) {
                  return false;
                }
                switch (swipeDirection) {
                  case SwipeDirection.left:
                  case SwipeDirection.right:
                    return true;
                  case SwipeDirection.up:
                  case SwipeDirection.down:
                    return false;
                }
              },
              onSwipeCompleted: (index, direction) {
                final itemIndex = index % matches.length;
                // If we're getting close to the end of the current data, refresh with new data
                if (itemIndex == pageSize - 3 || itemIndex == matches.length - 3) {
                  lastSwipeIndex = itemIndex;
                  ref.read(matchStreamRefreshProvider)();
                }
              },
              horizontalSwipeThreshold: 0.8,
              // Set max value to ignore vertical threshold.
              verticalSwipeThreshold: 1,
              builder: (context, properties) {
                final itemIndex = properties.index % matches.length;
                final match = matches[itemIndex];
                if (match == null) {
                  // If the match has not yet loaded, wait 200 ms and then try again
                  () async {
                    await Future.delayed(const Duration(milliseconds: 200));
                    setState(() {});
                  }();
                  return Card(child: Center(child: CircularProgressIndicator()));
                }
                return MatchCard(
                  match: match,
                );
              },
            ),
          ),
        ),
        BottomButtonsRow(
          onSwipe: (direction) {
            _controller.next(swipeDirection: direction);
          },
          onRewindTap: _controller.rewind,
          canRewind: _controller.canRewind,
        ),
      ],
    );
  }
}

/// A single decorated [Match] card for use in the [MatchCards] widget
class MatchCard extends StatelessWidget {
  const MatchCard({
    required this.match,
    Key? key,
  }) : super(key: key);

  final Match match;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ClipRRect(
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: BorderRadius.circular(14),
                image: DecorationImage(
                  image: AssetImage(match.media[0].uri.toString()),
                  fit: BoxFit.cover,
                ),
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, 2),
                    blurRadius: 26,
                    color: Colors.black.withOpacity(0.08),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(14),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[
                    Colors.black12.withOpacity(0),
                    Colors.black12.withOpacity(.4),
                    Colors.black12.withOpacity(.82),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  match.displayName,
                  style: theme.textTheme.headline6!.copyWith(
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: BottomButtonsRow.height)
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// A row of action buttons that overlays the [MatchCards] along the bottom
/// Contains buttons for rewind, swipe left, and swipe right
class BottomButtonsRow extends StatelessWidget {
  const BottomButtonsRow({
    required this.onRewindTap,
    required this.onSwipe,
    required this.canRewind,
    Key? key,
  }) : super(key: key);

  final bool canRewind;
  final VoidCallback onRewindTap;
  final ValueChanged<SwipeDirection> onSwipe;

  static const double height = 100;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: SizedBox(
          height: height,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _BottomButton(
                color: canRewind
                    ? Theme.of(context).extension<MatchCardsTheme>()?.rewindColor ?? Colors.orange
                    : Colors.grey,
                onPressed: canRewind ? onRewindTap : null,
                child: const Icon(Icons.refresh),
              ),
              _BottomButton(
                color: Theme.of(context).extension<MatchCardsTheme>()?.swipeLeftColor ?? Colors.red,
                child: const Icon(Icons.arrow_back),
                onPressed: () {
                  onSwipe(SwipeDirection.left);
                },
              ),
              _BottomButton(
                color: Theme.of(context).extension<MatchCardsTheme>()?.swipeRightColor ?? Colors.green,
                onPressed: () {
                  onSwipe(SwipeDirection.right);
                },
                child: const Icon(Icons.arrow_forward),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomButton extends StatelessWidget {
  const _BottomButton({
    required this.onPressed,
    required this.child,
    required this.color,
    Key? key,
  }) : super(key: key);

  final VoidCallback? onPressed;
  final Icon child;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64,
      width: 64,
      child: ElevatedButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.resolveWith(
            (states) => RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
          ),
          backgroundColor: MaterialStateProperty.resolveWith(
            (states) => color,
          ),
        ),
        onPressed: onPressed,
        child: child,
      ),
    );
  }
}
