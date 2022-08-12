import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_common/match_cards.dart';
import 'package:pull_flutter/ui/match_card.dart';

/// The cards tab, displaying a stack of potential matches
class CardSwipeTab extends ConsumerWidget {
  const CardSwipeTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print("loading cards tab");
    return MatchCards(cardBuilder: (context, match) {
      return PullMatchCard(match: match);
    });
  }
}
