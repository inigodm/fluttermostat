import '../../../Schedule.dart';

abstract class ScheduleEvent {
  final Schedule schedule;
  const ScheduleEvent(this.schedule);
}

class ScheduleCreated extends ScheduleEvent {
  ScheduleCreated(super.schedule);
}

class ScheduleSelected extends ScheduleEvent {
  ScheduleSelected(super.schedule);
}

class ScheduleDeleted extends ScheduleEvent {
  ScheduleDeleted(super.schedule);
}


