import 'package:flutter/material.dart';
import '../model/category.dart';
import '../service/api_service.dart';
import '../widgets/category_card.dart';
import 'category_screen.dart';
import 'meal_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService api = ApiService();
  List<Category> categories = [];
  List<Category> filtered = [];
  bool loading = true;
  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() async {
    final cats = await api.fetchCategories();
    setState(() {
      categories = cats;
      filtered = cats;
      loading = false;
    });
  }

  void _onSearch(String q) {
    setState(() {
      filtered = categories
          .where((c) => c.name.toLowerCase().contains(q.toLowerCase()))
          .toList();
    });
  }

  void _openCategory(String name) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CategoryScreen(category: name)),
    );
  }

  void _openRandom() async {
    final meal = await api.randomMeal();
    if (meal != null)
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => MealDetailScreen(mealId: meal.id)),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categories'),
        actions: [
          IconButton(icon: Icon(Icons.shuffle), onPressed: _openRandom),
        ],
      ),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextField(
                    onChanged: _onSearch,
                    decoration: InputDecoration(
                      hintText: 'Search categories',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    padding: EdgeInsets.all(8),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.9,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: filtered.length,
                    itemBuilder: (_, i) => GestureDetector(
                      onTap: () => _openCategory(filtered[i].name),
                      child: CategoryCard(category: filtered[i]),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
