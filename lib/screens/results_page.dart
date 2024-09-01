import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pie_chart/pie_chart.dart';

import 'home/home_page.dart';

class ResultsPage extends StatefulWidget {
  @override
  _ResultsPageState createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  late Future<List<QueryDocumentSnapshot>> searchData;
  late TextEditingController _searchController = TextEditingController();

  Map<String, double> dataMap = {};

  @override
  void initState() {
    super.initState();
    searchData = searchResults("");
    _loadData();
  }

  _loadData() async {
    final anemiaCount = await _getCollectionCount('anemia');
    final cancerCount = await _getCollectionCount('cancer');
    final diabetesCount = await _getCollectionCount('diabetes');
    final heartCount = await _getCollectionCount('heart');

    setState(() {
      dataMap = {
        'Anemia': anemiaCount.toDouble(),
        'Cancer': cancerCount.toDouble(),
        'Diabetes': diabetesCount.toDouble(),
        'Heart': heartCount.toDouble(),
      };
    });
  }

  Future<int> _getCollectionCount(String collectionName) async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection(collectionName).get();
    return snapshot.size;
  }

  Future<List<QueryDocumentSnapshot>> searchResults(String searchText) async {
    List<QueryDocumentSnapshot> results = [];

    QuerySnapshot heartSnapshot = await FirebaseFirestore.instance
        .collection('heart')
        .where('tc', isGreaterThanOrEqualTo: searchText)
        .where('tc', isLessThan: searchText + 'z')
        .get();
    results.addAll(heartSnapshot.docs);

    QuerySnapshot cancerSnapshot = await FirebaseFirestore.instance
        .collection('cancer')
        .where('tc', isGreaterThanOrEqualTo: searchText)
        .where('tc', isLessThan: searchText + 'z')
        .get();
    results.addAll(cancerSnapshot.docs);

    QuerySnapshot diabetesSnapshot = await FirebaseFirestore.instance
        .collection('diabetes')
        .where('tc', isGreaterThanOrEqualTo: searchText)
        .where('tc', isLessThan: searchText + 'z')
        .get();
    results.addAll(diabetesSnapshot.docs);

    QuerySnapshot anemiaSnapshot = await FirebaseFirestore.instance
        .collection('anemia')
        .where('tc', isGreaterThanOrEqualTo: searchText)
        .where('tc', isLessThan: searchText + 'z')
        .get();
    results.addAll(anemiaSnapshot.docs);

    return results;
  }

  void onSearch(String searchText) {
    setState(() {
      searchData = searchResults(searchText);
    });
  }

  void navigateToDetailPage(Map<String, dynamic> data) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailPage(data: data),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sonuçlar', style: TextStyle(
          color: Colors.white
        ),),
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(
            Icons.chevron_left,
            color: Colors.white,
            size: 30,
          ),
          onPressed: () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => HomePage()));
          },
        ),
      ),
      body: Container(
        decoration:
        const BoxDecoration(border: Border(left: BorderSide(width: 4))),
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Center(
              child: dataMap.isNotEmpty
                  ? PieChart(
                      dataMap: dataMap,
                      colorList: [
                        Color(0xFFD32F2F), // Koyu Kırmızı
                        Color(0xFF1976D2), // Koyu Mavi
                        Color(0xFF8E24AA), // Koyu Mor
                        Color(0xFFFFA000), // Koyu Sarı
                      ],
                      chartType: ChartType.disc,
                      chartRadius: MediaQuery.of(context).size.width / 1.40,
                      animationDuration: Duration(milliseconds: 800),
                      legendOptions: LegendOptions(
                        legendTextStyle: TextStyle(
                          fontSize: MediaQuery.of(context).size.width / 25,
                        ),
                        showLegendsInRow: true,
                        legendPosition: LegendPosition.bottom,
                        showLegends: true,
                      ),
                      chartValuesOptions: ChartValuesOptions(
                        chartValueStyle: GoogleFonts.roboto(
                          textStyle: Theme.of(context).textTheme.displayLarge,
                          fontSize: 24,
                          fontWeight: FontWeight.w400,
                        ),
                        showChartValueBackground: true,
                        showChartValues: true,
                        showChartValuesInPercentage: false,
                        showChartValuesOutside: false,
                        decimalPlaces: 0,
                      ),
                    )
                  : CircularProgressIndicator(),
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (text) {
                          onSearch(text);
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[200], // Arka plan rengi
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0), // Köşe yuvarlama
                            borderSide: BorderSide.none, // Sınır çizgisi yok
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: Colors.blue, width: 2.0), // Odaklandığında sınır rengi
                          ),
                          prefixIcon: Icon(Icons.search, color: Colors.grey[600]), // Ön ikon
                          hintText: 'TC ile arama yap', // Gölgeli yazı
                          hintStyle: TextStyle(color: Colors.grey[600]), // Gölgeli yazı rengi
                          suffixIcon: IconButton(
                            icon: Icon(Icons.clear, color: Colors.grey[600]), // Temizleme ikonu
                            onPressed: () {
                              _searchController.clear();
                              onSearch('');
                            },
                          ),
                        ),
                      ),
                    ),
                    FutureBuilder<List<QueryDocumentSnapshot>>(
                      future: searchData,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (snapshot.hasError) {
                          return Center(
                            child: Text('Veri alınamadı: ${snapshot.error}'),
                          );
                        }
                        List<QueryDocumentSnapshot> results = snapshot.data ?? [];
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: results.length,
                          itemBuilder: (context, index) {
                            var data = results[index].data() as Map<String, dynamic>;
                            return ListTile(
                              title: Text('TC: ${data['tc']}'),
                              subtitle: Text(
                                  '${data['result']} - ${data['ad']} ${data['soyad']}'),
                              trailing: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.black),
                                ),
                                onPressed: () {
                                  navigateToDetailPage(data);
                                },
                                child: Text(
                                  'Detaylar',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  final Map<String, dynamic> data;

  DetailPage({required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detaylar'),
        leading: IconButton(
          icon: Icon(
            Icons.chevron_left,
            size: 30,
          ),
          onPressed: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => ResultsPage()));
          },
        ),
      ),
      body: ListView(
        children: data.entries
            .map((entry) => ListTile(
                  title: Text(entry.key),
                  subtitle: Text(entry.value.toString()),
                ))
            .toList(),
      ),
    );
  }
}
