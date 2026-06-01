import 'package:flutter/material.dart';

class Artifact {
  final String id;
  final String title;
  final String titleEn;
  final String description;
  final String descriptionEn;
  final String foundLocation;
  final String foundLocationEn;
  final String imageUrl;
  final String modelUrl;
  final String addedBy;
  final DateTime createdAt;
  final double? originLat;
  final double? originLng;
  final String originName;
  final String originNameEn;
  final String? ancientImageUrl;
  final String? expeditionId;

  final String category;
  final String categoryEn;
  final String period;
  final String periodEn;
  final String museumSection;
  final String museumSectionEn;
  final String condition;
  final String conditionEn;
  final String finderId;
  final DateTime? foundDate;

  final String material;
  final String materialEn;
  final String restorationStatus;
  final String restorationStatusEn;
  final String contextNotes;
  final String contextNotesEn;

  final double? height;
  final double? width;
  final double? depth;

  final double? gpsLat;
  final double? gpsLng;
  final String esp32Url;
  final String slug;

  Artifact({
    required this.id,
    required this.title,
    this.titleEn = '',
    required this.description,
    this.descriptionEn = '',
    required this.foundLocation,
    this.foundLocationEn = '',
    required this.imageUrl,
    this.modelUrl = '',
    required this.addedBy,
    required this.createdAt,
    this.originLat,
    this.originLng,
    this.originName = 'Неизвестно',
    this.originNameEn = 'Unknown',
    this.ancientImageUrl,
    this.expeditionId,

    this.category = 'Не указана',
    this.categoryEn = 'Not specified',
    this.period = '',
    this.periodEn = '',
    this.museumSection = 'Общий зал',
    this.museumSectionEn = 'Main Hall',
    this.condition = '',
    this.conditionEn = '',
    this.finderId = '',
    this.foundDate,

    this.material = '',
    this.materialEn = '',
    this.restorationStatus = '',
    this.restorationStatusEn = '',
    this.contextNotes = '',
    this.contextNotesEn = '',

    this.height,
    this.width,
    this.depth,

    this.gpsLat,
    this.gpsLng,
    this.esp32Url = '',
    this.slug = '',
  });

  // Helper to safely get fields during Hot Reload or from incomplete data
  String _safe(String? val) => val ?? '';

