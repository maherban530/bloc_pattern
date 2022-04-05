import 'dart:async';
import 'package:bloc_pattern/user_model.dart';
import 'package:dio/dio.dart';

enum UserAction { Fetch }

class UserBloc {
  final _stateStreamController = StreamController<List<UserList>>();
  StreamSink<List<UserList>> get _userSink => _stateStreamController.sink;
  Stream<List<UserList>> get userStream => _stateStreamController.stream;

  final _eventStreamController = StreamController<UserAction>();
  StreamSink<UserAction> get eventSink => _eventStreamController.sink;
  Stream<UserAction> get _eventStream => _eventStreamController.stream;

  UserBloc() {
    _eventStream.listen((event) async {
      if (event == UserAction.Fetch) {
        try {
          var user = await getUser();
          if (user != null) {
            _userSink.add(user);
          } else {
            _userSink.addError("Wrong");
          }
        } on Exception catch (e) {
          _userSink.addError("Wrong");
        }
      }
    });
  }

  Future<List<UserList>> getUser() async {
    var response = await Dio().get("https://api.github.com/users");

    return userListFromJson(response.data);
    // var client = http.Client();
    // var userModel;

    // try {
    //   var response =
    //       await client.get(Uri.parse("https://api.github.com/users"));
    //   if (response.statusCode == 200) {
    //     var jsonString = response.body;
    //     var jsonMap = json.decode(jsonString);

    //     userModel = UserList.fromJson(jsonMap);
    //   }
    // } catch (Exception) {
    //   return userModel;
    // }

    // return userModel;
  }
}
