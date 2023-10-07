part of 'unsplash_bloc.dart';

@immutable
sealed class UnsplashState {}

final class UnsplashInitial extends UnsplashState {}

class UnsplashLoading extends UnsplashState {}

final class UnsplashGetImagesLoaded extends UnsplashState {
  final List<String> imageUrls;

  UnsplashGetImagesLoaded({required this.imageUrls});
}

final class UnsplashDownloadImagesLoaded extends UnsplashState {}

final class UnsplashError extends UnsplashState {}
