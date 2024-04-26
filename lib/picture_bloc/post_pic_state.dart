// part of 'post_pic_state.dart';

import 'package:api_assign/models/data_model.dart';

abstract class PictureState {}
//this class is for listeners 
abstract class PicturesAction extends PictureState{}
class PostInitialState extends PictureState {}
class PostLoadingState extends PictureState {}
class FetchSuccessfull extends PictureState {
  final List<PictureModel> pics;

  FetchSuccessfull({required this.pics});
}

class DownloadImageState extends PictureState{
  
}