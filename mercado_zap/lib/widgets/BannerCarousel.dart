import 'package:flutter/material.dart';

class BannerCarousel extends StatelessWidget {
  const BannerCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    final int initialPage = 1000;
    final PageController controller = PageController(
      viewportFraction: 0.85,
      initialPage: initialPage,
    );

    final images = [
      'lib/assets/banner/image1.png',
      'lib/assets/banner/image2.jpg',
      'lib/assets/banner/image3.png',
      'lib/assets/banner/image4.png',
    ];

    if (images.isEmpty) {
      return const SizedBox(
        height: 150,
        child: Center(child: Text('Nenhum banner')),
      );
    }

    return SizedBox(
      height: 150,

      child: PageView.builder(
        controller: controller,
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          final currentIndex = index % images.length; //ciclo infinito

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(images[currentIndex], fit: BoxFit.cover),
            ),
          );
        },
      ),
    );
  }
}
