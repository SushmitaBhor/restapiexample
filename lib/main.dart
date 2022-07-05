import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: PeopleApp(),
    );
  }
}

class PeopleApp extends StatefulWidget {
  PeopleApp({
    Key? key,
  }) : super(key: key);

  @override
  State<PeopleApp> createState() => _PeopleAppState();
}

class _PeopleAppState extends State<PeopleApp> {
  late Future<List<Post>> post;
  @override
  void initState() {
    super.initState();
    post = fetchPost();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Rest Api integration')),
      body: Center(
        child: FutureBuilder<List<Post>>(
          future: post,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Post>? data = snapshot.data;
              return ListView.separated(
                padding: EdgeInsets.all(10),
                separatorBuilder: (context, index) => SizedBox(height: 4),
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Text(snapshot.data![index].id.toString()),
                    contentPadding: EdgeInsets.all(10),
                    title: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(snapshot.data![index].title),
                    ),
                    tileColor: Colors.grey,
                    textColor: Colors.black,
                    subtitle: Container(
                        padding: EdgeInsets.all(10),
                        decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30))),
                        child: Text(
                          snapshot.data![index].body,
                          style:
                              TextStyle(color: Colors.blueAccent, fontSize: 14),
                        )),
                  );
                },
                itemCount: data!.length,
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}

class Post {
  final int userId;
  final int id;
  final String title;
  final String body;

  Post(
      {required this.userId,
      required this.id,
      required this.body,
      required this.title});
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
        userId: json["userId"],
        id: json['id'],
        title: json["title"],
        body: json["body"]);
  }
}

Future<List<Post>> fetchPost() async {
  String url = "https://jsonplaceholder.typicode.com/posts";
  final response = await http.get(Uri.parse('$url'));

  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((data) => new Post.fromJson(data)).toList();
  } else {
    throw Exception('Failed to load post');
  }
}
