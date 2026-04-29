import 'package:clean_architecture/cofig/context_extensions.dart';
import 'package:clean_architecture/core/colors/app_colors.dart';
import 'package:clean_architecture/core/di.dart';
import 'package:clean_architecture/feature/carrier_owner_module/bids/domain/entity/get_bid_entity.dart';
import 'package:clean_architecture/feature/carrier_owner_module/bids/presentation/bloc/bid_bloc.dart';
import 'package:clean_architecture/feature/carrier_owner_module/bids/presentation/bloc/bid_event.dart';
import 'package:clean_architecture/feature/carrier_owner_module/bids/presentation/bloc/bid_state.dart';
import 'package:clean_architecture/feature/chat/domain/usecases/get_or_create_room_usecase.dart';
import 'package:clean_architecture/feature/chat/presentation/screens/chat_room_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BidDetailScreen extends StatelessWidget {
  final String bidId;
  const BidDetailScreen({super.key, required this.bidId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<BidBloc>()..add(FetchBid(bidId)),
      child: _BidDetailView(bidId: bidId),
    );
  }
}

class _BidDetailView extends StatelessWidget {
  final String bidId;
  const _BidDetailView({required this.bidId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Bid Details',
          style: context.text.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: AppColors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: BlocConsumer<BidBloc, BidState>(
        listener: (context, state) {
          if (state is BidActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.success,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
          if (state is BidError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is BidLoading ||
              state is BidInitial ||
              state is BidActionLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is BidError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 48,
                    color: AppColors.grey,
                  ),
                  const SizedBox(height: 12),
                  Text(state.message, textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Go Back'),
                  ),
                ],
              ),
            );
          }
          final bid = state is BidDetailLoaded
              ? state.bid
              : state is BidActionSuccess
              ? state.bid
              : null;
          if (bid != null) return _BidDetailBody(bid: bid, bidId: bidId);
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _BidDetailBody extends StatelessWidget {
  final GetBidDetailEntity bid;
  final String bidId;
  const _BidDetailBody({required this.bid, required this.bidId});

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(bid.status ?? 'PENDING');

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: statusColor.withValues(alpha: 0.4),
                    ),
                  ),
                  child: Text(
                    bid.status ?? 'PENDING',
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Bid amount card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 28,
                    horizontal: 20,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEF2FF),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'CURRENT BID AMOUNT',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            bid.bidAmount?.toStringAsFixed(0) ?? '—',
                            style: const TextStyle(
                              fontSize: 52,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF111111),
                              height: 1,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Padding(
                            padding: EdgeInsets.only(bottom: 8),
                            child: Text(
                              'ETB',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.7),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.access_time_rounded,
                              size: 14,
                              color: AppColors.grey,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Valid for 24 more hours',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Message card
                if (bid.message != null && bid.message!.isNotEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.chat_bubble_outline_rounded,
                                size: 16,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Message from Carrier',
                              style: context.text.titleSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '"${bid.message}"',
                          style: TextStyle(
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                            color: Colors.grey[700],
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 16),

                // Freight owner card
                if (bid.freightOwner != null)
                  _FreightOwnerCard(owner: bid.freightOwner!),
              ],
            ),
          ),
        ),

        // Bottom action bar
        _BottomActionBar(bid: bid, bidId: bidId),
      ],
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'PENDING':
        return const Color(0xFFF59E0B);
      case 'ACCEPTED':
        return const Color(0xFF10B981);
      case 'REJECTED':
        return const Color(0xFFEF4444);
      case 'CANCELLED':
        return const Color(0xFF6B7280);
      default:
        return const Color(0xFF6B7280);
    }
  }
}

class _FreightOwnerCard extends StatelessWidget {
  final GetBidFreightOwnerEntity owner;
  const _FreightOwnerCard({required this.owner});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // Avatar
          Stack(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                backgroundImage: owner.profileImage != null
                    ? NetworkImage(owner.profileImage!)
                    : null,
                child: owner.profileImage == null
                    ? Text(
                        (owner.firstName?.isNotEmpty == true)
                            ? owner.firstName![0].toUpperCase()
                            : '?',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      )
                    : null,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: AppColors.success,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 14),

          // Name + rating
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  owner.fullName.isNotEmpty ? owner.fullName : 'Freight Owner',
                  style: context.text.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      size: 16,
                      color: Color(0xFFF59E0B),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      owner.ratingAverage?.toStringAsFixed(1) ?? '—',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                    if (owner.ratingQuantity != null) ...[
                      const SizedBox(width: 4),
                      Text(
                        '(${owner.ratingQuantity} shipments)',
                        style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),

          // Profile button
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: const BorderSide(color: AppColors.primary),
              ),
            ),
            child: const Text(
              'View Profile',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomActionBar extends StatelessWidget {
  final GetBidDetailEntity bid;
  final String bidId;
  const _BottomActionBar({required this.bid, required this.bidId});

  @override
  Widget build(BuildContext context) {
    final isPending = bid.status == 'PENDING';

    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        12,
        16,
        MediaQuery.of(context).padding.bottom + 12,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFEEEEF8))),
      ),
      child: Row(
        children: [
          // Chat button
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFF0F0FA),
              borderRadius: BorderRadius.circular(14),
            ),
            child: IconButton(
              icon: const Icon(Icons.chat_bubble_outline_rounded, size: 20),
              color: AppColors.grey,
              onPressed: () => _onChat(context),
            ),
          ),
          const SizedBox(width: 12),

          // Reject
          Expanded(
            child: SizedBox(
              height: 48,
              child: OutlinedButton(
                onPressed: isPending ? () => _onReject(context) : null,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.error,
                  side: BorderSide(
                    color: isPending
                        ? AppColors.error
                        : AppColors.error.withValues(alpha: 0.3),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Reject Bid',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Accept
          Expanded(
            child: SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: isPending ? () => _onAccept(context) : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: AppColors.primary.withValues(
                    alpha: 0.4,
                  ),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Accept Bid',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onAccept(BuildContext context) {
    context.read<BidBloc>().add(AcceptBid(bidId));
  }

  void _onReject(BuildContext context) {
    context.read<BidBloc>().add(RejectBid(bidId));
  }

  Future<void> _onChat(BuildContext context) async {
    final otherUserId = bid.carrierOwnerId;
    if (otherUserId == null) return;

    final result = await sl<GetOrCreateRoomUseCase>().call(otherUserId);
    if (!context.mounted) return;

    result.fold(
      (failure) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(failure.message),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      ),
      (room) => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ChatRoomScreen(
            roomId: room.id,
            otherParticipantName: 'Carrier Owner',
          ),
        ),
      ),
    );
  }
}
