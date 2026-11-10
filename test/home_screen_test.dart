import 'package:flutter_test/flutter_test.dart';
import 'package:ilac_takip/screens/home_screen.dart';

void main() {
  test('selamlama günün saatine göre değişir', () {
    String at(int hour) => HomeScreen.greetingFor(DateTime(2026, 1, 1, hour));

    expect(at(5), 'Günaydın!');
    expect(at(10), 'Günaydın!');
    expect(at(11), 'İyi günler!');
    expect(at(16), 'İyi günler!');
    expect(at(17), 'İyi akşamlar!');
    expect(at(21), 'İyi akşamlar!');
    expect(at(22), 'İyi geceler!');
    expect(at(2), 'İyi geceler!');
  });
}
