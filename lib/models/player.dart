class Data {
  final String name;
  final int kills;
  final int deaths;

  const Data({
    required this.name,
    required this.kills,
    required this.deaths,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return switch (json)
    {
      {
      'deaths': int deaths,
      'kills': int kills,
      'name': String name,
      } =>
        Data(
          name: name,
          kills: kills,
          deaths: deaths,
      ),
      Map<String, dynamic>() => throw UnimplementedError()
    };
  }
}