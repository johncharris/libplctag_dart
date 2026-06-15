/// A single entry returned by an Allen-Bradley tag-listing read.
class TagInfo {
  final int id;
  final int type;
  final String name;
  final int length;
  final List<int> dimensions;

  const TagInfo(this.id, this.type, this.name, this.length, this.dimensions);
}
