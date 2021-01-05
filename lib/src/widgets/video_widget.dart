import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String linkVideo;
  VideoPlayerWidget(this.linkVideo);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    _controller = VideoPlayerController.network(
      'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
    );
    _initializeVideoPlayerFuture = _controller.initialize();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.passthrough,
      children: <Widget>[
        Container(
          child: FutureBuilder(
            future: _initializeVideoPlayerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                // Si el VideoPlayerController ha finalizado la inicialización, usa
                // los datos que proporciona para limitar la relación de aspecto del VideoPlayer
                return AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  // Usa el Widget VideoPlayer para mostrar el vídeo
                  child: VideoPlayer(_controller),
                );
              } else {
                // Si el VideoPlayerController todavía se está inicializando, muestra un
                // spinner de carga
                return FadeInImage(
                  image: AssetImage('assets/img/loading.gif'),
                  placeholder: AssetImage('assets/img/loading.gif'),
                  fadeInDuration: Duration(milliseconds: 150),
                  fit: BoxFit.cover,
                );
              }
            },
          ),
        ),
        Container(
          padding: EdgeInsets.all(90.0),
          child: FloatingActionButton(
            backgroundColor: Colors.white30,
            onPressed: () {
              setState(() {
                if (_controller.value.isPlaying) {
                  _controller.pause();
                } else {
                  _controller.play();
                }
              });
            },
          ),
        ),
        Container(
          child: Icon(
              _controller.value.isPlaying ? Icons.pause : Icons.play_arrow),
        ),
      ],
    );
  }
}
