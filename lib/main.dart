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
      'name': String name,
      'kills': int kills,
      'deaths': int deaths,
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

void main() async {
  var resp = await http.get(Uri.https('localhost:8080', '/players'));
  playerDataList = (json.decode(resp.body) as List).map((i) => 
    PlayerData.fromJson(i)).toList();
  runApp(
    const MaterialApp(
      title: 'Nutone',
      home: Nutone(),
    ),
  );
}

class Nutone extends StatelessWidget {
  const Nutone({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Text('Nutone API'),
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

class _PlayerDataTableState extends State<PlayerDataTable> {
  int numItems = playerDataList.length;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: DataTable(
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
        rows: List<DataRow>.generate(
          numItems,
          (int index) => DataRow(
            cells: <DataCell>[
              DataCell(Text(playerDataList[index].name)),
              DataCell(Text(playerDataList[index].kills as String)),
              DataCell(Text(playerDataList[index].deaths as String)),
            ]
          )
        )
      )
    );
  }
}