
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../Models/item.dart';
import '../Store/storehome.dart';
import '../Widgets/loadingWidget.dart';
import '../Widgets/searchBox.dart';
class EditItem extends StatefulWidget {
  EditItem({Key key}) : super(key: key);

  @override
  State<EditItem> createState() => _EditItemState();
}

class _EditItemState extends State<EditItem> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            delegate: SearchBoxDelegate(),
          ),
          // SliverList(
          //   delegate: SliverChildBuilderDelegate(
          //     (BuildContext context, int index) {
          //       return Row(
          //         mainAxisAlignment: MainAxisAlignment.start,
          //         children: [
          //           SizedBox(
          //             width: 10.0,
          //           ),
          //           InkWell(
          //             onTap: () {
          //               Route route = MaterialPageRoute(
          //                   builder: ((context) =>
          //                       GeneralCatgory(title: 'Child', category: 'child')));
          //               Navigator.of(context).push(route);
          //             },
          //             child: Chip(
          //               backgroundColor: Colors.blue[600],
          //               label: Text(
          //                 'Child',
          //                 style: TextStyle(color: Colors.white),
          //               ),
          //             ),
          //           ),
          //           SizedBox(
          //             width: 10.0,
          //           ),
          //           InkWell(
          //             onTap: () {
          //               Route route = MaterialPageRoute(
          //                   builder: (context) => GeneralCatgory(
          //                         category: 'women',
          //                         title: "Women",
          //                       ));
          //               Navigator.push(context, route);
          //             },
          //             child: Chip(
          //               backgroundColor: Colors.blue[600],
          //               label: Text(
          //                 'Women',
          //                 style: TextStyle(color: Colors.white),
          //               ),
          //             ),
          //           ),
          //         ],
          //       );
          //     },
          //     childCount: 1,
          //   ),
          // ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("items")
                .limit(15)
                .orderBy("publishedDate", descending: true)
                .snapshots(),
            builder: (context, dataSnapshot) {
              return !dataSnapshot.hasData
                  ? SliverFillRemaining(
                      child: Center(
                        child: circularProgress(),
                      ),
                    )
                  : SliverFillRemaining(
                      child: MasonryGridView.count(
                        crossAxisCount: 1,
                        // staggeredTileBuilder: (c) => StaggeredTile.fit(1),
                        itemBuilder: (context, index) {
                          ItemModel model = ItemModel.fromJson(
                            dataSnapshot.data.docs[index].data(),
                          );
                          return designUpdate(model, context, isStockManager: true);
                        },
                        itemCount: dataSnapshot.data.docs.length,
                      ),
                    );
            },
          ),
        ],
      );
      
  }
}