class Undangan {
  final String id;
  final String title;
  final String organization;
  final String date;
  final String location;
  final String status; // 'pending', 'confirmed', 'declined'
  final String? description;

  Undangan({
    required this.id,
    required this.title,
    required this.organization,
    required this.date,
    required this.location,
    required this.status,
    this.description,
  });

  factory Undangan.fromJson(Map<String, dynamic> json) {
    return Undangan(
      id: json['id'] as String,
      title: json['title'] as String,
      organization: json['organization'] as String,
      date: json['date'] as String,
      location: json['location'] as String,
      status: json['status'] as String,
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'organization': organization,
      'date': date,
      'location': location,
      'status': status,
      'description': description,
    };
  }
}
