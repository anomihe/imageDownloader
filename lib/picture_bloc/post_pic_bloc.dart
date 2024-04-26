import 'dart:async';

import 'package:api_assign/models/data_model.dart';
import 'package:api_assign/picture_bloc/post_pic_event.dart';
import 'package:api_assign/picture_bloc/post_pic_state.dart';
import 'package:api_assign/repository/services.dart';
import 'package:bloc/bloc.dart';

import 'package:meta/meta.dart';

// part  'post_pic_event.dart';
// part  'post_pic_state.dart';

class PictureBloc extends Bloc<PictureEvent, PictureState> {
  PictureBloc() : super(PostInitialState()) {
    on<PostInitialEvent>(postInitialEvent);
    on<DownloadImage>(downloadImage);
  }

  FutureOr<void> postInitialEvent(
      PostInitialEvent event, Emitter<PictureState> emit) async {
    emit(PostLoadingState());
    List<PictureModel> picResult = await ApiCallRepo.fetchData();
    emit(FetchSuccessfull(pics: picResult));
  }

  FutureOr<void> downloadImage(
      DownloadImage event, Emitter<PictureState> emit, ) async {
    try {
      // void downloadResult = await ApiCallRepo.downloadImage(event.link);
      await ApiCallRepo.downloadImage(event.link, );
      //emit(DownloadImageState());
    } catch (e) {
      print('this bloc error:$e');
    }
  }
}
