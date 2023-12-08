import 'package:flutter/material.dart';

class NewTaskPage extends StatefulWidget {
  NewTaskPage({
    required this.controller,
    required this.task,
    required this.endDate,
    required this.isError,
    required this.onAddTask,
  });

  TextEditingController? controller;
  String? task;
  DateTime? endDate;
  bool isError;
  Function(String, DateTime) onAddTask;

  @override
  State<NewTaskPage> createState() => _NewTaskPageState();
}

class _NewTaskPageState extends State<NewTaskPage> {
  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setBottomSheetState) {
      return Container(
        width: double.infinity,
        height: 400,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 70,
                  margin: const EdgeInsets.only(
                    top: 20,
                    bottom: 10,
                    right: 15,
                    left: 15,
                  ),
                  child: TextField(
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      border: UnderlineInputBorder(borderSide: BorderSide.none),
                      filled: true,
                      fillColor: Color.fromARGB(255, 216, 216, 216),
                      label: Center(
                        child: Text(
                          'Enter Task',
                          style: TextStyle(
                            color: Color.fromARGB(255, 133, 133, 133),
                          ),
                        ),
                      ),
                    ),
                    controller: widget.controller,
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    DateTime? newDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(DateTime.now().year + 1),
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: ColorScheme.light(
                              primary: Colors.deepPurple,
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );

                    if (newDate == null) {
                      return;
                    } else {
                      setBottomSheetState(() {
                        widget.endDate = newDate;
                      });
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    height: 65,
                    margin: const EdgeInsets.only(
                      top: 10,
                      bottom: 10,
                      right: 15,
                      left: 15,
                    ),
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 216, 216, 216)),
                    child: Center(
                      child: Text(
                        widget.endDate == null
                            ? 'Enter End Date'
                            : '${widget.endDate!.year}-${widget.endDate!.month}-${widget.endDate!.day}',
                        style: TextStyle(
                          color: widget.endDate == null
                              ? Color.fromARGB(255, 133, 133, 133)
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (widget.isError == true)
              Container(
                child: Center(
                  child: Text(
                    'Must Enter Task And End Date!',
                    style: TextStyle(color: Colors.red, fontSize: 16),
                  ),
                ),
              ),
            Container(
              margin: EdgeInsets.all(10),
              width: double.infinity,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.deepPurple),
                ),
                onPressed: () async {
                  widget.task = widget.controller!.text;

                  if (widget.task!.isEmpty ||
                      widget.task == null ||
                      widget.endDate == null) {
                    setBottomSheetState(() {
                      widget.isError = true;
                    });
                  } else {
                    setBottomSheetState(
                      () {
                        widget.isError = false;
                      },
                    );
                    widget.onAddTask(widget.task!, widget.endDate!);
                    Navigator.of(context).pop();
                  }
                },
                child: Text('Add Task'),
              ),
            ),
          ],
        ),
      );
    });
  }
}
