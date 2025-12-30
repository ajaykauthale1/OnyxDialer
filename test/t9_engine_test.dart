import 'package:flutter_test/flutter_test.dart';
import 'package:onyxdialer/services/t9_engine.dart';

void main() {
  group('T9Engine Tests', () {
    late T9Engine t9Engine;

    setUp(() {
      t9Engine = T9Engine();
    });

    test('Should find contact by name match', () {
      t9Engine.insert('John Doe', '1234567890');
      
      // '5' -> 'j' (John)
      var results = t9Engine.search('5');
      expect(results.any((m) => m.name == 'John Doe'), isTrue);

      // '56' -> 'jo' (John)
      results = t9Engine.search('56');
      expect(results.any((m) => m.name == 'John Doe'), isTrue);
      
      // '564' -> 'joh' (John)
      results = t9Engine.search('564');
      expect(results.any((m) => m.name == 'John Doe'), isTrue);
    });

    test('Should handle multiple matches', () {
      t9Engine.insert('Amy', '111');
      t9Engine.insert('Bob', '222');
      
      // '2' -> 'a' (Amy), 'b' (Bob)
      final results = t9Engine.search('2');
      expect(results.length, 2);
      expect(results.any((m) => m.name == 'Amy'), isTrue);
      expect(results.any((m) => m.name == 'Bob'), isTrue);
    });

    test('Should return empty list for no match', () {
      t9Engine.insert('John', '123');
      
      // '9' -> w,x,y,z (No match for John)
      final results = t9Engine.search('9');
      expect(results, isEmpty);
    });
    
    test('Should ignore special characters in names', () {
      t9Engine.insert('O\'Neil', '555');
      
      // '6' -> 'o'
      // '66' -> 'on'
      final results = t9Engine.search('66');
      expect(results.any((m) => m.name == 'O\'Neil'), isTrue);
    });
  });
}
