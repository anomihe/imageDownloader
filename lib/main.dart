import 'package:api_assign/picture_bloc/post_pic_bloc.dart';
import 'package:api_assign/picture_bloc/post_pic_event.dart';
import 'package:api_assign/picture_bloc/post_pic_state.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:network_to_file_image/network_to_file_image.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Plugin must be initialized before using
  await FlutterDownloader.initialize(
      debug:
          true, // optional: set to false to disable printing logs to console (default: true)
      ignoreSsl:
          true // option: set to false to disable working with http links (default: false)
      );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Images',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Images'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final PictureBloc pictureBloc = PictureBloc();

  @override
  void initState() {
    pictureBloc.add(PostInitialEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: BlocConsumer<PictureBloc, PictureState>(
          listenWhen: (previous, current) => current is PicturesAction,
          buildWhen: (previous, current) => current is! PicturesAction,
          bloc: pictureBloc,
          builder: (BuildContext context, state) {
            switch (state.runtimeType) {
              case PostLoadingState:
                return Center(child: const CircularProgressIndicator());
              case FetchSuccessfull:
                final success = state as FetchSuccessfull;
                return ListView.builder(
                    itemCount: success.pics.length,
                    itemBuilder: (context, i) {
                      print(
                        success.pics[i].url!,
                      );

                      return Container(
                        height: 500,
                        width: 100,
                        margin: const EdgeInsets.all(20),
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Container(
                              height: 300,
                              // width: 100,
                              child: Image.network(
                                fit: BoxFit.cover,
                                success.pics[i].downloadUrl!,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  }
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value:
                                          loadingProgress.expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                    ),
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return Text('Error: $error');
                                },
                              ),
                            ),
                            Text(success.pics[i].author!),
                            const SizedBox(
                              height: 20,
                            ),
                            TextButton(
                                onPressed: () {
                                  pictureBloc.add(DownloadImage(
                                      link: success.pics[i].downloadUrl!));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'Image has finished downloading'),
                                    ),
                                  );
                                },
                                child: const Text('download image'))
                          ],
                        ),
                      );
                    });

              default:
                return const SizedBox(child: Text('no image'));
            }
          },
          listener: (BuildContext context, Object? state) {
            if (state is DownloadImageState) {
              // Show a message indicating that the image has finished downloading
            }
          },
        ));
  }
}
