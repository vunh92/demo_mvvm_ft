import 'package:demo_mvvm/data/data_source/local_data_source.dart';
import 'package:demo_mvvm/data/data_source/remote_data_source.dart';
import 'package:demo_mvvm/data/network/error_handler.dart';
import 'package:demo_mvvm/data/network/failure.dart';
import 'package:demo_mvvm/data/network/network_info.dart';
import 'package:demo_mvvm/data/request/request.dart';
import 'package:demo_mvvm/domain/model/model.dart';
import 'package:demo_mvvm/domain/repository/repository.dart';
import 'package:dartz/dartz.dart';
import 'package:demo_mvvm/data/mapper/mapper.dart';

import '../responses/responses.dart';

class RepositoryImpl extends Repository {
  RemoteDataSource _remoteDataSource;
  LocalDataSource _localDataSource;
  NetworkInfo _networkInfo;

  RepositoryImpl(
      this._remoteDataSource, this._localDataSource, this._networkInfo);

  @override
  Future<Either<Failure, Authentication>> login(
      LoginRequest loginRequest) async {
    if (await _networkInfo.isConnected) {
      try {
        // its safe to call the API
        // final response = await _remoteDataSource.login(loginRequest);
        final response = AuthenticationResponse(
            CustomerResponse('123456789', 'Mina', 12),
            ContactsResponse('mina@gmail.com', '0123456789', 'mina@facebook.com')
        );
        response.status = ApiInternalStatus.SUCCESS;
        response.message = '';
        await Future.delayed(const Duration(seconds: 2));

        if (response.status == ApiInternalStatus.SUCCESS) {
          return Right(response.toDomain());
        } else {
          return Left(Failure(response.status ?? ApiInternalStatus.FAILURE,
              response.message ?? ResponseMessage.DEFAULT));
        }
      } catch (error) {
        return (Left(ErrorHandler.handle(error).failure));
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, String>> forgotPassword(String email) async {
    if (await _networkInfo.isConnected) {
      try {
        // its safe to call API
        final response = await _remoteDataSource.forgotPassword(email);

        if (response.status == ApiInternalStatus.SUCCESS) {
          // success
          // return right
          return Right(response.toDomain());
        } else {
          // failure
          // return left
          return Left(Failure(response.status ?? ResponseCode.DEFAULT,
              response.message ?? ResponseMessage.DEFAULT));
        }
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      // return network connection error
      // return left
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, Authentication>> register(
      RegisterRequest registerRequest) async {
    if (await _networkInfo.isConnected) {
      try {
        // its safe to call the API
        final response = await _remoteDataSource.register(registerRequest);

        if (response.status == ApiInternalStatus.SUCCESS) // success
        {
          // return data (success)
          // return right
          return Right(response.toDomain());
        } else {
          // return biz logic error
          // return left
          return Left(Failure(response.status ?? ApiInternalStatus.FAILURE,
              response.message ?? ResponseMessage.DEFAULT));
        }
      } catch (error) {
        return (Left(ErrorHandler.handle(error).failure));
      }
    } else {
      // return connection error
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, HomeObject>> getHome() async {
    try {
      // get from cache
      final response = await _localDataSource.getHome();
      return Right(response.toDomain());
    } catch (cacheError) {
      // we have cache error so we should call API

      if (await _networkInfo.isConnected) {
        try {
          // its safe to call the API
          final response = await _remoteDataSource.getHome();

          if (response.status == ApiInternalStatus.SUCCESS) // success
          {
            // return data (success)
            // return right
            // save response to local data source
            _localDataSource.saveHomeToCache(response);
            return Right(response.toDomain());
          } else {
            // return biz logic error
            // return left
            return Left(Failure(response.status ?? ApiInternalStatus.FAILURE,
                response.message ?? ResponseMessage.DEFAULT));
          }
        } catch (error) {
          return (Left(ErrorHandler.handle(error).failure));
        }
      } else {
        // return connection error
        return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
      }
    }
  }

  @override
  Future<Either<Failure, StoreDetails>> getStoreDetails() async {
    try {
      // get data from cache

      final response = await _localDataSource.getStoreDetails();
      return Right(response.toDomain());
    } catch (cacheError) {
      if (await _networkInfo.isConnected) {
        try {
          final response = await _remoteDataSource.getStoreDetails();
          if (response.status == ApiInternalStatus.SUCCESS) {
            _localDataSource.saveStoreDetailsToCache(response);
            return Right(response.toDomain());
          } else {
            return Left(Failure(response.status ?? ResponseCode.DEFAULT,
                response.message ?? ResponseMessage.DEFAULT));
          }
        } catch (error) {
          return Left(ErrorHandler.handle(error).failure);
        }
      } else {
        return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
      }
    }
  }
}
