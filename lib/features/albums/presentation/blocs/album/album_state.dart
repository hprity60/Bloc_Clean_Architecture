part of 'album_cubit.dart';

abstract class AlbumState extends Equatable {
  const AlbumState();

  @override
  List<Object> get props => [];
}

class AlbumInitial extends AlbumState {
  const AlbumInitial();
}

class AlbumLoading extends AlbumState {
  const AlbumLoading();
}

class TopAlbumLoaded extends AlbumState {
  final Albums album;

 const TopAlbumLoaded(this.album);
  
  @override
  List<Object> get props => [album];
}

class TopAlbumFailed extends AlbumState {
  final TopAlbumsNetworkError error;

 const TopAlbumFailed(this.error);
  
  @override
  List<Object> get props => [error];
}

class AllAlbumLoaded extends AlbumState {
  final AlbumDetails albums;

  const AllAlbumLoaded(this.albums);

  @override
  List<Object> get props => [albums];
}
