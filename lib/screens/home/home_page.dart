import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dgbitirme/screens/lists/diabetes_list.dart';
import 'package:dgbitirme/screens/lists/heart_list.dart';
import 'package:dgbitirme/screens/predicts/predict_anemia.dart';
import 'package:dgbitirme/screens/predicts/predict_diabetes.dart';
import 'package:dgbitirme/screens/notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../lists/anemia_list.dart';
import '../lists/cancer_list.dart';
import '../onboding/onboding_screen.dart';
import '../predicts/predict_cancer.dart';
import '../predicts/predict_heart.dart';
import '../profile/profile_page.dart';
import '../results_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Ana Sayfa",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),

      /*
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),*/
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.title,
  });

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String imageUrl = '';
  Uint8List? _image;
  int _selectedIndex = 1;

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => OnboardingScreen()));
  }

  final currentUser = FirebaseAuth.instance.currentUser;
  final userCollection = FirebaseFirestore.instance.collection("Users");

  bool isFollowing = false;

  Future<void> editField(String field) async {
    String newValue = "";
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text(
          "Düzenle $field",
          style: TextStyle(color: Colors.white),
        ),
        content: TextField(
          autofocus: true,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: "Yeni $field giriniz",
            hintStyle: TextStyle(color: Colors.grey),
          ),
          onChanged: (value) {
            newValue = value;
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(newValue),
            child: Text(
              'İptal',
              style: TextStyle(color: Colors.white),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(newValue),
            child: Text(
              'Kaydet',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
    if (newValue.trim().length > 0) {
      await userCollection.doc(currentUser!.email).update({field: newValue});
    }
  }

  Future<void> _onItemTapped(int index) async {
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex == 0) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => NotificationsPage()));
      } else if (_selectedIndex == 1) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      } else if (_selectedIndex == 2) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => ResultsPage()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    String tAppName = 'Teşhis Kapısı';
    final TextStyle customTextStyle = TextStyle(
      // Define your custom text style properties here
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    );

    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.transparent,
          title: Text(
            tAppName,
            style: Theme.of(context).textTheme.headlineSmall,

          ),
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 20, top: 7),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                //For Dark Color
                color: Colors.grey, //isDark ? tSecondaryColor : tCardBgColor,
              ),
              child: IconButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ProfilePage()));
                  },
                  icon: Image.asset("assets/icons/profile.png")),
            ),
          ],
        ),
        drawer: Drawer(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                buildHeader(context),
                buildMenuItems(context),
              ],
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            decoration:
                const BoxDecoration(border: Border(left: BorderSide(width: 4))),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                Container(
                  //color: Colors.grey,
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.05), // Gri arka plan
                      borderRadius: BorderRadius.circular(20.0),
                      border: Border.all(color: Colors.grey)),
                  child: Container(
                    height: 40,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            children: [
                              SizedBox(width: 8.0),
                              Text(
                                'Ara...',
                                style: customTextStyle?.copyWith(
                                  fontSize: customTextStyle?.fontSize != null
                                      ? customTextStyle!.fontSize! + 1
                                      : null,
                                  color: Colors.grey.withOpacity(0.9),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 20),
                          child: Image.asset(
                            "assets/icons/search.png",
                            width: 23, // İstenilen genişlik değeri
                            height: 23, // İstenilen yükseklik değeri
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),
                SizedBox(
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "İstatistiksel Veriler",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      Expanded(
                        child: Text(
                          "Bildirimler",
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    buildSingleContainer(
                        Image.asset(
                          "assets/icons/microscope.png",
                          width: 30,
                          height: 30,
                        ),
                        "Mikroskop Analizi",
                        "Seç"),
                    buildSingleContainer(
                        Image.asset(
                          "assets/icons/disease.png",
                          width: 30,
                          height: 30,
                        ),
                        "Hastalık Yaygınlığı",
                        "Onayla"),
                  ],
                ),
                SizedBox(
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Test Sonuçları",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      Expanded(
                        child: Text(
                          "Hepsini Kontrol Et",
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 160,
                  child: ListView.builder(
                    itemCount: myList.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) => GestureDetector(

                      onTap: (){
                        if(myList[index]==myList[0]){
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      DiabetesListPage()));
                        }
                        else if(myList[index]==myList[1]){
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      AnemiaListPage()));
                        }
                        else if(myList[index]==myList[2]){
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      CancerListPage())); // BURASI KANSER OLACAK
                        }
                        else if(myList[index]==myList[3]){
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      HeartListPage())); // BURASI KANSER OLACAK
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 10), // Yatayda container'lar arası boşluk
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                25), // Kenarları kıvrılmış çerçeve
                            color: Colors.white, // İç kısmın rengi
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(
                                    0.5), // Gölgeli alanın rengi ve opaklığı
                                spreadRadius:
                                    2, // Yayılma yarıçapı (sadece kenarlarda gölge oluşturmak için)
                                blurRadius: 7, // Bulanıklık yarıçapı
                                offset: Offset(
                                    0, 0), // Gölgenin x ve y eksenindeki konumu
                              ),
                            ],
                          ),
                          child: SizedBox(
                            width: 150,
                            height: 120,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.blue,
                                  ),
                                  child: Center(
                                    child: Image.asset(myList[index].title),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      myList[index].heading,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6
                                          ?.merge(
                                            customTextStyle.copyWith(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      myList[index].subHeading,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText2
                                          ?.merge(
                                            customTextStyle.copyWith(
                                              fontSize: customTextStyle
                                                          ?.fontSize !=
                                                      null
                                                  ? customTextStyle!.fontSize! -
                                                      2
                                                  : null,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Testler",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      Expanded(
                        child: Text(
                          "Tahmin alın",
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  height: 400, // Yüksekliği istediğiniz gibi ayarlayabilirsiniz
                  child: ListView.builder(
                    itemCount:
                        (testList.length / 3).ceil(), // Toplam grup sayısı
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      int startIndex = index * 3; // Grubun başlangıç indeksi
                      int endIndex = (index + 1) * 3; // Grubun bitiş indeksi
                      if (endIndex > testList.length) {
                        endIndex =
                            testList.length; // Son grupta kalan elemanları al
                      }
                      return Row(
                        children: [
                          for (int i = startIndex; i < endIndex; i++)
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  if (testList[i] == testList[0]) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                DiabetesPredictPage()));
                                  }
                                  if (testList[i] == testList[1]) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AnemiaPredictPage()));
                                  }
                                  if (testList[i] == testList[2]) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                CancerPredictPage()));
                                  }
                                  if (testList[i] == testList[3]) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                HeartPredictPage()));
                                  }
                                },
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                    horizontal: 5,
                                    vertical: 10,
                                  ), // Yatayda container'lar arası boşluk
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                        25,
                                      ), // Kenarları kıvrılmış çerçeve
                                      color: Colors.white, // İç kısmın rengi
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(
                                            0.5,
                                          ), // Gölgeli alanın rengi ve opaklığı
                                          spreadRadius:
                                              2, // Yayılma yarıçapı (sadece kenarlarda gölge oluşturmak için)
                                          blurRadius: 7, // Bulanıklık yarıçapı
                                          offset: Offset(
                                            0,
                                            0,
                                          ), // Gölgenin x ve y eksenindeki konumu
                                        ),
                                      ],
                                    ),
                                    child: SizedBox(
                                      width: 150,
                                      height: 120,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 60,
                                            height: 60,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.blue,
                                            ),
                                            child: Center(
                                              child: Image.asset(
                                                testList[i].title,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                testList[i].heading,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline6
                                                    ?.merge(
                                                      customTextStyle.copyWith(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Text(
                                                testList[i].subHeading,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText2
                                                    ?.merge(
                                                      customTextStyle.copyWith(
                                                        fontSize: customTextStyle
                                                                    ?.fontSize !=
                                                                null
                                                            ? customTextStyle!
                                                                    .fontSize! -
                                                                2
                                                            : null,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                      ),
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ),

                //BannerIG(),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage("assets/icons/notifications.png")),
              label: 'Bildirimler',
              backgroundColor: Colors.red,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home_filled),
              label: 'Ana Sayfa',
              backgroundColor: Colors.green,
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage("assets/icons/test-results.png")),
              label: 'Sonuçlar',
              backgroundColor: Colors.purple,
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: Colors.blue,
        ));
  }

  Widget buildHeader(BuildContext context) => Container(
        height: 250,
        color: Colors.grey,
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: Column(
          children: [
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("Users")
                  .doc(currentUser!.email)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final userData =
                      snapshot.data?.data() as Map<String, dynamic>?;

                  return ListView(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    children: [
                      const SizedBox(
                        height: 15,
                      ),
                      /*
                                UserImage(onFileChanged: (imageUrl) {
                                  setState(() {
                                    this.imageUrl = imageUrl;
                                  });
                                }),*/

                      Center(
                        child: Stack(
                          children: [
                            _image != null
                                ? GestureDetector(
                                    onTap: () => Navigator.of(context)
                                        .pushReplacement(MaterialPageRoute(
                                            builder: (context) =>
                                                const ProfilePage())),
                                    child: CircleAvatar(
                                      radius: 64,
                                      backgroundImage: MemoryImage(_image!),
                                    ),
                                  )
                                : GestureDetector(
                                    onTap: () => Navigator.of(context)
                                        .pushReplacement(MaterialPageRoute(
                                            builder: (context) =>
                                                const ProfilePage())),
                                    child: CircleAvatar(
                                      radius: 64,
                                      backgroundImage: NetworkImage(
                                          'https://media.istockphoto.com/id/1209654046/vector/user-avatar-profile-icon-black-vector-illustration.jpg?s=612x612&w=0&k=20&c=EOYXACjtZmZQ5IsZ0UUp1iNmZ9q2xl1BD1VvN6tZ2UI='),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        currentUser!.email!,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey[200]),
                      ),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text("Hata: ${snapshot.error}"),
                  );
                }

                return Center(child: const CircularProgressIndicator());
              },
            ),
          ],
        ),
      );

  Widget buildMenuItems(BuildContext context) => Container(
        padding: EdgeInsets.all(24),
        child: Wrap(
          runSpacing: 16,
          children: [
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text("Ana Sayfa"),
              onTap: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const HomePage())),
            ),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text("Bildirimler"),
              onTap: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                      builder: (context) => NotificationsPage())),
            ),
            ListTile(
              leading: const ImageIcon(AssetImage("assets/icons/test-results.png")),
              title: const Text("Sonuçlar"),
              onTap: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                      builder: (context) => ResultsPage())),
            ),
            const Divider(
              color: Colors.black54,
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Çıkış Yap"),
              onTap: _signOut,
            ),
          ],
        ),
      );
}

