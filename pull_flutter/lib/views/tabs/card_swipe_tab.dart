import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_common/match_cards.dart';
import 'package:pull_common/pull_common.dart';

/// The cards tab, displaying a stack of potential matches
class CardSwipeTab extends ConsumerWidget {
  const CardSwipeTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MatchCards([
      Match(id: 0, displayName: 'James', media: [Uri.parse('assets/images/sample_1.jpg')]),
      Match(id: 1, displayName: 'Sylvie', media: [Uri.parse('assets/images/sample_2.jpg')]),
      Match(id: 2, displayName: 'Vivian', media: [Uri.parse('assets/images/sample_3.jpg')])
    ]);
  }
}
