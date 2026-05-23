class Medication {
  final String id;
  final String name;
  final String dosage;
  final TimeOfDay time;
  final bool isTaken;

  Medication({
    required this.id,
    required this.name,
    required this.dosage,
    required this.time,
    this.isTaken = false,
  });

  Medication copyWith({
    String? id,
    String? name,
    String? dosage,
    TimeOfDay? time,
    bool? isTaken,
  }) {
    return Medication(
      id: id ?? this.id,
      name: name ?? this.name,
      dosage: dosage ?? this.dosage,
      time: time ?? this.time,
      isTaken: isTaken ?? this.isTaken,
    );
  }
}
