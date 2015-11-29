part of blobs;

typedef void BlobItemHandler(BlobItem item);

// TODO remove the when
abstract class BlobItem {
  BlobItem.fromJson(Map json) : when = DateTime.parse(json['when']);

  BlobItem({ this.when }) {
    assert(when != null);
  }
  final DateTime when;

  Map toJson() => { 'when' : when.toIso8601String() };

  String get displayDate => DateUtils.toDateString(when);
}
