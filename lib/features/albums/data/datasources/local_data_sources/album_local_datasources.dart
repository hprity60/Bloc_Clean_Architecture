import 'package:bloc_clean_architecture/features/albums/data/models/album_detail_query/album_detail_query_dto.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:bloc_clean_architecture/features/albums/data/models/album_detail/album_detail_dto.dart';
import 'package:bloc_clean_architecture/features/albums/domain/entities/album_detail_query.dart';

abstract class AlbumLocalDataSources {
  //
  Future<void> deleteAlbum(AlbumDetailQueryDto query);
  //
  Future<void> deleteAllAlbums();
  //
  Future<AlbumDetailDto?> findAlbumDetail(AlbumDetailQueryDto query);
  //
  Future<List<AlbumDetailDto>> findAllAlbums();
  //
  Future<AlbumDetailDto> saveAlbums(AlbumDetailDto album);
  //
  Stream<List<AlbumDetailDto>> watchAllAlbums();
}

@Injectable(as: AlbumLocalDataSources)
class AlbumLocalDataSourcesIml implements AlbumLocalDataSources {
  final Box<AlbumDetailDto> _albumBox;
  AlbumLocalDataSourcesIml(@Named('albumBox') this._albumBox);

  @override
  Future<void> deleteAlbum(AlbumDetailQueryDto query) {
    return _albumBox.delete(query.toId());
  }

  @override
  Future<void> deleteAllAlbums() => _albumBox.clear();

  @override
  Future<AlbumDetailDto?> findAlbumDetail(AlbumDetailQueryDto query) async {
    return _albumBox.get(query.toId());
  }

  @override
  Future<List<AlbumDetailDto>> findAllAlbums() async {
    return _albumBox.values.toList();
  }

  @override
  Future<AlbumDetailDto> saveAlbums(AlbumDetailDto album) async {
    await _albumBox.put(album.toId(), album);
    return album;
  }

  @override
  Stream<List<AlbumDetailDto>> watchAllAlbums() {
    return _albumBox.watch().map((_) => _albumBox.values.toList());
  }
}

extension on AlbumDetailQueryDto {
  String toId() => '$artist-$album';
}

extension on AlbumDetailDto {
  String toId() => '$artist-$name';
}
