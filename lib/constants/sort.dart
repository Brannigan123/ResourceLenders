enum Sort { Ascending, Descending }

extension Sorting on Sort {
  Sort get opposite => this.isAscending ? Sort.Descending : Sort.Ascending;
  bool get isAscending => this == Sort.Ascending;
  bool get isDescending => this == Sort.Descending;
  String get str => isDescending ? '↓' : '↑';
}
