import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tiger_tracker_v2/database.dart';
import 'package:tiger_tracker_v2/size_config.dart';

import 'auth.dart';

class MyTrackPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyTrackPageState();
}

class _MyTrackPageState extends State<MyTrackPage> {
  GoogleMapController _controller;
  final AuthService _auth = AuthService();
  Position position;
  //final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  Widget _child;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  var selectedBus;
  var screenSize = SizeConfig.blockSizeVertical * 25;
  var count = 0;
  String icon = 'enlargeIcon.png';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<QuerySnapshot>.value(
        value: DatabaseService().users,
        child: Scaffold(
            appBar: AppBar(
              title: Text('Welcome'),
              backgroundColor: Colors.red,
              elevation: 0,
              actions: <Widget>[
                IconButton(
                    icon: Icon(
                      Icons.settings,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      //Navigator.of(context).pushNamed('/RTDBTrack');
                      _auth.signOut();
                    })
              ],
            ),
            body: Stack(children: <Widget>[
              Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: [0.2, 1],
                    colors: [Colors.red, Colors.white],
                  )),
                  child: Column(
                    children: [
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              flex: 5,
                              child: Column(children: <Widget>[
                                Container(
                                    child: Column(children: <Widget>[
                                  Container(
                                      //width: 200,
                                      child: Card(
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0)),
                                    margin: EdgeInsets.all(10),
                                    //semanticContainer: true,
                                    //clipBehavior: Clip.antiAliasWithSaveLayer,
                                    child: Stack(alignment: Alignment.center,
                                        //mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            child: Image.asset(
                                              "road.jpg",
                                              fit: BoxFit.fill,
                                              color: Color.fromRGBO(
                                                  255, 255, 255, 0.5),
                                              colorBlendMode:
                                                  BlendMode.modulate,
                                            ),
                                          ),
                                          Column(children: <Widget>[
                                            Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    0, 0, 0, 20),
                                                child: Text(
                                                    "Select Bus To Track",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold))),
                                            new StreamBuilder<QuerySnapshot>(
                                              stream: FirebaseFirestore.instance
                                                  .collection(
                                                      'Bus Track Details')
                                                  .snapshots(),
                                              builder: (context, snapshot) {
                                                if (!snapshot.hasData)
                                                  return const CupertinoActivityIndicator();
                                                else {
                                                  List<DropdownMenuItem>
                                                      busNumbers = [];
                                                  for (int i = 0;
                                                      i <
                                                          snapshot
                                                              .data.docs.length;
                                                      i++) {
                                                    DocumentSnapshot snap =
                                                        snapshot.data.docs[i];
                                                    busNumbers.add(
                                                        DropdownMenuItem(
                                                            child: Text(snap.id,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        17)),
                                                            value:
                                                                "${snap.id}"));
                                                  }
                                                  return Column(
                                                    children: <Widget>[
                                                      Container(
                                                          padding: EdgeInsets
                                                              .fromLTRB(
                                                                  4, 4, 4, 4),
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        9.0),
                                                            color: Colors
                                                                .transparent,
                                                            border: Border.all(
                                                                width: 3,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                          child:
                                                              DropdownButtonHideUnderline(
                                                                  child:
                                                                      DropdownButton(
                                                            items: busNumbers,
                                                            onChanged:
                                                                (busValue) {
                                                              setState(() {
                                                                selectedBus =
                                                                    busValue;
                                                                print(
                                                                    selectedBus);
                                                              });
                                                              FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'Bus Track Details')
                                                                  .doc(
                                                                      selectedBus)
                                                                  .snapshots()
                                                                  .listen(
                                                                      (value) {
                                                                var markerIdVal =
                                                                    selectedBus;
                                                                final MarkerId
                                                                    markerId =
                                                                    MarkerId(
                                                                        markerIdVal);
                                                                final Marker marker = Marker(
                                                                    position: LatLng(
                                                                        value['location']
                                                                            .latitude,
                                                                        value['location']
                                                                            .longitude),
                                                                    markerId:
                                                                        markerId);
                                                                setState(() {
                                                                  markers = {};
                                                                  markers[markerId] =
                                                                      marker;
                                                                  _child =
                                                                      mapWidget();
                                                                });
                                                              });
                                                            },
                                                            value: selectedBus,
                                                            isExpanded: false,
                                                            isDense: true,
                                                            hint: Text(
                                                                'Choose Bus #',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        17)),
                                                          ))),
                                                    ],
                                                  );
                                                }
                                              },
                                            ),
                                          ])
                                        ]),
                                  )),
                                ])),
                              ]),
                            ),
                            Expanded(
                              flex: 4,
                              child: Container(
                                child: Card(
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0)),
                                    margin: EdgeInsets.all(10),
                                    child: Stack(children: <Widget>[
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        child: Image.asset(
                                          "road.jpg",
                                          fit: BoxFit.fill,
                                          color: Color.fromRGBO(
                                              255, 255, 255, 0.5),
                                          colorBlendMode: BlendMode.modulate,
                                        ),
                                      ),
                                    ])),
                              ),
                            )
                          ]),
                      Expanded(
                          child: Align(
                              alignment: FractionalOffset.bottomCenter,
                              child: SizedBox(
                                child: _child,
                                height: screenSize,
                                width: SizeConfig.blockSizeHorizontal * 100,
                              )))
                    ],
                  ))
            ])));
  }

  Widget mapWidget() {
    return Stack(
      children: <Widget>[
        GoogleMap(
          mapType: MapType.hybrid,
          markers: Set<Marker>.of(markers.values),
          initialCameraPosition:
              CameraPosition(target: LatLng(42.0314, -80.2553), zoom: 12),
          onMapCreated: (GoogleMapController controller) {
            _controller = controller;
          },
          myLocationEnabled: true, //Responsible for Blue Dot
        ),
        RaisedButton(
            child: Image.asset(icon),
            onPressed: () {
              if (count == 0) {
                setState(() {
                  screenSize = SizeConfig.blockSizeVertical * 100;
                  count = count + 1;
                  icon = 'minimizeIcon.png';
                });
              } else if (count == 1) {
                setState(() {
                  screenSize = SizeConfig.blockSizeVertical * 25;
                  count = count - 1;
                  icon = 'enlargeIcon.png';
                });
              }
            })
      ],
    );
  }
}
