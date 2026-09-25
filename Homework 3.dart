// 1. Abstract Class MediaItem
abstract class MediaItem {
  String id;
  String title;
  double price;

  MediaItem(this.id, this.title, this.price);

  String getDetails();
}

// 3. Mixin Downloadable
mixin Downloadable {
  void download(String title) {
    print('>> Initiating download for: $title...');
  }
}

// 2. Subclass Audiobook
class Audiobook extends MediaItem with Downloadable {
  double durationHours;
  String narrator;

  Audiobook(super.id, super.title, super.price, this.durationHours, this.narrator);

  @override
  String getDetails() {
    return '[Audiobook] $title (ID: $id) - Narrator: $narrator, Time: ${durationHours}h, Cost: \$$price';
  }
}

// 2. Subclass EBook
class EBook extends MediaItem with Downloadable {
  double fileSizeMB;
  String author;

  EBook(super.id, super.title, super.price, this.fileSizeMB, this.author);

  @override
  String getDetails() {
    return '[EBook] $title (ID: $id) - By: $author, Size: ${fileSizeMB}MB, Cost: \$$price';
  }
}

// 4. Class ShoppingCart
class ShoppingCart {
  final List<MediaItem> _items = [];

  void addItem(MediaItem item) => _items.add(item);

  double calculateTotalWithTax({double taxRate = 0.12}) {
    var rawSum = _items.fold(0.0, (acc, item) => acc + item.price);
    return rawSum * (1 + taxRate);
  }

  List<MediaItem> filterByMaxPrice(double maxPrice) => 
      _items.where((element) => element.price <= maxPrice).toList();

  void printReceipt() {
    print('--- YOUR DIGITAL RECEIPT ---');
    
    for (int i = 0; i < _items.length; i++) {
      var currentItem = _items[i];
      print('${i + 1}. ${currentItem.getDetails()}');
      
      if (currentItem is Downloadable) {
        (currentItem as Downloadable).download(currentItem.title);
      }
      print(''); 
    }
    
    print('----------------------------');
    print('FINAL TOTAL (incl. tax): \$${calculateTotalWithTax().toStringAsFixed(2)}');
    print('----------------------------');
  }
}

void main() {
  var myCart = ShoppingCart();

  var book1 = EBook('EB101', 'Mastering Flutter', 19.99, 15.5, 'John Doe');
  var book2 = EBook('EB102', 'Dart in Action', 12.50, 4.2, 'Jane Smith');
  var audio1 = Audiobook('AB201', 'The Pragmatic Programmer', 24.00, 8.5, 'Andrew Hunt');

  myCart.addItem(book1);
  myCart.addItem(book2);
  myCart.addItem(audio1);

  print('--- FILTERED SEARCH (Max \$15) ---');
  var affordableItems = myCart.filterByMaxPrice(15.0);
  affordableItems.forEach((item) => print('- ${item.title}'));
  print('\n'); 

  myCart.printReceipt();
}