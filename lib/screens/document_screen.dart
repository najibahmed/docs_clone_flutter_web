import 'package:flutter/material.dart';
import 'package:flutter_docs_clone/models/document_model.dart';
import 'package:flutter_docs_clone/models/error_model.dart';
import 'package:flutter_docs_clone/repository/auth_repository.dart';
import 'package:flutter_docs_clone/repository/document_repository.dart';
import 'package:flutter_docs_clone/utils/app_images.dart';
import 'package:flutter_docs_clone/utils/colors.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DocumentScreen extends ConsumerStatefulWidget {
  final String id;
  const DocumentScreen({super.key, required this.id});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DocumentScreenState();
}

class _DocumentScreenState extends ConsumerState<DocumentScreen> {
  TextEditingController titleController = TextEditingController();
  QuillController _controller = QuillController.basic();
  ErrorModel? errorModel;
  @override
  void initState() {
    fetchDocumentData();
    
    super.initState();
  }
  fetchDocumentData()async{
     errorModel = await ref.read(documentRepositoryProvider).getSingleDocument( ref.read(userProvider)!.token!,  widget.id);
    if(errorModel!.data != null){
       
     titleController.text= (errorModel!.data as DocumentModel).title;
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void updateTitle(WidgetRef ref,String title)async{
    final snakbar = ScaffoldMessenger.of(context);
    final  errorModel= await ref.read(documentRepositoryProvider).updateTilte(
      token: ref.read(userProvider)!.token!, 
      id: widget.id, 
      title: title);
      if (errorModel.data != null) {
     titleController.text = (errorModel!.data as DocumentModel).title;
    } else {
      snakbar
          .showSnackBar(SnackBar(content: Text(errorModel.error.toString())));
    }
      
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              Image.asset(
                AppImages.instance.docsLogo,
                height: 40,
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
                  onSubmitted: (value) =>updateTitle(ref,value),
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
              onPressed: () {},
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
            QuillSimpleToolbar(
              controller: _controller,
              configurations: const QuillSimpleToolbarConfigurations(),
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
                    child: QuillEditor.basic(
                      controller: _controller,
                      configurations: const QuillEditorConfigurations(),
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
