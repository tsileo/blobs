part of blobs;

class Todo extends BlobItem {
  Todo({ String title, this.done }) : super(title: title);

  bool done;

  @override
  Map toJson() {
    Map json = super.toJson();
    json['done'] = done;
    json['type'] = runtimeType.toString();
    return json;
  }

  Todo.fromJson(Map json): done = json['done'], super.fromJson(json);

  void _onTodoToggle(Todo todo, bool done) {
    todo.done = done;
    // TODO(tsileo) trigger an AJAX call (a setState() ?)
  }

  Widget toRow(BlobItemHandler onUpdated) {
    return new TodoListItem(todo: this, onUpdated: onUpdated, onTodoToggle: _onTodoToggle);
  }

}

typedef void TodoToggleCallback(Todo todo, bool done);

class TodoListItem extends StatelessComponent {
  TodoListItem({ Todo todo, TodoToggleCallback onTodoToggle, BlobItemHandler onUpdated })
    : todo = todo, todoToggleCallback = onTodoToggle, onUpdated = onUpdated, super(key: new ObjectKey(todo));

  final Todo todo;
  final TodoToggleCallback todoToggleCallback;
  final BlobItemHandler onUpdated;

  void _toggle(Todo todo, bool done) {
    todoToggleCallback(todo, done);
    onUpdated(todo);
  }

  Color _getColor(BuildContext context) {
    return todo.done ? Colors.black54 : Theme.of(context).primaryColor;
  }

  TextStyle _getTextStyle(BuildContext context) {
    if (todo.done) {
      return DefaultTextStyle.of(context).copyWith(
          color: Colors.black54, decoration: lineThrough);
    }
    return null;
  }

  Widget build(BuildContext context) {
    return new ListItem(
      onTap: () => _toggle(todo, !todo.done),
      center: new Text('TODO ${todo.title}', style: _getTextStyle(context))
    );
  }
}

class TodoFragment extends StatefulComponent {
  TodoFragment({ this.onCreated });

  BlobItemHandler onCreated;

  TodoFragmentState createState() => new TodoFragmentState();
}

class TodoFragmentState extends State<TodoFragment> {
  String _title = "";

  void _handleSave() {
    config.onCreated(new Todo(title: _title, done: false));
    Navigator.of(context).pop();
  }

  Widget buildToolBar() {
    return new ToolBar(
      left: new IconButton(
        icon: "navigation/close",
        onPressed: Navigator.of(context).pop),
      center: new Text('New Todo'),
      right: <Widget>[
        new InkWell(
          onTap: _handleSave,
          child: new Text('SAVE')
        )
      ]
    );
  }

  void _handleTitleChanged(String title) {
    setState(() {
      _title = title;
    });
  }

  static final GlobalKey titleKey = new GlobalKey();

  Widget buildBody() {
    Todo todo = new Todo();
    return new Block(<Widget>[
        // new Text(meal.displayDate),
        new Input(
          key: titleKey,
          placeholder: 'Task Title',
          onChanged: _handleTitleChanged
        )
    ],
      padding: const EdgeDims.all(20.0)
    );
  }

  Widget build(BuildContext context) {
    return new Scaffold(
      toolBar: buildToolBar(),
      body: buildBody()
    );
  }
}
