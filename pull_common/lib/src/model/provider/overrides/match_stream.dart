import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_common/src/model/entity/match.dart';
import 'package:pull_common/src/model/provider/config.dart';
import 'package:pull_common/src/model/provider/match_stream.dart';
import 'package:pull_common/src/model/sample_data/match_cards.dart';

final matchStreamRefreshOverride =
    matchStreamRefreshProvider.overrideWithProvider(Provider((ref) => () {
          final activeRefreshNotifier =
              ref.read(activeRefreshProvider.notifier);
          if (activeRefreshNotifier.state) {
            return;
          }
          activeRefreshNotifier.state = true;
          final sampleData = <Match>[];
          final pageSize = ref.read(matchPageSizeProvider);
          final matchStreamController = ref.read(matchStreamControllerProvider);
          final random = Random();
          for (var i = 0; i < pageSize; i++) {
            final r = random.nextInt(sampleMatchCards.length);
            sampleData.add(sampleMatchCards[r]);
          }
          () async {
            await Future.delayed(const Duration(milliseconds: 1000));
            ref.read(activeRefreshProvider.notifier).state = false;
            matchStreamController.add(sampleData);
          }();
        }));
