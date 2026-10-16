import 'package:flutter/material.dart';

void main() => runApp(const GzApp());

// ───────────────────────── Theme colors ─────────────────────────
const kPrimary = Color(0xFF4A4FA3);
const kAccent = Color(0xFFFF5A5F);
const kOrange = Color(0xFFFFA726);
const kLime = Color(0xFFA6F42B);
const kBg = Color(0xFFF5F5F5);
const kCard = Color(0xFFEFEFEF);

// ───────────────────────── Data model ─────────────────────────
class Product {
  final int id;
  final String title;
  final String description;
  final String image; // asset path, e.g. assets/tablet.png
  final String price;
  final String category;
  final double rating;
  final bool onSale;
  final List<String> specs;

  const Product({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.price,
    required this.category,
    required this.rating,
    this.onSale = false,
    required this.specs,
  });
}

const List<Product> products = [
  Product(
    id: 1,
    title: 'XPpen Deco 01 V3',
    description:
    'Графический планшет для цифрового рисования: 8 горячих клавиш, '
        'перо без батареи и высокая точность линий.',
    image: 'assets/tablet1.png',
    price: '24 818.19 ₸',
    category: 'Планшеты',
    rating: 4.5,
    specs: ['XPpen', 'Китай', '5080 линий/дюйм', 'Евротест (CE), Ростест (EAC), FCC', '10" x 6"'],
  ),
  Product(
    id: 2,
    title: 'XP PEN DECO 1337 LAVA',
    description: 'Компактный планшет с micro-edge дизайном. В комплекте перо, кабель и краткое руководство.',
    image: 'assets/tablet2.png',
    price: '31 500.00 ₸',
    category: 'Планшеты',
    rating: 4.7,
    onSale: true,
    specs: ['XPpen', 'Китай', '5080 линий/дюйм', 'micro-edge', '10" x 6"'],
  ),
  Product(
    id: 3,
    title: 'Подставка для планшета',
    description: 'Регулируемая подставка с нескользящим покрытием. Подходит для планшетов 10–16 дюймов.',
    image: 'assets/holder.png',
    price: '6 990.00 ₸',
    category: 'Держатели',
    rating: 4.2,
    specs: ['XPpen', 'Китай', 'Регулируемый угол', 'Пластик + силикон'],
  ),
  Product(
    id: 4,
    title: 'Стилус PA2 Pro',
    description: 'Перо с 8192 уровнями нажима и функцией наклона. Работает без батарейки.',
    image: 'assets/stylus.png',
    price: '9 900.00 ₸',
    category: 'Стилусы',
    rating: 4.8,
    onSale: true,
    specs: ['XPpen', 'Китай', '8192 уровня нажима', 'Без батареи'],
  ),
];

// ───────────────────────── Favorites state ─────────────────────────
class FavoritesModel extends ChangeNotifier {
  final Set<int> _ids = {};

  bool isFav(int id) => _ids.contains(id);

  void toggle(int id) {
    _ids.contains(id) ? _ids.remove(id) : _ids.add(id);
    notifyListeners();
  }

  List<Product> get items => products.where((p) => _ids.contains(p.id)).toList();
}

final favorites = FavoritesModel();

// ───────────────────────── App ─────────────────────────
class GzApp extends StatelessWidget {
  const GzApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GZ',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: kPrimary),
        scaffoldBackgroundColor: kBg,
        useMaterial3: true,
      ),
      initialRoute: RegisterScreen.routeName,
      routes: {
        RegisterScreen.routeName: (_) => const RegisterScreen(),
        '/': (_) => const RootScreen(),
        CatalogScreen.routeName: (_) => const CatalogScreen(),
        DetailScreen.routeName: (_) => const DetailScreen(),
      },
    );
  }
}

class GzLogo extends StatelessWidget {
  const GzLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text.rich(
      TextSpan(children: [
        TextSpan(text: 'G', style: TextStyle(color: kPrimary)),
        TextSpan(text: 'Z', style: TextStyle(color: kAccent)),
      ]),
      style: TextStyle(fontSize: 34, fontWeight: FontWeight.w800),
    );
  }
}

