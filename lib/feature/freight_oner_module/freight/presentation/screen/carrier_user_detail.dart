import 'package:clean_architecture/cofig/routes_manager.dart';
import 'package:clean_architecture/core/colors/app_colors.dart';
import 'package:clean_architecture/core/di.dart';
import 'package:clean_architecture/core/widgets/shimmer_widgets.dart';
import 'package:clean_architecture/feature/chat/domain/usecases/get_or_create_room_usecase.dart';
import 'package:clean_architecture/feature/chat/presentation/screens/chat_room_screen.dart';
import 'package:clean_architecture/feature/freight_oner_module/freight/domain/entity/truck_detail_entity.dart';
import 'package:clean_architecture/feature/freight_oner_module/signup/presentation/bloc/login/login_bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class CarrierUserDetail extends StatefulWidget {
  final TruckOwnerEntity? owner;
  const CarrierUserDetail({super.key, this.owner});

  @override
  State<CarrierUserDetail> createState() => _CarrierUserDetailState();
}

class _CarrierUserDetailState extends State<CarrierUserDetail> {
  List<Map<String, dynamic>> _reviews = [];
  List<Map<String, dynamic>> _carriers = [];
  bool _loadingReviews = true;
  bool _loadingCarriers = true;
  bool _messagingLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.owner?.id != null) {
      _fetchReviews(widget.owner!.id!);
      _fetchCarriers(widget.owner!.id!);
    } else {
      setState(() {
        _loadingReviews = false;
        _loadingCarriers = false;
      });
    }
  }

  Future<void> _fetchReviews(String ownerId) async {
    try {
      final res = await sl<Dio>().get(
        '/reviews',
        queryParameters: {'targetId': ownerId, 'targetType': 'carrier_owner'},
      );
      final data = res.data as Map<String, dynamic>;
      final list = (data['data'] as List<dynamic>? ?? [])
          .cast<Map<String, dynamic>>();
      if (mounted)
        setState(() {
          _reviews = list;
          _loadingReviews = false;
        });
    } catch (_) {
      if (mounted) setState(() => _loadingReviews = false);
    }
  }

  Future<void> _fetchCarriers(String ownerId) async {
    try {
      final res = await sl<Dio>().get(
        '/carrier',
        queryParameters: {'truckOwner': ownerId},
      );
      final data = res.data as Map<String, dynamic>;
      final list =
          ((data['data']?['carrier'] ?? data['data']?['carriers'])
                      as List<dynamic>? ??
                  [])
              .cast<Map<String, dynamic>>();
      if (mounted)
        setState(() {
          _carriers = list;
          _loadingCarriers = false;
        });
    } catch (_) {
      if (mounted) setState(() => _loadingCarriers = false);
    }
  }

  Future<void> _openChat() async {
    final ownerId = widget.owner?.id;
    if (ownerId == null) return;
    setState(() => _messagingLoading = true);
    final result = await sl<GetOrCreateRoomUseCase>().call(ownerId);
    if (!mounted) return;
    setState(() => _messagingLoading = false);
    result.fold(
      (failure) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(failure.message),
          backgroundColor: AppColors.error,
        ),
      ),
      (room) {
        final uid = context.read<LoginBloc>().state.user?.data?.id;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ChatRoomScreen(
              roomId: room.id,
              otherParticipantName:
                  '${widget.owner?.firstName ?? ''} ${widget.owner?.lastName ?? ''}'
                      .trim(),
              currentUserId: uid,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final owner = widget.owner;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF121212) : AppColors.background;
    final surface = isDark ? const Color(0xFF1E1E1E) : AppColors.white;
    final textPrimary = isDark ? Colors.white : AppColors.black;
    final textSecondary = isDark ? Colors.white54 : AppColors.grey;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Owner Profile',
          style: TextStyle(
            color: textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ProfileHeader(
              owner: owner,
              surface: surface,
              textPrimary: textPrimary,
              textSecondary: textSecondary,
            ),
            const SizedBox(height: 16),
            _TrucksSection(
              carriers: _carriers,
              loading: _loadingCarriers,
              surface: surface,
              textPrimary: textPrimary,
              textSecondary: textSecondary,
            ),
            const SizedBox(height: 16),
            _ReviewsSection(
              reviews: _reviews,
              loading: _loadingReviews,
              ownerId: owner?.id,
              surface: surface,
              textPrimary: textPrimary,
              textSecondary: textSecondary,
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
      bottomSheet: _MessageButton(
        loading: _messagingLoading,
        surface: surface,
        onTap: _openChat,
      ),
    );
  }
}

