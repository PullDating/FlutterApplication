import 'package:pull_common/src/model/entity/match.dart';

import '../entity/media.dart';

final sampleMatchCards = <Match>[
  Match(
      id: 0,
      displayName: 'Aya',
      media: [Media(uri: Uri(path: 'assets/images/profile_1.webp'))],
      bio:
          'Pro: can cook\nCon: will try to get you to do the dishes\n\nPro: loves animals\n\nCon: may steal your pets'),
  Match(
      id: 1,
      displayName: 'Ryan',
      media: [
        Media(uri: Uri(path: 'assets/images/profile_2.webp')),
        Media(uri: Uri(path: 'assets/images/profile_8.webp'))
      ],
      bio: '6\'0 on a good day. Down for just about anything 😉'),
  Match(
      id: 2,
      displayName: 'Ingrid',
      media: [Media(uri: Uri(path: 'assets/images/profile_3.webp'))],
      bio:
          'sushi fiend 🍣🇯🇵\n\njust want someone who\'ll take me to Disneyland tbh'),
  Match(
      id: 3,
      displayName: 'Jane',
      media: [Media(uri: Uri(path: 'assets/images/profile_4.webp'))],
      bio: 'in need of attention'),
  Match(
      id: 4,
      displayName: 'Ella',
      media: [Media(uri: Uri(path: 'assets/images/profile_5.webp'))]),
  Match(
      id: 5,
      displayName: 'Isabelle',
      media: [Media(uri: Uri(path: 'assets/images/profile_6.webp'))]),
  Match(
      id: 6,
      displayName: 'Chloe',
      media: [Media(uri: Uri(path: 'assets/images/profile_7.webp'))]),
  Match(
      id: 7,
      displayName: 'Daniel',
      media: [Media(uri: Uri(path: 'assets/images/profile_9.webp'))]),
  Match(
      id: 8,
      displayName: 'Sara',
      media: [Media(uri: Uri(path: 'assets/images/profile_10.webp'))]),
  Match(
      id: 9,
      displayName: 'Ashley',
      media: [Media(uri: Uri(path: 'assets/images/profile_11.webp'))]),
];