/// Image from assets with a placeholder if the file is missing.
class ProductImage extends StatelessWidget {
  final String path;
  final BoxFit fit;
  const ProductImage(this.path, {super.key, this.fit = BoxFit.cover});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      path,
      fit: fit,
      width: double.infinity,
      errorBuilder: (_, __, ___) => Container(
        color: const Color(0xFF2B2B33),
        alignment: Alignment.center,
        child: const Icon(Icons.draw, color: Colors.white54, size: 48),
      ),
    );
  }
}

class Stars extends StatelessWidget {
  final double rating;
  final double size;
  const Stars(this.rating, {super.key, this.size = 16});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        final icon = rating >= i + 1
            ? Icons.star
            : (rating > i ? Icons.star_half : Icons.star_border);
        return Icon(icon, color: kOrange, size: size);
      }),
    );
  }
}

class SpecList extends StatelessWidget {
  final List<String> specs;
  final double fontSize;
  const SpecList(this.specs, {super.key, this.fontSize = 13});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: specs
          .map((s) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.diamond, size: 12, color: kPrimary),
            const SizedBox(width: 8),
            Expanded(child: Text(s, style: TextStyle(fontSize: fontSize, color: kPrimary))),
          ],
        ),
      ))
          .toList(),
    );
  }
}

// ───────────────────────── Root screen (BottomNavigationBar) ─────────────────────────
class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int _index = 0;

  void _goTo(int i) {
    Navigator.pop(context); // close drawer
    setState(() => _index = i);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu, color: kPrimary),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
        title: const GzLogo(),
        actions: [
          IconButton(icon: const Icon(Icons.search, color: kPrimary, size: 30), onPressed: () {}),
        ],
      ),
      drawer: Drawer(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(12),
            children: [
              const Padding(
                padding: EdgeInsets.all(12),
                child: Text('logo', style: TextStyle(fontSize: 32, color: kPrimary, fontWeight: FontWeight.w600)),
              ),
              ListTile(
                leading: const Icon(Icons.shopping_basket, color: kPrimary, size: 32),
                title: const Text('Корзина', style: TextStyle(color: kPrimary, fontSize: 18)),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.notifications, color: kPrimary, size: 32),
                title: const Text('Уведомления', style: TextStyle(color: kPrimary, fontSize: 18)),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.favorite, color: kPrimary, size: 32),
                title: const Text('Желаемое', style: TextStyle(color: kPrimary, fontSize: 18)),
                onTap: () => _goTo(1),
              ),
              ListTile(
                leading: const Icon(Icons.person, color: kPrimary, size: 32),
                title: const Text('Профиль', style: TextStyle(color: kPrimary, fontSize: 18)),
                onTap: () => _goTo(2),
              ),
            ],
          ),
        ),
      ),
      // IndexedStack keeps each tab's state alive when switching tabs
      body: IndexedStack(
        index: _index,
        children: const [FeedTab(), FavoritesTab(), ProfileTab()],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        selectedItemColor: kPrimary,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Главная'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Избранное'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Профиль'),
        ],
      ),
    );
  }
}

// ───────────────────────── Tab 1: Feed ─────────────────────────
class FeedTab extends StatelessWidget {
  const FeedTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        const SizedBox(height: 70),
        const Center(
          child: Text('Найди свой инструмент творчества',
              style: TextStyle(color: kPrimary, fontSize: 20)),
        ),
        const SizedBox(height: 14),
        const Center(
          child: Text('PALLET',
              style: TextStyle(color: Color(0xFF7A7A99), fontSize: 40, fontWeight: FontWeight.w300)),
        ),
        const SizedBox(height: 48),
        const _SearchBar(),
        const SizedBox(height: 70),
        const _Banner(),
        const Divider(height: 1, thickness: 1, color: Colors.black45),
        const SizedBox(height: 40),
        const _Categories(),
        const SizedBox(height: 40),
        // gray footer block from the design
        Container(height: 160, color: const Color(0xFFC4C4C4)),
      ],
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 42,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.black87),
        ),
        clipBehavior: Clip.antiAlias,
        child: Row(
          children: [
            const Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Поиск...',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 20),
                ),
              ),
            ),
            Container(
              width: 76,
              color: Colors.grey.shade400,
              alignment: Alignment.center,
              child: const Text('Найти'),
            ),
          ],
        ),
      ),
    );
  }
}

