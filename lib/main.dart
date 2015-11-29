library blobs;

import 'package:flutter/material.dart';
import 'date_utils.dart';
import 'dart:async';

part 'blob.dart';

typedef void EventItemHandler(Event item);

class Event {
  Event({ this.title });

  final String title;
}

class Todo extends BlobItem {
  Todo({ DateTime when, this.title }) : super(when: when);
  Todo.fromJson(Map json) : title = json['title'], super.fromJson(json);

  final String title;

  @override
  Map toJson() {
    Map json = super.toJson();
    json['title'] = title;
    json['type'] = runtimeType.toString();
    return json;
  }
}

class TodoItem extends StatelessComponent {
  TodoItem({ this.title });
  final String title;
  Widget build(BuildContext context) {
    return new Text('Title: $title');
  }
}

class Data {
  List<Event> _items = <Event>[];

  void add(Event event) {
    _items.add(event);
  }

  List<Event> get items => _items;
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

class HomeFragment extends StatefulComponent {
  HomeFragment({ this.data });

  final Data data;

  HomeFragmentState createState() => new HomeFragmentState();
}

class HomeFragmentState extends State<HomeFragment> {
  void _handleActionButtonPressed() {
    showDialog(context: context, child: new AddItemDialog()).then((routeName) {
      if (routeName != null)
        Navigator.of(context).pushNamed(routeName);
    });
  }

  Widget build(BuildContext context) {
    return new Scaffold(
      toolBar: new ToolBar(
        center: new Text("Blobs")
      ),
      body: new MaterialList<Event>(
        type: MaterialListType.oneLine,
        items: config.data.items,
        itemBuilder: (BuildContext context, Event event, int index) {
          return new EventListItem(event: event);
        }
      ),
      floatingActionButton: new FloatingActionButton(
        child: new Icon(
          icon: 'content/add'
        ),
        onPressed: _handleActionButtonPressed
      )
    );
  }
}

class EventFragment extends StatefulComponent {
  EventFragment({ this.onCreated });

  EventItemHandler onCreated;

  EventFragmentState createState() => new EventFragmentState();
}

class EventFragmentState extends State<EventFragment> {
  String _title = "";

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

class App extends StatefulComponent {
  AppState createState() => new AppState();
}

class AppState extends State<App> {
  Data _data;

  void initState() {
    super.initState();
    setState(() => _data = new Data());
    // TODO(tsileo) HTTP request to load data
  }

  void _handleEventCreated(Event item) {
    setState(() {
      _data.add(item);
      // TODO(tsileo) sort (cf fitness app)
    });
  }

  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "Blobs",
      routes: {
        '/': (RouteArguments args) => new HomeFragment(data: _data),
        '/events/new': (RouteArguments args) => new EventFragment(onCreated: _handleEventCreated)
      }
    );
  }
}

class AddItemDialog extends StatefulComponent {
  AddItemDialogState createState() => new AddItemDialogState();
}

class AddItemDialogState extends State<AddItemDialog> {
  // TODO(jackson): Internationalize
  static final Map<String, String> _labels = <String, String>{
    '/events/new': 'Event',
  };

  String _addItemRoute = _labels.keys.first;

  void _handleAddItemRouteChanged(String routeName) {
    setState(() {
        _addItemRoute = routeName;
    });
  }

  Widget build(BuildContext context) {
    List<Widget> menuItems = <Widget>[];
    for (String routeName in _labels.keys) {
      menuItems.add(new DialogMenuItem(<Widget>[
        new Flexible(child: new Text(_labels[routeName])),
        new Radio<String>(value: routeName, groupValue: _addItemRoute, onChanged: _handleAddItemRouteChanged),
      ], onPressed: () => _handleAddItemRouteChanged(routeName)));
    }
    return new Dialog(
      title: new Text("What are you doing?"),
      content: new Block(menuItems),
      actions: <Widget>[
        new FlatButton(
          child: new Text('CANCEL'),
          onPressed: () {
            Navigator.of(context).pop();
          }
        ),
        new FlatButton(
          child: new Text('ADD'),
          onPressed: () {
            Navigator.of(context).pop(_addItemRoute);
          }
        ),
      ]
    );
  }
}

class DialogMenuItem extends StatelessComponent {
  DialogMenuItem(this.children, { Key key, this.onPressed }) : super(key: key);

  List<Widget> children;
  Function onPressed;

  Widget build(BuildContext context) {
    return new Container(
      height: 48.0,
      child: new InkWell(
        onTap: onPressed,
        child: new Padding(
          padding: const EdgeDims.symmetric(horizontal: 16.0),
          child: new Row(children)
        )
      )
    );
  }
}

void main() {
  runApp(new App());
}
