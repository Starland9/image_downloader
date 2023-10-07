import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:image_downloader/services/unsplash_downloader.dart';
import 'package:meta/meta.dart';

part 'unsplash_event.dart';
part 'unsplash_state.dart';

class UnsplashBloc extends Bloc<UnsplashEvent, UnsplashState> {
  UnsplashBloc() : super(UnsplashInitial()) {
    on<UnsplashSearchEvent>(_searchImages);
    on<UnsplashMoreImagesEvent>(_moreImages);
    on<UnsplashDownloadImagesEvent>(_downloadImages);
  }

  FutureOr<void> _searchImages(
      UnsplashSearchEvent event, Emitter<UnsplashState> emit) async {
    emit(UnsplashLoading());
    try {
      final result = await UnsplashDownloader.getImagesUrls(query: event.query);
      emit(UnsplashGetImagesLoaded(imageUrls: result));
    } catch (e) {
      emit(UnsplashError());
    }
  }

  FutureOr<void> _moreImages(
      UnsplashMoreImagesEvent event, Emitter<UnsplashState> emit) async {
    emit(UnsplashLoading());
    try {
      final result = await UnsplashDownloader.getMoreImagesUrls(
          query: event.query, page: event.page);
      emit(UnsplashGetImagesLoaded(imageUrls: result));
    } catch (e) {
      emit(UnsplashError());
    }
  }

  FutureOr<void> _downloadImages(
      UnsplashDownloadImagesEvent event, Emitter<UnsplashState> emit) async {
    emit(UnsplashLoading());
    try {
      await UnsplashDownloader.downloadImages(event.imageUrls);
      emit(UnsplashDownloadImagesLoaded());
    } catch (e) {
      emit(UnsplashError());
    }
  }
}
