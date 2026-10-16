import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Apple Store',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.black,
        scaffoldBackgroundColor: const Color(0xFFF5F5F7),
      ),
      home: const MainScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Product {
  final String title;
  final String description;
  final String imagePath;
  final String price;

  Product({
    required this.title,
    required this.description,
    required this.imagePath,
    required this.price,
  });
}

final List<Product> appleProducts = [
  Product(
    title: 'iPhone',
    description: 'Идеальный смартфон с невероятной камерой и мощным процессором.',
    imagePath: 'assets/iphone.png',
    price: '\$999',
  ),
  Product(
    title: 'MacBook Air',
    description: 'Супертонкий, легкий и невероятно быстрый благодаря новому чипу.',
    imagePath: 'assets/macbook.jpg',
    price: '\$1199',
  ),
  Product(
    title: 'iPad Pro',
    description: 'Твой следующий компьютер — это не компьютер. Невероятный дисплей и мощь.',
    imagePath: 'assets/ipad.png',
    price: '\$799',
  ),
  Product(
    title: 'Apple Watch',
    description: 'Будущее здоровья на твоем запястье. Идеальный компаньон на каждый день.',
    imagePath: 'assets/watch.jpg',
    price: '\$399',
  ),
  Product(
    title: 'AirPods',
    description: 'Магия звука. Активное шумоподавление и пространственное аудио.',
    imagePath: 'assets/airpods.jpg',
    price: '\$249',
  ),
];

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const FeedScreen(),
    const FavoritesScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.storefront_outlined),
            selectedIcon: Icon(Icons.storefront),
            label: 'Store',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_outline),
            selectedIcon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar.large(
            title: Text('Apple Store', style: TextStyle(fontWeight: FontWeight.bold)),
            backgroundColor: Color(0xFFF5F5F7),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final product = appleProducts[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailScreen(product: product),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 200,
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                            ),
                            child: Hero(
                              tag: product.title,
                              child: Image.asset(product.imagePath, fit: BoxFit.contain),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  product.title,
                                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  product.price,
                                  style: const TextStyle(fontSize: 18, color: Colors.black54),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                childCount: appleProducts.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favorites'), backgroundColor: const Color(0xFFF5F5F7)),
      body: const Center(
        child: Text('Здесь будут сохраненные товары', style: TextStyle(fontSize: 18)),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile'), backgroundColor: const Color(0xFFF5F5F7)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black12, width: 2),
              ),
              child: const CircleAvatar(
                radius: 60,
                backgroundColor: Colors.black12,
                child: Icon(Icons.person, size: 60, color: Colors.black54),
              ),
            ),
            const SizedBox(height: 24),
            const Text('Qanysh Yergesh', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('kanysh.ergesh@narxoz.kz', style: TextStyle(fontSize: 16, color: Colors.black54)),
          ],
        ),
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  final Product product;

  const DetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(24.0),
                children: [
                  Hero(
                    tag: product.title,
                    child: Image.asset(product.imagePath, height: 300, fit: BoxFit.contain),
                  ),
                  const SizedBox(height: 40),
                  Text(
                    product.title,
                    style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, letterSpacing: -1),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    product.price,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.black87),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    product.description,
                    style: const TextStyle(fontSize: 18, color: Colors.black54, height: 1.5),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Color(0xFFF5F5F7),
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text('Вернуться назад', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
