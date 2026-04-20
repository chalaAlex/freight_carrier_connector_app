// import 'package:clean_architecture/core/core/network/api_client.dart';
// import 'package:clean_architecture/core/error/failure.dart';
// import 'package:dartz/dartz.dart';
// import '../models/post_model.dart';
// import 'post_remote_data_source.dart';

// class PostRemoteDataSourceImpl implements PostRemoteDataSource {
//   final ApiClient client;

//   PostRemoteDataSourceImpl({required this.client});

//   @override
//   Future<Either<Failure, PostModel>> getPosts() async {
//     return await client.getPosts();
//   }
// }