class _Banner extends StatelessWidget {
  const _Banner();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: Stack(
        children: [
          const Positioned(
            left: 14,
            top: 0,
            child: Text('XPpen Deco 01 V3',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700, color: Color(0xFF2B2B33))),
          ),
          Positioned(
            left: 14,
            top: 40,
            child: Row(
              children: const [
                Text.rich(TextSpan(children: [
                  TextSpan(text: '8 Efficient\n', style: TextStyle(color: kAccent)),
                  TextSpan(text: 'Shortcut Keys', style: TextStyle(color: kPrimary)),
                ]), style: TextStyle(fontWeight: FontWeight.w600)),
                SizedBox(width: 16),
                Text.rich(TextSpan(children: [
                  TextSpan(text: '12", '),
                  TextSpan(text: '5080\n', style: TextStyle(color: kAccent)),
                  TextSpan(text: 'lines/inch', style: TextStyle(color: kPrimary)),
                ]), style: TextStyle(fontWeight: FontWeight.w600, color: kPrimary)),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 90,
            height: 180,
            child: const ProductImage('assets/banner.png', fit: BoxFit.contain),
          ),
          const Positioned(
            right: 24,
            bottom: 50,
            child: Text.rich(
              TextSpan(children: [
                TextSpan(text: 'Create your\n', style: TextStyle(color: Color(0xFF2B2B33))),
                TextSpan(text: 'masterpiece', style: TextStyle(color: kAccent)),
              ]),
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 12,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                5,
                    (i) => Container(
                  width: 44,
                  height: 4,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  color: i == 3 ? Colors.grey.shade600 : Colors.grey.shade300,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Categories extends StatelessWidget {
  const _Categories();

  @override
  Widget build(BuildContext context) {
    // staggered layout like in Figma: left, right (lower), left (lower)
    return Column(
      children: const [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 30),
            child: _CategoryItem(label: 'Holders', image: 'assets/holder.png', category: 'Держатели'),
          ),
        ),
        SizedBox(height: 20),
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.only(right: 30),
            child: _CategoryItem(label: 'Stylus', image: 'assets/stylus.png', category: 'Стилусы'),
          ),
        ),
        SizedBox(height: 20),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 24),
            child: _CategoryItem(label: 'Tablets', image: 'assets/tablet1.png', category: 'Планшеты'),
          ),
        ),
      ],
    );
  }
}

class _CategoryItem extends StatelessWidget {
  final String label;
  final String image;
  final String category;
  const _CategoryItem({required this.label, required this.image, required this.category});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // open the catalog filtered by this category
      onTap: () => Navigator.pushNamed(context, CatalogScreen.routeName, arguments: category),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(width: 150, height: 130, child: ProductImage(image, fit: BoxFit.contain)),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

// ───────────────────────── Catalog (list of products) ─────────────────────────
class CatalogScreen extends StatelessWidget {
  static const routeName = '/catalog';
  const CatalogScreen({super.key});

