import 'package:auto_size_text/auto_size_text.dart';
import 'package:campusconnect/services/auth.dart';
import 'package:campusconnect/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expansion_card/expansion_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:url_launcher/url_launcher.dart';

import 'image_viewer.dart';

class Events extends StatefulWidget {
  @override
  _EventsState createState() => _EventsState();
}

class _EventsState extends State<Events> {
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  QuerySnapshot searchSnapshot;

  bool isLoading = true;
  bool noContent = false;

  // Widget eventsList() {
  //   return searchSnapshot != null
  //       ? ListView.builder(
  //     itemCount: searchSnapshot.docs.length,
  //     shrinkWrap: true,
  //     itemBuilder: (context, index) {
  //       print("hello");
  //       return eventsTile(
  //         searchSnapshot.docs[index].data()["body"],
  //         searchSnapshot.docs[index].data()["time"],
  //         searchSnapshot.docs[index].data()["title"],
  //       );
  //     },
  //   )
  //       : Container();
  // }


  getEvents() {
    databaseMethods.getEvents().then((value) {
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
    getEvents();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff2a4f98),
        title: Text(
          'Events',
          style: TextStyle(fontFamily: 'Nunito', fontSize: 25),
        ),
      ),
      body: isLoading
          ? Container(
        child: Center(child: CircularProgressIndicator()),
      ) : noContent ?
      Container(child: Center(child: Text('No events at the moment',style: TextStyle(fontFamily: 'Nunito'),)),)
          : eventsTile(searchSnapshot),
    );
  }
}


class eventsTile extends StatefulWidget {
  // final Timestamp time;
  // final String body;
  // final String title;
  // eventsTile(this.body,this.time,this.title);
  final QuerySnapshot snap;
  eventsTile(this.snap);

  @override
  _eventsTileState createState() => _eventsTileState();
}

class _eventsTileState extends State<eventsTile> {
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
                    child: widget.snap.docs[index].data()["image"] == "" ? Image.asset('image/ccbg.png'
                      // "https://images.pexels.com/photos/956981/milky-way-starry-sky-night-sky-star-956981.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
                      ,
                      alignment: Alignment.center,
                      fit: BoxFit.contain,
                      width: double.infinity,
                      height: 220.0,
                    ) :
                    Image.network(
                      widget.snap.docs[index].data()["image"],
                      fit: BoxFit.cover,
                      height: 230.0,
                      width: double.infinity,
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

  // @override
  // Widget build(BuildContext context) {
  //   return SingleChildScrollView(
  //       child: Column(
  //         children: [
  //           Padding(padding: EdgeInsets.all(13.0),),
  //           Padding(
  //             padding: EdgeInsets.only(left: 10.0,right: 10.0),
  //             child: ExpansionCard(
  //               borderRadius: 30,
  //               background: Image.asset(
  //                 'image/texture2.jpg',
  //                 fit: BoxFit.cover,
  //               ),
  //               title: Container(
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: <Widget>[
  //                     Text(
  //                       widget.title,
  //                       style: TextStyle(
  //                         fontFamily: 'Nunito',
  //                         fontWeight: FontWeight.w600,
  //                         fontSize: 30,
  //                         color: Colors.white,
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //               children: <Widget>[
  //                 Container(
  //                   margin: EdgeInsets.symmetric(horizontal: 7),
  //                   child: AutoSizeText(
  //                       widget.body,
  //                       maxLines: 9,
  //                       style: TextStyle(
  //                           fontSize: 20,
  //                           color: Colors.white,
  //                           fontFamily: 'Nunito'),
  //                   overflow: TextOverflow.clip,
  //                   ),
  //                 )
  //               ],
  //             ),
  //           ),
  //           SizedBox(height: 10.0),
  //         ],
  //       )
  //   );
  // }
}