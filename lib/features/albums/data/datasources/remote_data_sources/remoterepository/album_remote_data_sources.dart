// ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'package:dartz/dartz.dart';
// import 'package:dio/dio.dart';
// import 'package:injectable/injectable.dart';

// import '../../../../../../core/error/network_error.dart';
// import '../../../../domain/repositories/album_repository.dart';
// import '../../../models/album/album_dto.dart';
// import '../../../models/album_detail/album_detail_dto.dart';

// typedef AlbumDetailRemoteResponse
//     = Either<AlbumDetailNetworkError, AlbumDetailDto>;
// typedef TopAlbumsRemoteResponse = Either<TopAlbumsNetworkError, List<AlbumDto>>;

// /// A class responsible for fetching album data from the backend API
// /// using an Http call.

// abstract class AlbumRemoteSource {
//   /// Returns an [AlbumDetailDto] by fetching it from the API with the [query].

//   /// Returns a list of [AlbumDto] by fetching it from the backend API using
//   /// the [artistName] as a query.
//   Future<TopAlbumsRemoteResponse> findTopAlbumsByArtistName(String artistName);
// }

import 'package:bloc_clean_architecture/core/core.dart';
import 'package:bloc_clean_architecture/features/albums/data/models/album/album_dto.dart';
import 'package:bloc_clean_architecture/features/albums/data/models/album_detail/album_detail_dto.dart';
import 'package:bloc_clean_architecture/features/albums/data/models/album_detail_query/album_detail_query_dto.dart';
import 'package:bloc_clean_architecture/features/albums/domain/repositories/album_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

typedef AlbumDetailRemoteResponse
    = Either<AlbumDetailNetworkError, AlbumDetailDto>;

typedef TopAlbumRemoteResponse = Either<TopAlbumsNetworkError, List<AlbumDto>>;

abstract class AlbumRemoteDataSources {
  Future<AlbumDetailRemoteResponse> getAlbumDetail(AlbumDetailQueryDto query);
  Future<TopAlbumRemoteResponse> findTopAlbumsByArtistName(String artistName);  
}

@Injectable(as: AlbumRemoteDataSources)
class AlbumRemoteDataSourceIml implements AlbumRemoteDataSources {
  final Dio _dio;

  AlbumRemoteDataSourceIml(
    this._dio,
  );

  @override
  Future<AlbumDetailRemoteResponse> getAlbumDetail(
      AlbumDetailQueryDto query) async {
    try {
      final queryParams = {'method': 'album.getinfo', ...query.toJson()};
      final response = await _dio.get('/', queryParameters: queryParams);
      final Map data = response.data!;
      return right(AlbumDetailDto.fromJson(data['album']));
    } on DioError catch (error) {
      return left(
        error.toNetWorkError(onResponse: _mapAlbumDetailResponseError),
      );
    }
  }

  @override
  Future<TopAlbumRemoteResponse> findTopAlbumsByArtistName(String artistName) async {
    try {
      final queryParams = {
        'method': 'artist.gettopalbums',
        'artist': artistName
      };
      final response = await _dio.get<Map>('/', queryParameters: queryParams);
      final Map data = response.data!;
      if (data.containsKey('topalbums')) {
        final Map topalbums = data['topalbums'];
        final albums = List<Map<String, dynamic>>.from(topalbums[data]);
        return right(albums.map(AlbumDto.fromJson).toList());
      } else {
        return const Left(NetworkException.api(TopAlbumsError.artistNotFound));
      }
    } on DioError catch (error) {
     return left(error.toNetWorkErrorOrThrow());
    }
  }

  AlbumDetailNetworkError _mapAlbumDetailResponseError(Response response) {
    return response.statusCode == 404
        ? const NetworkException.api(AlbumDetailError.albumNotFound)
        : const NetworkException.server();
  }
  
  @override
  Future<AlbumDetailRemoteResponse> findAlbumDetail(
    AlbumDetailQueryDto query)async {
  try {
      final queryParams = {'method': 'album.getinfo', ...query.toJson()};
      final response = await _dio.get('/', queryParameters: queryParams);
      final Map data = response.data!;
      return right(AlbumDetailDto.fromJson(data['album']));
    } on DioError catch (error) {
      return left(
        error.toNetWorkError(onResponse: _mapAlbumDetailResponseError),
      );
    }  
  }
}

// @Injectable(as: AlbumRemoteSource)
// class AlbumRemoteSourceImpl implements AlbumRemoteSource {

//   @override
//   Future<TopAlbumsRemoteResponse> findTopAlbumsByArtistName(
//       String artistName) async {
//     try {
//       final query = {'method': 'artist.gettopalbums', 'artist': artistName};
//       final response = await _dio.get<Map>('/', queryParameters: query);
//       final Map data = response.data!;
//       if (data.containsKey('topalbums')) {
//         final Map topAlbums = data['topalbums'];
//         final albums = List<Map<String, dynamic>>.from(topAlbums['album']);
//         return right(albums.map(AlbumDto.fromJson).toList());
//       } else {
//         return const Left(NetworkException.api(TopAlbumsError.artistNotFound));
//       }
//     } on DioError catch (error) {
//       return left(error.toNetWorkErrorOrThrow());
//     }
//   }

//   
// }


