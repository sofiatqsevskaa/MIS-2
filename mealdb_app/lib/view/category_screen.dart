import 'package:flutter/material.dart';
import '../model/meal_summary.dart';
import '../service/api_service.dart';
import '../widgets/meal_card.dart';
import 'meal_detail_screen.dart';

class CategoryScreen extends StatefulWidget {
  final String category;
  CategoryScreen({required this.category});
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final ApiService api = ApiService();
  List<MealSummary> meals = [];
  List<MealSummary> filtered = [];
  bool loading = true;
  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() async {
    final m = await api.fetchMealsByCategory(widget.category);
    setState(() {
      meals = m;
      filtered = m;
      loading = false;
    });
  }

  void _onSearch(String q) async {
    if (q.trim().isEmpty) {
      setState(() => filtered = meals);
      return;
    }
    final results = await api.searchMeals(q);
    final sameCategory = results.where((r) => r.name.isNotEmpty).toList();
    setState(
      () => filtered = sameCategory
          .where((r) => meals.any((m) => m.id == r.id))
          .toList(),
    );
  }

  void _openMeal(String id) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => MealDetailScreen(mealId: id)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.category)),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextField(
                    onChanged: _onSearch,
                    decoration: InputDecoration(
                      hintText: 'Search meals in this category',
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
                      onTap: () => _openMeal(filtered[i].id),
                      child: MealCard(meal: filtered[i]),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
