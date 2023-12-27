import 'package:ultimate_movie_database/data/genre/remote/model/genre_remote_model.dart';
import 'package:ultimate_movie_database/model/genre.dart';

class GenreRemoteMapper {
  static Genre fromRemote(GenreRemoteModel remoteModel) {
    return Genre(id: remoteModel.id, name: remoteModel.name);
  }
}
