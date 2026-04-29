import 'package:clean_architecture/cofig/routes_manager.dart';
import 'package:clean_architecture/core/colors/app_colors.dart';
import 'package:clean_architecture/core/colors/color_scheme.dart';
import 'package:clean_architecture/feature/payment/domain/entity/payment_entity.dart';
import 'package:clean_architecture/feature/payment/presentation/bloc/wallet/wallet_bloc.dart';
import 'package:clean_architecture/feature/payment/presentation/bloc/wallet/wallet_event.dart';
import 'package:clean_architecture/feature/payment/presentation/bloc/wallet/wallet_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  @override
  void initState() {
    super.initState();
    context.read<WalletBloc>().add(GetWalletEvent());
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cs = isDark ? AppColorScheme.dark : AppColorScheme.light;

    return Scaffold(
      backgroundColor: cs.background,
      body: SafeArea(
        child: BlocConsumer<WalletBloc, WalletState>(
          listener: (context, state) {
            if (state is WithdrawalRequested) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Withdrawal request submitted!'), backgroundColor: Color(0xFF22C55E)),
              );
              context.read<WalletBloc>().add(GetWalletEvent());
            } else if (state is WalletError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message), backgroundColor: AppColors.error),
              );
            }
          },
          builder: (context, state) {
            if (state is WalletLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is WalletLoaded) {
              return _WalletBody(wallet: state.wallet, cs: cs);
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
                      onPressed: () => context.read<WalletBloc>().add(GetWalletEvent()),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class _WalletBody extends StatelessWidget {
  final WalletEntity wallet;
  final AppColorScheme cs;
  const _WalletBody({required this.wallet, required this.cs});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Text('My Wallet', style: TextStyle(color: cs.textPrimary, fontSize: 22, fontWeight: FontWeight.bold)),
          ),
          // Balance card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.primary.withValues(alpha: 0.75)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Available Balance', style: TextStyle(color: Colors.white70, fontSize: 13, letterSpacing: 0.5)),
                const SizedBox(height: 8),
                Text(
                  'ETB ${wallet.balance?.toStringAsFixed(2) ?? "0.00"}',
                  style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _BalancePill(
                      label: 'Pending',
                      value: 'ETB ${wallet.pendingBalance?.toStringAsFixed(2) ?? "0.00"}',
                    ),
                    const SizedBox(width: 12),
                    _BalancePill(label: 'Currency', value: wallet.currency ?? 'ETB'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Action buttons
          Row(
            children: [
              Expanded(
                child: _ActionButton(
                  icon: Icons.arrow_upward,
                  label: 'Withdraw',
                  color: AppColors.primary,
                  onTap: () => _showWithdrawDialog(context),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ActionButton(
                  icon: Icons.receipt_long_outlined,
                  label: 'Transactions',
                  color: AppColors.secondary,
                  onTap: () => Navigator.pushNamed(context, Routes.walletTransactions),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text('Recent Activity', style: TextStyle(color: cs.textPrimary, fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          BlocBuilder<WalletBloc, WalletState>(
            builder: (context, state) {
              if (state is WalletTransactionsLoaded) {
                final txns = state.data.transactions ?? [];
                if (txns.isEmpty) {
                  return Center(child: Text('No transactions yet', style: TextStyle(color: cs.textSecondary)));
                }
                return Column(
                  children: txns.take(5).map((t) => _TransactionTile(tx: t, cs: cs)).toList(),
                );
              }
              return TextButton(
                onPressed: () => context.read<WalletBloc>().add(const GetWalletTransactionsEvent()),
                child: const Text('Load transactions'),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showWithdrawDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Request Withdrawal'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Available: ETB ${wallet.balance?.toStringAsFixed(2) ?? "0.00"}',
                style: const TextStyle(fontSize: 13, color: Colors.grey)),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Amount (ETB)',
                border: OutlineInputBorder(),
                prefixText: 'ETB ',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final amount = double.tryParse(controller.text);
              if (amount != null && amount > 0) {
                Navigator.pop(context);
                context.read<WalletBloc>().add(RequestWithdrawalEvent(amount));
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: const Text('Submit', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class _BalancePill extends StatelessWidget {
  final String label;
  final String value;
  const _BalancePill({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text('$label: $value', style: const TextStyle(color: Colors.white, fontSize: 12)),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _ActionButton({required this.icon, required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 26),
            const SizedBox(height: 6),
            Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 13)),
          ],
        ),
      ),
    );
  }
}

class _TransactionTile extends StatelessWidget {
  final WalletTransactionEntity tx;
  final AppColorScheme cs;
  const _TransactionTile({required this.tx, required this.cs});

  @override
  Widget build(BuildContext context) {
    final isCredit = tx.type == 'RELEASE' || tx.type == 'CREDIT';
    final color = isCredit ? AppColors.success : AppColors.error;
    final icon = isCredit ? Icons.arrow_downward : Icons.arrow_upward;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 4)],
      ),
      child: Row(
        children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(tx.type ?? '—', style: TextStyle(color: cs.textPrimary, fontWeight: FontWeight.w600, fontSize: 13)),
                if (tx.description != null)
                  Text(tx.description!, style: TextStyle(color: cs.textSecondary, fontSize: 11), maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          Text(
            '${isCredit ? "+" : "-"}ETB ${tx.amount?.toStringAsFixed(2) ?? "0.00"}',
            style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
