// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:bloc_clean_architecture/features/albums/domain/entities/album_detail_query.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/album_detail.dart';
import '../../../domain/repositories/album_repository.dart';

part 'album_detail_state.dart';

class AlbumDetailCubit extends Cubit<AlbumDetailState> {
  final AlbumRepository _albumRepository;
  AlbumDetailCubit(
    this._albumRepository,
  ) : super(const AlbumDetailInitial());

  Future<void> deleteAlbum() async {
    final currentState = state;
    if (currentState is AlbumDetailSuccess) {
      await _deleteAlbum(currentState.album);
    }
  }

  Future<void> loadAlbumDetail(AlbumDetailQuery query) async {
    emit(const AlbumDetailLoading());
    final response = await _albumRepository.findAlbumDetail(query);
    emit(response.fold(AlbumDetailFailure.new, AlbumDetailSuccess.new));
  }

  Future<void> _deleteAlbum(AlbumDetail albumDetail) async {
    final request = AlbumDetailQuery.fromAlbum(albumDetail);
    await _albumRepository.deleteAlbum(request);
  }
}
