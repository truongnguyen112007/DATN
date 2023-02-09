import 'package:base_bloc/data/model/playlist_wall_login_model.dart';
import 'package:base_bloc/modules/login_to_wall/login_to_wall_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginToWallCubit extends Cubit<LoginToWallState> {
  LoginToWallCubit(): super(LoginToWallState());

}

List<PlaylistWallLoginModel> fakeDataAuthor() => [
  PlaylistWallLoginModel(rank:'7B', name: 'Adam', height: 12, date: '2022-05-07', author: 'Adam Kowaski'),
  PlaylistWallLoginModel(rank:'5B', name: 'Adam', height: 12, date: '2022-05-07', author: 'Adam Kowaski'),
  PlaylistWallLoginModel(rank:'7B', name: 'Adam', height: 12, date: '2022-05-07', author: 'Adam Kowaski',icon:Icons.circle),
  PlaylistWallLoginModel(rank:'5B', name: 'Adam', height: 12, date: '2022-05-07', author: 'Adam Kowaski'),
  PlaylistWallLoginModel(rank:'7B', name: 'Adam', height: 12, date: '2022-05-07', author: 'Adam Kowaski'),
  PlaylistWallLoginModel(rank:'5B', name: 'Adam', height: 12, date: '2022-05-07', author: 'Adam Kowaski'),
  PlaylistWallLoginModel(rank:'7B', name: 'Adam', height: 12, date: '2022-05-07', author: 'Adam Kowaski'),
  PlaylistWallLoginModel(rank:'5B', name: 'Adam', height: 12, date: '2022-05-07', author: 'Adam Kowaski'),
  PlaylistWallLoginModel(rank:'7B', name: 'Adam', height: 12, date: '2022-05-07', author: 'Adam Kowaski'),
  PlaylistWallLoginModel(rank:'5B', name: 'Adam', height: 12, date: '2022-05-07', author: 'Adam Kowaski'),
];

