import 'package:doorbell/components/avatar.dart';
import 'package:doorbell/components/button.dart';
import 'package:doorbell/components/textField.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class PostPopupSheet extends StatefulWidget {
  final String title;
  final DateTime timestamp;
  final String description;
  final List<String> imageUrls;
  final bool isEditiable;

  const PostPopupSheet({
    Key? key,
    required this.title,
    required this.timestamp,
    required this.description,
    this.imageUrls = const [],
    this.isEditiable = false,
  }) : super(key: key);

  @override
  _PostPopupSheetState createState() => _PostPopupSheetState();
}

class _PostPopupSheetState extends State<PostPopupSheet> {
  bool _isEditing = false;
  late TextEditingController _descriptionController;
  late TextEditingController _titleController;

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController(text: widget.description);
    _titleController = TextEditingController(text: widget.title);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _editPost() {
    setState(() {
      _isEditing = true;
    });
  }

  void _deletePost() {
    // Implement post deletion logic
  }

  void _saveChanges() {
    // Implement save changes logic
    setState(() {
      _isEditing = false;
    });
  }

  void _addImages() {
    // Implement add images logic
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: DraggableScrollableSheet(
        initialChildSize: 0.9,
        maxChildSize: 0.9,
        minChildSize: 0.4,
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
                        SizedBox(),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: Icon(CupertinoIcons.clear),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                            widget.isEditiable
                              ? PopupMenuButton<String>(
                                  onSelected: (value) {
                                    if (value == 'Edit') {
                                      _editPost();
                                    } else if (value == 'Delete') {
                                      _deletePost();
                                    }
                                  },
                                  itemBuilder: (BuildContext context) {
                                    return {'Edit', 'Delete'}.map((String choice) {
                                      return PopupMenuItem<String>(
                                        value: choice,
                                        child: Text(choice),
                                      );
                                    }).toList();
                                  },
                                )
                              : SizedBox(height: 44,),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 16.0),
                    _isEditing
                    ? CustomTextField(controller: _titleController)
                    : Text(
                        widget.title,
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    Text(
                      '${widget.timestamp.hour}:${widget.timestamp.minute} ${widget.timestamp.hour >= 12 ? "PM" : "AM"}',
                      style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600,),
                    ),
                    SizedBox(height: 16.0),
                    _isEditing
                        ? CustomTextField(controller: _descriptionController, isMultiLine: true,)
                        : Text(
                            widget.description,
                            style: TextStyle(fontSize: 16.0),
                          ),
                    SizedBox(height: 16.0),
                    SizedBox(height: 8,),
                    if (_isEditing)
                      Button(
                        icon: Image.asset("assets/images/icons/plusfill.png"),
                        text: 'Add Images',
                        onPressed: _addImages,
                      ),
                    if (widget.imageUrls.isNotEmpty)
                      SizedBox(
                        height: 100,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: widget.imageUrls.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.network(widget.imageUrls[index]),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 8,),
                    if (_isEditing)
                      Button(
                        text: 'Save Changes',
                        onPressed: _saveChanges,
                      ),
                  ],
                ),
              ),
              Positioned(
                top: 36,
                left: 8,
                child: Avatar(color: CupertinoColors.systemBrown, imagePath: 'assets/images/avatars/avatar1.png', size: 100,),
              ),
            ],
          );
        },
      ),
    );
  }
}
