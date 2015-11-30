part of blobs;

typedef void BlobItemHandler(BlobItem item);

abstract class BlobItem {
  BlobItem({ this.title });
  BlobItem.fromJson(Map json) : title = json['title'];

  final String title;

  Map toJson() => { 'title': title };

  BlobItemRow toRow(BlobItemHandler);
}

abstract class BlobItemRow extends StatelessComponent {
  BlobItemRaw({ BlobItem item });

  final BlobItem item;

  Widget buildContent(BuildContext context);

  Widget build(BuildContext context) {
    return buildContent(context);
  }
}

class Data {
  List<BlobItem> _items = <BlobItem>[];

  void add(BlobItem item) {
    _items.add(item);
  }

  List<BlobItem> get items => _items;
}
