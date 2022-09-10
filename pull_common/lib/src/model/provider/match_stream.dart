import 'dart:async';
import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_common/pull_common.dart';
import 'package:pull_common/src/model/entity/match.dart';
import 'package:pull_common/src/model/provider/config.dart';
import 'package:pull_common/src/model/provider/repository.dart';

import '../sample_data/match_cards.dart';

///stream controller for the iterable matches
/// not sure what the difference is from the stream provider atm.
final matchStreamControllerProvider =
    Provider((_) => StreamController<Iterable<Match>>());

///Stream provider for iterable matches
final matchStreamProvider = StreamProvider<Iterable<Match>>((ref) async* {
  yield* ref.watch(matchStreamControllerProvider).stream;
});

///provider that returns a boolean
final activeRefreshProvider = StateProvider((ref) => false);

///presumably handles the match refresh???
final matchStreamRefreshProvider = Provider((ref) => () async {

      // //this is what they had before
      // if (!ref.read(activeRefreshProvider)) {
      //   ref.read(activeRefreshProvider.state).state = true;
      //   ref.read(repositoryProvider).nextMatches(ref);
      // }


      // this is what i'm trying to fix the problem.
      final activeRefreshNotifier = ref.read(activeRefreshProvider.notifier);
      if (activeRefreshNotifier.state) { //if it is true skip
        return;
      }
      activeRefreshNotifier.state = true; //otherwise set it to true
      List<Match> sampleData = <Match>[]; //create an empty list of matches
      final pageSize = ref.read(matchPageSizeProvider); //get the number of items to read at once.
      final matchStreamController = ref.read(matchStreamControllerProvider); //read the stream controller?

      //make call to the api for the right number of new matches
      PullRepository repo = PullRepository(ref.read);
      sampleData = await repo.getPeople(pageSize);


      () async {
        ref.read(activeRefreshProvider.notifier).state = false;
        matchStreamController.add(sampleData);
      }();
    });
