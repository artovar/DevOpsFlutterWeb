import 'package:dev_ops_app/user.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test("User Unit Testing", () {
    final user = User("username123", "password123");

    expect(user.user, "username123");
    expect(user.passwd, "password123");
  });
}
