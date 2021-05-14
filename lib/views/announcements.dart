import 'package:auto_size_text/auto_size_text.dart';
import 'package:campusconnect/services/auth.dart';
import 'package:campusconnect/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expansion_card/expansion_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:url_launcher/url_launcher.dart';

import 'image_viewer.dart';

class announcement extends StatefulWidget {
  @override
  _announcementState createState() => _announcementState();
}

class _announcementState extends State<announcement> {
  //final double _borderRadius = 24;
  // var items = [
  //   EventInfo(
  //       '   Event 1', Color(0xff6DC8F3), Color(0xff73A1F9), 'Description'),
  //   EventInfo(
  //       '   Event 2', Color(0xffFFB157), Color(0xffFFA057), 'Description'),
  //   EventInfo(
  //       '   Event 3', Color(0xffFF5B95), Color(0xffF8556D), 'Description'),
  //   EventInfo(
  //       '   Event 4', Color(0xffD76EF5), Color(0xff8F7AFE), 'Description'),
  //   EventInfo(
  //       '   Event 5', Color(0xff42E695), Color(0xff3BB2B8), 'Description'),
  // ];

  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  QuerySnapshot searchSnapshot;
  bool isLoading = true;
  bool noContent = false;

  // Widget announcementList() {
  //   return searchSnapshot != null
  //       ? ListView.builder(
  //     itemCount: searchSnapshot.docs.length,
  //     shrinkWrap: true,
  //     itemBuilder: (context, index) {
  //       print("hello");
  //       return announcementTile(
  //           searchSnapshot.docs[index].data()["body"],
  //           searchSnapshot.docs[index].data()["time"],
  //           searchSnapshot.docs[index].data()["title"],
  //         );
  //     },
  //   )
  //       : Container();
  // }

  getAnnouncements() {
    databaseMethods.getAnnouncements().then((value) {
      setState(() {
        if(value!= null)
        searchSnapshot = value;
        isLoading = false;
        searchSnapshot.docs.length == 0 ? noContent = true : noContent = false;
      });
      print(searchSnapshot.docs.length);
    });
  }

  @override
  void initState() {
    getAnnouncements();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff2a4f98),
        title: Text(
          'Announcements',
          style: TextStyle(fontFamily: 'Nunito', fontSize: 25),
        ),
      ),
      body: isLoading
          ? Container(
        child: Center(child: CircularProgressIndicator()),
      ) : noContent ? Container(child: Center(child: Text('No announcements at the moment',style: TextStyle(fontFamily: 'Nunito'),)),) :announcementTile(searchSnapshot),
      // ListView.builder(
      //   itemCount: items.length,
      //   itemBuilder: (context, index) {
      //     return Padding(
      //       padding: const EdgeInsets.all(16.0),
      //       child: Stack(
      //         children: <Widget>[
      //           Container(
      //             height: 150,
      //             decoration: BoxDecoration(
      //               borderRadius: BorderRadius.circular(_borderRadius),
      //               gradient: LinearGradient(colors: [
      //                 items[index].startColor,
      //                 items[index].endColor
      //               ], begin: Alignment.topLeft, end: Alignment.bottomRight),
      //               boxShadow: [
      //                 BoxShadow(
      //                   color: items[index].endColor,
      //                   blurRadius: 12,
      //                   offset: Offset(0, 6),
      //                 ),
      //               ],
      //             ),
      //           ),
      //           Positioned.fill(
      //             child: Row(
      //               children: <Widget>[
      //                 Expanded(
      //                   flex: 4,
      //                   child: Column(
      //                     mainAxisSize: MainAxisSize.min,
      //                     crossAxisAlignment: CrossAxisAlignment.start,
      //                     children: <Widget>[
      //                       Center(
      //                         child: Text(
      //                           items[index].heading,
      //                           style: TextStyle(
      //                               color: Colors.white,
      //                               fontSize: 20,
      //                               fontWeight: FontWeight.w700),
      //                         ),
      //                       ),
      //                       SizedBox(height: 16),
      //                       Row(
      //                         children: <Widget>[
      //                           SizedBox(
      //                             width: 8,
      //                           ),
      //                           Text(
      //                             items[index].description,
      //                             style: TextStyle(
      //                                 color: Colors.white,
      //                                 fontWeight: FontWeight.w700),
      //                           ),
      //                         ],
      //                       ),
      //                     ],
      //                   ),
      //                 ),
      //               ],
      //             ),
      //           ),
      //         ],
      //       ),
      //     );
      //   },
      // ),
    );
  }
}

// class EventInfo {
//   final String heading;
//   final String description;
//   final Color startColor;
//   final Color endColor;
//
//   EventInfo(this.heading, this.startColor, this.endColor, this.description);
// }

class announcementTile extends StatefulWidget {
  final QuerySnapshot snap;
  announcementTile(this.snap);

  @override
  _announcementTileState createState() => _announcementTileState();
}

class _announcementTileState extends State<announcementTile> {
  QuerySnapshot searchSnapshot1;
  DatabaseMethods databaseMethods1 = new DatabaseMethods();
  QuerySnapshot searchSnapshot2;
  DatabaseMethods databaseMethods2 = new DatabaseMethods();

  launchURL(String url) async{
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20.0),
      child: Swiper(
        itemBuilder: (BuildContext context, int index) {
          return Stack(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(10.0),
                child: GestureDetector(
                  onTap: () {
                    widget.snap.docs[index].data()["image"] != "" ?  Navigator.push(
                        context, MaterialPageRoute(builder: (context) => ImageViewer(widget.snap.docs[index].data()["image"])))
                        : null;
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(35.0),
                      topRight: Radius.circular(35.0),
                    ),
                    child: widget.snap.docs[index].data()["image"] == "" ? Image.asset('image/ccbg.png',
                      //"https://images.pexels.com/photos/956981/milky-way-starry-sky-night-sky-star-956981.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
                      fit: BoxFit.contain,
                      height: 220.0,
                      width: double.infinity,
                      alignment: Alignment.center,
                    ) :
                    Image.network(
                      widget.snap.docs[index].data()["image"],
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 230.0,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(10.0, 210.0, 10.0, 30.0),
                child: Container(
                  height: 600.0,
                  width: 400.0,
                  child: Material(
                    borderRadius: BorderRadius.circular(20.0),
                    elevation: 10.0,
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.fromLTRB(
                                15.0, 15.0, 15.0, 20.0),
                            child: Column(
                              children: [
                                Center(
                                  child: AutoSizeText(
                                    widget.snap.docs[index].data()["title"],
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      fontFamily: 'Nunito',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Divider(color: Colors.black),
                                Text(
                                  widget.snap.docs[index].data()["body"],
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black,
                                      fontFamily: 'Nunito'),
                                ),
                                if (widget.snap.docs[index].data()["link"] != "") Divider(color: Colors.black),
                                if (widget.snap.docs[index].data()["link"] != "") GestureDetector(
                                  onTap: () {
                                    launchURL(widget.snap.docs[index].data()["link"]);
                                  },
                                  child: Text(
                                    widget.snap.docs[index].data()["link"],
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.blue,
                                        fontFamily: 'Nunito'),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          );
        },
        itemCount: widget.snap.docs.length,
        loop: false,
        autoplay: true,
        autoplayDelay: 5000,
        autoplayDisableOnInteraction: true,
        viewportFraction: 0.8,
        scale: 0.9,
      ),
    );
  }
}