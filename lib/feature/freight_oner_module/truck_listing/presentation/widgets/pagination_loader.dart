import 'package:flutter/material.dart';
import 'package:clean_architecture/cofig/size_manager.dart';

/// A loading indicator widget displayed at the bottom of the truck list
/// during pagination loading.
///
/// Shows a centered [CircularProgressIndicator] with appropriate padding
/// to indicate that more trucks are being loaded.
class PaginationLoader extends StatelessWidget {
  const PaginationLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeManager.paginationLoaderHeight,
      padding: const EdgeInsets.all(SizeManager.s16),
      alignment: Alignment.center,
      child: const CircularProgressIndicator(),
    );
  }
}
