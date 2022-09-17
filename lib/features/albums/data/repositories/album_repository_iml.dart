import 'dart:async';

import 'package:bloc_clean_architecture/features/albums/data/datasources/local_data_sources/album_local_datasources.dart';
import 'package:bloc_clean_architecture/features/albums/data/datasources/remote_data_sources/remoterepository/album_remote_data_sources.dart';
import 'package:bloc_clean_architecture/features/albums/data/models/album/album_dto.dart';
import 'package:bloc_clean_architecture/features/albums/data/models/album_detail_query/album_detail_query_dto.dart';
import 'package:bloc_clean_architecture/features/albums/domain/entities/album_detail_query.dart';
import 'package:bloc_clean_architecture/features/albums/domain/entities/album_detail.dart';
import 'package:bloc_clean_architecture/features/albums/domain/repositories/album_repository.dart';
import 'package:dartz/dartz.dart';

import '../models/album_detail/album_detail_dto.dart';

class AlbumRepositoryIml implements AlbumRepository {
  final AlbumRemoteDataSources _albumRemoteDataSources;
  final AlbumLocalDataSources _albumLocalDataSources;

  AlbumRepositoryIml(this._albumRemoteDataSources, this._albumLocalDataSources);

  @override
  Future<void> deleteAlbum(AlbumDetailQuery query) {
    final queryDto = AlbumDetailQueryDto.fromModel(query);
    return _albumLocalDataSources.deleteAlbum(queryDto);
  }

  @override
  Future<void> deleteAllAlbums() => _albumLocalDataSources.deleteAllAlbums();

  @override
  Future<AlbumDetailResponse> findAlbumDetail(AlbumDetailQuery query) async {
    final queryDto = AlbumDetailQueryDto.fromModel(query);
    final album = await _albumLocalDataSources.findAlbumDetail(queryDto);
    if (album == null) return _findAlbumDetailFromRemoteSource(queryDto);
    return right(album.toEntity());
  }

  @override
  Future<AlbumDetails> findAll() async {
    final storedAlbums = await _albumLocalDataSources.findAllAlbums();
    return storedAlbums.toEntities();
  }

  @override
  Future<TopAlbumsResponse> findTopAlbumsByArtistName(String name) async {
   final response = await _albumRemoteDataSources.findTopAlbumsByArtistName(name);
    return response.map((albums) => albums.toEntities());
  }

  @override
  Stream<AlbumDetails> watchAllAlbums() {
    return _albumLocalDataSources
        .watchAllAlbums()
        .map((storedAlbums) => storedAlbums.toEntities());
  }

  Future<AlbumDetailResponse> _findAlbumDetailFromRemoteSource(
      AlbumDetailQueryDto query) async {
    final response = await _albumRemoteDataSources.getAlbumDetail(query);
    return response.fold(left, _saveAlbum);
  }

  FutureOr<AlbumDetailResponse> _saveAlbum(AlbumDetailDto album) async {
    final savedAlbum = await _albumLocalDataSources.saveAlbums(album);
    return right(savedAlbum.toEntity());
  }
}
