import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import '../service/api_service.dart';
import '../model/meal_details.dart';

class MealDetailScreen extends StatefulWidget {
  final String mealId;
  MealDetailScreen({required this.mealId, Key? key}) : super(key: key);

  @override
  _MealDetailScreenState createState() => _MealDetailScreenState();
}

class _MealDetailScreenState extends State<MealDetailScreen> {
  final ApiService api = ApiService();
  MealDetails? meal;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadMeal();
  }

  void _loadMeal() async {
    final m = await api.lookupMeal(widget.mealId);
    setState(() {
      meal = m;
      loading = false;
    });
  }

  void _openYoutube(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (meal == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text('Meal not found')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(meal!.name)),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedNetworkImage(
              imageUrl: meal!.thumb,
              placeholder: (context, url) =>
                  Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) =>
                  Icon(Icons.broken_image, size: 100),
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 12),
            Text(
              meal!.name,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Text(
              'Ingredients:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ...meal!.ingredients.entries
                .map((e) => Text('• ${e.key} - ${e.value}'))
                .toList(),
            SizedBox(height: 12),
            Text(
              'Instructions:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(meal!.instructions),
            SizedBox(height: 12),
            if (meal!.youtube.isNotEmpty)
              ElevatedButton(
                onPressed: () => _openYoutube(meal!.youtube),
                child: Text('Watch on YouTube'),
              ),
          ],
        ),
      ),
    );
  }
}
