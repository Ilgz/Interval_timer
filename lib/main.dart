import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tutor_project/blocs/timer_bloc.dart';
import 'package:tutor_project/detail.dart';
import 'package:tutor_project/models/session.dart';
import 'package:tutor_project/timer.dart';

import 'home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TimerBloc(),
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: _router,
        title: "Go router",
      ),
    );
  }
}

final GoRouter _router = GoRouter(
  routes: [
    GoRoute(
        name: "home",
        path: "/",
        builder: (context, state) =>  HomePage(),
        routes: [
          GoRoute(
              name: "timer",
              path: "timer",
              builder: (context, state) => TimerPage(session: state.extra as Session))
        ]
    ),


  ],
);
