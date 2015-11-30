part of blobs;

class Event extends BlobItem {
  Event({ String title }) : super(title: title);

  @override
  Map toJson() {
    Map json = super.toJson();
    json['type'] = runtimeType.toString();
    return json;
  }

  Widget toRow(BlobItemHandler onUpdated) {
    return new EventListItem(event: this);
  }
}

class EventListItem extends StatelessComponent {
  EventListItem({ Event event })
    : event = event, super(key: new ObjectKey(event));

  final Event event;

  Widget build(BuildContext context) {
    return new ListItem(
      // onTap: () => onCartChanged(product, !inCart),
      center: new Text(event.title)
    );
  }
}

class EventFragment extends StatefulComponent {
  EventFragment({ this.onCreated });

  BlobItemHandler onCreated;

  EventFragmentState createState() => new EventFragmentState();
}

class EventFragmentState extends State<EventFragment> {
  String _title = "";
  DateTime _selectedDate = new DateTime.now();

  void _handleSave() {
    config.onCreated(new Event(title: _title));
    Navigator.of(context).pop();
  }

  Widget buildToolBar() {
    return new ToolBar(
      left: new IconButton(
        icon: "navigation/close",
        onPressed: Navigator.of(context).pop),
      center: new Text('New Event'),
      right: <Widget>[
        new InkWell(
          onTap: _handleSave,
          child: new Text('SAVE')
        )
      ]
    );
  }

  Future _handleSelectDate() async {
    DateTime picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: new DateTime(2015, 8),
      lastDate: new DateTime(2101)
    );
    if (picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _handleTitleChanged(String title) {
    setState(() {
      _title = title;
    });
  }

  static final GlobalKey titleKey = new GlobalKey();

  Widget buildBody() {
    Event event = new Event();
    return new Block(<Widget>[
        // new Text(meal.displayDate),
        new Input(
          key: titleKey,
          placeholder: 'Event Title',
          onChanged: _handleTitleChanged
        ),
      new Text(new DateFormat.yMMMd().format(_selectedDate)),
      new RaisedButton(
        onPressed: _handleSelectDate,
        child: new Text('SELECT DATE')
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
