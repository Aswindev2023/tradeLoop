import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trade_loop/core/constants/colors.dart';
import 'package:trade_loop/presentation/bloc/image_cubit/image_slider_cubit.dart';

class ImageSliderWidget extends StatelessWidget {
  final List<String> imageUrls;

  const ImageSliderWidget({super.key, required this.imageUrls});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isSingleImage = imageUrls.length <= 1;

    return Column(
      children: [
        BlocBuilder<ImageSliderCubit, int>(
          builder: (context, currentIndex) {
            return Column(
              children: [
                CarouselSlider.builder(
                  itemCount: imageUrls.length,
                  itemBuilder: (context, index, realIndex) {
                    return Image.network(
                      imageUrls[index],
                      width: screenWidth,
                      height: screenHeight * 0.5,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(child: CircularProgressIndicator());
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child:
                              Icon(Icons.broken_image, color: grey, size: 50),
                        );
                      },
                    );
                  },
                  options: CarouselOptions(
                    height: screenHeight * 0.5,
                    viewportFraction: 1.0,
                    autoPlay: !isSingleImage,
                    autoPlayInterval: const Duration(seconds: 3),
                    enableInfiniteScroll: !isSingleImage,
                    scrollPhysics: isSingleImage
                        ? const NeverScrollableScrollPhysics()
                        : const BouncingScrollPhysics(),
                    onPageChanged: (index, reason) {
                      context.read<ImageSliderCubit>().updateIndex(index);
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    imageUrls.length,
                    (index) => Container(
                      width: 8.0,
                      height: 8.0,
                      margin: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 4.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: currentIndex == index ? blueColor : grey,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
