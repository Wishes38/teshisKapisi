import 'package:dgbitirme/screens/home/home_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: NotificationsPage(),
    );
  }
}

class NotificationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bildirimler', style: TextStyle(
          color: Colors.white
        ),),
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.chevron_left, color: Colors.white,size: 30,),
          onPressed: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => HomePage()));
          },
        ),
      ),
      body: HealthNotificationList(),
    );
  }
}

class HealthNotificationList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        HealthNotificationCard(
          title: 'Egzersiz Hatırlatması',
          message: 'Bugün egzersiz yapmayı unutma. Sağlığın için önemli!',
        ),
        HealthNotificationCard(
          title: 'Su İçme Zamanı',
          message:
              'Su içmeyi unutma! Günde en az 8 bardak su içmek sağlığın için önemlidir.',
        ),
      ],
    );
  }
}

class HealthNotificationCard extends StatelessWidget {
  final String title;
  final String message;

  const HealthNotificationCard({
    Key? key,
    required this.title,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(message),
        leading: Icon(Icons.notifications),
        onTap: () {},
      ),
    );
  }
}
