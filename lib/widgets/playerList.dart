import "package:flutter/material.dart";
import "package:nutone_frontend/main.dart";

class PlayerList extends StatelessWidget {
  final PlayerDataSource dataSource;

  const PlayerList({super.key, required this.dataSource});
  
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: PaginatedDataTable(
        columns: const<DataColumn>[
          DataColumn(label: Text('Name')),
          DataColumn(label: Text('Kills')),
          DataColumn(label: Text('Deaths')),
        ],
        source: dataSource,
      )
    );
  }
}