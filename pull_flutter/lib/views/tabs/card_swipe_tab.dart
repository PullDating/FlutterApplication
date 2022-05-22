import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_common/match_cards.dart';

/// The cards tab, displaying a stack of potential matches
class CardSwipeTab extends ConsumerWidget {
  const CardSwipeTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const MatchCards();
  }
}
