import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_food_20221016/models/food_item.dart';
import 'package:http/http.dart' as http;

const apiBaseUrl = 'https://cpsu-test-api.herokuapp.com';
const apiGetFoods = '$apiBaseUrl/foods';

class FoodListPage extends StatefulWidget {
  const FoodListPage({Key? key}) : super(key: key);

  @override
  _FoodListPageState createState() => _FoodListPageState();
}

class _FoodListPageState extends State<FoodListPage> {
  List<FoodItem>? _foodList;
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FOOD LIST')),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _handleClickButton,
              child: const Text('GET FOOD DATA'),
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                if (_foodList != null)
                  ListView.builder(
                    itemBuilder: _buildListItem,
                    itemCount: _foodList!.length,
                  ),
                if (_isLoading)
                  const Center(child: CircularProgressIndicator()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleClickButton() async {
    setState(() {
      //_foodList = null;
      _isLoading = true;
    });

    var response = await http.get(Uri.parse(apiGetFoods));
    print(response.statusCode);
    print(response.body);
    var output = jsonDecode(response.body);
    print(output['status']);
    print(output['message']);

    setState(() {
      _foodList = [];
      output['data'].forEach((item) {
        print(item['name'] + ' ราคา ' + item['price'].toString());
        var foodItem = FoodItem(
          id: item['id'],
          name: item['name'],
          price: item['price'],
          image: item['image'],
        );
        _foodList!.add(foodItem);
      });
      _isLoading = false;
    });
  }

  Widget _buildListItem(BuildContext context, int index) {
    var foodItem = _foodList![index];

    return Card(
      child: InkWell(
        onTap: () {},
        child: Row(
          children: [
            Image.network(
              foodItem.image,
              width: 80.0,
              height: 80.0,
              fit: BoxFit.cover,
            ),
            const SizedBox(width: 8.0),
            Text(foodItem.name),
          ],
        ),
      ),
    );
  }
}