  void _openFilters(BuildContext context) {
    Widget tile(String title, List<String> options) => ExpansionTile(
      tilePadding: EdgeInsets.zero,
      title: Text(title, style: const TextStyle(fontSize: 22, color: kPrimary)),
      children: options
          .map((o) => ListTile(dense: true, title: Text(o), onTap: () {}))
          .toList(),
    );

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            const Expanded(child: Text('fILTERS', style: TextStyle(color: kPrimary))),
            IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx)),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              tile('Brand', ['XPpen', 'Wacom', 'Huion']),
              tile('Type', ['Планшеты', 'Стилусы', 'Держатели']),
              tile('Screen size', ['10" x 6"', '12"', '16"']),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final category = ModalRoute.of(context)?.settings.arguments as String?;
    final items = category == null
        ? products
        : products.where((p) => p.category == category).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: kPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const GzLogo(),
        actions: [
          IconButton(icon: const Icon(Icons.search, color: kPrimary, size: 30), onPressed: () {}),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(height: 240, child: const ProductImage('assets/hero.png')),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: OutlinedButton(
                onPressed: () => _openFilters(context),
                style: OutlinedButton.styleFrom(
                  foregroundColor: kPrimary,
                  shape: const RoundedRectangleBorder(),
                  side: const BorderSide(color: kPrimary),
                ),
                child: const Text('fILTERS', style: TextStyle(fontSize: 18)),
              ),
            ),
          ),
          if (items.isEmpty)
            const Padding(
              padding: EdgeInsets.all(32),
              child: Center(child: Text('Здесь пока пусто', style: TextStyle(color: Colors.grey, fontSize: 18))),
            )
          else
            for (final p in items) ProductCard(product: p),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// ───────────────────────── Product card ─────────────────────────
class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        // Navigator.push by route name, passing the whole object as arguments
        onTap: () => Navigator.pushNamed(context, DetailScreen.routeName, arguments: product),
        child: Container(
          decoration: BoxDecoration(color: kCard, borderRadius: BorderRadius.circular(24)),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  AspectRatio(aspectRatio: 16 / 9, child: ProductImage(product.image)),
                  if (product.onSale)
                    Positioned(
                      left: 0,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
                        decoration: const BoxDecoration(
                          color: kOrange,
                          borderRadius: BorderRadius.only(bottomRight: Radius.circular(24)),
                        ),
                        child: const Text('Sale', style: TextStyle(color: Colors.white, fontSize: 20)),
                      ),
                    ),
                  Positioned(right: 8, top: 8, child: FavButton(product: product)),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product.title, style: const TextStyle(fontSize: 14)),
                    const SizedBox(height: 4),
                    Row(children: [
                      Stars(product.rating, size: 14),
                      const SizedBox(width: 6),
                      Text('${product.rating}/5', style: const TextStyle(fontSize: 12)),
                    ]),
                    const SizedBox(height: 6),
                    Text(product.price, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
                    const Divider(height: 24),
                    SpecList(product.specs.take(4).toList(), fontSize: 12),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FavButton extends StatelessWidget {
  final Product product;
  const FavButton({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: favorites,
      builder: (_, __) {
        final fav = favorites.isFav(product.id);
        return IconButton(
          icon: Icon(fav ? Icons.favorite : Icons.favorite_border,
              color: fav ? Colors.red : Colors.grey.shade700),
          onPressed: () => favorites.toggle(product.id),
        );
      },
    );
  }
}

// ───────────────────────── Tab 2: Favorites ─────────────────────────
class FavoritesTab extends StatelessWidget {
  const FavoritesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: favorites,
      builder: (_, __) {
        final items = favorites.items;
        if (items.isEmpty) {
          return const Center(
            child: Text('Пока ничего не сохранено', style: TextStyle(color: Colors.grey, fontSize: 18)),
          );
        }
        return ListView(children: [for (final p in items) ProductCard(product: p)]);
      },
    );
  }
}

