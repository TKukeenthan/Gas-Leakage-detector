// ignore_for_file: file_names

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:gldapplication/chat%20app/callPage/widget.dart';
import 'package:gldapplication/chatUser.dart';

import '../../api.dart';
import 'homeWidgwt.dart';

class CallListPage extends StatefulWidget {
  const CallListPage(
      {Key? key, required this.scrollController, required ScrollController})
      : super(key: key);

  final ScrollController scrollController;

  @override
  _CallListPageState createState() => _CallListPageState();
}

class _CallListPageState extends State<CallListPage> {
  bool isSearch = false;
  TextEditingController controller = TextEditingController();
  List<ChatUser> users = [];

  @override
  void initState() {
    users = APIs.getUserInfo(users as ChatUser) as List<ChatUser>;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.transparent,
        child: IconButton(
          icon: Icon(Icons.phone_forwarded),
          onPressed: () {},
        ),
      ),
      body: SafeArea(
          child: Column(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 26,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Text(
                      "Calls",
                      style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: Colors.amber),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Transform.rotate(
                      angle: isSearch ? pi * (90 / 360) : 0,
                      child: IconButton(
                        icon:
                            Icon(isSearch ? Icons.add : Icons.search, size: 32),
                        splashRadius: 20,
                        onPressed: () {
                          setState(() {
                            isSearch = !isSearch;
                          });
                        },
                        color: Colors.amber,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              isSearch
                  ? searchBar(controller: controller)
                  : statusBar(
                      addWidget: false, seeAllWidget: false, statusList: users)
            ],
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.only(top: 10),
              controller: widget.scrollController,
              itemCount: users.length,
              separatorBuilder: (context, index) {
                return const Divider(
                  thickness: 0.3,
                );
              },
              itemBuilder: (context, index) => customListTile(
                  imageUrl: users[index].image,
                  title: "${users[index].name} ",
                  subTitle: "May 7, 6:29 PM",
                  onTap: () {},
                  numberOfCalls: 2,
                  customListTileType: CustomListTileType.call,
                  callStatus: CallStatus.accepted),
            ),
          )
        ],
      )),
    );
  }
}
