import 'package:flutter/material.dart';
import 'package:examapp/models/webtoon.dart';
import 'package:examapp/services/api_service.dart';
import 'package:examapp/widgets/webtoon_widget.dart';

class MainScreen extends StatelessWidget {
  MainScreen({super.key});

  final Future<List<WebtoonModel>> webtoons = ApiService.getTodaysToons();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Colors.white,
        foregroundColor: Colors.green,
        title: const Text("어늘의 웹툰", style: TextStyle(fontSize: 24)),
      ),
      body: FutureBuilder(
        future: webtoons,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: [
                const SizedBox(height: 50),
                Expanded(child: makeList(snapshot)),
              ],
            );
          }
          return const Center(child: CircularProgressIndicator());

          // return ListView.builder(
          //   scrollDirection: Axis.vertical,
          //   itemCount: snapshot.data!.length,
          //   itemBuilder: (context, index) {
          //     var webtoon = snapshot.data![index];
          //     return Text(webtoon.title);
          //   },
          // );

          // return ListView.separated(
          //   scrollDirection: Axis.horizontal,
          //   itemCount: snapshot.data!.length,
          //   itemBuilder: (context, index) {
          //     var webtoon = snapshot.data![index];
          //     return Text(webtoon.title);
          //   },
          //   separatorBuilder: (context, index) => const SizedBox(width: 20),
          // );
        },
      ),
    );
  }

  ListView makeList(AsyncSnapshot<List<WebtoonModel>> snapshot) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: snapshot.data!.length,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      itemBuilder: (context, index) {
        var webtoon = snapshot.data![index];
        return Webtoon(
          title: webtoon.title,
          thumb: webtoon.thumb,
          id: webtoon.id,
        );
      },
      separatorBuilder: (context, index) => const SizedBox(width: 40),
    );
  }
}
