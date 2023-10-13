import 'package:get/get.dart';
import 'package:store_app/users/model/cart.dart';

class CartListController extends GetxController {
  RxList<Cart> _cartList = <Cart>[].obs; //user all items in cart + record //5
  RxList<int> _selectedItemList = <int>[]
      .obs; //user selected items for which user want to proceed and want to place final order //2
  RxBool _isSelectedAll = false.obs;
  RxDouble _total = 0.0.obs;

  List<Cart> get cartList => _cartList.value;
  List<int> get selectedItemList => _selectedItemList.value;
  bool get isSelectedAll => _isSelectedAll.value;
  double get total => _total.value; //12

  setList(List<Cart> list) {
    _cartList.value = list;
  }

  addSelectedItem(int selectedItemCartID) {
    _selectedItemList.value.add(selectedItemCartID);
    update();
  }

  deleteSelectedItem(int selectedItemCartID) {
    _selectedItemList.value.remove(selectedItemCartID);
    update();
  }

  setIsSelectedAllItems() {
    _isSelectedAll.value = !_isSelectedAll.value;
  }

  clearAllSelectedItems() {
    _selectedItemList.value.clear();
    update();
  }

  setTotal(double overallTotal) {
    _total.value = overallTotal;
  }
}
