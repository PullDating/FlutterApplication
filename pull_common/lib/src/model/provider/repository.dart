import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_common/pull_common.dart';

final repositoryProvider = Provider((ref) => PullRepository(ref.read));
