import 'package:auction_clean_architecture/features/posts/presentation/pages/add_edit_post/edit_post.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timer_count_down/timer_count_down.dart';

import '../../../auction_event/post_details_page.dart';
import '../../domain/entities/posts_entity.dart';

class Postcard extends StatelessWidget {
  final dynamic snap;
  final String userId;
  const Postcard({Key? key, required this.snap, required this.userId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OnlineEventScreen(
              duration: (snap['startdate'].toDate())!
                  .difference(DateTime.now())
                  .inSeconds,
              post1: PostsEntity(
                uid: snap['uid'].toString(),
                name: snap['name'].toString(),
                image: snap['image'].toString(),
                price: snap['price'],
                postImage: snap['postImage'].toString(),
                postId: snap['postId'].toString(),
                category: snap['category'].toString(),
                startdate:
                    DateTime.parse(snap['startdate'].toDate().toString()),
                enddate: DateTime.parse(snap['enddate'].toDate().toString()),
                postTime: DateTime.parse(snap['postTime'].toDate().toString()),
                titel: snap['titel'].toString(),
                description: snap['description'].toString(),
                winner: snap['winner'].toString(),
                winnerID: snap['winnerID'].toString(),
              ),
              postId: snap['postId'].toString(),
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(
          left: 5,
          right: 5,
          top: 5,
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: Colors.teal.withOpacity(0.2),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => UserProfileScreen(
                        //       name: snap['name'].toString(),
                        //       id: snap['uid'].toString(),
                        //     ),
                        //   ),
                        // );
                      },
                      child: Row(
                        children: [
                          Stack(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.teal,
                                backgroundImage: NetworkImage(
                                  snap['image'].toString(),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                snap['name'].toString(),
                                style: TextStyle(
                                  color: Colors.teal[600],
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                  '${DateFormat.yMd().add_jm().format(snap['postTime'].toDate())} '),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Spacer(
                      flex: 1,
                    ),
                    (userId == snap['uid'].toString())
                        ? PopupMenuButton(
                            onSelected: (value) {
                              if (value.toString() == '/Delete') {
                                showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                    title: const Text('AlertDialog Title'),
                                    content:
                                        const Text('AlertDialog description'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, 'Cancel'),
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          // AuctionCubit.get(context).deletDoc(
                                          //     'posts',
                                          //     snap['postId'].toString());
                                          // Navigator.pop(context, 'OK');
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  ),
                                );
                              } else if (value.toString() == '/Edit') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditPostScreen(
                                      post: snap,
                                    ),
                                  ),
                                );
                              }
                            },
                            itemBuilder: (BuildContext bc) {
                              return const [
                                PopupMenuItem(
                                  value: '/Delete',
                                  child: Text("Delete"),
                                ),
                                PopupMenuItem(
                                  value: '/Edit',
                                  child: Text("Edit"),
                                ),
                              ];
                            },
                          )
                        : Container()
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: 200,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(
                          snap['postImage'].toString(),
                        ),
                        fit: BoxFit.cover),
                  ),
                ),
                Row(
                  children: [
                    SizedBox(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 5,
                          ),
                          Column(
                            children: [
                              Text(
                                snap['titel'].toString(),
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.teal[600],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            child: Text(
                                ' ${DateFormat.yMd().add_jm().format(snap['startdate'].toDate())}  '),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.40,
                            child: Text(
                              snap['description'].toString(),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.teal[600],
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 5,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          (DateTime.now().isAfter(snap['startdate'].toDate()) &&
                                  DateTime.now()
                                      .isBefore(snap['enddate'].toDate()))
                              ? CounterDownStarted(
                                  timeinSecond: (snap['enddate'].toDate())!
                                      .difference(DateTime.now())
                                      .inSeconds)
                              : CounterDown(
                                  timeinSecond: (snap['startdate'].toDate())!
                                      .difference(DateTime.now())
                                      .inSeconds,
                                ),
                          Text(
                            snap['category'].toString(),
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.teal,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget CounterDownStarted({
    required int timeinSecond,
  }) =>
      Container(
        alignment: Alignment.topLeft,
        child: Countdown(
          seconds: timeinSecond,
          build: (BuildContext context, double time) => Text(
            '${Duration(seconds: time.toInt()).inHours.remainder(24).toString()}:${Duration(seconds: time.toInt()).inMinutes.remainder(60).toString()}:${Duration(seconds: time.toInt()).inSeconds.remainder(60).toString().padLeft(2, '0')}',
            style: const TextStyle(
              fontSize: 30,
              color: Colors.red,
            ),
          ),
          interval: const Duration(seconds: 1),
          onFinished: () {},
        ),
      );

  Widget CounterDown({
    required int timeinSecond,
  }) =>
      Container(
        alignment: Alignment.topLeft,
        child: Countdown(
          seconds: timeinSecond,
          build: (BuildContext context, double time) => Text(
            '${Duration(seconds: time.toInt()).inDays.remainder(365).toString()}:${Duration(seconds: time.toInt()).inHours.remainder(24).toString()}:${Duration(seconds: time.toInt()).inMinutes.remainder(60).toString()}:${Duration(seconds: time.toInt()).inSeconds.remainder(60).toString().padLeft(2, '0')}',
            style: TextStyle(
              fontSize: 25,
              color: Theme.of(context).primaryColor,
            ),
          ),
          interval: const Duration(seconds: 1),
          onFinished: () {},
        ),
      );
}