// ───────────────────────── Tab 3: Profile ─────────────────────────
class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  bool _notifications = true;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<UserProfile?>(
      valueListenable: currentUser,
      builder: (context, user, _) {
        return ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const SizedBox(height: 12),
            const Center(
              child: CircleAvatar(
                radius: 48,
                backgroundColor: kPrimary,
                child: Icon(Icons.person, size: 56, color: Colors.white),
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: Text(user?.fullName ?? 'Гость',
                  style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
            ),
            if (user != null) ...[
              const SizedBox(height: 6),
              Center(child: Text(user.email, style: const TextStyle(fontSize: 16))),
              const SizedBox(height: 8),
              Center(
                child: Chip(
                  label: Text(user.role),
                  backgroundColor: kPrimary.withOpacity(0.12),
                  side: BorderSide.none,
                ),
              ),
            ],
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black87),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Phone Number', style: TextStyle(fontSize: 12)),
                  SizedBox(height: 4),
                  Text('Не указан', style: TextStyle(color: Colors.red, fontSize: 13)),
                ],
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(alignment: Alignment.centerLeft, foregroundColor: Colors.black),
              child: const Text('Изменить пароль',
                  style: TextStyle(decoration: TextDecoration.underline, fontWeight: FontWeight.bold)),
            ),
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(alignment: Alignment.centerLeft, foregroundColor: Colors.black),
              child: const Text('Удалить аккаунт',
                  style: TextStyle(decoration: TextDecoration.underline, fontWeight: FontWeight.bold)),
            ),
            SwitchListTile(
              title: const Text('Уведомления'),
              value: _notifications,
              activeColor: kPrimary,
              onChanged: (v) => setState(() => _notifications = v),
            ),
            const Divider(height: 32),
            const Center(child: Text('История покупок', style: TextStyle(fontSize: 20))),
            const SizedBox(height: 16),
            const Icon(Icons.inventory_2, size: 96, color: Colors.black45),
            const Center(child: Text('У вас пусто.', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold))),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: () {
                currentUser.value = null;
                Navigator.pushReplacementNamed(context, RegisterScreen.routeName);
              },
              icon: const Icon(Icons.logout),
              label: const Text('Выйти из аккаунта'),
              style: OutlinedButton.styleFrom(foregroundColor: kPrimary),
            ),
          ],
        );
      },
    );
  }
}

