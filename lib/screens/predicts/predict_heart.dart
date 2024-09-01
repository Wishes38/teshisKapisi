import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dgbitirme/components/text_box.dart';
import 'package:dgbitirme/screens/home/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class HeartPredictPage extends StatelessWidget {
  const HeartPredictPage({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHeartPredictPage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHeartPredictPage extends StatefulWidget {
  const MyHeartPredictPage({super.key, required this.title});

  final String title;

  @override
  State<MyHeartPredictPage> createState() => _MyHeartPredictPageState();
}

//-121.56	39.27	28	2332	395.0	1041	344	3.7125	0	1	0	0	0
// 4087 rows × 13 columns
class _MyHeartPredictPageState extends State<MyHeartPredictPage> {
  final TextStyle customTextStyle = TextStyle(
    // Define your custom text style properties here
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  String selectedValue = 'Erkek';


  String ad = "";
  String soyad = "";
  String tc = "";

  late Interpreter interpreter;
  var result = "";
  var mean = [
    53.726158,
    0.215259,
    132.292916,
    197.516349,
    0.241144,
    137.014986,
    0.403270,
    0.884196,
    0.540872,
    0.217984,
    0.190736,
    0.050409,
    0.598093,
    0.189373,
    0.212534,
    0.494550,
    0.433243,
    0.072207
  ];
  var std = [
    9.473159,
    0.411282,
    17.949376,
    111.692250,
    0.428069,
    25.527687,
    0.490889,
    1.043381,
    0.498666,
    0.413158,
    0.393149,
    0.218936,
    0.490618,
    0.392072,
    0.409380,
    0.500311,
    0.495861,
    0.259007
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadModel();
  }

  loadModel() async {
    interpreter = await Interpreter.fromAsset('assets/heart.tflite');
  }

  void addDataToFirestore(Map<String, dynamic> data) async {
    try {
      // Firestore referansını alın
      CollectionReference diabetesCollection =
          FirebaseFirestore.instance.collection('heart');

      // Veriyi Firestore'a ekleyin
      await diabetesCollection.add(data);

      // İşlem başarılı olduysa kullanıcıya geri bildirim verin
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veri başarıyla eklendi')),
      );
    } catch (e) {
      // Hata durumunda kullanıcıya geri bildirim verin
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veri eklenirken bir hata oluştu: $e')),
      );
    }
  }

  performAction() {
    double age = double.parse(ageController.text);
    double sex = double.parse(sexController.text);
    double restingBP = double.parse(restingBPController.text);
    double cholesterol = double.parse(cholesterolController.text);
    double fastingBS = double.parse(fastingBSController.text);
    double maxHR = double.parse(maxHRController.text);
    double exerciseAngina = double.parse(exerciseAnginaController.text);
    double oldpeak = double.parse(oldpeakController.text);
    double ASY = double.parse(ASYController.text);
    double NAP = double.parse(NAPController.text);
    double ATA = double.parse(ATAController.text);
    double TA = double.parse(TAController.text);
    double normal = double.parse(normalController.text);
    double ST = double.parse(STController.text);
    double LVH = double.parse(LVHController.text);
    double Flat = double.parse(FlatController.text);
    double Up = double.parse(UpController.text);
    double Down = double.parse(DownController.text);
    String ad = adController.text;
    String soyad = soyadController.text;
    String tc = tcController.text;

    Map<String, dynamic> data = {
      'age': age,
      'sex': sex,
      'restingBP': restingBP,
      'cholesterol': cholesterol,
      'fastingBS': fastingBS,
      'maxHR': maxHR,
      'exerciseAngina	': exerciseAngina,
      'oldpeak': oldpeak,
      'ASY': ASY,
      'NAP': NAP,
      'ATA': ATA,
      'TA': TA,
      'normal': normal,
      'ST': ST,
      'LVH': LVH,
      'Flat': Flat,
      'Up': Up,
      'Down': Down,
    };

    age = (age - mean[0]) / std[0];
    sex = (sex - mean[1]) / std[1];
    restingBP = (restingBP - mean[2]) / std[2];
    cholesterol = (cholesterol - mean[3]) / std[3];
    fastingBS = (fastingBS - mean[4]) / std[4];
    maxHR = (maxHR - mean[5]) / std[5];
    exerciseAngina = (exerciseAngina - mean[6]) / std[6];
    oldpeak = (oldpeak - mean[7]) / std[7];
    ASY = (ASY - mean[8]) / std[8];
    NAP = (NAP - mean[9]) / std[9];
    ATA = (ATA - mean[10]) / std[10];
    TA = (TA - mean[11]) / std[11];
    normal = (normal - mean[11]) / std[11];
    ST = (ST - mean[12]) / std[12];
    LVH = (LVH - mean[13]) / std[13];
    Flat = (Flat - mean[14]) / std[14];
    Up = (Up - mean[15]) / std[15];
    Down = (Down - mean[16]) / std[16];

    // For ex: if input tensor shape [1,5] and type is float32
    var input = [
      age,
      sex,
      restingBP,
      cholesterol,
      fastingBS,
      maxHR,
      exerciseAngina,
      oldpeak,
      ASY,
      NAP,
      ATA,
      TA,
      normal,
      ST,
      LVH,
      Flat,
      Up,
      Down
    ];

// if output tensor shape [1,2] and type is float32
    var output = List.filled(1 * 1, 0).reshape([1, 1]);

// inference
    interpreter.run(input, output);

// print the output
    print(output);
    result = output[0][0].toString();
    double resultAsDouble = double.parse(result);
    setState(() {
      if (resultAsDouble > 0.5) {
        result = "Risk var";
      } else {
        result = "Risk yok";
      }
      result;

    });


    data['result'] = result;
    data['ad'] = ad;
    data['soyad'] = soyad;
    data['tc'] = tc;
    addDataToFirestore(data);
  }

  TextEditingController ageController = TextEditingController();
  TextEditingController sexController = TextEditingController();
  TextEditingController restingBPController = TextEditingController();
  TextEditingController cholesterolController = TextEditingController();
  TextEditingController fastingBSController = TextEditingController();
  TextEditingController maxHRController = TextEditingController();
  TextEditingController exerciseAnginaController = TextEditingController();
  TextEditingController oldpeakController = TextEditingController();
  TextEditingController ASYController = TextEditingController();
  TextEditingController NAPController = TextEditingController();
  TextEditingController ATAController = TextEditingController();
  TextEditingController TAController = TextEditingController();
  TextEditingController normalController = TextEditingController();
  TextEditingController STController = TextEditingController();
  TextEditingController LVHController = TextEditingController();
  TextEditingController FlatController = TextEditingController();
  TextEditingController UpController = TextEditingController();
  TextEditingController DownController = TextEditingController();
  TextEditingController adController = TextEditingController();
  TextEditingController soyadController = TextEditingController();
  TextEditingController tcController = TextEditingController();

  ScrollController scrollController = ScrollController();

  // Alan Controller'ları

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            "Kalp Hastalığı",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Colors.black,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => HomePage()));
            },
          )),
      body: SingleChildScrollView(
        controller: scrollController,
        child: Container(
          decoration:
              const BoxDecoration(border: Border(left: BorderSide(width: 4))),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Container(
                height: 100,
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 5, right: 10),
                      child: Image.asset(
                        'assets/icons/medical-report.png',
                      ),
                    ),
                    Container(
                      width: 200, // Veya istediğiniz bir genişlik
                      child: Text(
                        '$result',
                        style: const TextStyle(
                            fontSize: 26, fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Ad",
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ],
                ),
              ),
              Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  //color: Colors.grey.withOpacity(0.2), // Gri arka plan
                    borderRadius: BorderRadius.circular(25.0),
                    border: Border.all(color: Colors.grey)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: adController,
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                            hintText: '',
                            border: InputBorder.none,
                            hintStyle:
                            TextStyle(color: Colors.grey, fontSize: 18)),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Soyad",
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ],
                ),
              ),
              Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  //color: Colors.grey.withOpacity(0.2), // Gri arka plan
                    borderRadius: BorderRadius.circular(25.0),
                    border: Border.all(color: Colors.grey)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: soyadController,
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                            hintText: '',
                            border: InputBorder.none,
                            hintStyle:
                            TextStyle(color: Colors.grey, fontSize: 18)),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Tc Kimlik No:",
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ],
                ),
              ),
              Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  //color: Colors.grey.withOpacity(0.2), // Gri arka plan
                    borderRadius: BorderRadius.circular(25.0),
                    border: Border.all(color: Colors.grey)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: tcController,
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                            hintText: '',
                            border: InputBorder.none,
                            hintStyle:
                            TextStyle(color: Colors.grey, fontSize: 18)),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Yaş",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ],
                ),
              ),
              Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    //color: Colors.grey.withOpacity(0.2), // Gri arka plan
                    borderRadius: BorderRadius.circular(25.0),
                    border: Border.all(color: Colors.grey)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: ageController,
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                            hintText: '',
                            border: InputBorder.none,
                            hintStyle:
                                TextStyle(color: Colors.grey, fontSize: 18)),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Cinsiyet",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ],
                ),
              ),
              Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  //color: Colors.grey.withOpacity(0.2), // Gri arka plan
                    borderRadius: BorderRadius.circular(25.0),
                    border: Border.all(color: Colors.grey)),
                child: Expanded(
                  child: Center(
                    child: DropdownButton(
                      value: selectedValue,
                      items: [
                        DropdownMenuItem(child: Text('Erkek'), value: 'Erkek'),
                        DropdownMenuItem(child: Text('Kadın'), value: 'Kadın'),
                      ],
                      onChanged: (newValue) {
                        setState(() {
                          selectedValue = newValue!;
                          if (newValue == "Erkek") {
                            sexController.text =
                            "0"; // Controller güncelleniyor
                          }
                          if (newValue == "Kadın") {
                            sexController.text =
                            "1"; // Controller güncelleniyor
                          }
                        });
                      },
                    ),
                  ),

                ),
              ),
              SizedBox(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "restingBP",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ],
                ),
              ),
              Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    //color: Colors.grey.withOpacity(0.2), // Gri arka plan
                    borderRadius: BorderRadius.circular(25.0),
                    border: Border.all(color: Colors.grey)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: TextField(
                        textAlign: TextAlign.center,
                        controller: restingBPController,
                        decoration: const InputDecoration(
                            hintText: '',
                            border: InputBorder.none,
                            hintStyle:
                                TextStyle(color: Colors.white, fontSize: 18)),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Kolesterol",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ],
                ),
              ),
              Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    //color: Colors.grey.withOpacity(0.2), // Gri arka plan
                    borderRadius: BorderRadius.circular(25.0),
                    border: Border.all(color: Colors.grey)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: TextField(
                        textAlign: TextAlign.center,
                        controller: cholesterolController,
                        decoration: const InputDecoration(
                            hintText: '',
                            border: InputBorder.none,
                            hintStyle:
                                TextStyle(color: Colors.white, fontSize: 18)),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "fastingBS",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ],
                ),
              ),
              Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    //color: Colors.grey.withOpacity(0.2), // Gri arka plan
                    borderRadius: BorderRadius.circular(25.0),
                    border: Border.all(color: Colors.grey)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: TextField(
                        textAlign: TextAlign.center,
                        controller: fastingBSController,
                        decoration: const InputDecoration(
                            hintText: '',
                            border: InputBorder.none,
                            hintStyle:
                                TextStyle(color: Colors.white, fontSize: 18)),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "maxHR",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ],
                ),
              ),
              Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    //color: Colors.grey.withOpacity(0.2), // Gri arka plan
                    borderRadius: BorderRadius.circular(25.0),
                    border: Border.all(color: Colors.grey)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: TextField(
                        textAlign: TextAlign.center,
                        controller: maxHRController,
                        decoration: const InputDecoration(
                            hintText: '',
                            border: InputBorder.none,
                            hintStyle:
                                TextStyle(color: Colors.white, fontSize: 18)),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "exerciseAngina",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ],
                ),
              ),
              Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    //color: Colors.grey.withOpacity(0.2), // Gri arka plan
                    borderRadius: BorderRadius.circular(25.0),
                    border: Border.all(color: Colors.grey)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: TextField(
                        textAlign: TextAlign.center,
                        controller: exerciseAnginaController,
                        decoration: const InputDecoration(
                            hintText: '',
                            border: InputBorder.none,
                            hintStyle:
                                TextStyle(color: Colors.white, fontSize: 18)),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "oldpeak",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ],
                ),
              ),
              Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    //color: Colors.grey.withOpacity(0.2), // Gri arka plan
                    borderRadius: BorderRadius.circular(25.0),
                    border: Border.all(color: Colors.grey)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: TextField(
                        textAlign: TextAlign.center,
                        controller: oldpeakController,
                        decoration: const InputDecoration(
                            hintText: '',
                            border: InputBorder.none,
                            hintStyle:
                                TextStyle(color: Colors.white, fontSize: 18)),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "ASY",
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ],
                ),
              ),
              Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  //color: Colors.grey.withOpacity(0.2), // Gri arka plan
                    borderRadius: BorderRadius.circular(25.0),
                    border: Border.all(color: Colors.grey)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: TextField(
                        textAlign: TextAlign.center,
                        controller: ASYController,
                        decoration: const InputDecoration(
                            hintText: '',
                            border: InputBorder.none,
                            hintStyle:
                            TextStyle(color: Colors.white, fontSize: 18)),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "NAP",
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ],
                ),
              ),
              Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  //color: Colors.grey.withOpacity(0.2), // Gri arka plan
                    borderRadius: BorderRadius.circular(25.0),
                    border: Border.all(color: Colors.grey)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: TextField(
                        textAlign: TextAlign.center,
                        controller: NAPController,
                        decoration: const InputDecoration(
                            hintText: '',
                            border: InputBorder.none,
                            hintStyle:
                            TextStyle(color: Colors.white, fontSize: 18)),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "ATA",
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ],
                ),
              ),
              Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  //color: Colors.grey.withOpacity(0.2), // Gri arka plan
                    borderRadius: BorderRadius.circular(25.0),
                    border: Border.all(color: Colors.grey)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: TextField(
                        textAlign: TextAlign.center,
                        controller: ATAController,
                        decoration: const InputDecoration(
                            hintText: '',
                            border: InputBorder.none,
                            hintStyle:
                            TextStyle(color: Colors.white, fontSize: 18)),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "TA",
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ],
                ),
              ),
              Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  //color: Colors.grey.withOpacity(0.2), // Gri arka plan
                    borderRadius: BorderRadius.circular(25.0),
                    border: Border.all(color: Colors.grey)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: TextField(
                        textAlign: TextAlign.center,
                        controller: TAController,
                        decoration: const InputDecoration(
                            hintText: '',
                            border: InputBorder.none,
                            hintStyle:
                            TextStyle(color: Colors.white, fontSize: 18)),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Normal",
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ],
                ),
              ),
              Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  //color: Colors.grey.withOpacity(0.2), // Gri arka plan
                    borderRadius: BorderRadius.circular(25.0),
                    border: Border.all(color: Colors.grey)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: TextField(
                        textAlign: TextAlign.center,
                        controller: normalController,
                        decoration: const InputDecoration(
                            hintText: '',
                            border: InputBorder.none,
                            hintStyle:
                            TextStyle(color: Colors.white, fontSize: 18)),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "ST",
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ],
                ),
              ),
              Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  //color: Colors.grey.withOpacity(0.2), // Gri arka plan
                    borderRadius: BorderRadius.circular(25.0),
                    border: Border.all(color: Colors.grey)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: TextField(
                        textAlign: TextAlign.center,
                        controller: STController,
                        decoration: const InputDecoration(
                            hintText: '',
                            border: InputBorder.none,
                            hintStyle:
                            TextStyle(color: Colors.white, fontSize: 18)),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "LVH",
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ],
                ),
              ),
              Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  //color: Colors.grey.withOpacity(0.2), // Gri arka plan
                    borderRadius: BorderRadius.circular(25.0),
                    border: Border.all(color: Colors.grey)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: TextField(
                        textAlign: TextAlign.center,
                        controller: LVHController,
                        decoration: const InputDecoration(
                            hintText: '',
                            border: InputBorder.none,
                            hintStyle:
                            TextStyle(color: Colors.white, fontSize: 18)),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Flat",
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ],
                ),
              ),
              Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  //color: Colors.grey.withOpacity(0.2), // Gri arka plan
                    borderRadius: BorderRadius.circular(25.0),
                    border: Border.all(color: Colors.grey)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: TextField(
                        textAlign: TextAlign.center,
                        controller: FlatController,
                        decoration: const InputDecoration(
                            hintText: '',
                            border: InputBorder.none,
                            hintStyle:
                            TextStyle(color: Colors.white, fontSize: 18)),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Up",
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ],
                ),
              ),
              Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  //color: Colors.grey.withOpacity(0.2), // Gri arka plan
                    borderRadius: BorderRadius.circular(25.0),
                    border: Border.all(color: Colors.grey)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: TextField(
                        textAlign: TextAlign.center,
                        controller: UpController,
                        decoration: const InputDecoration(
                            hintText: '',
                            border: InputBorder.none,
                            hintStyle:
                            TextStyle(color: Colors.white, fontSize: 18)),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Down",
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ],
                ),
              ),
              Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  //color: Colors.grey.withOpacity(0.2), // Gri arka plan
                    borderRadius: BorderRadius.circular(25.0),
                    border: Border.all(color: Colors.grey)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: TextField(
                        textAlign: TextAlign.center,
                        controller: DownController,
                        decoration: const InputDecoration(
                            hintText: '',
                            border: InputBorder.none,
                            hintStyle:
                            TextStyle(color: Colors.white, fontSize: 18)),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width - 200,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    scrollController.jumpTo(0);
                    performAction();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'Kontrol Et',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
