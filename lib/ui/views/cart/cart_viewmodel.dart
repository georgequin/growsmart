import 'package:stacked/stacked.dart';

class CartViewModel extends BaseViewModel {
  List<int> itemsToDelete = [];

  void addRemoveDelete(int index) {
    itemsToDelete.contains(index)
        ? itemsToDelete.remove(index)
        : itemsToDelete.add(index);
    rebuildUi();
  }
}
