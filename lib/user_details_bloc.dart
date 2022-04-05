import 'dart:async';
import 'package:bloc_pattern/user_details_model.dart';
import 'package:dio/dio.dart';

// enum UserAction { Fetch }

class UserDetailsBloc {
  final _stateStreamController = StreamController<UserDetailsModel>();
  StreamSink<UserDetailsModel> get _userSink => _stateStreamController.sink;
  Stream<UserDetailsModel> get userStream => _stateStreamController.stream;

  final _eventStreamController = StreamController<String>();
  StreamSink<String> get eventSink => _eventStreamController.sink;
  Stream<String> get _eventStream => _eventStreamController.stream;

  UserDetailsBloc() {
    _eventStream.listen((event) async {
      try {
        var user = await getUserDetails(event);
        if (user != null) {
          _userSink.add(user);
        } else {
          _userSink.addError("Wrong");
        }
      } on Exception catch (e) {
        _userSink.addError("Wrong");
      }
    });
  }

  Future<UserDetailsModel> getUserDetails(String id) async {
    var response = await Dio().get("https://api.github.com/users/$id");

    return userDetailsModelFromJson(response.data);
  }
}
