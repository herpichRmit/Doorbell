import 'package:doorbell/components/avatar.dart';
import 'package:doorbell/components/button.dart';
import 'package:doorbell/components/splashSmallText.dart';
import 'package:doorbell/components/textField.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class DoorbellPopupSheet extends StatefulWidget {
  final String name;
  final String avatarPath;
  final Color avatarColor;

  const DoorbellPopupSheet({
    Key? key,
    required this.name,
    required this.avatarPath,
    required this.avatarColor,
  }) : super(key: key);

  @override
  _DoorbellPopupSheetState createState() => _DoorbellPopupSheetState();
}

class _DoorbellPopupSheetState extends State<DoorbellPopupSheet> {


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: DraggableScrollableSheet(
        initialChildSize: 0.2,
        maxChildSize: 0.5,
        minChildSize: 0.2,
        builder: (BuildContext context, ScrollController scrollController) {
          return Stack(
            children: [ 
              Container(
                padding: EdgeInsets.all(32.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [ 
                        Avatar(color: widget.avatarColor, imagePath: widget.avatarPath, size: 64,),
                        SizedBox(height: 52),
                        Container(
                          height: 64,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(children: [
                                Text("${widget.name} ", style: TextStyle(fontSize: 14.0,),),
                                Text("rung your doorbell!", style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold, color: widget.avatarColor),),
                              ],),
                              Text("Be sure to provide everyone an update.", style: TextStyle(fontSize: 14.0 ),),
                          ],),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
