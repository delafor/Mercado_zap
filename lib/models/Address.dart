class Address {
  final String name;
  final String nameRua;
  final String numberCasa;
  final String complemento;
  final String numberTel;
  final String bairro;

  Address({
    required this.name,
    required this.nameRua,
    required this.numberCasa,
    required this.complemento,
    required this.numberTel,
    required this.bairro,
  });

  // Construtor a partir de Map
  factory Address.fromMap(Map<String, dynamic> map) {
    return Address(
      name: map['name'] ?? '',
      nameRua: map['nameRua'] ?? '',
      numberCasa: map['numberCasa'] ?? '',
      complemento: map['complemento'] ?? '',
      numberTel: map['numberTel'] ?? '',
      bairro: map['bairro'] ?? '',
    );
  }

  // Converte para Map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'nameRua': nameRua,
      'numberCasa': numberCasa,
      'complemento': complemento,
      'numberTel': numberTel,
      'bairro': bairro,
    };
  }
}
