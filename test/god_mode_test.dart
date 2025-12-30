import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:onyxdialer/providers/god_mode_provider.dart';

void main() {
  test('God Mode starts locked', () {
    final container = ProviderContainer();
    expect(container.read(godModeProvider), false);
  });

  test('God Mode can be unlocked', () {
    final container = ProviderContainer();
    container.read(godModeProvider.notifier).unlock();
    expect(container.read(godModeProvider), true);
  });

  test('God Mode can be locked', () {
    final container = ProviderContainer();
    container.read(godModeProvider.notifier).unlock();
    container.read(godModeProvider.notifier).lock();
    expect(container.read(godModeProvider), false);
  });
}
