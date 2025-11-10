import 'package:flutter/material.dart';
import 'package:recallist/core/data/repositories/item_repository.dart';
import 'package:recallist/core/models/item.dart';
import 'package:recallist/core/service_locator.dart';
import 'package:recallist/core/services/notification_service.dart';
import 'package:recallist/features/items/add_item/add_item_button.dart';
import 'package:recallist/features/items/dashboard/dashboard_utils.dart';
import 'package:recallist/features/items/dashboard/tab_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await initServiceLocator();
    // Initialize notification service
    await sl<NotificationService>().initialize();
  } catch (ex) {
    debugPrint(ex.toString());
  }

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

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  List<Item> _items = [];
  bool _isLoading = true;
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadItems();
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
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
      // Reschedule notifications when items are updated
      sl<NotificationService>().rescheduleNotifications();
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
    final todayItems = getTodayItems(_items);
    final tomorrowItems = getTomorrowItems(_items);
    final upcomingItems = getUpcomingItems(_items);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text(
          'Dashboard',
          style: TextStyle(color: Color.fromARGB(255, 41, 22, 46)),
        ),
        centerTitle: true,
        bottom: _isLoading || _items.isEmpty || _tabController == null
            ? null
            : TabBar(
                controller: _tabController!,
                labelColor: Theme.of(context).colorScheme.onSurface,
                unselectedLabelColor: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.6),
                indicatorColor: Theme.of(context).colorScheme.primary,
                tabs: [
                  _TabLabel(
                    label: 'Today',
                    count: todayItems.length,
                    tabIndex: 0,
                    controller: _tabController!,
                  ),
                  _TabLabel(
                    label: 'Tomorrow',
                    count: tomorrowItems.length,
                    tabIndex: 1,
                    controller: _tabController!,
                  ),
                  _TabLabel(
                    label: 'Upcoming',
                    count: upcomingItems.length,
                    tabIndex: 2,
                    controller: _tabController!,
                  ),
                ],
              ),
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
          : _tabController == null
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController!,
              children: [
                ItemsTabView(
                  items: todayItems,
                  onItemUpdated: _loadItems,
                  emptyMessage: 'Nothing scheduled today 🎉',
                ),
                ItemsTabView(
                  items: tomorrowItems,
                  onItemUpdated: _loadItems,
                  emptyMessage: 'Nothing scheduled tomorrow 🎉',
                ),
                ItemsTabView(
                  items: upcomingItems,
                  onItemUpdated: _loadItems,
                  emptyMessage: 'Nothing upcoming 🎉',
                ),
              ],
            ),
      floatingActionButton: AddItemButton(onItemAdded: _loadItems),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class _TabLabel extends StatefulWidget {
  const _TabLabel({
    required this.label,
    required this.count,
    required this.tabIndex,
    required this.controller,
  });

  final String label;
  final int count;
  final int tabIndex;
  final TabController controller;

  @override
  State<_TabLabel> createState() => _TabLabelState();
}

class _TabLabelState extends State<_TabLabel> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTabChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTabChanged);
    super.dispose();
  }

  void _onTabChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isActive = widget.controller.index == widget.tabIndex;

    // Color scheme based on tab type
    Color activeColor;
    if (widget.tabIndex == 0) {
      // Today - deep purple (primary)
      activeColor = theme.colorScheme.primary;
    } else if (widget.tabIndex == 1) {
      // Tomorrow - soft accent (primary with reduced opacity for softer look)
      activeColor = theme.colorScheme.primary.withValues(alpha: 0.8);
    } else {
      // Upcoming - neutral gray
      activeColor = theme.colorScheme.onSurface.withValues(alpha: 0.7);
    }

    final textColor = isActive
        ? activeColor
        : theme.colorScheme.onSurface.withValues(alpha: 0.6);

    return Tab(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.label,
            style: TextStyle(
              color: textColor,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          if (widget.count > 0) ...[
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: isActive
                    ? activeColor.withValues(alpha: 0.2)
                    : theme.colorScheme.onSurface.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                widget.count.toString(),
                style: TextStyle(
                  color: textColor,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
