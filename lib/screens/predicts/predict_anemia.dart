import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dgbitirme/components/text_box.dart';
import 'package:dgbitirme/screens/home/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class AnemiaPredictPage extends StatelessWidget {
  const AnemiaPredictPage({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyAnemiaPredictPage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyAnemiaPredictPage extends StatefulWidget {
  const MyAnemiaPredictPage({super.key, required this.title});

  final String title;

  @override
  State<MyAnemiaPredictPage> createState() => _MyAnemiaPredictPageState();
}

//-121.56	39.27	28	2332	395.0	1041	344	3.7125	0	1	0	0	0
// 4087 rows × 13 columns
class _MyAnemiaPredictPageState extends State<MyAnemiaPredictPage> {
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
  double? cikti;
  String araDeger = "";
  var mean = [
    45.171821,
    0.415808,
    4.265979,
    36.647079,
    87.504296,
    28.347113,
    32.180790,
    15.136254,
    8.850584,
    222.300000
  ];
  var std = [
    18.817949,
    0.493710,
    0.821438,
    6.867280,
    9.168301,
    3.943656,
    2.963027,
    2.234934,
    4.768168,
    100.573022
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //sexController.text = selectedValue; // Controller'a başlangıç değeri atanıyor
    loadModel();
  }

  loadModel() async {
    interpreter = await Interpreter.fromAsset('assets/anemia.tflite');
  }

  void addDataToFirestore(Map<String, dynamic> data) async {
    try {
      // Firestore referansını alın
      CollectionReference diabetesCollection =
          FirebaseFirestore.instance.collection('anemia');

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
    double RBC = double.parse(RBCController.text);
    double PCV = double.parse(PCVController.text);
    double MCV = double.parse(MCVController.text);
    double MCH = double.parse(MCHController.text);
    double MCHC = double.parse(MCHCController.text);
    double RDW = double.parse(RDWController.text);
    double TLC = double.parse(TLCController.text);
    double PLTmm3 = double.parse(PLTmm3Controller.text);
    String ad = adController.text;
    String soyad = soyadController.text;
    String tc = tcController.text;

    Map<String, dynamic> data = {
      'age': age,
      'sex': sex,
      'RBC': RBC,
      'PCV': PCV,
      'MCV': MCV,
      'MCH': MCH,
      'MCHC': MCHC,
      'RDW': RDW,
      'TLC': TLC,
      'PLTmm3': PLTmm3,
    };

    age = (age - mean[0]) / std[0];
    sex = (sex - mean[1]) / std[1];
    RBC = (RBC - mean[2]) / std[2];
    PCV = (PCV - mean[3]) / std[3];
    MCV = (MCV - mean[4]) / std[4];
    MCH = (MCH - mean[5]) / std[5];
    MCHC = (MCHC - mean[6]) / std[6];
    RDW = (RDW - mean[7]) / std[7];
    TLC = (TLC - mean[8]) / std[8];
    PLTmm3 = (PLTmm3 - mean[9]) / std[9];

    // For ex: if input tensor shape [1,5] and type is float32
    var input = [age, sex, RBC, PCV, MCV, MCH, MCHC, RDW, TLC, PLTmm3];

// if output tensor shape [1,2] and type is float32
    var output = List.filled(1 * 1, 0).reshape([1, 1]);

// inference
    interpreter.run(input, output);

// print the output
    print(output);
    result = output[0][0].toString();
    double resultAsDouble = double.parse(result);
    cikti = resultAsDouble;
    araDeger = cikti!.toStringAsFixed(2);

    setState(() {
      result="Risk Yok";
      if (sex == 0 && age >= 12) {
        //0'a erkek dedim.
        if (age >= 12 && age < 15) {
          if (resultAsDouble < 12.5) {
            result = "Risk var";
          }
        }
        if (age >= 15 && age < 18) {
          if (resultAsDouble < 13.3) {
            result = "Risk var";
          }
        }
        if (age >= 18) {
          if (resultAsDouble < 13.5) {
            result = "Risk var";
          }
        }
      }
      else if (sex == 1 && age >= 12) {
        if (age >= 12 && age < 15) {
          if (resultAsDouble < 12.5) {
            result = "Risk var";
          }
        }
        if (age >= 15 && age < 18) {
          if (resultAsDouble < 12.0) {
            result = "Risk var";
          }
        }
        if (age >= 18) {
          if (resultAsDouble < 12.0) {
            result = "Risk var";
          }
        }
      }
      else if (age >= 1 && age < 2) {
        if (resultAsDouble < 11.0) {
          result = "Risk var";
        }
      } else if (age >= 2 && age < 5) {
        if (resultAsDouble < 11.1) {
          result = "Risk var";
        }
      } else if (age >= 5 && age < 8) {
        if (resultAsDouble < 11.5) {
          result = "Risk var";
        }
      } else if (age >= 8 && age < 12) {
        if (resultAsDouble < 11.9) {
          result = "Risk var";
        }
      }
      result;
      cikti;
      araDeger;
    });

    data['result'] = result;
    data['araDeger'] = araDeger;
    data['ad'] = ad;
    data['soyad'] = soyad;
    data['tc'] = tc;
    addDataToFirestore(data);
  }


  TextEditingController adController = TextEditingController();
  TextEditingController soyadController = TextEditingController();
  TextEditingController tcController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController sexController = TextEditingController();
  TextEditingController RBCController = TextEditingController();
  TextEditingController PCVController = TextEditingController();
  TextEditingController MCVController = TextEditingController();
  TextEditingController MCHController = TextEditingController();
  TextEditingController MCHCController = TextEditingController();
  TextEditingController RDWController = TextEditingController();
  TextEditingController TLCController = TextEditingController();
  TextEditingController PLTmm3Controller = TextEditingController();

  ScrollController scrollController = ScrollController();

  // Alan Controller'ları

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            "Anemi Hastalığı",
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
                        '$result\nHGB: $araDeger',
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
                  /*
                  child: TextField(
                    textAlign: TextAlign.center,
                    controller: sexController,
                    decoration: const InputDecoration(
                        hintText: '0 : (Erkek), 1 : (Kadın)',
                        border: InputBorder.none,
                        ),
                  ),
                  */
                ),
              ),
              SizedBox(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "RBC",
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
                        controller: RBCController,
                        decoration: InputDecoration(
                          hintText: 'Red Blood Cell count',
                          border: InputBorder.none,
                        ),
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
                      "PCV",
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
                        controller: PCVController,
                        decoration: const InputDecoration(
                          hintText: 'Packed Cell Volume',
                          border: InputBorder.none,
                        ),
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
                      "MCV",
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
                        controller: MCVController,
                        decoration: const InputDecoration(
                          hintText: 'Mean Cell Volume',
                          border: InputBorder.none,
                        ),
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
                      "MCH",
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
                        controller: MCHController,
                        decoration: const InputDecoration(
                          hintText: 'Mean Cell Hemoglobin',
                          border: InputBorder.none,
                        ),
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
                      "MCHC",
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
                        controller: MCHCController,
                        decoration: const InputDecoration(
                          hintText: 'Mean Corpuscular Hemoglobin Concentration',
                          border: InputBorder.none,
                        ),
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
                      "RDW",
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
                        controller: RDWController,
                        decoration: const InputDecoration(
                          hintText: 'Red Cell Distribution width',
                          border: InputBorder.none,
                        ),
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
                      "TLC",
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
                        controller: TLCController,
                        decoration: const InputDecoration(
                          hintText: 'White Blood Cell (WBC count)',
                          border: InputBorder.none,
                        ),
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
                      "PLT/mm3",
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
                        controller: PLTmm3Controller,
                        decoration: const InputDecoration(
                          hintText: 'Platelet',
                          border: InputBorder.none,
                        ),
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
