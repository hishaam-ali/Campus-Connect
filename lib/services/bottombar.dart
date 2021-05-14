import 'package:campusconnect/helper/constants.dart';
import 'package:campusconnect/helper/helperfunctions.dart';
import 'package:campusconnect/profile/profileui2.dart';
import 'package:campusconnect/services/database.dart';
import 'package:campusconnect/views/chatroomscreen.dart';
import 'package:campusconnect/views/home_page.dart';
import 'package:campusconnect/views/profile_page.dart';
import 'package:campusconnect/views/search_users.dart';
import 'package:campusconnect/views/upload.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';

class BottomBar extends StatefulWidget {
  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _currentIndex = 0;

  String dp = "";
  DatabaseMethods databaseMethods = new DatabaseMethods();
  QuerySnapshot searchSnapshot;

  final List<Widget> _children = [
    HomePage(),
    SearchUsers(),
    Upload(),
    ChatRoom(),
    ProfileUI2(),
  ];

  void onTapBar(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  initSearch() async {
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    print(Constants.myName);
    await databaseMethods.getUserByUsername(Constants.myName).then((val) {
      setState(() {
        searchSnapshot = val;
      });
    });
    dp = searchSnapshot.docs[0].data()["displaypic"];
  }

  showAlertDialog(BuildContext context) {
    //String name = getUserName(widget.userEmail);
    Widget cancelbutton = FlatButton(
      color: Color(0xff2a4f98),
      child: Text("CANCEL",
        style: TextStyle(fontFamily: 'Nunito',color: Colors.white),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continuebutton = FlatButton(
      color: Color(0xff2a4f98),
      child: Text("OK",
        style: TextStyle(fontFamily: 'Nunito',color: Colors.white),
      ),
      onPressed: () {
        //databaseMethods3.deletePost(name,widget.id).then(
            SystemNavigator.pop();
        //);
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text("Close",style: TextStyle(fontFamily: 'Nunito'),),
      content: Text("Do you want to close the application?",style: TextStyle(fontFamily: 'Nunito'),),
      actions: [
        cancelbutton,
        continuebutton,
      ],
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        }
    );
  }

  @override
  Widget build(BuildContext context) {
  initSearch();
    return WillPopScope(
      onWillPop: () {showAlertDialog(context); },
      child: Scaffold(
        body: _children[_currentIndex],
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black,
              ),
            ],
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            onTap: onTapBar,
            unselectedItemColor: Colors.white,
            selectedItemColor: Color(0xffFFD700),
            selectedIconTheme: IconThemeData(color: Color(0xffFFD700)),
            unselectedIconTheme: IconThemeData(color: Colors.white),
            backgroundColor: Color(0xff2a4f98),
            currentIndex: _currentIndex,
            items: [
              BottomNavigationBarItem(
                icon: Icon(
                  CupertinoIcons.home,
                  size: 26,
                ),
                title: Container(),
                // Text("Home",
                //     style: TextStyle(fontFamily: 'Nunito', fontSize: 16)),
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Entypo.magnifying_glass,
                  size: 30,
                ),
                title: Container(),
                // Text("Search",
                //     style: TextStyle(fontFamily: 'Nunito', fontSize: 16)),
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  CupertinoIcons.add_circled_solid,
                  size: 30,
                ),
                title: Container(),
                // Text("New Post",
                //     style: TextStyle(fontFamily: 'Nunito', fontSize: 16)),
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Entypo.chat,
                  size: 30,
                ),
                title: Container(),
                // Text("Messaging",
                //     style: TextStyle(fontFamily: 'Nunito', fontSize: 16)),
              ),
              BottomNavigationBarItem(
                icon: CircleAvatar(
                  backgroundImage: dp == ""
                      ? NetworkImage(
                      "https://slcp.lk/wp-content/uploads/2020/02/no-profile-photo.png")
                      : NetworkImage(dp),
                  radius: 15.0,
                ),
                // Icon(
                //   AntDesign.profile,
                //   size: 30,
                // ),
                title: Container(),
                // Text("Profile",
                //     style: TextStyle(fontFamily: 'Nunito', fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}






// class BottomBar extends StatefulWidget {
//   @override
//   _BottomBarState createState() => _BottomBarState();
// }
//
// class _BottomBarState extends State<BottomBar> {
//   int _selectedIndex = 0;
//   String dp = "";
//   DatabaseMethods databaseMethods = new DatabaseMethods();
//   QuerySnapshot searchSnapshot;
//
//   List<GlobalKey<NavigatorState>> _navigatorKeys = [
//     GlobalKey<NavigatorState>(),
//     GlobalKey<NavigatorState>(),
//     GlobalKey<NavigatorState>(),
//     GlobalKey<NavigatorState>(),
//     GlobalKey<NavigatorState>()
//   ];
//
//   initSearch() async {
//     Constants.myName = await HelperFunctions.getUserNameSharedPreference();
//     print(Constants.myName);
//     await databaseMethods.getUserByUsername(Constants.myName).then((val) {
//       setState(() {
//         searchSnapshot = val;
//       });
//     });
//     dp = searchSnapshot.docs[0].data()["displaypic"];
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     initSearch();
//     return WillPopScope(
//       onWillPop: () async {
//         final isFirstRouteInCurrentTab =
//         !await _navigatorKeys[_selectedIndex].currentState.maybePop();
//
//         // let system handle back button if we're on the first route
//         return isFirstRouteInCurrentTab;
//       },
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         bottomNavigationBar: BottomNavigationBar(
//           type: BottomNavigationBarType.fixed,
//           currentIndex: _selectedIndex,
//           unselectedItemColor: Colors.white,
//           selectedItemColor: Color(0xffFFD700),
//           selectedIconTheme: IconThemeData(color: Color(0xffFFD700)),
//           unselectedIconTheme: IconThemeData(color: Colors.white),
//           backgroundColor: Color(0xff2a4f98),
//           showSelectedLabels: false,
//           showUnselectedLabels: false,
//           items: [
//           BottomNavigationBarItem(
//               icon: Icon(
//                 CupertinoIcons.home,
//                 size: 26,
//               ),
//               title: Container(),
//               // Text("Home",
//               //     style: TextStyle(fontFamily: 'Nunito', fontSize: 16)),
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(
//                 Entypo.magnifying_glass,
//                 size: 30,
//               ),
//               title: Container(),
//               // Text("Search",
//               //     style: TextStyle(fontFamily: 'Nunito', fontSize: 16)),
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(
//                 CupertinoIcons.add_circled_solid,
//                 size: 30,
//               ),
//               title: Container(),
//               // Text("New Post",
//               //     style: TextStyle(fontFamily: 'Nunito', fontSize: 16)),
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(
//                 Entypo.chat,
//                 size: 30,
//               ),
//               title: Container(),
//               // Text("Messaging",
//               //     style: TextStyle(fontFamily: 'Nunito', fontSize: 16)),
//             ),
//             BottomNavigationBarItem(
//               icon: CircleAvatar(
//                 backgroundImage: dp == ""
//                     ? NetworkImage(
//                     "https://slcp.lk/wp-content/uploads/2020/02/no-profile-photo.png")
//                     : NetworkImage(dp),
//                 radius: 15.0,
//               ),
//               // Icon(
//               //   AntDesign.profile,
//               //   size: 30,
//               // ),
//               title: Container(),
//               // Text("Profile",
//               //     style: TextStyle(fontFamily: 'Nunito', fontSize: 16)),
//             ),
//           ],
//           onTap: (index) {
//             setState(() {
//               _selectedIndex = index;
//             });
//           },
//         ),
//         body: Stack(
//           children: [
//             _buildOffstageNavigator(0),
//             _buildOffstageNavigator(1),
//             _buildOffstageNavigator(2),
//             _buildOffstageNavigator(3),
//             _buildOffstageNavigator(4),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Map<String, WidgetBuilder> _routeBuilders(BuildContext context, int index) {
//     return {
//       '/': (context) {
//         return [
//           HomePage(),
//           SearchUsers(),
//           Upload(),
//           ChatRoom(),
//           ProfileUI2(),
//         ].elementAt(index);
//       },
//     };
//   }
//
//   Widget _buildOffstageNavigator(int index) {
//     var routeBuilders = _routeBuilders(context, index);
//
//     return Offstage(
//       offstage: _selectedIndex != index,
//       child: Navigator(
//         key: _navigatorKeys[index],
//         onGenerateRoute: (routeSettings) {
//           return MaterialPageRoute(
//             builder: (context) => routeBuilders[routeSettings.name](context),
//           );
//         },
//       ),
//     );
//   }
// }