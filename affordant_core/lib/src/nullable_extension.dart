extension NullableExtension<T> on T? {
  U? mapNotNull<U>(U Function(T) delegate) {
    final v = this;
    if (v != null) {
      return delegate(v);
    } else {
      return null;
    }
  }
}
