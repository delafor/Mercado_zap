import 'package:flutter/material.dart';

class BannerCarousel extends StatefulWidget {
  const BannerCarousel({super.key});

  @override
  State<BannerCarousel> createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<BannerCarousel> {
  late final PageController controller;
  static const List<String> images = [
    'assets/banner/image2.jpg',

    'assets/banner/image4.png',
    'assets/banner/image5.png',
  
  ];

  final int initialPage = 1000;

  @override
  void initState() {
    super.initState();

    
    controller = PageController(
      viewportFraction: 0.85,
      initialPage: initialPage,
    );


    WidgetsBinding.instance.addPostFrameCallback((_) async {
      for (final image in images) {
        try {
          print('PRECACHE: $image');

          await precacheImage(AssetImage(image), context);

          print('OK: $image');
        } catch (e) {
          print('ERRO NA IMAGEM: $image');
          print(e);
        }
      }
    });
  }

  @override
  void dispose() {
    
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) {
      return const SizedBox(
        height: 150,
        child: Center(child: const Text('Nenhum banner')),
      );
    }

    return SizedBox(
      height: 160,

      child: PageView.builder(
        controller: controller,

  
        physics: const BouncingScrollPhysics(),

      
        itemBuilder: (context, index) {
          final currentIndex = index % images.length;

          return Padding(
            padding: const EdgeInsets.all(8),

            child: RepaintBoundary(
       
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),

                child: Image.asset(
                  images[currentIndex],

                  fit: BoxFit.cover,

            
                  filterQuality: FilterQuality.medium,

                  errorBuilder: (_, __, ___) {
                    return Container(
                      color: Colors.grey.shade300,
                      child: const Icon(Icons.image_not_supported),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
