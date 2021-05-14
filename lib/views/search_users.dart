import 'package:campusconnect/helper/constants.dart';
import 'package:campusconnect/helper/helperfunctions.dart';
import 'package:campusconnect/services/database.dart';
import 'package:campusconnect/views/conversation_screen.dart';
import 'package:campusconnect/views/profile_page.dart';
import 'package:campusconnect/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class SearchUsers extends StatefulWidget {
  @override
  _SearchUsersState createState() => _SearchUsersState();
}

String _myName;

class _SearchUsersState extends State<SearchUsers> {
  DatabaseMethods databaseMethods = new DatabaseMethods();

  TextEditingController searchTextEditingController =
      new TextEditingController();

  QuerySnapshot searchSnapshot;

  String selectedBatch = 'Batch';
  String selectedDept = 'Dept';
  String selectedClub = 'Club';

  bool Started = false;
  bool nodoc = false;

  Widget searchList() {
    int x=0;
    return searchSnapshot != null
        ? ListView.builder(
            itemCount: searchSnapshot.docs.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              print(searchSnapshot.docs.length);
              print(x);
              if(searchSnapshot.docs[index].data()["searchname"].toString().contains(searchTextEditingController.text.toLowerCase()))
              return SearchTile(
                userName: searchSnapshot.docs[index].data()["name"],
                userEmail: searchSnapshot.docs[index].data()["email"],
                userImage: searchSnapshot.docs[index].data()["displaypic"],
              );
              else {
                x++;
                return x == (searchSnapshot.docs.length) ?
                Container(child: Center(child: Text('No users found',style: TextStyle(fontFamily: 'Nunito'),)),) : Container();
              }
            },
          )
        : Started ? Container(child: Text('No users found'),) : Container();
  }

  initiateSearch() {
    databaseMethods
        .getUserByFilter(searchTextEditingController.text, selectedDept,
            selectedBatch, selectedClub)
        .then((val) {
      setState(() {
        searchSnapshot = val;
      });
    });
  }

  initiateSearch1() {
    databaseMethods
        .getUserByFilter1(searchTextEditingController.text, selectedDept,
        selectedBatch, selectedClub)
        .then((val) {
      setState(() {
        searchSnapshot = val;
        Started = true;
        print("hello : ");
        print(searchSnapshot.docs.length);
        searchSnapshot.docs.length == 0 ? nodoc = true : nodoc = false;
      });
    });
  }


