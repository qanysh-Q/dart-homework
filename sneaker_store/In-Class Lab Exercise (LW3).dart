class Book {
  String title;
  String author;
  double price;
  bool isBorrowed;

  Book(this.title, this.author, this.price, [this.isBorrowed = false]);

  @override
  String toString() {
    return 'Book: $title | Author: $author | Price: \$$price';
  }
}

class Library {
  final List<Book> _books = [];

  void addBook(Book book) {
    _books.add(book);
  }

  List<Book> getAvailableBooks() => 
      _books.where((b) => !b.isBorrowed).toList();

  double getTotalValue() => 
      _books.fold(0.0, (currentTotal, b) => currentTotal + b.price);
}

void main() {
  var localLibrary = Library();

  localLibrary.addBook(Book('The Great Gatsby', 'F. Scott Fitzgerald', 12.50));
  localLibrary.addBook(Book('Sapiens', 'Yuval Noah Harari', 22.90, true));
  localLibrary.addBook(Book('To Kill a Mockingbird', 'Harper Lee', 14.20));
  localLibrary.addBook(Book('The Catcher in the Rye', 'J.D. Salinger', 11.00, true));

  print('*** BOOKS CURRENTLY IN STOCK ***');
  var inStock = localLibrary.getAvailableBooks();
  
  inStock.forEach((b) => print(b.toString()));

  print('\n*** INVENTORY VALUE ***');
  print('Total value of all books: \$${localLibrary.getTotalValue()}');
}