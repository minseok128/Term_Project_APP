import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<List<CAUAPI>> fetchPhotos(http.Client client) async {
  final response = await client.get('http://minseok128.pythonanywhere.com/Fire_extinguisher/all/');
  return compute(parseCAUAPI, response.body);
}
List<CAUAPI> parseCAUAPI(String responseBody){
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<CAUAPI>((json) => CAUAPI.fromJson(json)).toList();
}

class CAUAPI {
  final int fireState;
  CAUAPI({this.fireState});

  factory CAUAPI.fromJson(Map<String, dynamic> json){
    return CAUAPI(
      fireState: json['fire_state'] as int,
    );
  }
}

class Test extends StatefulWidget {
  Test({Key key, this.title}) : super(key: key);

  final String title;

  @override
  TestState createState() => TestState();
}

class TestState extends State<Test> {
  var _flutterLocalNotificationsPlugin;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = IOSInitializationSettings();

    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);

    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  Future<void> onSelectNotification(String payload) async {
    debugPrint("$payload");
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Notification Payload'),
          content: Text('Payload: $payload'),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //RaisedButton(
            //  onPressed: _showNotification,
            //  child: Text('Show Notification'),
            //),
            Container(
              child: FutureBuilder<List<CAUAPI>>(
                future: fetchPhotos(http.Client()),
                builder: (context, snapshot) {
                  if (snapshot.hasError) print(snapshot.error);

                  return snapshot.hasData
                      ? CAUAPIList(cauapis: snapshot.data)
                      : Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ]
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future<void> _showNotification() async {
    var android = AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High);

    var ios = IOSNotificationDetails();
    var detail = NotificationDetails(android, ios);

    await _flutterLocalNotificationsPlugin.show(
      0,
      '단일 Notification',
      '단일 Notification 내용',
      detail,
      payload: 'Hello Flutter',
    );
  }
}

class CAUAPIList extends StatefulWidget {
  final List<CAUAPI> cauapis;
  CAUAPIList({Key key, this.cauapis}) : super(key: key);
  @override
  _CAUAPIListState createState() => _CAUAPIListState();
}

class _CAUAPIListState extends State<CAUAPIList> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.55
      ),
      itemCount: widget.cauapis.length,
      itemBuilder: (context, index) {
        final int _fireState = widget.cauapis[index].fireState;
        return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 20,
            child: Container(
              height: 40,
              width: 20,
              child: Text(
                  '점검일로부터: $_fireState', style: TextStyle(fontSize: 15)),
              )
            );
          }
        );
      }
}
