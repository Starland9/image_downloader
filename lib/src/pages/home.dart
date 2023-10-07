import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_downloader/blocs/bloc/unsplash_bloc.dart';
import 'package:image_downloader/src/pages/download.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Image Downloader'),
        ),
        body: BlocProvider(
          create: (context) =>
              UnsplashBloc()..add(UnsplashSearchEvent(query: 'banane')),
          child: BlocListener<UnsplashBloc, UnsplashState>(
            listener: (context, state) {
              if (state is UnsplashError) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text(
                  "Problem loading images",
                )));
              }
            },
            child: const Column(
              children: [
                SearchView(),
                SizedBox(height: 20),
                Expanded(child: ImagesView()),
              ],
            ),
          ),
        ));
  }
}

class SearchView extends StatefulWidget {
  const SearchView({
    super.key,
  });

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UnsplashBloc, UnsplashState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Rechercher des images...',
                    prefixIcon: Icon(Icons.search),
                  ),
                  keyboardType: TextInputType.name,
                ),
              ),
              IconButton.filledTonal(
                  onPressed: () => context
                      .read<UnsplashBloc>()
                      .add(UnsplashSearchEvent(query: _searchController.text)),
                  icon: const Icon(Icons.send))
            ],
          ),
        );
      },
    );
  }
}

class ImagesView extends StatelessWidget {
  const ImagesView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UnsplashBloc, UnsplashState>(
      builder: (context, state) {
        if (state is UnsplashLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is UnsplashGetImagesLoaded) {
          return GridView.count(
              crossAxisCount: 3,
              children: state.imageUrls
                  .map((e) => GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DownloadImagePage(
                                url: e,
                              ),
                            ),
                          );
                        },
                        child: Hero(
                          transitionOnUserGestures: true,
                          tag: e,
                          child: Image.network(
                            e,
                            filterQuality: FilterQuality.none,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                  child: CircularProgressIndicator(
                                      color: Colors.accents[Random()
                                          .nextInt(Colors.accents.length)]));
                            },
                          ),
                        ),
                      ))
                  .toList());
        }
        return Container();
      },
    );
  }
}
