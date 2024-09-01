import 'dart:io';
import 'dart:typed_data';
import 'package:dgbitirme/screens/onboding/onboding_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stacked/stacked.dart';
import 'package:http/http.dart' as http;

import '../../app/app_base_view_model.dart';
import '../../components/text_box.dart';
import '../home/home_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final currentUser = FirebaseAuth.instance.currentUser;
  final userCollection = FirebaseFirestore.instance.collection("Users");

  bool isFollowing = false;

  String imageUrl = '';
  Uint8List? _image;

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

  @override
  void initState() {
    super.initState();
    downloadProfileImage();
  }

  Future<void> downloadProfileImage() async {
    // Firestore'dan profil fotoğrafının URL'sini alın
    String? imageUrl = await FirebaseFirestore.instance
        .collection("Users")
        .doc(currentUser!.email)
        .get()
        .then((doc) => doc.data()?['profileImageUrl']);

    if (imageUrl != null) {
      // URL varsa resmi indir
      var response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        // Başarılı bir şekilde indirildiyse resmi göster
        setState(() {
          _image = response.bodyBytes;
        });
      } else {
        // Hata durumunda kullanıcıya bildir
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Hata'),
            content: Text('Profil fotoğrafı indirilemedi.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Tamam'),
              ),
            ],
          ),
        );
      }
    }
  }


  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => OnboardingScreen()));
  }

  buildProfileButton() {
    bool isProfileOwner;
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AppBaseViewModel>.reactive(
        viewModelBuilder: () => AppBaseViewModel(),
        onModelReady: (model) => model.init(),
        builder: (context, model, child) => MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData(),
              darkTheme: ThemeData.dark(),
              themeMode: model.theme,
              home: Scaffold(
                appBar: AppBar(
                  title: model.theme == ThemeMode.light
                      ? Text(
                          "Profil Sayfası",
                        style: TextStyle(color: Colors.black),)
                      : Text(
                          "Profil Sayfası", style: TextStyle(color: Colors.white)
                        ),
                  leading: IconButton(
                    icon: model.theme == ThemeMode.light ? Icon(Icons.arrow_back, color: Colors.black) : Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => const HomePage())),
                  ),
                  backgroundColor: model.theme == ThemeMode.light ? Colors.white : Colors.black,
                  actions: [
                    IconButton(
                        onPressed: () {
                          model.ChangeTheme();
                        },
                        icon: model.theme == ThemeMode.light
                            ? Icon(Icons.dark_mode)
                            : Icon(Icons.light_mode)),
                    IconButton(onPressed: _signOut, icon: Icon(Icons.logout))
                  ],
                ),
                body: StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("Users")
                      .doc(currentUser!.email)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final userData =
                          snapshot.data?.data() as Map<String, dynamic>?;

                      return ListView(
                        children: [
                          const SizedBox(
                            height: 50,
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
                                    ? CircleAvatar(
                                        radius: 64,
                                        backgroundImage: MemoryImage(_image!),
                                      )
                                    : CircleAvatar(
                                        radius: 64,
                                        backgroundImage: NetworkImage(
                                            'https://media.istockphoto.com/id/1209654046/vector/user-avatar-profile-icon-black-vector-illustration.jpg?s=612x612&w=0&k=20&c=EOYXACjtZmZQ5IsZ0UUp1iNmZ9q2xl1BD1VvN6tZ2UI='),
                                      ),
                                Positioned(
                                  child: IconButton(
                                    onPressed: () async {
                                      ImagePicker imagePicker = ImagePicker();
                                      XFile? file = await imagePicker.pickImage(
                                          source: ImageSource.gallery);
                                      if (file == null) return;
                                      Uint8List img = await file!.readAsBytes();
                                      setState(() {
                                        _image = img;
                                      });

                                      //if (file == null) return;

                                      String uniqueFileName = DateTime.now()
                                          .millisecondsSinceEpoch
                                          .toString();

                                      Reference referenceRoot =
                                          FirebaseStorage.instance.ref();
                                      Reference referenceDirImages =
                                          referenceRoot.child('images');

                                      Reference referenceImageToUpload =
                                          referenceDirImages
                                              .child(uniqueFileName);

                                      try {
                                        await referenceImageToUpload
                                            .putFile(File(file!.path));

                                        imageUrl = await referenceImageToUpload
                                            .getDownloadURL();
                                      } catch (e) {}
                                    },
                                    icon: Icon(Icons.add_a_photo),
                                  ),
                                  bottom: -10,
                                  left: 80,
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            currentUser!.email!,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 25),
                            child: SizedBox(
                              height: 30,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Kullanıcı Bilgileri",
                                    style:
                                    TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          MyTextBox(
                            text: userData?['username'] ?? '',
                            sectionName: 'Kullanıcı Adı',
                            onPressed: () => editField('username'),
                          ),
                          MyTextBox(
                            text: userData?['name'] ?? '',
                            sectionName: 'Ad',
                            onPressed: () => editField('name'),
                          ),
                          MyTextBox(
                            text: userData?['surname'] ?? '',
                            sectionName: 'Soyad',
                            onPressed: () => editField('surname'),
                          ),
                          MyTextBox(
                            text: userData?['bio'] ?? '',
                            sectionName: 'Hakkında',
                            onPressed: () => editField('bio'),
                          ),
                          const SizedBox(
                            height: 50,
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
              ),
            ));
  }
}
