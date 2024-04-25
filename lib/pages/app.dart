import 'package:carrot/generated/assets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'homeActivity.dart';

// <===== < App > =====>
class App extends StatefulWidget {
  const App({super.key, required this.title});

  final String title;

  // creating App state
  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  List<Map<String, String>> data = [];
  int currPageIdx = 0;

  @override
  void initState() {
    super.initState();
  }

  // <===== start of BODY =====>
  Widget CustomBody() {
    switch(currPageIdx){
      case 0: return HomeActivity();
      case 1: return Container();
      case 2: return Container();
      case 3: return Container();
      case 3: return Container();
    }
    return Container();
  }

  // <===== start of BOTTOM_NAVBAR =====>
  Widget CustomBottomNavbar() {
    return BottomNavigationBar(
      items: [
        [Assets.svgHomeOff, Assets.svgHomeOn, "홈"],
        [Assets.svgNotesOff, Assets.svgNotesOn, "동네 생활"],
        [Assets.svgLocationOff, Assets.svgLocationOn, "내 근처"],
        [Assets.svgChatOff, Assets.svgChatOn, "채팅"],
        [Assets.svgUserOff, Assets.svgUserOn, "나의 당근"]
      ].map((el) => BottomNavigationBarItem(
          icon: Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: SvgPicture.asset(el[0], width: 22)),
          label: el[2],
          activeIcon: SvgPicture.asset(el[1], width: 22)))
          .toList(),
      onTap: (int index) {
        setState(() {
          currPageIdx = index;
        });
      },
      currentIndex: currPageIdx,
      type: BottomNavigationBarType.fixed,
    );
  }

  @override
  Widget build(BuildContext context) {
    // build 부분은 간단하게!

    return Scaffold(
      body: CustomBody(),
      bottomNavigationBar: CustomBottomNavbar(),
    );
  }
}
