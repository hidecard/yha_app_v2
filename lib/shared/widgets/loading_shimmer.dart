import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:yha/core/theme/app_colors.dart';

class LoadingShimmer extends StatelessWidget {
  const LoadingShimmer({super.key, this.height = 16, this.width = double.infinity, this.radius = 8});
  final double height;
  final double width;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.border,
      highlightColor: Colors.white,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(radius)),
      ),
    );
  }
}

class CourseCardShimmer extends StatelessWidget {
  const CourseCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          LoadingShimmer(height: 140, radius: 0),
          Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LoadingShimmer(height: 14, width: 80),
                SizedBox(height: 8),
                LoadingShimmer(height: 18),
                SizedBox(height: 8),
                LoadingShimmer(height: 14, width: 120),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProjectCardShimmer extends StatelessWidget {
  const ProjectCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return const Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LoadingShimmer(height: 140, radius: 0),
          Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LoadingShimmer(height: 18),
                SizedBox(height: 8),
                LoadingShimmer(height: 14, width: 140),
                SizedBox(height: 6),
                LoadingShimmer(height: 14, width: 100),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
