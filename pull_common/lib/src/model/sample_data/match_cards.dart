import 'package:pull_common/src/model/entity/match.dart';

import '../entity/media.dart';

final sampleMatchCards = <Match>[
  Match(id: 0, displayName: 'Aya', media: [Media(uri: Uri(path: 'assets/images/profile_1.webp'))]),
  Match(id: 1, displayName: 'Ryan', media: [
    Media(uri: Uri(path: 'assets/images/profile_2.webp')),
    Media(uri: Uri(path: 'assets/images/profile_8.webp'))
  ]),
  Match(id: 2, displayName: 'Ingrid', media: [Media(uri: Uri(path: 'assets/images/profile_3.webp'))]),
  Match(id: 3, displayName: 'Jane', media: [Media(uri: Uri(path: 'assets/images/profile_4.webp'))]),
  Match(id: 4, displayName: 'Ella', media: [Media(uri: Uri(path: 'assets/images/profile_5.webp'))]),
  Match(id: 5, displayName: 'Isabelle', media: [Media(uri: Uri(path: 'assets/images/profile_6.webp'))]),
  Match(id: 6, displayName: 'Chloe', media: [Media(uri: Uri(path: 'assets/images/profile_7.webp'))]),
  Match(id: 7, displayName: 'Daniel', media: [Media(uri: Uri(path: 'assets/images/profile_9.webp'))]),
  Match(id: 8, displayName: 'Sara', media: [Media(uri: Uri(path: 'assets/images/profile_10.webp'))]),
  Match(id: 9, displayName: 'Ashley', media: [Media(uri: Uri(path: 'assets/images/profile_11.webp'))]),
];
