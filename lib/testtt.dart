import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pie_chart/pie_chart.dart';

class TestPage extends StatefulWidget {
  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  Map<String, double> dataMap = {};

  @override
  void initState() {
    super.initState();
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
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection(collectionName).get();
    return snapshot.size;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pie Chart Example'),
      ),
      body: Center(
        child: dataMap.isNotEmpty
            ? PieChart(
          dataMap: dataMap,
          chartType: ChartType.disc,
          chartRadius: MediaQuery.of(context).size.width,

          animationDuration: Duration(milliseconds: 800),
          legendOptions: LegendOptions(
            showLegendsInRow: true,
            legendPosition: LegendPosition.bottom,
            showLegends: true,
          ),
          chartValuesOptions: ChartValuesOptions(
            showChartValueBackground: true,
            showChartValues: true,
            showChartValuesInPercentage: false,
            showChartValuesOutside: false,
            decimalPlaces: 1,
          ),
        )
            : CircularProgressIndicator(),
      ),
    );
  }
}
