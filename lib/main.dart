import 'package:countries_task/cityScreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'Model/listModel.dart';
import 'Model/model.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

ListModel model = ListModel();
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const FirstScreen(),
    );
  }
}

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  bool loading = true;
  //Future<List<Location>>
  void getData() async {
    const String apiUrl = 'https://countriesnow.space/api/v0.1/countries';
    var res = await http.get(Uri.parse(apiUrl));

    var data = json.decode(res.body);
    setState(() {
      if (data != Null) {
        model = ListModel.fromJson(data);
        loading = false;
      }
    });
    //model != Null ? print("model not null") : print('model is null');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    getData();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Countries'),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.search,
            ),
            onPressed: () {
              showSearch(
                context: context,
                delegate: SearchLocation(),
              );
            },
          )
        ],
      ),
      body: loading == false
          ? ListView.builder(
              itemCount: model.data?.length,
              itemBuilder: (BuildContext context, int index) => CustomListItem(
                    obj: model.data![index],
                  ))
          : Center(child: FittedBox(child: CircularProgressIndicator())),
    );
  }
}

class CustomListItem extends StatelessWidget {
  const CustomListItem({
    super.key,
    required this.obj,
  });
  final Model obj;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CityScreen(city: obj.cities)));
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[Text(obj.country), Icon(Icons.chevron_right)],
          ),
        ),
      ),
    );
  }
}

class SearchLocation extends SearchDelegate {
  @override
  Widget? buildLeading(BuildContext context) => IconButton(
      icon: Icon(Icons.arrow_back), onPressed: () => close(context, null));
  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query.isEmpty ? close(context, null) : query = '';
          },
        )
      ];

  List getResults(String query) {
    List suggestions = ['data'];
    int i = 0;
    List tempList = model.data!;
    int len = tempList.length;
    print(len);
    print(query);
    for (i; i < len; i++) {
      if (model.data![i].country.toLowerCase() == query.toLowerCase()) {
        suggestions = tempList[i].cities;
      }
    }
    return suggestions;
  }

  List getSuggestions(String query) {
    List suggestions = [];
    int i = 0;
    List tempList = model.data!;
    int len = tempList.length;
    print(len);
    print(query);
    for (i; i < len; i++) {
      if (model.data![i].country.toLowerCase().contains(query.toLowerCase())) {
        suggestions.add(tempList[i]);
      }
    }
    print(suggestions);
    return suggestions;
  }

  @override
  Widget buildResults(BuildContext context) {
    List suggestions = query.isEmpty ? [] : getResults(query);
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final suggestion = suggestions[index];
        return ListTile(
          title: Text(suggestion),
          onTap: () {},
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List suggestions = query.isEmpty ? [] : getSuggestions(query);
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final suggestion = suggestions[index];
        return CustomListItem(obj: suggestion);
      },
    );
  }
}
