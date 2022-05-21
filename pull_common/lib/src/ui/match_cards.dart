import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pull_common/src/model/entity/match.dart';
import 'package:swipable_stack/swipable_stack.dart';

class MatchCardsTheme extends ThemeExtension<MatchCardsTheme> {
  const MatchCardsTheme(
      {this.rewindColor = Colors.orange, this.swipeLeftColor = Colors.red, this.swipeRightColor = Colors.green});

  final Color rewindColor;
  final Color swipeLeftColor;
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

class MatchCards extends StatefulWidget {
  const MatchCards(this.potentialMatches, {Key? key}) : super(key: key);

  final List<Match> potentialMatches;

  @override
  _MatchCardsState createState() => _MatchCardsState();
}

class _MatchCardsState extends State<MatchCards> {
  late final SwipableStackController _controller;

  void _listenController() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _controller = SwipableStackController()..addListener(_listenController);
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
                if (kDebugMode) {
                  print('$index, $direction');
                }
              },
              horizontalSwipeThreshold: 0.8,
              // Set max value to ignore vertical threshold.
              verticalSwipeThreshold: 1,
              builder: (context, properties) {
                final itemIndex = properties.index % widget.potentialMatches.length;
                return MatchCard(
                  match: widget.potentialMatches[itemIndex],
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
                borderRadius: BorderRadius.circular(14),
                image: DecorationImage(
                  image: AssetImage(match.media[0].toString()),
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
