// Imports the Flutter Driver API.
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('Todo App', () {
    // First, define the Finders and use them to locate widgets from the
    // test suite. Note: the Strings provided to the `byValueKey` method must
    // be the same as the Strings we used for the Keys in step 1.
    final userNameField = find.byValueKey('username');
    final passwordField = find.byValueKey('password');
    final signInButton = find.byValueKey('signIn');
    final createAccountButton = find.byValueKey('createAccount');

    final signOutButton = find.byValueKey('signOut');

    final addField = find.byValueKey('addField');
    final addButton = find.byValueKey('addButton');

    FlutterDriver driver;

    Future<bool> isPresent(SerializableFinder byValueKey,
        {Duration timeOut = const Duration(seconds: 1)}) async {
      try {
        await driver.waitFor(byValueKey, timeout: timeOut);
        return true;
      } catch (e) {
        return false;
      }
    }

    // Connect to the Flutter driver before running any tests.
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    // Close the connection to the driver after the tests have completed.
    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    test('create account', () async {
      // if there is a sign our button present (Already logged in), then first log out the user
      if (await isPresent(signOutButton)) {
        await driver.tap(signOutButton);
      }

      await driver.tap(userNameField);
      await driver.enterText('jashaswee12345@gmail.com');
      await driver.tap(passwordField);
      await driver.enterText('test12345');

      await driver.tap(createAccountButton);
      await driver.waitFor(find.text('Your Todos'));
    });
    test('login', () async {
      if (await isPresent(signOutButton)) {
        await driver.tap(signOutButton);
      }

      await driver.tap(userNameField);
      await driver.enterText('jashaswee@gmail.com');
      await driver.tap(passwordField);
      await driver.enterText('test12345');

      await driver.tap(signInButton);
      await driver.waitFor(find.text('Your Todos'));
    });

    test('add a todo', () async {
      if (await isPresent(signOutButton)) {
        // App is signed in
        await driver.tap(addField);
        await driver.enterText('Integration test TODO');
        await driver.tap(addButton);

        await driver.waitFor(find.text('Integration test TODO'));
      }
    });
  });
}