  String getDisplayTitle(Locale locale) => locale.languageCode == 'en' && _safe(titleEn).isNotEmpty ? _safe(titleEn) : _safe(title);
  String getDisplayDescription(Locale locale) => locale.languageCode == 'en' && _safe(descriptionEn).isNotEmpty ? _safe(descriptionEn) : _safe(description);
  String getDisplayLocation(Locale locale) => locale.languageCode == 'en' && _safe(foundLocationEn).isNotEmpty ? _safe(foundLocationEn) : _safe(foundLocation);
  String getDisplayCategory(Locale locale) => locale.languageCode == 'en' && _safe(categoryEn).isNotEmpty ? _safe(categoryEn) : _safe(category);
  String getDisplayPeriod(Locale locale) => locale.languageCode == 'en' && _safe(periodEn).isNotEmpty ? _safe(periodEn) : _safe(period);
  String getDisplayMaterial(Locale locale) => locale.languageCode == 'en' && _safe(materialEn).isNotEmpty ? _safe(materialEn) : _safe(material);
  String getDisplayCondition(Locale locale) => locale.languageCode == 'en' && _safe(conditionEn).isNotEmpty ? _safe(conditionEn) : _safe(condition);
  String getDisplayMuseumSection(Locale locale) => locale.languageCode == 'en' && _safe(museumSectionEn).isNotEmpty ? _safe(museumSectionEn) : _safe(museumSection);
  String getDisplayOriginName(Locale locale) => locale.languageCode == 'en' && _safe(originNameEn).isNotEmpty ? _safe(originNameEn) : _safe(originName);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'titleEn': titleEn,
      'description': description,
      'descriptionEn': descriptionEn,
      'foundLocation': foundLocation,
      'foundLocationEn': foundLocationEn,
      'imageUrl': imageUrl,
      'modelUrl': modelUrl,
      'addedBy': addedBy,
      'createdAt': createdAt.toIso8601String(),
      'originLat': originLat,
      'originLng': originLng,
      'originName': originName,
      'originNameEn': originNameEn,
      'ancientImageUrl': ancientImageUrl,
      'expeditionId': expeditionId,
      'category': category,
      'categoryEn': categoryEn,
      'period': period,
      'periodEn': periodEn,
      'museumSection': museumSection,
      'museumSectionEn': museumSectionEn,
      'condition': condition,
      'conditionEn': conditionEn,
      'finderId': finderId,
      'foundDate': foundDate?.toIso8601String(),
      'material': material,
      'materialEn': materialEn,
      'restorationStatus': restorationStatus,
      'restorationStatusEn': restorationStatusEn,
      'contextNotes': contextNotes,
      'contextNotesEn': contextNotesEn,
      'height': height,
      'width': width,
      'depth': depth,
      'gpsLat': gpsLat,
      'gpsLng': gpsLng,
      'esp32Url': esp32Url,
      'slug': slug,
    };
  }

  factory Artifact.fromMap(Map<String, dynamic> data) {
    return Artifact(
      id: data['id']?.toString() ?? '',
      title: data['title']?.toString() ?? '',
      titleEn: data['titleEn']?.toString() ?? '',
      description: data['description']?.toString() ?? '',
      descriptionEn: data['descriptionEn']?.toString() ?? '',
      foundLocation: data['foundLocation']?.toString() ?? '',
      foundLocationEn: data['foundLocationEn']?.toString() ?? '',
      imageUrl: data['imageUrl']?.toString() ?? '',
      modelUrl: data['modelUrl']?.toString() ?? '',
      addedBy: data['addedBy']?.toString() ?? '',
      createdAt: DateTime.tryParse(data['createdAt']?.toString() ?? '') ?? DateTime.now(),
      originLat: (data['originLat'] is num) ? (data['originLat'] as num).toDouble() : null,
      originLng: (data['originLng'] is num) ? (data['originLng'] as num).toDouble() : null,
      originName: data['originName']?.toString() ?? 'Неизвестно',
      originNameEn: data['originNameEn']?.toString() ?? 'Unknown',
      ancientImageUrl: data['ancientImageUrl']?.toString(),
      expeditionId: data['expeditionId']?.toString(),
      category: data['category']?.toString() ?? 'Не указана',
      categoryEn: data['categoryEn']?.toString() ?? 'Not specified',
      period: data['period']?.toString() ?? '',
      periodEn: data['periodEn']?.toString() ?? '',
      museumSection: data['museumSection']?.toString() ?? 'Общий зал',
      museumSectionEn: data['museumSectionEn']?.toString() ?? 'Main Hall',
      condition: data['condition']?.toString() ?? '',
      conditionEn: data['conditionEn']?.toString() ?? '',
      finderId: data['finderId']?.toString() ?? '',
      foundDate: data['foundDate'] != null ? DateTime.tryParse(data['foundDate'].toString()) : null,
      material: data['material']?.toString() ?? '',
      materialEn: data['materialEn']?.toString() ?? '',
      restorationStatus: data['restorationStatus']?.toString() ?? '',
      restorationStatusEn: data['restorationStatusEn']?.toString() ?? '',
      contextNotes: data['contextNotes']?.toString() ?? '',
      contextNotesEn: data['contextNotesEn']?.toString() ?? '',
      height: (data['height'] is num) ? (data['height'] as num).toDouble() : null,
      width: (data['width'] is num) ? (data['width'] as num).toDouble() : null,
      depth: (data['depth'] is num) ? (data['depth'] as num).toDouble() : null,
      gpsLat: (data['gpsLat'] is num) ? (data['gpsLat'] as num).toDouble() : null,
      gpsLng: (data['gpsLng'] is num) ? (data['gpsLng'] as num).toDouble() : null,
      esp32Url: data['esp32Url']?.toString() ?? '',
      slug: data['slug']?.toString() ?? '',
    );
  }

  Artifact copyWith({
    String? id,
    String? title,
    String? titleEn,
    String? description,
    String? descriptionEn,
    String? foundLocation,
    String? foundLocationEn,
    String? imageUrl,
    String? modelUrl,
    String? addedBy,
    DateTime? createdAt,
    double? originLat,
    double? originLng,
    String? originName,
    String? originNameEn,
    String? ancientImageUrl,
    String? expeditionId,
    String? category,
    String? categoryEn,
    String? period,
    String? periodEn,
    String? museumSection,
    String? museumSectionEn,
    String? condition,
    String? conditionEn,
    String? finderId,
    DateTime? foundDate,
    String? material,
    String? materialEn,
    String? restorationStatus,
    String? restorationStatusEn,
    String? contextNotes,
    String? contextNotesEn,
    double? height,
    double? width,
    double? depth,
    double? gpsLat,
    double? gpsLng,
    String? esp32Url,
    String? slug,
  }) {
    return Artifact(
      id: id ?? this.id,
      title: title ?? this.title,
      titleEn: titleEn ?? this.titleEn,
      description: description ?? this.description,
      descriptionEn: descriptionEn ?? this.descriptionEn,
      foundLocation: foundLocation ?? this.foundLocation,
      foundLocationEn: foundLocationEn ?? this.foundLocationEn,
      imageUrl: imageUrl ?? this.imageUrl,
      modelUrl: modelUrl ?? this.modelUrl,
      addedBy: addedBy ?? this.addedBy,
      createdAt: createdAt ?? this.createdAt,
      originLat: originLat ?? this.originLat,
      originLng: originLng ?? this.originLng,
      originName: originName ?? this.originName,
      originNameEn: originNameEn ?? this.originNameEn,
      ancientImageUrl: ancientImageUrl ?? this.ancientImageUrl,
      expeditionId: expeditionId ?? this.expeditionId,
      category: category ?? this.category,
      categoryEn: categoryEn ?? this.categoryEn,
      period: period ?? this.period,
      periodEn: periodEn ?? this.periodEn,
      museumSection: museumSection ?? this.museumSection,
      museumSectionEn: museumSectionEn ?? this.museumSectionEn,
      condition: condition ?? this.condition,
      conditionEn: conditionEn ?? this.conditionEn,
      finderId: finderId ?? this.finderId,
      foundDate: foundDate ?? this.foundDate,
      material: material ?? this.material,
      materialEn: materialEn ?? this.materialEn,
      restorationStatus: restorationStatus ?? this.restorationStatus,
      restorationStatusEn: restorationStatusEn ?? this.restorationStatusEn,
      contextNotes: contextNotes ?? this.contextNotes,
      contextNotesEn: contextNotesEn ?? this.contextNotesEn,
      height: height ?? this.height,
      width: width ?? this.width,
      depth: depth ?? this.depth,
      gpsLat: gpsLat ?? this.gpsLat,
      gpsLng: gpsLng ?? this.gpsLng,
      esp32Url: esp32Url ?? this.esp32Url,
      slug: slug ?? this.slug,
    );
  }
}
