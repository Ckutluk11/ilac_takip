import 'dart:async';

import 'auth_service.dart';

/// Firebase bağlanana kadar kullanılan sahte servis.
///
/// Her işlem [delay] kadar bekler (gerçek ağ isteğini taklit eder) ve
/// her zaman başarılı olur. Kullanıcılar yalnızca bellekte tutulur;
/// uygulama kapanınca silinir.
class FakeAuthService implements AuthService {
  FakeAuthService({this.delay = const Duration(seconds: 1)});

  final Duration delay;

  final _controller = StreamController<AppUser?>.broadcast();
  final Map<String, String> _namesByEmail = {};
  AppUser? _currentUser;
  int _nextId = 1;

  @override
  AppUser? get currentUser => _currentUser;

  @override
  Stream<AppUser?> authStateChanges() async* {
    yield _currentUser;
    yield* _controller.stream;
  }

  @override
  Future<AppUser> signIn({
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(delay);
    final normalized = _normalize(email);
    // Bu oturumda kayıt olunmuşsa gerçek adı, olmamışsa e-postanın
    // @ öncesini ad olarak kullan.
    final name = _namesByEmail[normalized] ?? normalized.split('@').first;
    return _setUser(name: name, email: normalized);
  }

  @override
  Future<AppUser> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(delay);
    final normalized = _normalize(email);
    _namesByEmail[normalized] = name.trim();
    return _setUser(name: name.trim(), email: normalized);
  }

  @override
  Future<void> sendPasswordReset(String email) async {
    await Future<void>.delayed(delay);
  }

  @override
  Future<void> signOut() async {
    _currentUser = null;
    _controller.add(null);
  }

  void dispose() => _controller.close();

  AppUser _setUser({required String name, required String email}) {
    final user = AppUser(id: 'fake-${_nextId++}', name: name, email: email);
    _currentUser = user;
    _controller.add(user);
    return user;
  }

  String _normalize(String email) => email.trim().toLowerCase();
}
