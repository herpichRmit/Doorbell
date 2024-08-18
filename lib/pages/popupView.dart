import 'package:doorbell/components/avatar.dart';
import 'package:doorbell/components/button.dart';
import 'package:doorbell/components/splashSmallText.dart';
import 'package:doorbell/components/textField.dart';
import 'package:doorbell/model/post.dart' as my_post;
import 'package:doorbell/model/user.dart' as my_user;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class PostPopupSheet extends StatefulWidget {
  final String postId;
  final String title;
  final DateTime timestamp;
  final String name;
  final String description;
  final List<String> imageUrls;
  final Color avatarColor;
  final String avatarPath;
  final bool isEditable;
  final bool isNew;

  const PostPopupSheet({
    Key? key,
    this.postId = "",
    required this.title,
    required this.timestamp,
    this.name = "",
    required this.description,
    required this.avatarColor,
    required this.avatarPath,
    this.imageUrls = const [],
    this.isEditable = true,
    this.isNew = true,
  }) : super(key: key);

  @override
  _PostPopupSheetState createState() => _PostPopupSheetState();
}

class _PostPopupSheetState extends State<PostPopupSheet> {
  bool _isEditing = false;
  bool _isTitleEmpty = false;
  late TextEditingController _descriptionController;
  late TextEditingController _titleController;

  @override
  void initState() {
    super.initState();

    if (widget.isNew) {
      _isEditing = true;
    }

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

  Future<void> _createPost() async {
    activateLoading();
    setState(() {
      _isTitleEmpty = _titleController.text.isEmpty;
    });

    if (!_isTitleEmpty) {
      var userAuth = FirebaseAuth.instance.currentUser;
      var user = await my_user.UserService().getUser(userAuth!.uid);

      if (user != null) {
        var post = my_post.Post(
          userId: user.id, 
          userName: user.name, 
          avatarPath: user.avatar, 
          avatarColor: user.avatarColor, 
          title: _titleController.text, 
          description: _descriptionController.text, 
          images: widget.imageUrls, 
          timestamp: DateTime.now()
        );

        var result = await my_post.PostService().createPost(post);

        if (result == true) {
          _isEditing = false;
          Navigator.of(context).pop();
          deActivateLoading();
        }
      }
      
    }
    deActivateLoading();
  }

  Future<void> _saveChanges() async {
    activateLoading();
    setState(() {
      _isTitleEmpty = _titleController.text.isEmpty;
    });

    if (!_isTitleEmpty) {
      var userAuth = FirebaseAuth.instance.currentUser;
      var user = await my_user.UserService().getUser(userAuth!.uid);

      if (user != null) {
        var post = my_post.Post(
          id: widget.postId,
          userId: user.id, 
          userName: user.name, 
          avatarPath: user.avatar, 
          avatarColor: user.avatarColor, 
          title: _titleController.text, 
          description: _descriptionController.text, 
          images: widget.imageUrls, 
          timestamp: widget.timestamp
        );

        var result = await my_post.PostService().updatePost(post);

        if (result == true) {
          _isEditing = false;
          deActivateLoading();
        }
      }
      
    }
    deActivateLoading();
  }

  Future<void> _deletePost() async {
    var result = await my_post.PostService().deletePost(widget.postId);

    if (result == true) {
      Navigator.of(context).pop();
    }
  }

  void _addImages() {
    // Implement add images logic
  }

  bool _isLoading = false;

  void activateLoading(){
    setState(() { 
      _isLoading = true;
    });
  }

  void deActivateLoading(){
    setState(() { 
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      padding: EdgeInsets.all(32.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
              Stack(
                children: [ 
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(height: 85,),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: Icon(CupertinoIcons.clear),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          widget.isEditable && !widget.isNew
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
                              : SizedBox(height: 0),
                        ],
                      ),
                    ],
                  ),
                  Positioned(
                    top: 0,
                    left: -14,
                    child: Avatar(
                      color: widget.avatarColor,
                      imagePath: widget.avatarPath,
                      size: 100,
                    ),
                  ),
              ], 
            ),
              SizedBox(height: 16.0),
              Expanded(
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _isEditing
                              ? TextField(
                                  controller: _titleController,
                                  decoration: InputDecoration(
                                    hintText: 'Title',
                                    hintStyle: TextStyle(
                                      color: CupertinoColors.systemGrey,
                                    ),
                                    border: InputBorder.none,
                                  ),
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                )
                              : Text(
                                  _titleController.text.isEmpty
                                      ? 'Type your post here...'
                                      : _titleController.text,
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                    color: _titleController.text.isEmpty
                                        ? CupertinoColors.systemGrey
                                        : Colors.black,
                                  ),
                                ),
                          if (!_isEditing)
                            Column(
                              children: [
                                SizedBox(height: 8.0),
                                Row(
                                  children: [
                                    Text(
                                      '${widget.name}',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      '${widget.timestamp.hour}:${widget.timestamp.minute} ${widget.timestamp.hour >= 12 ? "PM" : "AM"}',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 16.0),
                              ],
                            ),
                          _isEditing
                              ? TextField(
                                  controller: _descriptionController,
                                  decoration: InputDecoration(
                                    hintText: 'Type your description here...',
                                    hintStyle: TextStyle(
                                      color: CupertinoColors.systemGrey,
                                    ),
                                    border: InputBorder.none,
                                  ),
                                  maxLines: null,
                                  style: TextStyle(fontSize: 16.0),
                                )
                              : Text(
                                  _descriptionController.text.isEmpty
                                      ? 'desc'
                                      : _descriptionController.text,
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: _descriptionController.text.isEmpty
                                        ? CupertinoColors.systemGrey
                                        : Colors.black,
                                  ),
                                ),
                          SizedBox(height: 32.0),
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
                          SizedBox(height: 8.0),
                          if (_isEditing && !widget.isNew)
                            Button(
                              text: 'Save Changes',
                              isLoading: _isLoading,
                              onPressed: () async {
                                _saveChanges();
                              }
                              ),
                          if (_isEditing && widget.isNew)
                            Button(
                              text: 'Create Post',
                              isLoading: _isLoading,
                              onPressed: () async {
                                _createPost();
                              }
                              ),
                          SizedBox(height: 4.0),
                          if (_isTitleEmpty)
                            SplashSmallText(
                              text: 'Title can\'t be empty.',
                              backOption: false,
                              isError: true,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