// ── Profile header ────────────────────────────────────────────────────────────

class _ProfileHeader extends StatelessWidget {
  final TruckOwnerEntity? owner;
  final Color surface, textPrimary, textSecondary;
  const _ProfileHeader({
    required this.owner,
    required this.surface,
    required this.textPrimary,
    required this.textSecondary,
  });

  String get _initials {
    final f = owner?.firstName ?? '';
    final l = owner?.lastName ?? '';
    return '${f.isNotEmpty ? f[0] : ''}${l.isNotEmpty ? l[0] : ''}'
        .toUpperCase();
  }

  String get _memberSince {
    final dt = owner?.createdAt;
    if (dt == null) return '';
    return 'Member since ${dt.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: surface,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: AppColors.primary.withValues(alpha: 0.12),
            child: Text(
              _initials.isEmpty ? '?' : _initials,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '${owner?.firstName ?? ''} ${owner?.lastName ?? ''}'.trim().isEmpty
                ? 'Carrier Owner'
                : '${owner?.firstName ?? ''} ${owner?.lastName ?? ''}'.trim(),
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.star, color: AppColors.warning, size: 20),
              const SizedBox(width: 4),
              Text(
                (owner?.ratingAverage ?? 0.0).toStringAsFixed(1),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: textPrimary,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '• ${owner?.ratingQuantity?.toInt() ?? 0} reviews',
                style: TextStyle(fontSize: 14, color: textSecondary),
              ),
            ],
          ),
          if (_memberSince.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              _memberSince,
              style: TextStyle(fontSize: 14, color: textSecondary),
            ),
          ],
        ],
      ),
    );
  }
}

// ── Trucks section ────────────────────────────────────────────────────────────

