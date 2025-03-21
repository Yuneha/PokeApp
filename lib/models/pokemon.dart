class Pokemon {
  final String numDex;
  final String name;
  final String img;
  final List<String> type;
  final String height;
  final String weight;
  final List<String>? weaknesses;
  final List<dynamic>? prevEvolution;
  final List<dynamic>? nextEvolution;

  Pokemon({
    required this.numDex,
    required this.name,
    required this.img,
    required this.type,
    required this.height,
    required this.weight,
    this.weaknesses,
    this.prevEvolution,
    this.nextEvolution,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      numDex: json['num'] ?? '',
      name: json['name'] ?? '',
      img: json['img'] ?? '',
      type: List<String>.from(json['type'] ?? []),
      height: json['height'] ?? '',
      weight: json['weight'] ?? '',
      weaknesses:
          (json['weaknesses'] as List?)?.map((e) => e as String).toList(),
      prevEvolution: json['prev_evolution'],
      nextEvolution: json['next_evolution'],
    );
  }
}
