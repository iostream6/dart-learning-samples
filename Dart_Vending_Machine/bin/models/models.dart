/**
 * Author: Ilamah, Osho
 * 
 * 2020.11.29  - Created
 */

class Item{
  String name;
  double price;
  String id;
  String category;
  int inventoryQuantity;
  String slot;

  Item(this.slot, this.name, this.price, this.category);

  @override
  String toString(){
    return inventoryQuantity == 0 ? ' $slot | $name | \$$price a piece | SOLD OUT' : ' $slot | $name | \$$price a piece';
  }
}