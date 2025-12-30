import 'package:flutter_riverpod/flutter_riverpod.dart';

class GodModeNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void unlock() {
    state = true;
  }

  void lock() {
    state = false;
  }
}

final godModeProvider = NotifierProvider<GodModeNotifier, bool>(GodModeNotifier.new);
