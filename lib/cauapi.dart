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
  final int num;
  final String location;
  final int localNum;
  final String lastCheck;
  final int fireState;
  CAUAPI({this.num, this.location, this.localNum, this.lastCheck, this.fireState});

  factory CAUAPI.fromJson(Map<String, dynamic> json){
    return CAUAPI(
      num: json['num'] as int,
      location: json['location'] as String,
      localNum: json['local_num'] as int,
      lastCheck: json['last_check'] as String,
      fireState: json['fire_state'] as int,
    );
  }
}

class CAUShow extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Scaffold(
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              pinned: true,
              expandedHeight: 150,
              flexibleSpace: FlexibleSpaceBar(
                title: RichText( text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: "중앙대학교\n",
                        style: TextStyle(color: Colors.black, fontSize: 35, fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: "서울특별시 동작구 흑석로 84",
                        style: TextStyle(color: Colors.black, fontSize: 10),
                      ),
                    ]
                ),
                ),
              ),
            ),
            SliverFillRemaining(
              child: FutureBuilder<List<CAUAPI>>(
                future: fetchPhotos(http.Client()),
                builder: (context, snapshot) {
                  if (snapshot.hasError) print(snapshot.error);

                  return snapshot.hasData
                      ? CAUAPIList(cauapis: snapshot.data)
                      : Center(child: CircularProgressIndicator());
                },
              ),
            )
          ],
        )
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
  var flutterLocalNotificationsPlugin;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = IOSInitializationSettings();

    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
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
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.55
      ),
      itemCount: widget.cauapis.length,
      itemBuilder: (context, index) {
        final int _num = widget.cauapis[index].num;
        final String location = widget.cauapis[index].location;
        final int _localNum = widget.cauapis[index].localNum;
        final String _lastCheck = widget.cauapis[index].lastCheck;
        final int _fireState = widget.cauapis[index].fireState;
        final int _year = int.parse(_lastCheck.substring(0, 4));
        final int _month = int.parse(_lastCheck.substring(4, 6));
        final int _day = int.parse(_lastCheck.substring(6, 8));
        final _now = DateTime.now();
        final _lastCheckTime = DateTime(_year, _month, _day);
        final _betweenDay = _now.difference(_lastCheckTime).inDays;
        var _imageURL = '';
        if (_betweenDay >= 3650) {
          _imageURL = 'assets/change.png';
        } else if (_betweenDay >= 31) {
          _imageURL = 'assets/need.png';
        } else {
          _imageURL = 'assets/can.png';
        }
        if (_fireState == 1) {
          _showNotification();
        }
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 20,
          child: Container(
            height: 40,
            width: 20,
            child: Column(
              children: <Widget>[
                Text('\nLocal ID: $_localNum', style: TextStyle(fontSize: 15)),
                Text(location, style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 20)),
                Text(' ', style: TextStyle(fontSize: 15)),
                Image.asset(_imageURL),
                Text('\n마지막 점검: $_year/$_month/$_day',
                    style: TextStyle(fontSize: 15)),
                Text('점검일로부터: $_betweenDay일', style: TextStyle(fontSize: 15)),
              ],
            ),
          ),
          margin: const EdgeInsets.all(10),
        );
      }
      );
  }
  Future<void> _showNotification() async {
    var android = AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High);

    var ios = IOSNotificationDetails();
    var detail = NotificationDetails(android, ios);
    await flutterLocalNotificationsPlugin.show(
      0,
      'Fire Fight Network System',
      '중앙대학교 소화기 사용됨',
      detail,
      payload: 'Hello Flutter',
    );
  }
}