//create chatroom
//   createChatroomAndStartConversation({String userName}) {
//
//     print('${Constants.myName}');
//     if(userName != Constants.myName) {
//
//       String chatRoomId = getChatRoomId(userName, Constants.myName);
//
//       List<String> users = [
//         userName,
//         Constants.myName
//       ];
//       Map<String,dynamic> chatRoomMap = {
//         "users": users,
//         "chatroomid": chatRoomId
//       };
//
//       DatabaseMethods().createChatRoom(chatRoomId,chatRoomMap);
//       Navigator.push(context,
//           MaterialPageRoute(
//               builder: (context)  => ConversationScreen(
//                   chatRoomId,chatRoomId.replaceAll("_", "")
//                   .replaceAll(Constants.myName, "")
//               )
//           ));
//     }
//     else {
//       print('you cannot send msg to yourself');
//     }
//   }

  Widget SearchTile({String userName, String userEmail, String userImage}) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Row(
          children: [
            Container(
              height: 50.0,
              width: 50.0,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(50.0),
              ),
              child: CircleAvatar(
                backgroundImage: userImage == ""
                    ? NetworkImage(
                        "https://slcp.lk/wp-content/uploads/2020/02/no-profile-photo.png")
                    : NetworkImage(userImage),
                radius: 70.0,
              ),
              // Text("${userName.substring(0,1).toUpperCase()}",
              //   style: TextStyle(
              //     color: Colors.white,
              //     fontSize: 25.0,
              //   ),
              // ),
            ),
            SizedBox(
              width: 12.0,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName,
                  style: TextStyle(fontSize: 15, fontFamily: 'Nunito'),
                ),
                Text(
                  userEmail,
                  style: TextStyle(fontSize: 15, fontFamily: 'Nunito'),
                )
              ],
            ),
            Spacer(),
            GestureDetector(
              onTap: () {
                nameIs(userName);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ProfilePage()));
              },
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Colors.blueAccent,
                    Colors.blue[200],
                  ]),
                  borderRadius: BorderRadius.circular(35.0),
                ),
                padding: EdgeInsets.all(10.0),
                child: Icon(
                  AntDesign.profile,
                  color: Colors.white,
                  size: 30.0,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Started = false;
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Search Users',
            style: TextStyle(
              fontSize: 25.0,
              fontFamily: 'Nunito',
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: const Color(0xff2a4f98),
      ),
      body: Container(
        child: Column(
          children: [
            SizedBox(
              height: 20.0,
            ),
            Center(
              child: Container(
                height: 80.0,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.only(
                    left: 20.0, right: 20.0, top: 5.0, bottom: 5.0),
                //padding: EdgeInsets.symmetric(horizontal: 24.0,vertical: 16.0),
                child: Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width - 120.0,
                      child: TextField(
                          controller: searchTextEditingController,
                          style: TextStyle(
                            color: Colors.black,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Search username',
                            hintStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontFamily: 'Nunito'),
                            border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(25.0),
                              borderSide: new BorderSide(),
                            ),
                          )),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    GestureDetector(
                      onTap: () {
                        initiateSearch1();
                      },
                      child: Container(
                        // height: 80.0,
                        // width: 60.0,
                        // padding: EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                            Colors.blueAccent,
                            Colors.blue[200],
                          ]),
                          borderRadius: BorderRadius.circular(35.0),
                        ),
                        padding: EdgeInsets.all(5.0),
                        child: Icon(
                          Icons.search,
                          color: Colors.white,
                          size: 40.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              child: Text(
                'Filter Search Results',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 20.0,
              width: 900,
              child: Divider(
                thickness: 1,
              ),
            ),
            Column(
              children: [
                SizedBox(
                  width: 10,
                ),
                Row(
                  children: [
                    Container(
                        padding: EdgeInsets.symmetric(horizontal: 24.0),
                        child: Text(
                          'Filter using Branch : ',
                          style: TextStyle(fontFamily: 'Nunito', fontSize: 16),
                        )),
                    SizedBox(
                      width: 9,
                    ),
                    DropdownButton(
                      icon: Icon(CupertinoIcons.down_arrow),
                      iconSize: 16,
                      elevation: 16,
                      style: TextStyle(color: Colors.black),
                      underline: Container(
                        height: 2,
                        color: Colors.blue,
                      ),
                      dropdownColor: Colors.white,
                      value: selectedDept,
                      items: [
                        DropdownMenuItem(
                          child: Text(
                            'CSE',
                            style:
                                TextStyle(fontSize: 15, fontFamily: 'Nunito'),
                          ),
                          value: 'CSE',
                        ),
                        DropdownMenuItem(
                          child: Text(
                            'ECE',
                            style:
                                TextStyle(fontSize: 15, fontFamily: 'Nunito'),
                          ),
                          value: 'ECE',
                        ),
                        DropdownMenuItem(
                          child: Text(
                            'ME',
                            style:
                                TextStyle(fontSize: 15, fontFamily: 'Nunito'),
                          ),
                          value: 'ME',
                        ),
                        DropdownMenuItem(
                          child: Text(
                            'MA',
                            style:
                                TextStyle(fontSize: 15, fontFamily: 'Nunito'),
                          ),
                          value: 'MA',
                        ),
                        DropdownMenuItem(
                          child: Text(
                            'MP',
                            style:
                                TextStyle(fontSize: 15, fontFamily: 'Nunito'),
                          ),
                          value: 'MP',
                        ),
                        DropdownMenuItem(
                          child: Text(
                            'BT',
                            style:
                                TextStyle(fontSize: 15, fontFamily: 'Nunito'),
                          ),
                          value: 'BT',
                        ),
                        DropdownMenuItem(
                          child: Text(
                            'Branch',
                            style:
                                TextStyle(fontSize: 15, fontFamily: 'Nunito'),
                          ),
                          value: 'Dept',
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedDept = value;
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(
                  width: 20.0,
                ),
                Row(
                  children: [
                    Container(
                        padding: EdgeInsets.symmetric(horizontal: 24.0),
                        child: Text(
                          'Filter using Batch : ',
                          style: TextStyle(fontFamily: 'Nunito', fontSize: 16),
                        )),
                    SizedBox(
                      width: 18,
                    ),
                    DropdownButton(
                      icon: Icon(CupertinoIcons.down_arrow),
                      iconSize: 16,
                      elevation: 16,
                      style: TextStyle(color: Colors.black),
                      underline: Container(
                        height: 2,
                        color: Colors.blue,
                      ),
                      dropdownColor: Colors.white,
                      value: selectedBatch,
                      items: [
                        DropdownMenuItem(
                          child: Text(
                            '2020',
                            style:
                                TextStyle(fontSize: 15, fontFamily: 'Nunito'),
                          ),
                          value: '2020',
                        ),
                        DropdownMenuItem(
                          child: Text(
                            '2021',
                            style:
                                TextStyle(fontSize: 15, fontFamily: 'Nunito'),
                          ),
                          value: '2021',
                        ),
                        DropdownMenuItem(
                          child: Text(
                            '2022',
                            style:
                                TextStyle(fontSize: 15, fontFamily: 'Nunito'),
                          ),
                          value: '2022',
                        ),
                        DropdownMenuItem(
                          child: Text(
                            '2023',
                            style:
                                TextStyle(fontSize: 15, fontFamily: 'Nunito'),
                          ),
                          value: '2023',
                        ),
                        DropdownMenuItem(
                          child: Text(
                            '2024',
                            style:
                                TextStyle(fontSize: 15, fontFamily: 'Nunito'),
                          ),
                          value: '2024',
                        ),
                        DropdownMenuItem(
                          child: Text(
                            'Batch',
                            style:
                                TextStyle(fontSize: 15, fontFamily: 'Nunito'),
                          ),
                          value: 'Batch',
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedBatch = value;
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(
                  width: 20.0,
                ),
                Row(
                  children: [
                    Container(
                        padding: EdgeInsets.symmetric(horizontal: 24.0),
                        child: Text(
                          'Filter using Clubs : ',
                          style: TextStyle(fontFamily: 'Nunito', fontSize: 16),
                        )),
                    SizedBox(
                      width: 18,
                    ),
                    DropdownButton(
                      icon: Icon(CupertinoIcons.down_arrow),
                      iconSize: 16,
                      elevation: 16,
                      style: TextStyle(color: Colors.black),
                      underline: Container(
                        height: 2,
                        color: Colors.blue,
                      ),
                      dropdownColor: Colors.white,
                      value: selectedClub,
                      items: [
                        DropdownMenuItem(
                          child: Text(
                            'LanScape',
                            style:
                                TextStyle(fontSize: 15, fontFamily: 'Nunito'),
                          ),
                          value: 'LanScape',
                        ),
                        DropdownMenuItem(
                          child: Text(
                            'Film Club',
                            style:
                                TextStyle(fontSize: 15, fontFamily: 'Nunito'),
                          ),
                          value: 'Film Club',
                        ),
                        DropdownMenuItem(
                          child: Text(
                            'IEEE',
                            style:
                                TextStyle(fontSize: 15, fontFamily: 'Nunito'),
                          ),
                          value: 'IEEE',
                        ),
                        DropdownMenuItem(
                          child: Text(
                            'IEDC',
                            style:
                                TextStyle(fontSize: 15, fontFamily: 'Nunito'),
                          ),
                          value: 'IEDC',
                        ),
                        DropdownMenuItem(
                          child: Text(
                            'ASME',
                            style:
                                TextStyle(fontSize: 15, fontFamily: 'Nunito'),
                          ),
                          value: 'ASME',
                        ),
                        DropdownMenuItem(
                          child: Text(
                            'SAE',
                            style:
                                TextStyle(fontSize: 15, fontFamily: 'Nunito'),
                          ),
                          value: 'SAE',
                        ),
                        DropdownMenuItem(
                          child: Text(
                            'CEST',
                            style:
                                TextStyle(fontSize: 15, fontFamily: 'Nunito'),
                          ),
                          value: 'CEST',
                        ),
                        DropdownMenuItem(
                          child: Text(
                            'Team Meckartans',
                            style:
                                TextStyle(fontSize: 15, fontFamily: 'Nunito'),
                          ),
                          value: 'Team Meckartans',
                        ),
                        DropdownMenuItem(
                          child: Text(
                            'Team Roborex',
                            style:
                                TextStyle(fontSize: 15, fontFamily: 'Nunito'),
                          ),
                          value: 'Team Roborex',
                        ),
                        DropdownMenuItem(
                          child: Text(
                            'LnD',
                            style:
                                TextStyle(fontSize: 15, fontFamily: 'Nunito'),
                          ),
                          value: 'LnD',
                        ),
                        DropdownMenuItem(
                          child: Text(
                            'Club',
                            style:
                                TextStyle(fontSize: 15, fontFamily: 'Nunito'),
                          ),
                          value: 'Club',
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedClub = value;
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 12,
                  width: 1000,
                  child: Divider(
                    thickness: 1,
                  ),
                )
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Container(
                height: 1.0,
                width: 150.0,
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            nodoc ? Container(child: Center(child: Text('No users found',style: TextStyle(fontFamily: 'Nunito'),)),) : Expanded(child: searchList()),
          ],

          // Row(
          //   children: [
          //     Text('Filter : ',
          //       style: TextStyle(
          //         color: Colors.black,
          //         fontSize: 20.0,
          //         fontWeight: FontWeight.bold,
          //       ),
          //     ),
          //     Container(
          //       color: Colors.white,
          //       child: DropdownButton(
          //         dropdownColor: Colors.white,
          //         value: selectedDept,
          //         items: [
          //           DropdownMenuItem(
          //             child: Text('CSE'),
          //             value: 'CSE',
          //           ),
          //           DropdownMenuItem(
          //             child: Text('ECE'),
          //             value: 'ECE',
          //           ),
          //           DropdownMenuItem(
          //             child: Text('ME'),
          //             value: 'ME',
          //           ),
          //           DropdownMenuItem(
          //             child: Text('MA'),
          //             value: 'MA',
          //           ),
          //           DropdownMenuItem(
          //             child: Text('MP'),
          //             value: 'MP',
          //           ),
          //           DropdownMenuItem(
          //             child: Text('BT'),
          //             value: 'BT',
          //           ),
          //           DropdownMenuItem(
          //             child: Text('---Dept---'),
          //             value: 'Dept',
          //           ),
          //         ],
          //         onChanged: (value) {
          //           setState(() {
          //             selectedDept = value;
          //           });
          //         },
          //       ),
          //     ),
          //     SizedBox(width: 10.0,),
          //     Container(
          //       color: Colors.white,
          //       child: DropdownButton(
          //         dropdownColor: Colors.white,
          //         value: selectedBatch,
          //         items: [
          //           DropdownMenuItem(
          //             child: Text('2020'),
          //             value: '2020',
          //           ),
          //           DropdownMenuItem(
          //             child: Text('2021'),
          //             value: '2021',
          //           ),
          //           DropdownMenuItem(
          //             child: Text('2022'),
          //             value: '2022',
          //           ),
          //           DropdownMenuItem(
          //             child: Text('2023'),
          //             value: '2023',
          //           ),
          //           DropdownMenuItem(
          //             child: Text('2024'),
          //             value: '2024',
          //           ),
          //           DropdownMenuItem(
          //             child: Text('---Batch---'),
          //             value: 'Batch',
          //           ),
          //         ],
          //         onChanged: (value) {
          //           setState(() {
          //             selectedBatch = value;
          //           });
          //         },
          //       ),
          //     ),
          //     SizedBox(width: 10.0,),
          //     Container(
          //       color: Colors.white,
          //       child: DropdownButton(
          //         dropdownColor: Colors.white,
          //         value: selectedClub,
          //         items: [
          //           DropdownMenuItem(
          //             child: Text('LanScape'),
          //             value: 'LanScape',
          //           ),
          //           DropdownMenuItem(
          //             child: Text('Film Club'),
          //             value: 'Film Club',
          //           ),
          //           DropdownMenuItem(
          //             child: Text('IEEE'),
          //             value: 'IEEE',
          //           ),
          //           DropdownMenuItem(
          //             child: Text('IEDC'),
          //             value: 'IEDC',
          //           ),
          //           DropdownMenuItem(
          //             child: Text('ASME'),
          //             value: 'ASME',
          //           ),
          //           DropdownMenuItem(
          //             child: Text('SAE'),
          //             value: 'SAE',
          //           ),
          //           DropdownMenuItem(
          //             child: Text('CEST'),
          //             value: 'CEST',
          //           ),
          //           DropdownMenuItem(
          //             child: Text('Team Meckartans'),
          //             value: 'Team Meckartans',
          //           ),
          //           DropdownMenuItem(
          //             child: Text('Team Roborex'),
          //             value: 'Team Roborex',
          //           ),
          //           DropdownMenuItem(
          //             child: Text('LnD'),
          //             value: 'LnD',
          //           ),
          //           DropdownMenuItem(
          //             child: Text('---Club---'),
          //             value: 'Club',
          //           ),
          //         ],
          //         onChanged: (value) {
          //           setState(() {
          //             selectedClub = value;
          //           });
          //         },
          //       ),
          //     ),
          //     ],
          //     ),
          //   SizedBox(
          //     height: 10.0,
          //   ),
          //   Padding(
          //     padding:EdgeInsets.symmetric(horizontal:10.0),
          //     child:Container(
          //       height:1.0,
          //       width: 150.0,
          //       color: Colors.white,
          //     ),
          //   ),
          //   SizedBox(height: 10.0,),
          //   Expanded(child: searchList()),
          // ],
        ),
      ),
    );
  }
}

getChatRoomId(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}