// ───────────────────────── Detail screen ─────────────────────────
class DetailScreen extends StatelessWidget {
  static const routeName = '/detail';
  const DetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Receive the full Product object passed via Navigator.pushNamed(arguments: ...)
    final product = ModalRoute.of(context)!.settings.arguments as Product;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: kPrimary),
          onPressed: () => Navigator.pop(context), // AppBar back button
        ),
        title: const GzLogo(),
        actions: [
          IconButton(icon: const Icon(Icons.search, color: kPrimary, size: 30), onPressed: () {}),
        ],
      ),
      body: ListView(
        children: [
          Container(
            color: kCard,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Text('Главная / ...... / ${product.category} / ${product.title}',
                style: const TextStyle(fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
          Stack(
            children: [
              AspectRatio(aspectRatio: 4 / 3, child: ProductImage(product.image)),
              Positioned(right: 8, top: 8, child: FavButton(product: product)),
              if (product.onSale)
                Positioned(
                  left: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
                    decoration: const BoxDecoration(
                      color: kOrange,
                      borderRadius: BorderRadius.only(bottomRight: Radius.circular(24)),
                    ),
                    child: const Text('Sale', style: TextStyle(color: Colors.white, fontSize: 20)),
                  ),
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.title.toUpperCase(),
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                Row(children: [
                  Stars(product.rating, size: 24),
                  const SizedBox(width: 10),
                  Text('${product.rating}/5', style: const TextStyle(fontSize: 18)),
                ]),
                const SizedBox(height: 6),
                const Text.rich(TextSpan(children: [
                  TextSpan(text: '4 669 отзывов', style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: '; '),
                  TextSpan(text: '15 636 купили', style: TextStyle(fontWeight: FontWeight.bold)),
                ]), style: TextStyle(color: Colors.blue, fontSize: 16)),
                const SizedBox(height: 6),
                Text('Категория: ${product.category}', style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 14),
                Text(product.description, style: const TextStyle(fontSize: 15)),
                const SizedBox(height: 14),
                SpecList(product.specs, fontSize: 16),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: kCard, borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(product.price, style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w800)),
                      const SizedBox(height: 4),
                      const Text('Цена за 1 штуку'),
                      const SizedBox(height: 12),
                      Row(children: [
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(backgroundColor: kLime, foregroundColor: Colors.black),
                          child: const Text('Купить сейчас'),
                        ),
                        const SizedBox(width: 14),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(backgroundColor: kOrange, foregroundColor: Colors.black),
                          child: const Text('В корзину'),
                        ),
                      ]),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // In-body back button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Назад'),
                    style: OutlinedButton.styleFrom(foregroundColor: kPrimary),
                  ),
                ),
                const SizedBox(height: 24),
                const Text('Похожие объявления', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                SizedBox(
                  height: 230,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      for (final p in products.where((p) => p.id != product.id))
                        _SimilarCard(product: p),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SimilarCard extends StatelessWidget {
  final Product product;
  const _SimilarCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // push another detail screen with different arguments
      onTap: () => Navigator.pushNamed(context, DetailScreen.routeName, arguments: product),
      child: Container(
        width: 170,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(color: kCard, borderRadius: BorderRadius.circular(18)),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 110, child: ProductImage(product.image)),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.title, style: const TextStyle(fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
                  Stars(product.rating, size: 12),
                  const SizedBox(height: 4),
                  Text(product.price, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ───────────────────────── Registration ─────────────────────────
class UserProfile {
  final String firstName;
  final String lastName;
  final String email;
  final String role;

  const UserProfile({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.role,
  });

  String get fullName => '$firstName $lastName';
}

/// The registered user (null = nobody signed in yet)
final ValueNotifier<UserProfile?> currentUser = ValueNotifier(null);

class RegisterScreen extends StatefulWidget {
  static const routeName = '/register';
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  static const _roles = ['Student', 'Teacher', 'Developer', 'Artist'];
  String _role = _roles.first;
  bool _marketing = false; // optional checkbox from the design
  bool _hidePass = true;
  bool _hideConfirm = true;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _lastNameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  // ── Validators ──
  String? _validateName(String? v) =>
      (v == null || v.trim().isEmpty) ? 'Write your name *' : null;

  String? _validateLastName(String? v) =>
      (v == null || v.trim().isEmpty) ? 'Write your last name *' : null;

  String? _validateEmail(String? v) {
    final value = v?.trim() ?? '';
    if (value.isEmpty) return 'Email is required *';
    if (!value.contains('@') || !value.contains('.')) {
      return 'Email must contain @ and . (e.g. name@narxoz.kz)';
    }
    return null;
  }

  String? _validatePassword(String? v) {
    if (v == null || v.isEmpty) return 'Password is required *';
    if (v.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  String? _validateConfirm(String? v) {
    if (v == null || v.isEmpty) return 'Confirm your password *';
    if (v != _passCtrl.text) return 'Passwords do not match';
    return null;
  }

  // ── Submit ──
  void _submit() {
    // validate() runs every validator and shows the error text under each invalid field
    if (!_formKey.currentState!.validate()) return;

    final user = UserProfile(
      firstName: _nameCtrl.text.trim(),
      lastName: _lastNameCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      role: _role,
    );

    // Print the form data in the terminal (password is masked on purpose)
    debugPrint('──── Registration data ────');
    debugPrint('Name:       ${user.firstName}');
    debugPrint('Last name:  ${user.lastName}');
    debugPrint('Email:      ${user.email}');
    debugPrint('Password:   ${'*' * _passCtrl.text.length}');
    debugPrint('Role:       ${user.role}');
    debugPrint('Terms:      accepted');
    debugPrint('Marketing:  $_marketing');

    currentUser.value = user;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green.shade700,
        content: Text('Account created! Welcome, ${user.firstName}'),
      ),
    );

    // Go to the main app and remove the registration screen from the stack
    Navigator.pushReplacementNamed(context, '/');
  }

  InputDecoration _decoration(String label, {Widget? suffix}) {
    OutlineInputBorder border(Color c, [double w = 1]) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: c, width: w),
    );
    return InputDecoration(
      labelText: label,
      suffixIcon: suffix,
      border: border(Colors.black87),
      enabledBorder: border(Colors.black87),
      focusedBorder: border(kPrimary, 2),
      errorBorder: border(Colors.red),
      focusedErrorBorder: border(Colors.red, 2),
      errorStyle: const TextStyle(color: Colors.red),
      errorMaxLines: 2,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDDDDDD),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(36),
                ),
                child: Form(
                  key: _formKey,
                  // real-time validation: errors appear as soon as the user edits a field
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const GzLogo(),
                      const SizedBox(height: 20),
                      const Text('Create an account',
                          style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 24),

                      // Name + Last name
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _nameCtrl,
                              textInputAction: TextInputAction.next,
                              decoration: _decoration('Name*'),
                              validator: _validateName,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: _lastNameCtrl,
                              textInputAction: TextInputAction.next,
                              decoration: _decoration('Last name*'),
                              validator: _validateLastName,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Email
                      TextFormField(
                        controller: _emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        decoration: _decoration('Email address *'),
                        validator: _validateEmail,
                      ),
                      const SizedBox(height: 16),

                      // Password
                      TextFormField(
                        controller: _passCtrl,
                        obscureText: _hidePass,
                        textInputAction: TextInputAction.next,
                        decoration: _decoration(
                          'Password *',
                          suffix: IconButton(
                            icon: Icon(_hidePass ? Icons.visibility_off : Icons.visibility),
                            onPressed: () => setState(() => _hidePass = !_hidePass),
                          ),
                        ),
                        validator: _validatePassword,
                      ),
                      const SizedBox(height: 16),

                      // Confirm password
                      TextFormField(
                        controller: _confirmCtrl,
                        obscureText: _hideConfirm,
                        textInputAction: TextInputAction.done,
                        decoration: _decoration(
                          'Confirm password *',
                          suffix: IconButton(
                            icon: Icon(_hideConfirm ? Icons.visibility_off : Icons.visibility),
                            onPressed: () => setState(() => _hideConfirm = !_hideConfirm),
                          ),
                        ),
                        validator: _validateConfirm,
                      ),
                      const SizedBox(height: 16),

                      // Role dropdown
                      DropdownButtonFormField<String>(
                        value: _role,
                        decoration: _decoration('Role'),
                        items: _roles
                            .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                            .toList(),
                        onChanged: (v) => setState(() => _role = v ?? _role),
                        validator: (v) => v == null ? 'Select a role' : null,
                      ),
                      const SizedBox(height: 12),

                      // Terms checkbox (required) - FormField so its error is shown under it
                      FormField<bool>(
                        initialValue: false,
                        validator: (v) =>
                        v == true ? null : 'You must accept the Terms and Conditions',
                        builder: (state) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                  value: state.value,
                                  activeColor: const Color(0xFF0033CC),
                                  onChanged: (v) => state.didChange(v),
                                ),
                                const Expanded(
                                  child: Text('I accept the Terms and Conditions'),
                                ),
                              ],
                            ),
                            if (state.hasError)
                              Padding(
                                padding: const EdgeInsets.only(left: 12),
                                child: Text(state.errorText!,
                                    style: const TextStyle(color: Colors.red, fontSize: 12)),
                              ),
                          ],
                        ),
                      ),

                      // Optional marketing checkbox from the design
                      Row(
                        children: [
                          Checkbox(
                            value: _marketing,
                            activeColor: const Color(0xFF0033CC),
                            onChanged: (v) => setState(() => _marketing = v ?? false),
                          ),
                          const Expanded(
                            child: Text('“GZ” may send me personalized offers, support news, and events via email.'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      const Text.rich(
                        TextSpan(children: [
                          TextSpan(text: 'Your “GZ” account information is used in accordance with '),
                          TextSpan(text: 'the Privacy Statement', style: TextStyle(color: Color(0xFF0033CC))),
                        ]),
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 20),

                      Center(
                        child: SizedBox(
                          width: 240,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kPrimary,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            child: const Text('Create', style: TextStyle(fontSize: 18)),
                          ),
                        ),
                      ),
                      Center(
                        child: TextButton(
                          onPressed: () => Navigator.pushReplacementNamed(context, '/'),
                          child: const Text('Продолжить как гость'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}