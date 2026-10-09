extension IntExtensions on int {
  bool get getBoolValue {
    switch (this) {
      case 0:
        return false;
      case 1:
        return true;
      default:
        return false;
    }
  }
}
