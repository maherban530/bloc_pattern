import 'package:bloc_pattern/user_bloc.dart';
import 'package:bloc_pattern/user_model.dart';
import 'package:bloc_pattern/userdetails.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final userList = UserBloc();
  @override
  void initState() {
    userList.eventSink.add(UserAction.Fetch);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("User List"),
        ),
        body: StreamBuilder<List<UserList>>(
            stream: userList.userStream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const CircularProgressIndicator();
              }
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    UserDetails(snapshot.data![index]),
                              ),
                            );
                          },
                          leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  snapshot.data![index].avatarUrl.toString())),
                          title: Text(snapshot.data![index].login.toString()));
                    });
              }
              return Container();
            }));
  }
}
