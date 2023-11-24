import 'package:nyxx/nyxx.dart';

void onReadyListener(NyxxGateway client) {
  client.onReady.listen((event) async {
    print('Ready and Waiting!');
  });
}
