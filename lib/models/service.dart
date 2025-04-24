class BarberService {
  final String id;
  final String nameKey; // Localization key for name
  final double price;
  final int durationMinutes;
  final String iconName;
  bool isSelected;

  BarberService({
    required this.id,
    required this.nameKey,
    required this.price,
    required this.durationMinutes,
    required this.iconName,
    this.isSelected = false,
  });

  BarberService copyWith({bool? isSelected}) {
    return BarberService(
      id: id,
      nameKey: nameKey,
      price: price,
      durationMinutes: durationMinutes,
      iconName: iconName,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nameKey': nameKey,
      'price': price,
      'durationMinutes': durationMinutes,
      'iconName': iconName,
      'isSelected': isSelected,
    };
  }

  factory BarberService.fromJson(Map<String, dynamic> json) {
    return BarberService(
      id: json['id'],
      nameKey: json['nameKey'],
      price: json['price'].toDouble(),
      durationMinutes: json['durationMinutes'],
      iconName: json['iconName'],
      isSelected: json['isSelected'] ?? false,
    );
  }

  static List<BarberService> getServices() {
    return [
      BarberService(
        id: '1',
        nameKey: 'haircut',
        price: 25.0,
        durationMinutes: 30,
        iconName: 'content_cut',
      ),
      BarberService(
        id: '2',
        nameKey: 'beard_trim',
        price: 15.0,
        durationMinutes: 15,
        iconName: 'face',
      ),
      BarberService(
        id: '3',
        nameKey: 'blow_dry',
        price: 10.0,
        durationMinutes: 15,
        iconName: 'air',
      ),
      BarberService(
        id: '4',
        nameKey: 'hair_coloring',
        price: 45.0,
        durationMinutes: 60,
        iconName: 'color_lens',
      ),
      BarberService(
        id: '5',
        nameKey: 'shaving',
        price: 20.0,
        durationMinutes: 20,
        iconName: 'clean_hands',
      ),
      BarberService(
        id: '6',
        nameKey: 'face_treatment',
        price: 35.0,
        durationMinutes: 45,
        iconName: 'spa',
      ),
      BarberService(
        id: '7',
        nameKey: 'children_haircut',
        price: 18.0,
        durationMinutes: 25,
        iconName: 'child_care',
      ),
    ];
  }
}
