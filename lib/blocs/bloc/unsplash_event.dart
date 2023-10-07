part of 'unsplash_bloc.dart';

@immutable
sealed class UnsplashEvent {}

final class UnsplashSearchEvent extends UnsplashEvent {
  final String query;

  UnsplashSearchEvent({required this.query});

  @override
  String toString() => 'UnsplashSearchEvent { query: $query }';
}

final class UnsplashMoreImagesEvent extends UnsplashEvent {
  final String query;
  final int page;

  UnsplashMoreImagesEvent({required this.query, required this.page});

  @override
  String toString() => 'UnsplashMoreImagesEvent { query: $query, page: $page }';
}

final class UnsplashDownloadImagesEvent extends UnsplashEvent {
  final List<String> imageUrls;

  UnsplashDownloadImagesEvent({required this.imageUrls});

  @override
  String toString() => 'UnsplashDownloadImagesEvent { imageUrls: $imageUrls }';
}
