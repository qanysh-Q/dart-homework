import 'package:flutter/material.dart';
import 'product_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, String>> products = const [
    {
      'name': 'Nike Air Max 270',
      'price': '75 000 ₸',
      'image': 'assets/images/shoe1.jpeg',
      'description': 'Инновационная амортизирующая вставка Air Max обеспечивает непревзойденный комфорт на весь день. Идеально подходят для активной городской жизни.',
    },
    {
      'name': 'Nike Air Force 1',
      'price': '60 000 ₸',
      'image': 'assets/images/shoe2.jpg',
      'description': 'Легендарная классика в уличном стиле. Прочный кожаный верх и мягкая подошва делают эту пару универсальным выбором для любого гардероба.',
    },
    {
      'name': 'Nike ZoomX Vaporfly',
      'price': '105 000 ₸',
      'image': 'assets/images/shoe3.jpeg',
      'description': 'Профессиональные беговые кроссовки с карбоновой пластиной. Максимальный возврат энергии для новых личных рекордов.',
    },
    {
      'name': 'Nike Revolution 6',
      'price': '45 000 ₸',
      'image': 'assets/images/shoe4.jpg',
      'description': 'Легкие и дышащие кроссовки из экологичных материалов. Отличный вариант для ежедневных тренировок и пеших прогулок.',
    },
  ];

  final List<Map<String, String>> cart = [];

  void addToCart(Map<String, String> product) {
    setState(() {
      cart.add(product);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product['name']} добавлен в корзину!'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void showCartModal() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Ваша корзина',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const Divider(),
                  cart.isEmpty
                      ? const Expanded(
                          child: Center(
                            child: Text(
                              'Корзина пуста',
                              style: TextStyle(fontSize: 18, color: Colors.grey),
                            ),
                          ),
                        )
                      : Expanded(
                          child: ListView.builder(
                            itemCount: cart.length,
                            itemBuilder: (context, index) {
                              final item = cart[index];
                              return ListTile(
                                leading: Image.asset(item['image']!, width: 50, fit: BoxFit.cover),
                                title: Text(item['name']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                                subtitle: Text(item['price']!, style: const TextStyle(color: Colors.redAccent)),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    setState(() {
                                      cart.removeAt(index);
                                    });
                                    setModalState(() {});
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                  if (cart.isNotEmpty)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Заказ успешно оформлен!')),
                        );
                        setState(() {
                          cart.clear();
                        });
                      },
                      child: const Text('Оформить заказ', style: TextStyle(color: Colors.white, fontSize: 18)),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Sneaker Store',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart, color: Colors.black),
                onPressed: showCartModal,
              ),
              if (cart.isNotEmpty)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${cart.length}',
                      style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Trending Now',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.75,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final item = products[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailScreen(
                            name: item['name']!,
                            price: item['price']!,
                            imagePath: item['image']!,
                            description: item['description']!,
                            onAddToCart: () => addToCart(item),
                          ),
                        ),
                      );
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                              child: Image.asset(
                                item['image']!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['name']!,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      item['price']!,
                                      style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
                                    ),
                                    const Icon(Icons.star, color: Colors.orange, size: 16),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
