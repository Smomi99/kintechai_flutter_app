import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:phoneotp/screens/account_screen.dart';
import 'package:phoneotp/screens/chat_screen.dart';
import 'package:phoneotp/screens/home_page_screen.dart';
import 'package:phoneotp/screens/myads_screen.dart';
import 'package:phoneotp/screens/sellitems/seller_category_list.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  static const String id = 'main-screen';

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Widget _currentScreen = HomePageScreen();
  int _index = 0;
  final PageStorageBucket _bucket = PageStorageBucket();
  @override
  Widget build(BuildContext context) {
    Color color = Theme.of(context).primaryColor;
    return Scaffold(
      body: PageStorage(
        child: _currentScreen,
        bucket: _bucket,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple,
        onPressed: () {
          Navigator.pushNamed(context, SellerCategory.id);
        },
        child: CircleAvatar(
          backgroundColor: Colors.white,
          child: Icon(Icons.add),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 0,
        child: Container(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        _index = 0;
                        _currentScreen = HomePageScreen();
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(_index == 0 ? Icons.home : Icons.home_outlined),
                        Text(
                          'Home',
                          style: TextStyle(
                              color: _index == 0 ? color : Colors.black,
                              fontWeight: _index == 0
                                  ? FontWeight.bold
                                  : FontWeight.normal),
                        ),
                      ],
                    ),
                  ),
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        _index = 1;
                        _currentScreen = ChatScreen();
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(_index == 1
                            ? CupertinoIcons.chat_bubble_fill
                            : Icons.chat_bubble),
                        Text(
                          'Chats',
                          style: TextStyle(
                            color: _index == 1 ? color : Colors.black,
                            fontWeight: _index == 1
                                ? FontWeight.bold
                                : FontWeight.normal,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        _index = 2;
                        _currentScreen = MyAdsScreen();
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(_index == 2
                            ? CupertinoIcons.chat_bubble_fill
                            : Icons.chat_bubble),
                        Text(
                          'My Ads',
                          style: TextStyle(
                            color: _index == 2 ? color : Colors.black,
                            fontWeight: _index == 2
                                ? FontWeight.bold
                                : FontWeight.normal,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        _index = 3;
                        _currentScreen = MyAccountScreen();
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(_index == 3
                            ? CupertinoIcons.chat_bubble_fill
                            : Icons.chat_bubble),
                        Text(
                          'Chats',
                          style: TextStyle(
                            color: _index == 3 ? color : Colors.black,
                            fontWeight: _index == 3
                                ? FontWeight.bold
                                : FontWeight.normal,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
