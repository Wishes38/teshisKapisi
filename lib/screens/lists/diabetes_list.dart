import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DiabetesListPage extends StatefulWidget {
  @override
  _DiabetesListPageState createState() => _DiabetesListPageState();
}

class _DiabetesListPageState extends State<DiabetesListPage> {
  late Future<List<DocumentSnapshot>> diabetesData;
  late TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    diabetesData = getDiabetesData();
  }

  Future<List<DocumentSnapshot>> getDiabetesData() async {
    QuerySnapshot querySnapshot =
    await FirebaseFirestore.instance.collection('diabetes').get();
    return querySnapshot.docs;
  }

  Future<List<DocumentSnapshot>> searchDiabetesData(String searchText) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('diabetes')
        .where('tc', isEqualTo: searchText)
        .get();
    return querySnapshot.docs;
  }

  void onSearch(String searchText) {
    if (searchText.isNotEmpty) {
      setState(() {
        diabetesData = searchDiabetesData(searchText);
      });
    } else {
      setState(() {
        diabetesData = getDiabetesData();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Diyabet Hastalıkları Listesi'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: onSearch,
              decoration: InputDecoration(
                labelText: 'TC ile arama yap',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    onSearch(_searchController.text.trim());
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<DocumentSnapshot>>(
              future: diabetesData,
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
                List<DocumentSnapshot> diabetesList = snapshot.data!;
                return ListView.builder(
                  itemCount: diabetesList.length,
                  itemBuilder: (context, index) {
                    var data = diabetesList[index].data() as Map<String, dynamic>;
                    var result = data['result'];
                    var name = data['ad'];
                    var surname = data['soyad'];
                    return Card(
                      shadowColor: Colors.black,
                      color: Colors.white,
                      margin: EdgeInsets.all(10),
                      child: ListTile(
                        title: Text('$name $surname'),
                        subtitle: Text(result == 'Risk' ? 'Risk Var' : 'Risk Yok'),
                        trailing: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DiabetesDetailPage(data: data),
                              ),
                            );
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.black),
                          ),
                          child: Text(
                            "Detaylar",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class DiabetesDetailPage extends StatelessWidget {
  final Map<String, dynamic> data;

  const DiabetesDetailPage({required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detaylar'),
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
