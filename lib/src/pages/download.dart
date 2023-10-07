import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_downloader/blocs/bloc/unsplash_bloc.dart';

class DownloadImagePage extends StatelessWidget {
  const DownloadImagePage({super.key, required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UnsplashBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Image Downloader'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Hero(tag: url, child: Image.network(url)),
              const Divider(),
              BlocConsumer<UnsplashBloc, UnsplashState>(
                listener: (context, state) {
                  if (state is UnsplashError) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                      "Problem downlaoding images",
                    )));
                  }

                  if (state is UnsplashDownloadImagesLoaded) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                      "Image downloaded",
                    )));
                  }
                },
                builder: (context, state) {
                  return IconButton.filledTonal(
                      onPressed: () => context
                          .read<UnsplashBloc>()
                          .add(UnsplashDownloadImagesEvent(imageUrls: [url])),
                      icon: const Icon(Icons.download));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
