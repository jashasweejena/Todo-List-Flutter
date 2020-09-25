import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:notesfreecodecamp/services/auth.dart';

class MockUser extends Mock implements User {}

final MockUser _mockUser = MockUser();

class MockFirebaseAuth extends Mock implements FirebaseAuth {
  @override
  Stream<User> authStateChanges() {
    return Stream.fromIterable(([_mockUser]));
  }
}

void main() {
  final MockFirebaseAuth mockFirebaseAuth = MockFirebaseAuth();
  final Auth auth = Auth(auth: mockFirebaseAuth);
  setUp(() {});
  tearDown(() {});

  test('emit occurs', () async {
    expectLater(auth.user, emitsInOrder([_mockUser]));
  });

  test('create account', () async {
    when(mockFirebaseAuth.createUserWithEmailAndPassword(
            email: "jashaswee@gmail.com", password: "test12345"))
        .thenAnswer((realInvocation) => null);

    expect(
        await auth.createAccount(
            email: "jashaswee@gmail.com", password: "test12345"),
        'Success');
  });

  test('create account exception', () async {
    when(mockFirebaseAuth.createUserWithEmailAndPassword(
            email: "jashaswee@gmail.com", password: "test12345"))
        .thenAnswer((realInvocation) =>
            throw FirebaseAuthException(message: "You Screwed up!!"));

    expect(
        await auth.createAccount(
            email: "jashaswee@gmail.com", password: "test12345"),
        'You Screwed up!!');
  });

  test('sign in', () async {
    when(mockFirebaseAuth.signInWithEmailAndPassword(
            email: "jashaswee@gmail.com", password: "test12345"))
        .thenAnswer((realInvocation) => null);

    expect(
        await auth.signIn(email: "jashaswee@gmail.com", password: "test12345"),
        'Success');
  });

  test('sign in exception', () async {
    when(mockFirebaseAuth.signInWithEmailAndPassword(
            email: "jashaswee@gmail.com", password: "test12345"))
        .thenAnswer((realInvocation) =>
            throw FirebaseAuthException(message: "You screwed up!!"));

    expect(
        await auth.signIn(email: "jashaswee@gmail.com", password: "test12345"),
        'You screwed up!!');
  });

  test('sign out', () async {
    when(mockFirebaseAuth.signOut()).thenAnswer((realInvocation) => null);
    expect(await auth.signOut(), 'Success');
  });

  test('sign out exception', () async {
    when(mockFirebaseAuth.signOut()).thenAnswer((realInvocation) =>
        throw FirebaseAuthException(message: "You Screwed Up!!"));
    expect(await auth.signOut(), 'You Screwed Up!!');
  });
}
