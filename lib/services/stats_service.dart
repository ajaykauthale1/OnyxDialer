import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/god_mode_provider.dart';
import 'vault_service.dart';

class CallStats {
  final int totalCalls;
  final int incoming;
  final int outgoing;
  final int missed;

  CallStats({
    required this.totalCalls,
    required this.incoming,
    required this.outgoing,
    required this.missed,
  });
}

final statsServiceProvider = FutureProvider<CallStats>((ref) async {
  final isGodMode = ref.watch(godModeProvider);
  
  if (isGodMode) {
    // Fetch from Vault
    final vaultService = ref.read(vaultServiceProvider);
    final logs = await vaultService.getAllCallLogs();
    
    int incoming = 0;
    int outgoing = 0;
    int missed = 0;

    for (var log in logs) {
      // Assuming 1=Incoming, 2=Outgoing, 3=Missed (Standard Android types)
      if (log.type == 1) incoming++;
      else if (log.type == 2) outgoing++;
      else if (log.type == 3) missed++;
    }

    return CallStats(
      totalCalls: logs.length,
      incoming: incoming,
      outgoing: outgoing,
      missed: missed,
    );
  } else {
    // Fetch from System (Placeholder - normally use CallLog plugin)
    // For now, return dummy public stats
    return CallStats(
      totalCalls: 10,
      incoming: 5,
      outgoing: 3,
      missed: 2,
    );
  }
});
