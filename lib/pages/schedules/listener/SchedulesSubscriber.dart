import 'package:fluthermostat/pages/schedules/listener/ScheduleEvent.dart';

class SchedulesSubscriber{
  List<Function(ScheduleEvent)> onCreateSubscribers = List.empty(growable: true);
  List<Function(ScheduleEvent)> onSelectedSubscribers = List.empty(growable: true);
  List<Function(ScheduleEvent)> onDeletedSubscribers = List.empty(growable: true);

  void subscribeToCreation(Function(ScheduleEvent) scheduleObserver) {
    onCreateSubscribers.add(scheduleObserver);
  }

  void subscribeToSelection(Function(ScheduleEvent) scheduleObserver) {
    onSelectedSubscribers.add(scheduleObserver);
  }

  void push(ScheduleEvent event) async {
    if (event is ScheduleCreated) _onCreate(event);
    if (event is ScheduleSelected) _onSelected(event);
    if (event is ScheduleDeleted) _onDeleted(event);
  }

  void _onCreate(ScheduleCreated event) {
    for (var subscriber in onCreateSubscribers) { subscriber.call(event); }
  }

  void _onSelected(ScheduleSelected event) {
    for (var subscriber in onSelectedSubscribers) { subscriber.call(event); }
  }

  void _onDeleted(ScheduleDeleted event) {
    for (var subscriber in onDeletedSubscribers) { subscriber.call(event); }
  }
}