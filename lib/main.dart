library blobs;

import 'package:flutter/material.dart';
import 'date_utils.dart';
import 'package:intl/intl.dart';
import 'dart:async';

part 'blob.dart';
part 'calendar.dart';
part 'todo.dart';

class HomeFragment extends StatefulComponent {
  HomeFragment({ this.data, this.onUpdated });

  final Data data;
  final BlobItemHandler onUpdated;

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
      body: new MaterialList<BlobItem>(
        type: MaterialListType.oneLine,
        items: config.data.items,
        itemBuilder: (BuildContext context, BlobItem item, int index) {
          return item.toRow(config.onUpdated);
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

  void _handleEventCreated(BlobItem item) {
    setState(() {
      _data.add(item);
      // TODO(tsileo) sort (cf fitness app)
    });
  }

  void _handleEventUpdated(BlobItem item) {
    // TODO(tsileo) update and reload all the list
    setState(() {
      // _data.add(item);
    });
 }

  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "Blobs",
      routes: {
        '/': (RouteArguments args) => new HomeFragment(data: _data, onUpdated: _handleEventUpdated),
        '/events/new': (RouteArguments args) => new EventFragment(onCreated: _handleEventCreated),
        '/todos/new': (RouteArguments args) => new TodoFragment(onCreated: _handleEventCreated)
      }
    );
  }
}

class AddItemDialog extends StatefulComponent {
  AddItemDialogState createState() => new AddItemDialogState();
}

class AddItemDialogState extends State<AddItemDialog> {
  static final Map<String, String> _labels = <String, String>{
    '/events/new': 'Event',
    '/todos/new': 'Todo',
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