class _TrucksSection extends StatelessWidget {
  final List<Map<String, dynamic>> carriers;
  final bool loading;
  final Color surface, textPrimary, textSecondary;
  const _TrucksSection({
    required this.carriers,
    required this.loading,
    required this.surface,
    required this.textPrimary,
    required this.textSecondary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: surface,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Available Trucks',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textPrimary,
                ),
              ),
              if (!loading)
                Text(
                  '${carriers.length} Total',
                  style: TextStyle(fontSize: 14, color: textSecondary),
                ),
            ],
          ),
          const SizedBox(height: 16),
          if (loading)
            const SizedBox(
              height: 180,
              child: CarrierCardListShimmer(itemCount: 2),
            )
          else if (carriers.isEmpty)
            Text('No trucks available', style: TextStyle(color: textSecondary))
          else
            SizedBox(
              height: 180,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: carriers.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (ctx, i) {
                  final c = carriers[i];
                  final images =
                      (c['image'] as List<dynamic>?)?.cast<String>() ?? [];
                  final model = c['model'] as String? ?? '—';
                  final brand = c['brand'] as String? ?? '';
                  final capacity = c['loadCapacity'];
                  final carrierId = (c['_id'] as String?) ?? '';
                  return GestureDetector(
                    onTap: () => Navigator.pushNamed(
                      ctx,
                      Routes.truckDetailRoute,
                      arguments: carrierId,
                    ),
                    child: Container(
                      width: 160,
                      decoration: BoxDecoration(
                        color: AppColors.lightGrey,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(12),
                            ),
                            child: images.isNotEmpty
                                ? Image.network(
                                    images.first,
                                    height: 100,
                                    width: 160,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) =>
                                        _truckPlaceholder(),
                                  )
                                : _truckPlaceholder(),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '$brand $model'.trim(),
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                if (capacity != null)
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.scale,
                                        size: 13,
                                        color: AppColors.primary,
                                      ),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          '$capacity kg',
                                          style: const TextStyle(
                                            fontSize: 11,
                                            color: AppColors.grey,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _truckPlaceholder() => Container(
    height: 100,
    width: 160,
    color: AppColors.primary.withValues(alpha: 0.1),
    child: const Icon(Icons.local_shipping, size: 40, color: AppColors.primary),
  );
}

// ── Reviews section ───────────────────────────────────────────────────────────

class _ReviewsSection extends StatelessWidget {
  final List<Map<String, dynamic>> reviews;
  final bool loading;
  final String? ownerId;
  final Color surface, textPrimary, textSecondary;
  const _ReviewsSection({
    required this.reviews,
    required this.loading,
    required this.ownerId,
    required this.surface,
    required this.textPrimary,
    required this.textSecondary,
  });

  @override
  Widget build(BuildContext context) {
    // Show at most 2 reviews; "View all" navigates with the ownerId
    final preview = reviews.take(2).toList();

    return Container(
      color: surface,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Reviews',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textPrimary,
                ),
              ),
              if (!loading && reviews.isNotEmpty)
                TextButton(
                  onPressed: () => Navigator.pushNamed(
                    context,
                    Routes.viewAllReiviews,
                    arguments: ownerId,
                  ),
                  child: const Text(
                    'View all',
                    style: TextStyle(color: AppColors.primary),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          if (loading)
            const ListRowShimmer(
              itemCount: 2,
              avatarSize: 32,
              showTrailing: false,
            )
          else if (reviews.isEmpty)
            Text('No reviews yet', style: TextStyle(color: textSecondary))
          else
            ...preview.map(
              (r) => _ReviewCard(
                review: r,
                textPrimary: textPrimary,
                textSecondary: textSecondary,
              ),
            ),
        ],
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final Map<String, dynamic> review;
  final Color textPrimary, textSecondary;
  const _ReviewCard({
    required this.review,
    required this.textPrimary,
    required this.textSecondary,
  });

  @override
  Widget build(BuildContext context) {
    final rating = (review['rating'] as num?)?.toInt() ?? 0;
    final comment = review['comment'] as String? ?? '';
    final reviewer = review['reviewerId'] as Map<String, dynamic>?;
    final firstName = reviewer?['firstName'] as String? ?? '';
    final lastName = reviewer?['lastName'] as String? ?? '';
    final name = '$firstName $lastName'.trim().isEmpty
        ? 'Anonymous'
        : '$firstName $lastName'.trim();
    final createdAt = review['createdAt'] != null
        ? DateTime.tryParse(review['createdAt'] as String)
        : null;
    final dateStr = createdAt != null
        ? DateFormat('MMM d, y').format(createdAt)
        : '';

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: List.generate(
              5,
              (i) => Icon(
                i < rating ? Icons.star : Icons.star_border,
                color: AppColors.warning,
                size: 18,
              ),
            ),
          ),
          if (comment.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              '"$comment"',
              style: TextStyle(fontSize: 14, color: textPrimary, height: 1.5),
            ),
          ],
          const SizedBox(height: 10),
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.lightGrey,
                child: Text(
                  name[0].toUpperCase(),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  name,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: textPrimary,
                  ),
                ),
              ),
              if (dateStr.isNotEmpty)
                Text(
                  dateStr,
                  style: TextStyle(fontSize: 11, color: textSecondary),
                ),
            ],
          ),
          const Divider(height: 24),
        ],
      ),
    );
  }
}

// ── Message button ────────────────────────────────────────────────────────────

class _MessageButton extends StatelessWidget {
  final bool loading;
  final Color surface;
  final VoidCallback onTap;
  const _MessageButton({
    required this.loading,
    required this.surface,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton.icon(
            onPressed: loading ? null : onTap,
            icon: loading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.message, size: 20),
            label: Text(
              loading ? 'Opening chat…' : 'Message Owner',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
          ),
        ),
      ),
    );
  }
}
