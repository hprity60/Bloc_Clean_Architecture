// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:bloc_clean_architecture/features/albums/presentation/blocs/album/album_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TopAlbumScreen extends StatelessWidget {
  const TopAlbumScreen({
    Key? key,
    required this.artistName,
  }) : super(key: key);
  final String artistName;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AlbumCubit>()..
      loadTopAlbums(artistName),
      child: Container(),
    );
  }
}
