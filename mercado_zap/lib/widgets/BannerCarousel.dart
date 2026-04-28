import 'package:flutter/material.dart';

class BannerCarousel extends StatefulWidget {
  const BannerCarousel({super.key});

  @override
  State<BannerCarousel> createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<BannerCarousel> {
  late final PageController controller;
  static const List<String> images = [
    'lib/assets/banner/image1.png',
    'lib/assets/banner/image2.jpg',
    'lib/assets/banner/image3.png',
    'lib/assets/banner/image4.png',
    'lib/assets/banner/image5.png',
    // 'lib/assets/banner/image5.png',
  ];

  final int initialPage = 1000;

  @override
  void initState() {
    super.initState();

    // controller criado apenas 1x
    // evita recriar toda rebuild
    controller = PageController(
      viewportFraction: 0.85,
      initialPage: initialPage,
    );

    //  pré-carrega imagens depois que tela abre
    // melhora velocidade no primeiro swipe
    WidgetsBinding.instance.addPostFrameCallback((_) {
      for (final image in images) {
        precacheImage(AssetImage(image), context);
      }
    });
  }

  @override
  void dispose() {
    //  libera memória do controller
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
      height: 150,

      child: PageView.builder(
        controller: controller,

        //  scroll mais fluido no Android
        physics: const BouncingScrollPhysics(),

        //  não precisa informar itemCount
        // deixa infinito mesmo
        itemBuilder: (context, index) {
          final currentIndex = index % images.length;

          return Padding(
            padding: const EdgeInsets.all(8),

            child: RepaintBoundary(
              // evita repintar widgets vizinhos
              // melhora FPS no scroll
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),

                child: Image.asset(
                  images[currentIndex],

                  fit: BoxFit.cover,

                  // imagem reduzida pra tela
                  //cacheWidth: 180,

                  //  render mais leve
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
