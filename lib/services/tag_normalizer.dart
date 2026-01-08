String normalizeTag(String tag) {
  final t = tag.toLowerCase().trim();

  if (['person', 'people', 'human'].contains(t)) return 'person';
  if (['car', 'vehicle', 'automobile'].contains(t)) return 'car';
  if (['tree', 'plant'].contains(t)) return 'tree';
  if (['food', 'meal', 'dish'].contains(t)) return 'food';

  return t;
}