import 'package:bloc_pattern/user_details_bloc.dart';
import 'package:bloc_pattern/user_details_model.dart';
import 'package:bloc_pattern/user_model.dart';
import 'package:flutter/material.dart';

class UserDetails extends StatefulWidget {
  final UserList login;
  const UserDetails(
    this.login, {
    Key? key,
  }) : super(key: key);

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  final userDetailsList = UserDetailsBloc();
  @override
  void initState() {
    userDetailsList.eventSink.add(widget.login.login.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("User Details"),
        ),
        body: StreamBuilder<UserDetailsModel>(
            stream: userDetailsList.userStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasData) {
                return ListTile(
                  leading: CircleAvatar(
                      backgroundImage:
                          NetworkImage(snapshot.data!.avatarUrl.toString())),
                  title: Text(snapshot.data!.login.toString()),
                  subtitle: Text(snapshot.data!.blog.toString()),
                );
              }
              return Container();
            }));
  }
}
