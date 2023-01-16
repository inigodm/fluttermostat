class Schedule{
  int? id;
  String timeFrom;
  String timeTo;
  String weekDays;
  bool active;
  int desiredTemp;

  Schedule(this.id,
      this.timeFrom,
      this.timeTo,
      this.weekDays,
      this.active,
      this.desiredTemp);
}