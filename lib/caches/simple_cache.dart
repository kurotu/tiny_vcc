class SimpleCache<T> {
  T? _data;

  bool get hasCache => _data != null;

  T get() {
    return _data!;
  }

  void set(T data) {
    _data = data;
  }
}
