// import 'package:clean_architecture/core/colors/app_colors.dart';
// import 'package:clean_architecture/core/colors/color_scheme.dart';
// import 'package:clean_architecture/core/di.dart';
// import 'package:clean_architecture/core/widgets/shimmer_widgets.dart';
// import 'package:clean_architecture/feature/payment/presentation/screen/payment_history_detail_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:dio/dio.dart';

// class PaymentHistoryScreen extends StatefulWidget {
//   const PaymentHistoryScreen({super.key});

//   @override
//   State<PaymentHistoryScreen> createState() => _PaymentHistoryScreenState();
// }

// class _PaymentHistoryScreenState extends State<PaymentHistoryScreen> {
//   List<Map<String, dynamic>> _payments = [];
//   bool _loading = true;
//   String? _error;

//   @override
//   void initState() {
//     super.initState();
//     _load();
//   }

//   Future<void> _load() async {
//     setState(() {
//       _loading = true;
//       _error = null;
//     });
//     try {
//       final response = await sl<Dio>().get('/payments/my-payments');
//       final data = response.data as Map<String, dynamic>;
//       final list = (data['data']?['payments'] as List<dynamic>? ?? [])
//           .cast<Map<String, dynamic>>();
//       setState(() {
//         _payments = list;
//         _loading = false;
//       });
//     } catch (e) {
//       setState(() {
//         _error = e is DioException
//             ? (e.response?.data?['message'] ?? e.message ?? 'Failed to load')
//             : e.toString();
//         _loading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     final cs = isDark ? AppColorScheme.dark : AppColorScheme.light;

//     return Scaffold(
//       backgroundColor: cs.background,
//       appBar: AppBar(
//         backgroundColor: cs.surface,
//         elevation: 0,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: cs.textPrimary),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: Text(
//           'Transaction History',
//           style: TextStyle(
//             color: cs.textPrimary,
//             fontWeight: FontWeight.bold,
//             fontSize: 18,
//           ),
//         ),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.refresh, color: cs.textPrimary),
//             onPressed: _load,
//           ),
//         ],
//       ),
//       body: _buildBody(cs),
//     );
//   }

//   Widget _buildBody(AppColorScheme cs) {
//     if (_loading) return const ListRowShimmer(itemCount: 6);

//     if (_error != null) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.error_outline, size: 48, color: AppColors.error),
//             const SizedBox(height: 16),
//             Text(
//               _error!,
//               style: TextStyle(color: cs.textSecondary),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 16),
//             TextButton(onPressed: _load, child: const Text('Retry')),
//           ],
//         ),
//       );
//     }

//     if (_payments.isEmpty) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               Icons.receipt_long_outlined,
//               size: 56,
//               color: cs.textSecondary.withValues(alpha: 0.4),
//             ),
//             const SizedBox(height: 16),
//             Text(
//               'No transactions yet',
//               style: TextStyle(color: cs.textSecondary, fontSize: 16),
//             ),
//           ],
//         ),
//       );
//     }

//     return ListView.separated(
//       padding: const EdgeInsets.all(16),
//       itemCount: _payments.length,
//       separatorBuilder: (_, __) => const SizedBox(height: 10),
//       itemBuilder: (_, i) => _PaymentCard(
//         payment: _payments[i],
//         cs: cs,
//         onTap: () => Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (_) => PaymentHistoryDetailScreen(payment: _payments[i]),
//           ),
//         ),
//       ),
//     );
//   }
// }

// // ── Simplified card — no TRID ─────────────────────────────────────────────

// class _PaymentCard extends StatelessWidget {
//   final Map<String, dynamic> payment;
//   final AppColorScheme cs;
//   final VoidCallback onTap;
//   const _PaymentCard({
//     required this.payment,
//     required this.cs,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final status = (payment['status'] as String? ?? 'PENDING').toUpperCase();
//     final gateway = (payment['gateway'] as String? ?? '').toUpperCase();
//     final totalAmount = (payment['totalAmount'] as num?)?.toDouble() ?? 0.0;
//     final paidAt = payment['paidAt'] != null
//         ? DateTime.tryParse(payment['paidAt'] as String)
//         : null;
//     final statusColor = _statusColor(status);

//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: cs.surface,
//           borderRadius: BorderRadius.circular(14),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withValues(alpha: 0.05),
//               blurRadius: 8,
//               offset: const Offset(0, 2),
//             ),
//           ],
//         ),
//         child: Row(
//           children: [
//             // Gateway icon circle
//             Container(
//               width: 46,
//               height: 46,
//               decoration: BoxDecoration(
//                 color: _gatewayColor(gateway).withValues(alpha: 0.12),
//                 shape: BoxShape.circle,
//               ),
//               child: Icon(
//                 _gatewayIcon(gateway),
//                 color: _gatewayColor(gateway),
//                 size: 22,
//               ),
//             ),
//             const SizedBox(width: 14),
//             // Middle: gateway name + date
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     gateway.isEmpty ? 'Payment' : gateway,
//                     style: TextStyle(
//                       color: cs.textPrimary,
//                       fontWeight: FontWeight.w600,
//                       fontSize: 14,
//                     ),
//                   ),
//                   const SizedBox(height: 3),
//                   Text(
//                     paidAt != null
//                         ? DateFormat('MMM d, y · HH:mm').format(paidAt)
//                         : 'Pending',
//                     style: TextStyle(color: cs.textSecondary, fontSize: 12),
//                   ),
//                 ],
//               ),
//             ),
//             // Right: amount + status
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: [
//                 Text(
//                   'ETB ${totalAmount.toStringAsFixed(2)}',
//                   style: TextStyle(
//                     color: cs.textPrimary,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 15,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 _StatusBadge(status: status, color: statusColor),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Color _statusColor(String s) {
//     switch (s) {
//       case 'HELD':
//         return const Color(0xFF2196F3);
//       case 'RELEASED':
//         return AppColors.success;
//       case 'DISPUTED':
//         return AppColors.warning;
//       case 'REFUNDED':
//         return AppColors.grey;
//       default:
//         return const Color(0xFFF59E0B);
//     }
//   }

//   Color _gatewayColor(String g) {
//     switch (g) {
//       case 'TELEBIRR':
//         return const Color(0xFF00A651);
//       case 'CBE':
//         return const Color(0xFF003087);
//       case 'CHAPA':
//         return const Color(0xFF1DBF73);
//       default:
//         return AppColors.grey;
//     }
//   }

//   IconData _gatewayIcon(String g) {
//     switch (g) {
//       case 'TELEBIRR':
//         return Icons.phone_android;
//       case 'CBE':
//         return Icons.account_balance;
//       case 'CHAPA':
//         return Icons.credit_card;
//       default:
//         return Icons.payment;
//     }
//   }
// }

// // ── Shared widgets ────────────────────────────────────────────────────────

// class _StatusBadge extends StatelessWidget {
//   final String status;
//   final Color color;
//   const _StatusBadge({required this.status, required this.color});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
//       decoration: BoxDecoration(
//         color: color.withValues(alpha: 0.12),
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: color.withValues(alpha: 0.3)),
//       ),
//       child: Text(
//         status,
//         style: TextStyle(
//           color: color,
//           fontSize: 10,
//           fontWeight: FontWeight.bold,
//           letterSpacing: 0.5,
//         ),
//       ),
//     );
//   }
// }
