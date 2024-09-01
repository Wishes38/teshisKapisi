import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dgbitirme/components/text_box.dart';
import 'package:dgbitirme/screens/home/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class DiabetesPredictPage extends StatelessWidget {
  const DiabetesPredictPage({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyDiabetesPredictPage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyDiabetesPredictPage extends StatefulWidget {
  const MyDiabetesPredictPage({super.key, required this.title});

  final String title;

  @override
  State<MyDiabetesPredictPage> createState() => _MyDiabetesPredictPageState();
}

//-121.56	39.27	28	2332	395.0	1041	344	3.7125	0	1	0	0	0
// 4087 rows × 13 columns
class _MyDiabetesPredictPageState extends State<MyDiabetesPredictPage> {
  final TextStyle customTextStyle = TextStyle(
    // Define your custom text style properties here
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  String ad = "";
  String soyad = "";
  String tc = "";

  late Interpreter interpreter;
  var result = "";
  var mean = [
    3.891462,
    121.808973,
    68.813314,
    20.327062,
    79.470333,
    32.076845,
    0.476249,
    33.276411,
  ];
  var std = [
    3.387286,
    32.134427,
    19.568272,
    16.062112,
    116.104926,
    7.687131,
    0.336858,
    11.588238,
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadModel();
  }

  loadModel() async {
    interpreter = await Interpreter.fromAsset('assets/diabetes.tflite');
  }

  void addDataToFirestore(Map<String, dynamic> data) async {
    try {
      // Firestore referansını alın
      CollectionReference diabetesCollection = FirebaseFirestore.instance.collection('diabetes');

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
    double pregnancies = double.parse(pregnanciesController.text);
    double glucose = double.parse(glucoseController.text);
    double bloodPressure = double.parse(bloodPressureController.text);
    double skinThickness = double.parse(skinThicknessController.text);
    double insulin = double.parse(insulinController.text);
    double BMI = double.parse(BMIController.text);
    double diabetesPedigreeFunction =
        double.parse(diabetesPedigreeFunctionController.text);
    double age = double.parse(ageController.text);
    String ad = adController.text;
    String soyad = soyadController.text;
    String tc = tcController.text;


    Map<String, dynamic> data = {
      'pregnancies': pregnancies,
      'glucose': glucose,
      'bloodPressure': bloodPressure,
      'skinThickness': skinThickness,
      'insulin': insulin,
      'BMI': BMI,
      'diabetesPedigreeFunction': diabetesPedigreeFunction,
      'age': age,

    };


    pregnancies = (pregnancies - mean[0]) / std[0];
    glucose = (glucose - mean[1]) / std[1];
    bloodPressure = (bloodPressure - mean[2]) / std[2];
    skinThickness = (skinThickness - mean[3]) / std[3];
    insulin = (insulin - mean[4]) / std[4];
    BMI = (BMI - mean[5]) / std[5];
    diabetesPedigreeFunction = (diabetesPedigreeFunction - mean[6]) / std[6];
    age = (age - mean[7]) / std[7];

    // For ex: if input tensor shape [1,5] and type is float32
    var input = [
      pregnancies,
      glucose,
      bloodPressure,
      skinThickness,
      insulin,
      BMI,
      diabetesPedigreeFunction,
      age
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

    //'result': result, // Sonucu da ekleyin
    data['result'] = result;
    data['ad'] = ad;
    data['soyad'] = soyad;
    data['tc'] = tc;
    addDataToFirestore(data);

  }

  TextEditingController adController = TextEditingController();
  TextEditingController soyadController = TextEditingController();
  TextEditingController tcController = TextEditingController();
  TextEditingController pregnanciesController = TextEditingController();
  TextEditingController glucoseController = TextEditingController();
  TextEditingController bloodPressureController = TextEditingController();
  TextEditingController skinThicknessController = TextEditingController();
  TextEditingController insulinController = TextEditingController();
  TextEditingController BMIController = TextEditingController();
  TextEditingController diabetesPedigreeFunctionController =
      TextEditingController();
  TextEditingController ageController = TextEditingController();

  ScrollController scrollController = ScrollController();

  // Alan Controller'ları

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Diyabet Hastalığı", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
          centerTitle: true,
          backgroundColor: Colors.black,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white
              ,),
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
                      "Hamilelik",
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
                        controller: pregnanciesController,
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
                      "Glikoz",
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
                        controller: glucoseController,
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
                      "Tansiyon",
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
                        controller: bloodPressureController,
                        decoration: const InputDecoration(
                            hintText: 'Tansiyon',
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
                      "Cilt Kalınlığı",
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
                        controller: skinThicknessController,
                        decoration: const InputDecoration(
                            hintText: 'Cilt Kalınlığı',
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
                      "İnsülin",
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
                        controller: insulinController,
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
                      "BMI",
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
                        controller: BMIController,
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
                      "Diyabet Soyağacı Fonksiyonu",
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
                        controller: diabetesPedigreeFunctionController,
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
                        textAlign: TextAlign.center,
                        controller: ageController,
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
