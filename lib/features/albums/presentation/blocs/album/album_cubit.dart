// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:bloc_clean_architecture/features/albums/domain/entities/album.dart';
import 'package:bloc_clean_architecture/features/albums/domain/entities/album_detail.dart';
import 'package:bloc_clean_architecture/features/albums/domain/repositories/album_repository.dart';

part 'album_state.dart';

class AlbumCubit extends Cubit<AlbumState> {
  StreamSubscription _streamSubscription;
  final AlbumRepository _albumRepository;
  AlbumCubit(
    this._streamSubscription,
    this._albumRepository,
  ) : super(const AlbumInitial());

  @override
  Future<void> close() async {
    await _streamSubscription.cancel();
    await super.close();
  }

  Future<void> deleteAllAlbums() async {
    await _albumRepository.deleteAllAlbums();
    emit(const AllAlbumLoaded([]));
  }

  Future<void> loadAllAlbums() async {
    emit(const AlbumLoading());
    final response = await _albumRepository.findAll();
    emit(AllAlbumLoaded(response));
  }

  Future<void> loadTopAlbums(String name) async {
    emit(const AlbumLoading());
    final response = await _albumRepository.findTopAlbumsByArtistName(name);
    emit(response.fold(TopAlbumFailed.new, TopAlbumLoaded.new));
  }

  Future<void> watchAllAlbums() async {
    await loadAllAlbums();
    _streamSubscription ??=
        _albumRepository.watchAllAlbums().map(AllAlbumLoaded.new).
        listen(emit);
  }
}
