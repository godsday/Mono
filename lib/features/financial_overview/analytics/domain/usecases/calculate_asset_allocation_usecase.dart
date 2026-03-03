import '../../../asset/domain/entities/asset_entity.dart';

class CalculateAssetAllocationUseCase {
  Map<String, double> call(List<AssetEntity> assets) {
    Map<String, double> allocations = {};
    for (var asset in assets) {
      // Exclude liabilities
      if (asset.type.toLowerCase() == 'liability' ||
          asset.type.toLowerCase() == 'debt') {
        continue;
      }
      allocations[asset.type] =
          (allocations[asset.type] ?? 0) + asset.currentValue;
    }

    // Sort by value descending
    var sortedEntries = allocations.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // Limit to top 5 categories, group others
    if (sortedEntries.length > 5) {
      var top5 = sortedEntries.sublist(0, 4);
      var others = sortedEntries.sublist(4);
      double othersValue = others.fold(0, (sum, item) => sum + item.value);

      Map<String, double> result = Map.fromEntries(top5);
      result['Others'] = othersValue;
      return result;
    }

    return Map.fromEntries(sortedEntries);
  }
}
