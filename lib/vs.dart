void main() async {
  print('line 1');
  for (int i = 0; i < 10; i++) {
    Future.delayed(Duration(seconds: i), () => print('hi'));
  }
  print('line 3');
}
