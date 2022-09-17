import 'package:dartz/dartz.dart';

import '../../../../core/exceptions/network_error.dart';
import '../entities/album.dart';
import '../entities/album_detail.dart';
import '../entities/album_detail_query.dart';

typedef AlbumDetailNetworkError = NetworkException<AlbumDetailError>;

typedef AlbumDetailResponse = Either<AlbumDetailNetworkError, AlbumDetail>;

typedef TopAlbumsNetworkError = NetworkException<TopAlbumsError>;

typedef TopAlbumsResponse = Either<TopAlbumsNetworkError, Albums>;

enum AlbumDetailError {
  albumNotFound,
}

abstract class AlbumRepository {

  Future<void> deleteAlbum(AlbumDetailQuery query);

  /// Removes all stored [Albums] from the local storage.
  Future<void> deleteAllAlbums();

  /// Returns [AlbumDetail] from the local storage. If the [AlbumDetail] is not
  /// found in the local storage it will get it from the remote data source.
  ///
  /// When the [AlbumDetail] is fetched from the remote source it will be stored
  /// in the local storage.
  Future<AlbumDetailResponse> findAlbumDetail(AlbumDetailQuery query);

  /// Returns all [AlbumDetails] stored in the local storage.
  Future<AlbumDetails> findAll();

  /// Returns top [Albums] of an artist with the given name by fetching it from
  /// the remote source.
  ///
  /// The top [Albums] will be stored in the local storage if a successful
  /// response is returned from the remote source. Otherwise,
  /// [TopAlbumsNetworkError] will be returned.
  Future<TopAlbumsResponse> findTopAlbumsByArtistName(String name);

  /// Returns stream of [AlbumDetails] by listening to updates in the local
  /// storage.
  Stream<AlbumDetails> watchAllAlbums();
}

/// Possible errors that could occur when trying to get top albums for a
/// specific artist.
enum TopAlbumsError {
  /// Happens when an artist could not be found with a given query.
  ///
  /// For example, when searching top albums by not existing/invalid artist name.
  artistNotFound,
}
