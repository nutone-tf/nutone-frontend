import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PlayerData {
  final String name;
  final int kills;
  final int deaths;

  const PlayerData({
    required this.name,
    required this.kills,
    required this.deaths,
  });

  factory PlayerData.fromJson(Map<String, dynamic> json) {
    return switch (json)
    {
      {
      'deaths': int deaths,
      'kills': int kills,
      'name': String name,
      } =>
        PlayerData(
          name: name,
          kills: kills,
          deaths: deaths,
      ),
      Map<String, dynamic>() => throw UnimplementedError()
    };
  }
}

List <PlayerData> pData = [];
List <PlayerData> sData = [];
String? filter = '';
final PlayerDataSource dataSource = PlayerDataSource();

void main() async {
  dataSource.get();
  runApp(
    MaterialApp(
      title: 'Nutone',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.dark,
        ),
      ),
      home: Nutone(),
    ),
  );
}

class Nutone extends StatelessWidget {
  Nutone({super.key});
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    textController.addListener(() {dataSource.notify(textController.text);});
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nutone API'),
        actions: <Widget> [SearchBar(
            controller: textController,
            padding: const MaterialStatePropertyAll<EdgeInsets>(EdgeInsets.symmetric(horizontal: 16.0)),
            leading: const Icon(Icons.search)
            )
          ]
        ),
      body: const PlayerDataTable()
      );
  }
}

class PlayerDataTable extends StatefulWidget {
  const PlayerDataTable({super.key});

  @override
  State<PlayerDataTable> createState() => _PlayerDataTableState();
}

class PlayerDataSource extends DataTableSource {
  @override
  int get rowCount => sData.length;

  @override
  DataRow? getRow(int index) {
      return DataRow(
        cells: <DataCell>[
          DataCell(Text(sData[index].name.toString())),
          DataCell(Text(sData[index].kills.toString())),
          DataCell(Text(sData[index].deaths.toString())),
        ]
      );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;

  void notify(String text) {
    filter = text;
    notifyListeners();
  }

  void get() async {
    var resp = await http.get(
      Uri.https('nutone.okudai.dev', '/players')
    );
    pData = (json.decode(resp.body) as List).map((i) => 
      PlayerData.fromJson(i)).toList();
    sData = pData.where((player) => player.name.contains(filter!)).toList();
    notifyListeners();
  }
}

class _PlayerDataTableState extends State<PlayerDataTable> {
  int numItems = pData.length;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: PaginatedDataTable(
        columns: const<DataColumn>[
          DataColumn(
            label: Text('Name'),
          ),
          DataColumn(
            label: Text('Kills'),
          ),
          DataColumn(
            label: Text('Deaths'),
          ),
        ],
        source: dataSource,
      )
    );
  }

}