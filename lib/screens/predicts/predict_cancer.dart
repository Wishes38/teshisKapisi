import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dgbitirme/components/text_box.dart';
import 'package:dgbitirme/screens/home/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class CancerPredictPage extends StatelessWidget {
  const CancerPredictPage({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyCancerPredictPage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyCancerPredictPage extends StatefulWidget {
  const MyCancerPredictPage({super.key, required this.title});

  final String title;

  @override
  State<MyCancerPredictPage> createState() => _MyCancerPredictPageState();
}

//-121.56	39.27	28	2332	395.0	1041	344	3.7125	0	1	0	0	0
// 4087 rows × 13 columns
class _MyCancerPredictPageState extends State<MyCancerPredictPage> {
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
    14.146057,
    19.251740,
    92.132026,
    657.462335,
    0.097103,
    0.105734,
    0.090534,
    0.049749,
    0.181669,
    0.062842,
    0.412231,
    1.219293,
    2.908929,
    41.421590,
    0.007108,
    0.025804,
    0.032208,
    0.011907,
    0.020756,
    0.003754,
    16.302888,
    25.637621,
    107.485617,
    885.788987,
    0.133301,
    0.257872,
    0.277499,
    0.115795,
    0.290572,
    0.083960
  ];
  var std = [
    3.564197,
    4.283905,
    24.590970,
    358.777473,
    0.014268,
    0.052806,
    0.079705,
    0.038774,
    0.027398,
    0.007026,
    0.288455,
    0.539603,
    2.090960,
    48.522508,
    0.003054,
    0.017917,
    0.027263,
    0.005935,
    0.008488,
    0.002388,
    4.892420,
    6.152119,
    33.903442,
    582.943669,
    0.023150,
    0.161656,
    0.214005,
    0.065518,
    0.062442,
    0.018739
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadModel();
  }

  loadModel() async {
    interpreter = await Interpreter.fromAsset('assets/cancer.tflite');
  }

  void addDataToFirestore(Map<String, dynamic> data) async {
    try {
      // Firestore referansını alın
      CollectionReference diabetesCollection =
          FirebaseFirestore.instance.collection('cancer');

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
    double radius_mean = double.parse(radius_meanController.text);
    double texture_mean = double.parse(texture_meanController.text);
    double perimeter_mean = double.parse(perimeter_meanController.text);
    double area_mean = double.parse(area_meanController.text);
    double smoothness_mean = double.parse(smoothness_meanController.text);
    double compactness_mean = double.parse(compactness_meanController.text);
    double concavity_mean = double.parse(concavity_meanController.text);
    double concave_points_mean =
        double.parse(concave_points_meanController.text);
    double symmetry_mean = double.parse(symmetry_meanController.text);
    double fractal_dimension_mean =
        double.parse(fractal_dimension_meanController.text);
    double radius_se = double.parse(radius_seController.text);
    double texture_se = double.parse(texture_seController.text);
    double perimeter_se = double.parse(perimeter_seController.text);
    double area_se = double.parse(area_seController.text);
    double smoothness_se = double.parse(smoothness_seController.text);
    double compactness_se = double.parse(compactness_seController.text);
    double concavity_se = double.parse(concavity_seController.text);
    double concave_points_se = double.parse(concave_points_seController.text);
    double symmetry_se = double.parse(symmetry_seController.text);
    double fractal_dimension_se =
        double.parse(fractal_dimension_seController.text);
    double radius_worst = double.parse(radius_worstController.text);
    double texture_worst = double.parse(texture_worstController.text);
    double perimeter_worst = double.parse(perimeter_worstController.text);
    double area_worst = double.parse(area_worstController.text);
    double smoothness_worst = double.parse(smoothness_worstController.text);
    double compactness_worst = double.parse(compactness_worstController.text);
    double concavity_worst = double.parse(concavity_worstController.text);
    double concave_points_worst =
        double.parse(concave_points_worstController.text);
    double symmetry_worst = double.parse(symmetry_worstController.text);
    double fractal_dimension_worst =
        double.parse(fractal_dimension_worstController.text);
    String ad = adController.text;
    String soyad = soyadController.text;
    String tc = tcController.text;


    Map<String, dynamic> data = {
      'radius_mean': radius_mean,
      'texture_mean': texture_mean,
      'perimeter_mean': perimeter_mean,
      'area_mean': area_mean,
      'smoothness_mean': smoothness_mean,
      'compactness_mean': compactness_mean,
      'concavity_mean': concavity_mean,
      'concave_points_mean': concave_points_mean,
      'symmetry_mean': symmetry_mean,
      'fractal_dimension_mean': fractal_dimension_mean,
      'radius_se': radius_se,
      'texture_se': texture_se,
      'perimeter_se': perimeter_se,
      'area_se': area_se,
      'smoothness_se': smoothness_se,
      'compactness_se': compactness_se,
      'concavity_se': concavity_se,
      'concave_points_se': concave_points_se,
      'symmetry_se': symmetry_se,
      'fractal_dimension_se': fractal_dimension_se,
      'radius_worst': radius_worst,
      'texture_worst': texture_worst,
      'perimeter_worst': perimeter_worst,
      'area_worst': area_worst,
      'smoothness_worst': smoothness_worst,
      'compactness_worst': compactness_worst,
      'concavity_worst': concavity_worst,
      'concave_points_worst': concave_points_worst,
      'symmetry_worst': symmetry_worst,
      'fractal_dimension_worst': fractal_dimension_worst,
    };

    radius_mean = (radius_mean - mean[0]) / std[0];
    texture_mean = (texture_mean - mean[1]) / std[1];
    perimeter_mean = (perimeter_mean - mean[2]) / std[2];
    area_mean = (area_mean - mean[3]) / std[3];
    smoothness_mean = (smoothness_mean - mean[4]) / std[4];
    compactness_mean = (compactness_mean - mean[5]) / std[5];
    concavity_mean = (concavity_mean - mean[6]) / std[6];
    concave_points_mean = (concave_points_mean - mean[7]) / std[7];
    symmetry_mean = (symmetry_mean - mean[8]) / std[8];
    fractal_dimension_mean = (fractal_dimension_mean - mean[9]) / std[9];
    radius_se = (radius_se - mean[10]) / std[10];
    texture_se = (texture_se - mean[11]) / std[11];
    perimeter_se = (perimeter_se - mean[12]) / std[12];
    area_se = (area_se - mean[13]) / std[13];
    smoothness_se = (smoothness_se - mean[14]) / std[14];
    compactness_se = (compactness_se - mean[15]) / std[15];
    concavity_se = (concavity_se - mean[16]) / std[16];
    concave_points_se = (concave_points_se - mean[17]) / std[17];
    symmetry_se = (symmetry_se - mean[18]) / std[18];
    fractal_dimension_se = (fractal_dimension_se - mean[19]) / std[19];
    radius_worst = (radius_worst - mean[20]) / std[20];
    texture_worst = (texture_worst - mean[21]) / std[21];
    perimeter_worst = (perimeter_worst - mean[22]) / std[22];
    area_worst = (area_worst - mean[23]) / std[23];
    smoothness_worst = (smoothness_worst - mean[24]) / std[24];
    compactness_worst = (compactness_worst - mean[25]) / std[25];
    concavity_worst = (concavity_worst - mean[26]) / std[26];
    concave_points_worst = (concave_points_worst - mean[27]) / std[27];
    symmetry_worst = (symmetry_worst - mean[28]) / std[28];
    fractal_dimension_worst = (fractal_dimension_worst - mean[29]) / std[29];



    // For ex: if input tensor shape [1,5] and type is float32
    var input = [
      radius_mean,
      texture_mean,
      perimeter_mean,
      area_mean,
      smoothness_mean,
      compactness_mean,
      concavity_mean,
      concave_points_mean,
      symmetry_mean,
      fractal_dimension_mean,
      radius_se,
      texture_se,
      perimeter_se,
      area_se,
      smoothness_se,
      compactness_se,
      concavity_se,
      concave_points_se,
      symmetry_se,
      fractal_dimension_se,
      radius_worst,
      texture_worst,
      perimeter_worst,
      area_worst,
      smoothness_worst,
      compactness_worst,
      concavity_worst,
      concave_points_worst,
      symmetry_worst,
      fractal_dimension_worst,
    ];

// if output tensor shape [1,2] and type is float32
    var output = List.filled(1 * 1, 0).reshape([1, 1]);

// inference
    interpreter.run(input, output);

// print the output
    print(output);
    result = output[0][0].toString();
    double? resultAsDouble = double.tryParse(result);
    setState(() {
      if (resultAsDouble! > 0.5) {
        result = "Kötü Huylu Tümör Riski";
      } else {
        result = "İyi Huylu Tümör";
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
  TextEditingController radius_meanController = TextEditingController();
  TextEditingController texture_meanController = TextEditingController();
  TextEditingController perimeter_meanController = TextEditingController();
  TextEditingController area_meanController = TextEditingController();
  TextEditingController smoothness_meanController = TextEditingController();
  TextEditingController compactness_meanController = TextEditingController();
  TextEditingController concavity_meanController = TextEditingController();
  TextEditingController concave_points_meanController = TextEditingController();
  TextEditingController symmetry_meanController = TextEditingController();
  TextEditingController fractal_dimension_meanController =
      TextEditingController();
  TextEditingController radius_seController = TextEditingController();
  TextEditingController texture_seController = TextEditingController();
  TextEditingController perimeter_seController = TextEditingController();
  TextEditingController area_seController = TextEditingController();
  TextEditingController smoothness_seController = TextEditingController();
  TextEditingController compactness_seController = TextEditingController();
  TextEditingController concavity_seController = TextEditingController();
  TextEditingController concave_points_seController = TextEditingController();
  TextEditingController symmetry_seController = TextEditingController();
  TextEditingController fractal_dimension_seController =
      TextEditingController();
  TextEditingController radius_worstController = TextEditingController();
  TextEditingController texture_worstController = TextEditingController();
  TextEditingController perimeter_worstController = TextEditingController();
  TextEditingController area_worstController = TextEditingController();
  TextEditingController smoothness_worstController = TextEditingController();
  TextEditingController compactness_worstController = TextEditingController();
  TextEditingController concavity_worstController = TextEditingController();
  TextEditingController concave_points_worstController =
      TextEditingController();
  TextEditingController symmetry_worstController = TextEditingController();
  TextEditingController fractal_dimension_worstController =
      TextEditingController();

  ScrollController scrollController = ScrollController();

  // Alan Controller'ları

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            "Kanser Hastalığı",
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
                      "radius_mean",
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
                        controller: radius_meanController,
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
                      "texture_mean",
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
                        controller: texture_meanController,
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
                      "perimeter_mean",
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
                        controller: perimeter_meanController,
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
                      "area_mean",
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
                        controller: area_meanController,
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
                      "smoothness_mean",
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
                        controller: smoothness_meanController,
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
                      "compactness_mean",
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
                        controller: compactness_meanController,
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
                      "concavity_mean",
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
                        controller: concavity_meanController,
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
                      "concave_points_mean",
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
                        controller: concave_points_meanController,
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
                      "symmetry_mean",
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
                        controller: symmetry_meanController,
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
                      "fractal_dimension_mean",
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
                        controller: fractal_dimension_meanController,
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
                      "radius_se",
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
                        controller: radius_seController,
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
                      "texture_se",
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
                        controller: texture_seController,
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
                      "perimeter_se",
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
                        controller: perimeter_seController,
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
                      "area_se",
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
                        controller: area_seController,
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
                      "smoothness_se",
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
                        controller: smoothness_seController,
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
                      "compactness_se",
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
                        controller: compactness_seController,
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
                      "concavity_se",
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
                        controller: concavity_seController,
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
                      "concave_points_se",
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
                        controller: concave_points_seController,
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
                      "symmetry_se",
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
                        controller: symmetry_seController,
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
                      "fractal_dimension_se",
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
                        controller: fractal_dimension_seController,
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
                      "radius_worst",
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
                        controller: radius_worstController,
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
                      "texture_worst",
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
                        controller: texture_worstController,
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
                      "perimeter_worst",
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
                        controller: perimeter_worstController,
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
                      "area_worst",
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
                        controller: area_worstController,
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
                      "smoothness_worstr",
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
                        controller: smoothness_worstController,
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
                      "compactness_worst",
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
                        controller: compactness_worstController,
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
                      "concavity_worst",
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
                        controller: concavity_worstController,
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
                      "concave_points_worst",
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
                        controller: concave_points_worstController,
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
                      "symmetry_worst",
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
                        controller: symmetry_worstController,
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
                      "fractal_dimension_worst",
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
                        controller: fractal_dimension_worstController,
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
              // BURAYA KADAR
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
