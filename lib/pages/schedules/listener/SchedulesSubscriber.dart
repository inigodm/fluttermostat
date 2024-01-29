import 'package:fluthermostat/pages/schedules/listener/ScheduleEvent.dart';

class SchedulesSubscriber{
  final List<Function(ScheduleEvent)> _onCreateSubscribers = List.empty(growable: true);
  final List<Function(ScheduleEvent)> _onSelectedSubscribers = List.empty(growable: true);
  final List<Function(ScheduleEvent)> _onDeletedSubscribers = List.empty(growable: true);

  void subscribeToCreation(Function(ScheduleEvent) scheduleObserver) {
    _onCreateSubscribers.add(scheduleObserver);
  }

  void subscribeToSelection(Function(ScheduleEvent) scheduleObserver) {
    _onSelectedSubscribers.add(scheduleObserver);
  }

  void push(ScheduleEvent event) async {
    if (event is ScheduleCreated) _onCreate(event);
    if (event is ScheduleSelected) _onSelected(event);
    if (event is ScheduleDeleted) _onDeleted(event);
  }

  void _onCreate(ScheduleCreated event) {
    for (var subscriber in _onCreateSubscribers) { subscriber.call(event); }
  }

  void _onSelected(ScheduleSelected event) {
    for (var subscriber in _onSelectedSubscribers) { subscriber.call(event); }
  }

  void _onDeleted(ScheduleDeleted event) {
    for (var subscriber in _onDeletedSubscribers) { subscriber.call(event); }
  }
}