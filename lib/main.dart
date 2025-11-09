import 'package:flutter/material.dart';
import 'package:recallist/core/data/repositories/item_repository.dart';
import 'package:recallist/core/models/item.dart';
import 'package:recallist/core/service_locator.dart';
import 'package:recallist/features/items/add_item/add_item_button.dart';
import 'package:recallist/features/items/dashboard/item_card.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initServiceLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recallist',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Item> _items = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final items = await sl<ItemRepository>().getAllItems();
      setState(() {
        _items = items;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error loading items: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text(
          'Dashboard',
          style: TextStyle(color: Color.fromARGB(255, 41, 22, 46)),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _items.isEmpty
          ? const Center(
              child: Text(
                'No items yet.\nTap the + button to add your first item!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : RefreshIndicator(
              onRefresh: _loadItems,
              child: ListView.builder(
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  return ItemCard(
                    item: _items[index],
                    onItemUpdated: _loadItems,
                  );
                },
              ),
            ),
      floatingActionButton: AddItemButton(onItemAdded: _loadItems),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
