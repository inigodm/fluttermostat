class Schedule{
  String? id;
  String timeFrom;
  String weekDays;
  bool active;
  int desiredTemp;

  Schedule(this.id,
      this.timeFrom,
      this.weekDays,
      this.active,
      this.desiredTemp);
}