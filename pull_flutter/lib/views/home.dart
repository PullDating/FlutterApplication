import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_flutter/views/tabs/card_swipe_tab.dart';
import 'package:pull_flutter/views/tabs/chats_tab.dart';

class PullHomePage extends ConsumerStatefulWidget {
  const PullHomePage({Key? key, required this.title, required this.path}) : super(key: key);

  final String title;
  final String path;

  @override
  ConsumerState<PullHomePage> createState() => _PullHomePageState();
}

class _PullHomePageState extends ConsumerState<PullHomePage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  final tabs = <String, WidgetBuilder>{
    'cards': (BuildContext context) {
      return const CardSwipeTab();
    },
    'chats': (BuildContext context) {
      return const ChatsTab();
    }
  };

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.fastOutSlowIn,
        child: tabs[widget.path]!(context),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(label: 'Cards', icon: Icon(Icons.people_outline_sharp)),
          BottomNavigationBarItem(label: 'Chats', icon: Icon(Icons.chat))
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
