import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:management_app/screens/calendar_page/calendar_page.dart';
import 'package:management_app/screens/home_page/home_page.dart';
import 'package:management_app/screens/notification_page/notification_page.dart';
import 'package:management_app/screens/task/task_page.dart';

import '../../constants/color.dart';
import '../../constants/font.dart';

import '../data/data.dart';
import '../widgets/quick_create_item.dart';

class NavigationBottom extends StatefulWidget {
  final int initialIndex;
  final int tabForward;
  const NavigationBottom({Key? key, this.initialIndex = 0, this.tabForward = 0})
      : super(key: key);

  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<NavigationBottom> {
  static int _selectedIndex = 0;
  static int _tabForward = 0;
  static List<Widget> _pages = [];
  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    _tabForward = widget.tabForward;
    _pages = <Widget>[
      HomePage(initialTab: _tabForward),
      const TaskPage(),
      const HomePage(),
      const CalendarPage(),
      const NotificationPage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    void showQuickCreate() {
      showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (ctx) => Container(
          height: 380,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Tạo nhanh',
                style: GoogleFonts.montserrat(
                  color: COLOR_BLACK,
                  fontSize: FONT_SIZE_BIG,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Expanded(
                flex: 1,
                child: GridView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 1 / 1,
                      crossAxisSpacing: 40,
                      mainAxisSpacing: 40),
                  children: [
                    ...quickCreateList.map(
                      (e) => InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(
                              context, e['route_name'].toString());
                        },
                        child: QuickCreateItem(
                          value: e,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Image.asset(
                    'lib/assets/images/home_page/bottom_dialog/close_dialog_button.png'),
              ),
            ],
          ),
        ),
      );
    }

    Widget navigationContainer = Material(
      // elevation: 1,
      // shadowColor: const Color.fromARGB(150, 166, 166, 166),
      color: const Color.fromARGB(217, 250, 112, 112),
      // shape: const StadiumBorder(),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [
          BottomNavigationBar(
            elevation: 0,
            onTap: (index) {
              setState(() {
                // showQuickCreate();
                _selectedIndex = index;
              });
              // print(_currentIndex);
            },
            backgroundColor: Colors.transparent,
            currentIndex: _selectedIndex,
            type: BottomNavigationBarType.fixed,
            unselectedLabelStyle: GoogleFonts.montserrat(
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
            selectedItemColor: COLOR_GREEN,
            selectedLabelStyle: GoogleFonts.montserrat(
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
            selectedFontSize: 14,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Trang chủ',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.checklist),
                label: 'Cá nhân',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.circle,
                  size: 0,
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_month),
                label: 'Lịch',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.notifications),
                label: 'Thông báo',
              )
            ],
          ),
          Positioned(
            bottom: 15, // đ
            child: Container(
              width: 70,
              height: 70,
              // margin: const EdgeInsets.only(bottom: 30),
              decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(20, 238, 238, 238),
                    spreadRadius: 3,
                    blurRadius: 20,
                    offset: Offset(1, 1),
                  ),
                ],
              ),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(COLOR_DONE),
                  shape: MaterialStateProperty.all(
                    const CircleBorder(),
                  ),
                ),
                onPressed: showQuickCreate,
                child: Image.asset(
                  'lib/assets/images/home_page/add_icon.png',
                  width: 32,
                ),
              ),
            ),
          ),
        ],
      ),
    );
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      navigationContainer = Container(
        color: COLOR_WHITE,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            CupertinoTabBar(
              border:
                  const Border(bottom: BorderSide(color: Colors.transparent)),
              backgroundColor: COLOR_WHITE,
              onTap: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              activeColor: COLOR_GREEN,
              currentIndex: _selectedIndex,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Trang chủ',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.checklist),
                  label: 'Cá nhân',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.circle,
                    size: 0,
                  ),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_month),
                  label: 'Lịch',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.notifications),
                  label: 'Thông báo',
                )
              ],
            ),
            Positioned(
              bottom: 45, // đ

              child: Container(
                width: 70,
                height: 70,
                // margin: const EdgeInsets.only(bottom: 30),
                decoration: const BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(20, 238, 238, 238),
                      spreadRadius: 3,
                      blurRadius: 20,
                      offset: Offset(1, 1),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(COLOR_DONE),
                    shape: MaterialStateProperty.all(
                      const CircleBorder(),
                    ),
                  ),
                  onPressed: showQuickCreate,
                  child: Image.asset(
                    'lib/assets/images/home_page/add_icon.png',
                    width: 32,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      // resizeToAvoidBottomInset: false,
      bottomNavigationBar: navigationContainer,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: _pages.elementAt(_selectedIndex)),
        ],
      ),
      floatingActionButton: Container(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
    );
  }
}
