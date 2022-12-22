import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tutor_project/models/session.dart';

abstract class TimerEvent{}
class TimerOnTickEvent extends TimerEvent{
 final int seconds;

 TimerOnTickEvent(this.seconds);
}
class TimerInitEvent extends TimerEvent{
 final Session session;
 TimerInitEvent(this.session);
}
class TimerStartEvent extends TimerEvent{
 final int seconds;

  TimerStartEvent(this.seconds);
}
class TimerPauseEvent extends TimerEvent{
}
class TimerResumeEvent extends TimerEvent{
}
abstract class TimerState{}
class TimerWorkingState extends TimerState{}
class TimerRestingState extends TimerState{}
class TimerDoneState extends TimerState{}
class TimerPausedState extends TimerState{
}
class TimerInitial extends TimerState{
 final int seconds;
  TimerInitial(this.seconds);
}
class TimerOnTickState extends TimerState {
 final int seconds;
 TimerOnTickState(this.seconds);
}
class TimerOnRunOutState extends TimerState {
 TimerOnRunOutState();
}
class TimerResumedState extends TimerState{}
class TimerBloc extends Bloc<TimerEvent,TimerState>{
 StreamSubscription? streamSubscription;
 Completer? completer;
 Timer? timer;

 TimerBloc():super(TimerInitial(0)){
  on<TimerOnTickEvent>(_onTimerTick);
  on<TimerInitEvent>(_onTimerInit);
  on<TimerPauseEvent>(_onTimerPause);
  on<TimerResumeEvent>(_onTimerReset);
 }
  stop(){
  streamSubscription?.cancel();
 }


 _onTimerReset(TimerResumeEvent event,Emitter<TimerState> emit){
  streamSubscription?.resume();
  emit(TimerResumedState());
 }
 _onTimerPause(TimerPauseEvent event,Emitter<TimerState> emit){
  streamSubscription?.pause();
  emit(TimerPausedState());
 }
 _onTimerStartFunc(int seconds)async{
  emit(TimerOnTickState(seconds));
  streamSubscription?.cancel();
  streamSubscription=Stream.periodic(Duration(seconds: 1),(count){
   add(TimerOnTickEvent(seconds-count-1));
  }).listen((event) {
  });

 }
 _onTimerTick(TimerOnTickEvent event,Emitter<TimerState> emit){
  if(event.seconds>=0){
   emit(TimerOnTickState(event.seconds));
  }else{
   completer?.complete();
   streamSubscription?.cancel();
  }
 }
 _onTimerInit(TimerInitEvent event,Emitter<TimerState> emit)async {
   Session session=event.session;

   for(int i=0;i<session.sets;i++){
    emit(TimerWorkingState());
    completer=Completer();
    _onTimerStartFunc(session.workingSeconds);
    await completer?.future;
    emit(TimerRestingState());
    completer=Completer();
    _onTimerStartFunc(session.restingSeconds);
    await completer?.future;
   }
   emit(TimerDoneState());

 }
}