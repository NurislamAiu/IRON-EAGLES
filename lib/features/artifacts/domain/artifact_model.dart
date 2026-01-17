class Artifact {
  final String id;
  final String title;
  final String description;
  final String foundLocation;
  final String imageUrl;
  final String qrCodeUrl;
  final String addedBy;
  final DateTime createdAt;

  // ➕ Новые поля (все НЕ обязательные, чтобы не ломать код)
  final String category;            // тип: Керамика, Металл и т.д.
  final String period;              // эпоха / период
  final String museumSection;       // зал: "Общий зал", "Зал 1" и т.п.
  final String condition;           // состояние: Отличное / Среднее / Плохое
  final String finderId;            // ID или email находчика
  final DateTime? foundDate;        // когда нашли (может быть null)

  final String material;            // материал: глина, бронза и т.д.
  final String restorationStatus;   // статус реставрации
  final String contextNotes;        // заметки контекста (глубина, слой и т.п.)

  final double? height;             // см
  final double? width;              // см
  final double? depth;              // см

  final double? gpsLat;             // широта
  final double? gpsLng;             // долгота

  Artifact({
    required this.id,
    required this.title,
    required this.description,
    required this.foundLocation,
    required this.imageUrl,
    required this.qrCodeUrl,
    required this.addedBy,
    required this.createdAt,

    this.category = 'Не указана',
    this.period = '',
    this.museumSection = 'Общий зал',
    this.condition = '',
    this.finderId = '',
    this.foundDate,

    this.material = '',
    this.restorationStatus = '',
    this.contextNotes = '',

    this.height,
    this.width,
    this.depth,

    this.gpsLat,
    this.gpsLng,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'foundLocation': foundLocation,
      'imageUrl': imageUrl,
      'qrCodeUrl': qrCodeUrl,
      'addedBy': addedBy,
      'createdAt': createdAt.toIso8601String(),

      'category': category,
      'period': period,
      'museumSection': museumSection,
      'condition': condition,
      'finderId': finderId,
      'foundDate': foundDate?.toIso8601String(),

      'material': material,
      'restorationStatus': restorationStatus,
      'contextNotes': contextNotes,

      'height': height,
      'width': width,
      'depth': depth,

      'gpsLat': gpsLat,
      'gpsLng': gpsLng,
    };
  }

  factory Artifact.fromMap(Map<String, dynamic> data) {
    return Artifact(
      id: data['id'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      foundLocation: data['foundLocation'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      qrCodeUrl: data['qrCodeUrl'] ?? '',
      addedBy: data['addedBy'] ?? '',
      createdAt: DateTime.tryParse(data['createdAt'] ?? '') ?? DateTime.now(),

      category: data['category'] ?? 'Не указана',
      period: data['period'] ?? '',
      museumSection: data['museumSection'] ?? 'Общий зал',
      condition: data['condition'] ?? '',
      finderId: data['finderId'] ?? '',
      foundDate: data['foundDate'] != null
          ? DateTime.tryParse(data['foundDate'])
          : null,

      material: data['material'] ?? '',
      restorationStatus: data['restorationStatus'] ?? '',
      contextNotes: data['contextNotes'] ?? '',

      height: (data['height'] is num) ? (data['height'] as num).toDouble() : null,
      width: (data['width'] is num) ? (data['width'] as num).toDouble() : null,
      depth: (data['depth'] is num) ? (data['depth'] as num).toDouble() : null,

      gpsLat: (data['gpsLat'] is num) ? (data['gpsLat'] as num).toDouble() : null,
      gpsLng: (data['gpsLng'] is num) ? (data['gpsLng'] as num).toDouble() : null,
    );
  }
}
