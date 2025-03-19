import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_docs_clone/models/document_model.dart';
import 'package:flutter_docs_clone/models/error_model.dart';
import 'package:flutter_docs_clone/repository/auth_repository.dart';
import 'package:flutter_docs_clone/repository/document_repository.dart';
import 'package:flutter_docs_clone/repository/socket_repository.dart';
import 'package:flutter_docs_clone/utils/app_images.dart';
import 'package:flutter_docs_clone/utils/colors.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_quill/quill_delta.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

class DocumentScreen extends ConsumerStatefulWidget {
  final String id;
  const DocumentScreen({super.key, required this.id});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DocumentScreenState();
}

class _DocumentScreenState extends ConsumerState<DocumentScreen> {
  TextEditingController titleController = TextEditingController();
  quill.QuillController? _controller;
  ErrorModel? errorModel;
  SocketRepository socketRepository = SocketRepository();

  @override
  void initState() {
    super.initState();
    socketRepository.joinRoom(widget.id);
    fetchDocumentData();
    socketRepository.changeListener((data) {
      _controller?.compose(
          Delta.fromJson(data['delta']),
          _controller?.selection ?? const TextSelection.collapsed(offset: 0),
          quill.ChangeSource.remote);
    });
    Timer.periodic(const Duration(seconds: 2), (timer) {
      socketRepository.autoSave(<String, dynamic>{
        "delta": _controller?.document.toDelta(),
        "room": widget.id
      });
    });
  }

  fetchDocumentData() async {
    errorModel = await ref
        .read(documentRepositoryProvider)
        .getSingleDocument(ref.read(userProvider)!.token!, widget.id);
        // print("error model data ${errorModel!.data}");
    if (errorModel!.data != null) {
       titleController.text = (errorModel!.data as DocumentModel).title;
      _controller = quill.QuillController(
        document: (errorModel!.data as DocumentModel).content.isNotEmpty
            ? quill.Document.fromDelta(Delta.fromJson(errorModel!.data.content))
            :  quill.Document(),
        selection: const TextSelection.collapsed(offset: 0),
      );
     
      setState(() {});
    }
    
    _controller!.document.changes.listen((event) {
      if (event.source == quill.ChangeSource.local) {
        Map<String, dynamic> map = {
          "delta": event.change, 
          "room": widget.id
          };
        socketRepository.typing(map);
      }
    });
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  void updateTitle(WidgetRef ref, String title) async {
    final snakbar = ScaffoldMessenger.of(context);
    final errorModel = await ref.read(documentRepositoryProvider).updateTilte(
        token: ref.read(userProvider)!.token!, id: widget.id, title: title);
    if (errorModel.data != null) {
      titleController.text = (errorModel.data as DocumentModel).title;
    } else {
      snakbar
          .showSnackBar(SnackBar(content: Text(errorModel.error.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: kWhiteColor,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              GestureDetector(
                onTap: (){
                  Routemaster.of(context).replace("/");
                },
                child: Image.asset(
                  AppImages.instance.docsLogo,
                  height: 40,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              SizedBox(
                  width: 200,
                  child: TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: kBlackColor)),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 10)),
                    onSubmitted: (value) => updateTitle(ref, value),
                  ))
            ],
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  backgroundColor: kBluekColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8))),
              onPressed: () {
                Clipboard.setData( ClipboardData(text: 'http://localhost:3000/#/document/${widget.id}'))
                .then((value){
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Link Copied")));
                });
              },
              icon: const Icon(
                Icons.lock,
                size: 16,
                color: kWhiteColor,
              ),
              label: const Text(
                "Share",
                style: TextStyle(color: kWhiteColor),
              ),
            ),
          )
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2),
          child: Container(
            height: 0.1,
            decoration: BoxDecoration(
              color: kGreyColor,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 20,
            ),
            quill.QuillSimpleToolbar(
              controller: _controller,
              configurations: const quill.QuillSimpleToolbarConfigurations(),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: SizedBox(
                width: 760,
                child: Card(
                  color: kWhiteColor,
                  elevation: 5,
                  child: Container(
                    margin: const EdgeInsets.all(30),
                    child: quill.QuillEditor.basic(
                      controller: _controller,
                      configurations: const quill.QuillEditorConfigurations(),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
