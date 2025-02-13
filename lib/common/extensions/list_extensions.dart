extension ListExtension<T> on List<T>? {
  /// format symbol
  /// input: [AAA, TCB]
  /// output: AAA, TCB
  String get symbolsFormat {
    if (isNullOrEmpty) return '';

    final newList = [...this!]..removeWhere((e) => (e as String).isEmpty);

    return newList.join(',');
  }

  void addAllIf(List<T>? data, {bool Function()? addIf}) {
    if (addIf?.call() == true && this != null && data != null) {
      this!.addAll(data);
    }
  }

  bool get isNullOrEmpty {
    return this == null || this!.isEmpty;
  }

  bool get hasData => !isNullOrEmpty;

  T? getElementAt(int index) {
    if (this == null || index >= this!.length || index < 0) return null;

    return this?[index];
  }

  void removeDuplicate(
    dynamic Function(T item, T element) test, {
    bool Function(T item)? ignore,
    bool removeItemBehind = true,
  }) {
    if (T is num || T is String) return;

    if (this == null || this!.isEmpty) return;

    for (int i = 0; i < this!.length; i++) {
      if (ignore?.call(this![i]) == true) {
        continue;
      }

      final itemsFilter = this!.where((e) => test(e, this![i])).toList();

      if (itemsFilter.length > 1) {
        if (removeItemBehind) {
          itemsFilter.removeAt(0);
        } else {
          itemsFilter.removeLast();
        }

        for (final value in itemsFilter) {
          this?.remove(value);
        }
      }
    }
  }
}
