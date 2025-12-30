class T9Engine {
  // Map of digit to letters
  static const Map<String, String> _keypad = {
    '2': 'abc',
    '3': 'def',
    '4': 'ghi',
    '5': 'jkl',
    '6': 'mno',
    '7': 'pqrs',
    '8': 'tuv',
    '9': 'wxyz',
  };

  // Simple Trie Node
  final _TrieNode _root = _TrieNode();

  void insert(String name, String number) {
    // Normalize name: lowercase, remove non-letters
    final cleanName = name.toLowerCase().replaceAll(RegExp(r'[^a-z]'), '');
    if (cleanName.isEmpty) return;

    // Convert name to T9 digits
    String digits = '';
    for (int i = 0; i < cleanName.length; i++) {
      final char = cleanName[i];
      String? digit;
      for (final entry in _keypad.entries) {
        if (entry.value.contains(char)) {
          digit = entry.key;
          break;
        }
      }
      if (digit != null) {
        digits += digit;
      }
    }

    // Insert into Trie
    _TrieNode current = _root;
    for (int i = 0; i < digits.length; i++) {
      final digit = digits[i];
      if (!current.children.containsKey(digit)) {
        current.children[digit] = _TrieNode();
      }
      current = current.children[digit]!;
      // Store the contact at this node (partial match)
      current.matches.add(ContactMatch(name: name, number: number));
    }
  }

  List<ContactMatch> search(String query) {
    if (query.isEmpty) return [];

    _TrieNode current = _root;
    for (int i = 0; i < query.length; i++) {
      final digit = query[i];
      if (!current.children.containsKey(digit)) {
        return []; // No match
      }
      current = current.children[digit]!;
    }
    return current.matches;
  }
}

class _TrieNode {
  final Map<String, _TrieNode> children = {};
  final List<ContactMatch> matches = [];
}

class ContactMatch {
  final String name;
  final String number;

  ContactMatch({required this.name, required this.number});
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ContactMatch &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          number == other.number;

  @override
  int get hashCode => name.hashCode ^ number.hashCode;
}