class MyListItem {
  final Future<void> Function() onPress;
  final String title;
  final String heading;
  final String subHeading;

  MyListItem({
    required this.onPress,
    required this.title,
    required this.heading,
    required this.subHeading,
  });
}

// Usage:
List<MyListItem> myList = [
  MyListItem(
    onPress: () async {
      // Your onPress function
    },
    title: "assets/icons/diabetes-care(1).png",
    heading: "Diyabet",
    subHeading: "Sonuç",
  ),
  MyListItem(
    onPress: () async {
      // Your onPress function
    },
    title: "assets/icons/bloodPh.png",
    heading: "Anemi",
    subHeading: "Sonuç ve HGB",
  ),
  MyListItem(
    onPress: () async {
      // Your onPress function
    },
    title: "assets/icons/human-disease(1).png",
    heading: "Kanser",
    subHeading: "İyi-Kötü Huylu",
  ),
  MyListItem(
    onPress: () async {
      // Your onPress function
    },
    title: "assets/icons/heart(1).png",
    heading: "Kalp Hastalığı",
    subHeading: "Teşhis",
  ),
  // Add more items as needed
];

class testListItem {
  final Future<void> Function() onPress;
  final String title;
  final String heading;
  final String subHeading;

  testListItem({
    required this.onPress,
    required this.title,
    required this.heading,
    required this.subHeading,
  });
}

