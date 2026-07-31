import 'package:clean_architecture/core/colors/app_colors.dart';
import 'package:clean_architecture/core/di.dart';
import 'package:clean_architecture/core/widgets/shimmer_widgets.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CarrierUserReviewAll extends StatefulWidget {
  final String? ownerId;
  const CarrierUserReviewAll({super.key, this.ownerId});

  @override
  State<CarrierUserReviewAll> createState() => _CarrierUserReviewAllState();
}

class _CarrierUserReviewAllState extends State<CarrierUserReviewAll> {
  List<Map<String, dynamic>> _reviews = [];
  bool _loading = true;
  String _sort = 'Most Recent';

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  Future<void> _fetch() async {
    if (widget.ownerId == null) {
      setState(() => _loading = false);
      return;
    }
    try {
      final res = await sl<Dio>().get(
        '/reviews',
        queryParameters: {
          'targetId': widget.ownerId,
          'targetType': 'carrier_owner',
        },
      );
      final data = res.data as Map<String, dynamic>;
      final list = (data['data'] as List<dynamic>? ?? [])
          .cast<Map<String, dynamic>>();
      if (mounted)
        setState(() {
          _reviews = list;
          _loading = false;
        });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  List<Map<String, dynamic>> get _sorted {
    final copy = List<Map<String, dynamic>>.from(_reviews);
    switch (_sort) {
      case 'Highest Rating':
        copy.sort(
          (a, b) => ((b['rating'] as num?) ?? 0).compareTo(
            (a['rating'] as num?) ?? 0,
          ),
        );
        break;
      case 'Lowest Rating':
        copy.sort(
          (a, b) => ((a['rating'] as num?) ?? 0).compareTo(
            (b['rating'] as num?) ?? 0,
          ),
        );
        break;
      default: // Most Recent — already sorted by backend
        break;
    }
    return copy;
  }

  double get _avgRating {
    if (_reviews.isEmpty) return 0;
    final sum = _reviews.fold<double>(
      0,
      (acc, r) => acc + ((r['rating'] as num?)?.toDouble() ?? 0),
    );
    return sum / _reviews.length;
  }

  Map<int, int> get _distribution {
    final dist = {5: 0, 4: 0, 3: 0, 2: 0, 1: 0};
    for (final r in _reviews) {
      final rating = (r['rating'] as num?)?.toInt() ?? 0;
      if (dist.containsKey(rating)) dist[rating] = dist[rating]! + 1;
    }
    return dist;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Reviews and Ratings',
          style: TextStyle(
            color: AppColors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: _loading
          ? const ListRowShimmer(
              itemCount: 6,
              avatarSize: 40,
              showTrailing: true,
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_reviews.isNotEmpty)
                    _RatingSummary(
                      avg: _avgRating,
                      total: _reviews.length,
                      distribution: _distribution,
                    ),
                  const SizedBox(height: 16),
                  _AllReviewsList(
                    reviews: _sorted,
                    sort: _sort,
                    onSortChanged: (s) => setState(() => _sort = s),
                  ),
                ],
              ),
            ),
    );
  }
}

// ── Rating summary ────────────────────────────────────────────────────────────

class _RatingSummary extends StatelessWidget {
  final double avg;
  final int total;
  final Map<int, int> distribution;
  const _RatingSummary({
    required this.avg,
    required this.total,
    required this.distribution,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Column(
              children: [
                Text(
                  avg.toStringAsFixed(1),
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    5,
                    (i) => Icon(
                      i < avg.round() ? Icons.star : Icons.star_border,
                      color: AppColors.warning,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '$total Reviews',
                  style: TextStyle(fontSize: 14, color: AppColors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            flex: 3,
            child: Column(
              children: [5, 4, 3, 2, 1].map((star) {
                final count = distribution[star] ?? 0;
                final pct = total > 0 ? count / total : 0.0;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Text(
                        '$star',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.darkGrey,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Stack(
                          children: [
                            Container(
                              height: 8,
                              decoration: BoxDecoration(
                                color: AppColors.lightGrey,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            FractionallySizedBox(
                              widthFactor: pct,
                              child: Container(
                                height: 8,
                                decoration: BoxDecoration(
                                  color: AppColors.warning,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

// ── All reviews list ──────────────────────────────────────────────────────────

class _AllReviewsList extends StatelessWidget {
  final List<Map<String, dynamic>> reviews;
  final String sort;
  final ValueChanged<String> onSortChanged;
  const _AllReviewsList({
    required this.reviews,
    required this.sort,
    required this.onSortChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'All Reviews',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
              ),
              _FilterButton(sort: sort, onChanged: onSortChanged),
            ],
          ),
          const SizedBox(height: 20),
          if (reviews.isEmpty)
            const Center(
              child: Text(
                'No reviews yet',
                style: TextStyle(color: AppColors.grey),
              ),
            )
          else
            ...reviews.map((r) => _ReviewCard(review: r)),
        ],
      ),
    );
  }
}

class _FilterButton extends StatelessWidget {
  final String sort;
  final ValueChanged<String> onChanged;
  const _FilterButton({required this.sort, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (_) => _SortSheet(current: sort, onChanged: onChanged),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.lightGrey),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.filter_list, size: 16, color: AppColors.darkGrey),
            const SizedBox(width: 6),
            Text(
              sort,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.darkGrey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SortSheet extends StatelessWidget {
  final String current;
  final ValueChanged<String> onChanged;
  const _SortSheet({required this.current, required this.onChanged});

  static const _options = ['Most Recent', 'Highest Rating', 'Lowest Rating'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Sort by',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 16),
          ..._options.map(
            (o) => ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                o,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: o == current
                      ? FontWeight.w600
                      : FontWeight.normal,
                  color: o == current ? AppColors.primary : AppColors.black,
                ),
              ),
              trailing: o == current
                  ? const Icon(Icons.check, color: AppColors.primary)
                  : null,
              onTap: () {
                onChanged(o);
                Navigator.pop(context);
              },
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final Map<String, dynamic> review;
  const _ReviewCard({required this.review});

  @override
  Widget build(BuildContext context) {
    final rating = (review['rating'] as num?)?.toDouble() ?? 0;
    final comment = review['comment'] as String? ?? '';
    final reviewer = review['reviewerId'] as Map<String, dynamic>?;
    final firstName = reviewer?['firstName'] as String? ?? '';
    final lastName = reviewer?['lastName'] as String? ?? '';
    final name = '$firstName $lastName'.trim().isEmpty
        ? 'Anonymous'
        : '$firstName $lastName'.trim();
    final initials = name.isNotEmpty ? name[0].toUpperCase() : '?';
    final createdAt = review['createdAt'] != null
        ? DateTime.tryParse(review['createdAt'] as String)
        : null;
    final dateStr = createdAt != null
        ? DateFormat('MMM d, y').format(createdAt)
        : '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: AppColors.primary.withValues(alpha: 0.12),
              child: Text(
                initials,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.black,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          rating.toStringAsFixed(1),
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.black,
                          ),
                        ),
                        const SizedBox(width: 2),
                        const Icon(
                          Icons.star,
                          size: 13,
                          color: AppColors.warning,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (dateStr.isNotEmpty) ...[
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(left: 52),
            child: Text(
              dateStr,
              style: const TextStyle(fontSize: 12, color: AppColors.grey),
            ),
          ),
        ],
        if (comment.isNotEmpty) ...[
          const SizedBox(height: 10),
          Text(
            comment,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.darkGrey,
              height: 1.5,
            ),
          ),
        ],
        const Divider(height: 28),
      ],
    );
  }
}
