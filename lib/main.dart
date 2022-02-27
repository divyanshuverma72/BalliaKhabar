import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterapp/ballia_khabar.dart';

import 'bloc/posts/posts_cubit.dart';
import 'bloc/posts/posts_repository.dart';
import 'bloc/posts/posts_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp( repository: PostsRepository(PostsService()),));
}

class MyApp extends StatelessWidget {

  final PostsRepository repository;

  const MyApp({Key key, this.repository}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (context) => PostsCubit(repository),
        child: BalliaKhabar(),
      ),
      color: Colors.white,
    );
  }
}
