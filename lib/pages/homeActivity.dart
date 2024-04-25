import 'package:carrot/generated/assets.dart';
import 'package:carrot/repository/contents_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

final oCcy = new NumberFormat("#,###", 'ko_KR');
String calcStringToWon(String priceString) =>
    priceString == '무료나눔' ? "나눔♥️" : "${oCcy.format(int.parse(priceString))}원";

// <===== < Home_Activity > =====>
class HomeActivity extends StatefulWidget {
  const HomeActivity({super.key});

  @override
  State<HomeActivity> createState() => _HomeActivityState();
}

// <===== start of Home_Build =====>
class _HomeActivityState extends State<HomeActivity> {
  String currLocation = "화곡";
  ContentsRepository contentsRepository = ContentsRepository();

  @override
  void initState() {
    super.initState();
  }

  // <===== start of Home_AppBar Widget =====>
  PreferredSizeWidget _HomeAppBar() {
    return AppBar(
      surfaceTintColor: Colors.white,
      shadowColor: Colors.black.withOpacity(0.7),
      titleTextStyle: TextStyle(fontSize: 17),
      title: PopupMenuButton<String>(
        // itemBuilder: 드롭다운 클릭했을 때 아래로 내려오는 아이템들 생성
        itemBuilder: (BuildContext context) {
          return [
            PopupMenuItem(value: "화곡", child: Text("화곡동")),
            PopupMenuItem(value: "발산", child: Text("발산동")),
            PopupMenuItem(value: "마곡", child: Text("마곡동"))
          ];
        },
        child: Row(
          children: [Text('강서구 ${currLocation}동'), Icon(Icons.arrow_drop_down)],
        ),
        onSelected: (String item) => setState(() => currLocation = item),
        shape: ShapeBorder.lerp(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            1),
        offset: Offset(0, 28),
      ),
      elevation: 1,
      actions: [
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(Icons.tune),
          onPressed: () {},
        ),
        IconButton(
          icon: SvgPicture.asset(Assets.svgBell, width: 20, height: 20),
          onPressed: () {},
        ),
      ],
    );
  }

  _renderListData(data) {
    return ListView.separated(
        // PopupMenu의 itemBuilder: 각각 list의 아이템을 만드는 빌더. 아이템 원소 하나에 대한 내용
        itemBuilder: (BuildContext _context, int index) {
          // index: 0 ~ 아이템 원소의 길이.
          // map돌면서 아이템 원소 크기 만큼 itmeBuilder로 ListView 안의 각각의 item을 생성함.
          return Container(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                ClipRRect(
                  child: Image.asset(data[index]['image']!,
                      width: 100, height: 100),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 20),
                    height: 90,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data[index]['title']!,
                          style: TextStyle(fontSize: 15),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(data[index]['location']!,
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.black.withOpacity(0.3))),
                        SizedBox(height: 5),
                        Text(calcStringToWon(data[index]['price']!),
                            style: TextStyle(fontWeight: FontWeight.w700)),
                        // Expanded: Expanded의 child를 부모의 크기에서 다른 자식 위젯들이 차지하는 최소한의 공간을 제외하고 남은 차지할 수 있는 공간을 다 차지하도록 해줌.
                        // 다만 Expanded 자체가 Container의 역할은 못함! 꼭 child안에 따로 컨테이너(Container, SizedBox..etc)를 지정해줘야 함! Expanded는 단지 남은 모든 공간을 차지한다는 의미만 부여해줌.
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SvgPicture.asset(
                                Assets.svgHeartOff,
                                width: 13,
                                height: 13,
                              ),
                              SizedBox(width: 5),
                              Text(data[index]['likes']!)
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        },
        // separatorBuilder: 아이템 사이의 seperator를 만드는 빌더
        separatorBuilder: (BuildContext _context, int index) {
          return Container(
            height: 1,
            color: Colors.black.withOpacity(0.2),
          );
        },
        itemCount: 10);
  }

  // <===== start of Home_Body Widget =====>
  Widget _HomeBody() {
    return FutureBuilder(
      // future 아규먼트로 해당 위젯에서 사용해야하는 비동기 Future 데이터 가져옴.
        future: contentsRepository.loadContentsFromLocation(currLocation),

        // builder로 사용 할 future값이 로딩 되기 전, 로딩 된 후, 에러 생길 경우에 따라서 각각 화면에 어떻게 표시할 지 정의해 줌.
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {  // snapshot값으로 현재 future값의 상태를 받아올 수 있음.
          if (snapshot.connectionState != ConnectionState.done)  // 1. future값의 connectionState가 done이 아닐 경우 (로딩이 다 안된 경우)
            return Center(child: CircularProgressIndicator());  // CircularProgressIndicator: 로딩 스피너 (플러터 자체 위젯)
          if (snapshot.hasError)  // 2. future 값이 에러가 난 경우
            return Center(
                child: Text(snapshot.hasData ? "데이터 오류" : "해당 지역의 데이터가 없습니다."));

          // 3. future값이 제대로 로딩이 된 경우(hasData = true) => _renderListData: 해당 아규먼트 데이터 이용해 리스트뷰 렌더링.
          if (snapshot.hasData) return _renderListData(snapshot.data);

          // null을 리턴할 수 없으므로 (_HomeBody는 not nullable, must return Widget) default로 Center 위젯 리턴
          return Center(child: Text("문제가 발생했습니다."));
        });
  }

  // <==== Home Widget Build =====>
  @override
  Widget build(BuildContext context) {
    // build의 Scaffold는 최대한 간결하게
    return Scaffold(
      appBar: _HomeAppBar(),
      body: _HomeBody(),
    );
  }
}
