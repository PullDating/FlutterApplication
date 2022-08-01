import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_common/src/model/entity/match.dart';
import 'package:pull_common/src/model/provider/repository.dart';

final matchStreamControllerProvider =
    Provider((_) => StreamController<Iterable<Match>>());

final matchStreamProvider = StreamProvider<Iterable<Match>>((ref) async* {
  yield* ref.watch(matchStreamControllerProvider).stream;
});

final activeRefreshProvider = StateProvider((ref) => false);

final matchStreamRefreshProvider = Provider((ref) => () {
      if (!ref.read(activeRefreshProvider)) {
        ref.read(activeRefreshProvider.state).state = true;
        ref.read(repositoryProvider).nextMatches();
      }
    });
