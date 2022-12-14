
class Contest{
  final int id, durationSeconds, startTimeSeconds;
  final String name, phase, websiteUrl;

  Contest({
    required this.id,
    required this.durationSeconds,
    required this.startTimeSeconds,
    required this.name,
    required this.phase,
    required this.websiteUrl,
  });

  factory Contest.fromJson(Map<String, dynamic> json){
    return Contest(id: json['id'], 
    durationSeconds: json['durationSeconds'], 
    startTimeSeconds: json['startTimeSeconds'], 
    name: json['name'],
    phase: json['phase'],
    websiteUrl: json['websiteUrl'] ?? '',
    );
  }
}