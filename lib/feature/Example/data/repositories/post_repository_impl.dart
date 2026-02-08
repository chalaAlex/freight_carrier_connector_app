// import 'package:clean_architecture/core/error/failure.dart';
// import 'package:clean_architecture/feature/Example/data/models/post_model.dart';
// import 'package:dartz/dartz.dart';
// import '../../domain/repositories/post_repository.dart';
// import '../datasources/post_remote_data_source.dart';

// class PostRepositoryImpl implements PostRepository {
//   final PostRemoteDataSource remoteDataSource;

//   PostRepositoryImpl(this.remoteDataSource);

//   @override
//   Future<Either<Failure, PostModel>>getPosts() async {
//     return await remoteDataSource.getPosts();
//   }
// }