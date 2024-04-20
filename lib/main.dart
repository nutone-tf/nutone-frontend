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

late List <PlayerData> playerDataList;
final PlayerDataSource dataSource = PlayerDataSource();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var resp = await http.get(
    Uri.https('nutone.okudai.dev', '/players')
  );
  playerDataList = (json.decode(resp.body) as List).map((i) => 
    PlayerData.fromJson(i)).toList();
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
      home: const Nutone(),
    ),
  );
}

class Nutone extends StatelessWidget {
  const Nutone({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nutone API'),
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
  int get rowCount => playerDataList.length;

  @override
  DataRow? getRow(int index) {
    return DataRow(
      cells: <DataCell>[
        DataCell(Text(playerDataList[index].name.toString())),
        DataCell(Text(playerDataList[index].kills.toString())),
        DataCell(Text(playerDataList[index].deaths.toString())),
      ]
    );
  }
  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}

class _PlayerDataTableState extends State<PlayerDataTable> {
  int numItems = playerDataList.length;

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