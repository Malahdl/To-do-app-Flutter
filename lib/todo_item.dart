import 'package:flutter/material.dart';

import 'Todo.dart';

class TodoItem extends StatefulWidget {
  TodoItem({
    required this.todo,
    required this.onCheck,
    required this.onRemove,
  });

  Todo todo;
  Function(Todo, bool) onCheck;
  Function(Todo) onRemove;

  @override
  State<TodoItem> createState() => _TodoItemState();
}

class _TodoItemState extends State<TodoItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      width: double.infinity,
      height: 75,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Theme(
                    data: Theme.of(context).copyWith(
                      unselectedWidgetColor: Colors.deepPurple,
                    ),
                    child: Checkbox(
                      activeColor: Colors.deepPurple,
                      value: widget.todo.isDone,
                      onChanged: (value) async {
                        await widget.onCheck(widget.todo, value!);
                      },
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    widget.todo.task,
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                child: Text(
                  'Due Date: ' +
                      '${widget.todo.endDate.year}-${widget.todo.endDate.month}-${widget.todo.endDate.day}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.deepPurple,
                  ),
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () async {
              await widget.onRemove(widget.todo);
            },
            child: Container(
              margin: EdgeInsets.all(10),
              child: Icon(
                Icons.delete,
                color: Colors.red,
                size: 35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
