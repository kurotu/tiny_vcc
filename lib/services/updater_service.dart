import 'package:github/github.dart';

class UpdaterService {
  UpdaterService(RepositorySlug repositorySlug) : _slug = repositorySlug;

  final _github = GitHub();
  final RepositorySlug _slug;

  Future<Release> getLatestRelease() async {
    return _github.repositories.getLatestRelease(_slug);
  }
}
