import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tutor_project/blocs/timer_bloc.dart';
import 'package:tutor_project/models/session.dart';
import 'package:tutor_project/utils/seconds_formatter.dart';

class TimerPage extends StatelessWidget {
  TimerPage({Key? key, required this.session}) : super(key: key);
  Session session;
  bool onStart = true;
  String timerState = "Работа";
  late int seconds = session.workingSeconds;
  bool isPaused = false;
  MaterialColor backgroundColor = Colors.lightGreen;

  @override
  Widget build(BuildContext context) {
    if (onStart) {
      context.read<TimerBloc>().add(TimerInitEvent(session));
      onStart = false;
    }
    return BlocBuilder<TimerBloc, TimerState>(
      buildWhen: (context, state) {
        if (state is TimerWorkingState) {
          backgroundColor = Colors.lightGreen;
          return true;
        } else if (state is TimerRestingState) {
          backgroundColor = Colors.amber;
          return true;
        } else if (state is TimerDoneState) {
          backgroundColor = Colors.teal;
          return true;
        }
        return false;
      },
      builder: (context, state) {
        return Scaffold(
          floatingActionButton: FloatingActionButton(
            backgroundColor: backgroundColor,
            onPressed: () {
              if (state is TimerDoneState) {
                context.pop();
              } else {
                if (isPaused) {
                  isPaused = false;
                  context.read<TimerBloc>().add(TimerResumeEvent());
                } else {
                  isPaused = true;
                  context.read<TimerBloc>().add(TimerPauseEvent());
                }
              }
            },
            child: BlocBuilder<TimerBloc, TimerState>(
              builder: (context, state) {
                if (state is TimerPausedState) {
                  return Icon(
                    Icons.play_arrow,
                  );
                }
                if (state is TimerDoneState) {
                  return Icon(Icons.square);
                }
                return Icon(
                  Icons.pause,
                );
              },
            ),
          ),
          backgroundColor: backgroundColor,
          body: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: SafeArea(
              child: Stack(
                children: [
                  BlocBuilder<TimerBloc, TimerState>(
                    buildWhen: (context, state) {
                      if (state is TimerDoneState) {
                        return true;
                      }
                      return false;
                    },
                    builder: (context, state) {
                      if (state is TimerDoneState) {
                        return const SizedBox();
                      }
                      return Container(
                          margin: EdgeInsets.only(top: 20),
                          alignment: AlignmentDirectional.topCenter,
                          child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25, vertical: 10),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16)),
                                  backgroundColor: Colors.grey.shade800),
                              onLongPress: () {
                                context.read<TimerBloc>().stop();
                                context.pop();
                              },
                              child: FittedBox(
                                fit: BoxFit.fitWidth,
                                child: Text(
                                  "Удерживайте чтобы выйти",
                                  style: TextStyle(fontSize: 22),
                                ),
                              )));
                    },
                  ),
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        BlocBuilder<TimerBloc, TimerState>(
                            buildWhen: (context, state) {
                          if (state is TimerOnTickState) {
                            seconds = state.seconds;
                            return true;
                          } else if (state is TimerDoneState) {
                            return true;
                          }
                          return false;
                        }, builder: (context, state) {
                          if (state is TimerDoneState) {
                            return const SizedBox();
                          }
                          return Text(
                            formatterTime(seconds),
                            style: TextStyle(
                                fontSize: 64, fontWeight: FontWeight.bold),
                          );
                        }),
                        BlocBuilder<TimerBloc, TimerState>(
                          buildWhen: (context, state) {
                            if (state is TimerWorkingState) {
                              timerState = "Работа";
                              return true;
                            } else if (state is TimerRestingState) {
                              timerState = "Отдых";
                              return true;
                            } else if (state is TimerDoneState) {
                              timerState = "Завершено";
                              return true;
                            }
                            return false;
                          },
                          builder: (context, state) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: FittedBox(
                                fit: BoxFit.fitWidth,
                                child: Text(
                                  timerState.toUpperCase(),
                                  style: TextStyle(
                                      fontSize: 200, color: Colors.white24),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
