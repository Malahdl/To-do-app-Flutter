class Todo {
  final String id;
  final String task;
  final DateTime endDate;
  bool isDone;

  Todo(
      {required this.id,
      required this.task,
      required this.endDate,
      this.isDone = false});
}