List<testListItem> testList = [
  testListItem(
    onPress: () async {},
    title: "assets/icons/diabetes-care.png",
    heading: "Diyabet",
    subHeading: "Analiz",
  ),
  testListItem(
    onPress: () async {},
    title: "assets/icons/blood(1).png",
    heading: "Anemi",
    subHeading: "Kontrol",
  ),
  testListItem(
    onPress: () async {},
    title: "assets/icons/human-disease.png",
    heading: "Kanser",
    subHeading: "Test",
  ),
  testListItem(
    onPress: () async {},
    title: "assets/icons/heart(2).png",
    heading: "Kalp Hastalığı",
    subHeading: "Teşhis",
  ),
  // Add more items as needed
];

Widget buildSingleContainer(Widget leading, String title, String trailing) {
  return Container(
    margin:
        EdgeInsets.symmetric(vertical: 10), // Üst ve alttan 10 birim uzaklık
    padding: EdgeInsets.all(10), // İçeriği çerçeveden uzaklaştırma
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25), // Kenarları kıvrılmış çerçeve
      color: Colors.white, // İç kısmın rengi
      boxShadow: [
        BoxShadow(
          color:
              Colors.grey.withOpacity(0.5), // Gölgeli alanın rengi ve opaklığı
          spreadRadius:
              2, // Yayılma yarıçapı (sadece kenarlarda gölge oluşturmak için)
          blurRadius: 7, // Bulanıklık yarıçapı
          offset: Offset(0, 0), // Gölgenin x ve y eksenindeki konumu
        ),
      ],
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 14.0),
          child: leading,
        ), // Sol tarafta ikon
        Text(title), // Orta kısımda metin
        ElevatedButton(
          onPressed: () {},
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.black),
          ),
          child: Text(
            trailing,
            style: TextStyle(color: Colors.white),
          ),
        ), // Sağ tarafta buton
      ],
    ),
  );
}
