import 'package:flutter/material.dart';

class ProductFormScreen extends StatefulWidget {
  const ProductFormScreen({Key? key}) : super(key: key);

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final TextEditingController _imageUrlController = TextEditingController();
  final _imageURLFocus = FocusNode();

  void _onImageUpdate() {
    setState(() {});
  }

  @override
  void initState() {
    _imageURLFocus.addListener(_onImageUpdate);
    super.initState();
  }

  @override
  void dispose() {
    _imageURLFocus.dispose();
    _imageUrlController.dispose();
    _imageURLFocus.removeListener(_onImageUpdate);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
            child: ListView(children: [
          TextFormField(
            decoration: const InputDecoration(labelText: 'Name'),
            textInputAction: TextInputAction.next,
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Price'),
            textInputAction: TextInputAction.next,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Description'),
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.multiline,
            maxLines: 3,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: TextFormField(
                  decoration: const InputDecoration(labelText: 'Image URL'),
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.url,
                  controller: _imageUrlController,
                  focusNode: _imageURLFocus,
                ),
              ),
              Container(
                width: 100,
                height: 100,
                margin: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 1),
                ),
                child: _imageUrlController.text.isEmpty
                    ? const Text('Image Preview')
                    : FittedBox(
                        child: Image.network(_imageUrlController.text),
                        fit: BoxFit.cover,
                      ),
              )
            ],
          ),
        ])),
      ),
    );
  }
}
