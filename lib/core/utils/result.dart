import "../network/api_exception.dart";

/// Represente le resultat d'une operation (appel repository) qui peut
/// echouer. Evite de propager des exceptions brutes jusqu'a l'UI : chaque
/// provider recoit un Result et decide explicitement quoi faire des deux cas.
/// Utilisation :
///   final result = await repository.fetchSummary();
///   switch (result) {
///     case Success(:final data): ...
///     case Failure(:final error): ...
///   }
sealed class Result<T> {
  const Result();

  bool get isSuccess => this is Success<T>;
}

final class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

final class Failure<T> extends Result<T> {
  final ApiException error;
  const Failure(this.error);
}
