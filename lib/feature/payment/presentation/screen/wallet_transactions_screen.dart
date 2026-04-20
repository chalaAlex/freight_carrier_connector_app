import 'package:clean_architecture/core/colors/app_colors.dart';
import 'package:clean_architecture/core/colors/color_scheme.dart';
import 'package:clean_architecture/feature/payment/domain/entity/payment_entity.dart';
import 'package:clean_architecture/feature/payment/presentation/bloc/wallet/wallet_bloc.dart';
import 'package:clean_architecture/feature/payment/presentation/bloc/wallet/wallet_event.dart';
import 'package:clean_architecture/feature/payment/presentation/bloc/wallet/wallet_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class WalletTransactionsScreen extends StatefulWidget {
  const WalletTransactionsScreen({super.key});

  @override
  State<WalletTransactionsScreen> createState() => _WalletTransactionsScreenState();
}

class _WalletTransactionsScreenState extends State<WalletTransactionsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<WalletBloc>().add(const GetWalletTransactionsEvent());
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cs = isDark ? AppColorScheme.dark : AppColorScheme.light;

    return Scaffold(
      backgroundColor: cs.background,
      appBar: AppBar(
        backgroundColor: cs.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: cs.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Transaction History', style: TextStyle(color: cs.textPrimary, fontWeight: FontWeight.bold, fontSize: 18)),
      ),
      body: BlocBuilder<WalletBloc, WalletState>(
        builder: (context, state) {
          if (state is WalletLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is WalletTransactionsLoaded) {
            final txns = state.data.transactions ?? [];
            if (txns.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.receipt_long_outlined, size: 56, color: cs.textSecondary.withValues(alpha: 0.4)),
                    const SizedBox(height: 16),
                    Text('No transactions yet', style: TextStyle(color: cs.textSecondary, fontSize: 16)),
                  ],
                ),
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: txns.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (_, i) => _TransactionCard(tx: txns[i], cs: cs),
            );
          }
          if (state is WalletError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 48, color: AppColors.error),
                  const SizedBox(height: 16),
                  Text(state.message, style: TextStyle(color: cs.textSecondary)),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => context.read<WalletBloc>().add(const GetWalletTransactionsEvent()),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _TransactionCard extends StatelessWidget {
  final WalletTransactionEntity tx;
  final AppColorScheme cs;
  const _TransactionCard({required this.tx, required this.cs});

  @override
  Widget build(BuildContext context) {
    final isCredit = tx.type == 'RELEASE' || tx.type == 'CREDIT';
    final color = isCredit ? AppColors.success : AppColors.error;
    final icon = _iconForType(tx.type);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_labelForType(tx.type), style: TextStyle(color: cs.textPrimary, fontWeight: FontWeight.w600, fontSize: 14)),
                if (tx.description != null) ...[
                  const SizedBox(height: 2),
                  Text(tx.description!, style: TextStyle(color: cs.textSecondary, fontSize: 12), maxLines: 2, overflow: TextOverflow.ellipsis),
                ],
                if (tx.createdAt != null) ...[
                  const SizedBox(height: 4),
                  Text(DateFormat('MMM d, y · HH:mm').format(tx.createdAt!), style: TextStyle(color: cs.textSecondary, fontSize: 11)),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${isCredit ? "+" : "-"}ETB ${tx.amount?.toStringAsFixed(2) ?? "0.00"}',
            style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 15),
          ),
        ],
      ),
    );
  }

  IconData _iconForType(String? type) {
    switch (type) {
      case 'HOLD': return Icons.lock_outline;
      case 'RELEASE': return Icons.check_circle_outline;
      case 'DEBIT': return Icons.arrow_upward;
      case 'CREDIT': return Icons.arrow_downward;
      default: return Icons.swap_horiz;
    }
  }

  String _labelForType(String? type) {
    switch (type) {
      case 'HOLD': return 'Escrow Hold';
      case 'RELEASE': return 'Payment Released';
      case 'DEBIT': return 'Withdrawal';
      case 'CREDIT': return 'Credit';
      default: return type ?? '—';
    }
  }
}
