import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'package:term_app_02/cauapi.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Term Project',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
            title: Text('Fire Fight Network System')
        ),
        body: ListView(
          scrollDirection:  Axis.vertical,
          children: <Widget>[
            Container(
              width: 300,
              height: 300,
              child:Image.asset('assets/icon_main.png') ,
            ),
            ListTile(
              leading: Icon(Icons.business),
              title: Text('Locations'),
              trailing: Icon(Icons.navigate_next),
              onTap: (){
                Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Location()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.call),
              title: Text('CALL 119'),
              trailing: Icon(Icons.navigate_next),
              onTap: (){
                UrlLauncher.launch('tel:119');
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              trailing: Icon(Icons.navigate_next),
              onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context) => Settings()));},
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('About me'),
              trailing: Icon(Icons.navigate_next),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => AboutMe()));
              },
            ),
          ],
        )
    );
  }
}

class Location extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text('Location')
        ),
        body: ListView(
          scrollDirection:  Axis.vertical,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.business),
              title: Text('중앙대학교 서울캠퍼스'),
              trailing: Icon(Icons.navigate_next),
              onTap: (){
                Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CAUShow()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.business),
              title: Text('중앙대학교 안성캠퍼스'),
              trailing: Icon(Icons.navigate_next),
              onTap: (){},
            ),
            ListTile(
              leading: Icon(Icons.business),
              title: Text('동탄중앙고등학교'),
              trailing: Icon(Icons.navigate_next),
              onTap: (){},
            ),
            ListTile(
              leading: Icon(Icons.business),
              title: Text('동탄중앙이음터'),
              trailing: Icon(Icons.navigate_next),
              onTap: (){},
            ),
            ListTile(
              leading: Icon(Icons.business),
              title: Text('예술의 전당'),
              trailing: Icon(Icons.navigate_next),
              onTap: (){},
            ),
            ListTile(
              leading: Icon(Icons.business),
              title: Text('국립 과천과학관'),
              trailing: Icon(Icons.navigate_next),
              onTap: (){},
            ),
          ],
        )
    );
  }
}

class AboutMe extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Me'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.people),
            title: Text('개발자: 장민석'),
          ),
          ListTile(
            leading: Icon(Icons.business),
            title: Text('소속: 중앙대학교 소프트웨어학부'),
          ),
          ListTile(
            leading: Icon(Icons.location_on),
            title: Text('주소: 서울특별시 동작구 흑석로 84'),
          ),
          ListTile(
            leading: Icon(Icons.account_balance),
            title: Text('Instagram: @minseok128'),
          ),
          ListTile(
            leading: Icon(Icons.mail),
            title: Text('Mail: minseok128@cau.ac.kr'),
          ),
          ListTile(
            leading: Icon(Icons.texture),
            title: Text('Test bar!'),
            trailing: Icon(Icons.navigate_next),
            onTap: (){
            },
          ),
        ],
      ),
    );
  }
}

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
    );
  }
}