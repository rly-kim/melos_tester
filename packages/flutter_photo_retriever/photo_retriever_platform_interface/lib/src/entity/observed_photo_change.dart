typedef LocalIdentifier = String;

class ObservedPhotoChange {
  final List<LocalIdentifier> changed;
  final List<LocalIdentifier> removed;
  final List<LocalIdentifier> inserted;

  ObservedPhotoChange({
    required this.changed,
    required this.removed,
    required this.inserted,
  });

  factory ObservedPhotoChange.fromJson(Map<String, dynamic> json) {
    return ObservedPhotoChange(
      changed: json["changed"] ?? [],
      removed: json["removed"] ?? [],
      inserted: json["inserted"] ?? [],
    );
  }
}
