class BannerImage {
  String? id;
  String urlImagem;
  String? title;
  String? subtitle;
  String? description;
  bool isActive;

  BannerImage({
    this.id,
    required this.urlImagem,
    this.title,
    this.subtitle,
    this.description,
    required this.isActive,
  });

  // Construtor a partir de Map
  factory BannerImage.fromMap(Map<String, dynamic> map) {
    return BannerImage(
      id: map['id']?.toString(),
      urlImagem: map['urlImagem'] ?? '',
      title: map['title'],
      subtitle: map['subtitle'],
      description: map['description'],
      isActive: map['isActive'] ?? true,
    );
  }

  // Converte para Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'urlImagem': urlImagem,
      'title': title,
      'subtitle': subtitle,
      'description': description,
      'isActive': isActive,
    };
  }

  // Permite criar cópia com alterações
  BannerImage copyWith({
    String? id,
    String? urlImagem,
    String? title,
    String? subtitle,
    String? description,
    bool? isActive,
  }) {
    return BannerImage(
      id: id ?? this.id,
      urlImagem: urlImagem ?? this.urlImagem,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      description: description ?? this.description,
      isActive: isActive ?? this.isActive,
    );
  }
}
