import 'dart:math';
import 'package:flutter/material.dart';
import '../models/product.dart';
import '../utils/CurrencyInputFormatter.dart';

class ProductFormScreen extends StatefulWidget {
  const ProductFormScreen({Key? key}) : super(key: key);

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final TextEditingController _imageUrlController = TextEditingController();
  final _imageURLFocus = FocusNode();
  final _formKey = GlobalKey<FormState>();
  final _formData = Map<String, Object>();

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

  void _submitForm() {
    print('submit form');

    final isValid = _formKey.currentState?.validate() ?? false;
    print(_formData.values);

    if (!isValid) {
      return;
    }

    _formKey.currentState!.save();
    final Product product = Product(
      id: Random().nextDouble().toString(),
      name: _formData['name'] as String,
      description: _formData['description'] as String,
      price: _formData['price'] as double,
      imageUrl: _formData['imageUrl'] as String,
    );
  }

  double? _toDouble(String value) {
    if (value.isEmpty) {
      return 0;
    }

    String onlyNumbers = value.replaceAll(RegExp(r'[^\d]'), '');
    return double.tryParse(onlyNumbers)! / 100;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Form'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _submitForm,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
            key: _formKey,
            child: ListView(children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Name'),
                textInputAction: TextInputAction.next,
                onSaved: (name) => _formData['name'] = name ?? '',
                validator: (_name) =>
                    _name!.trim().isEmpty || _name.trim().length < 3
                        ? 'A valid name is required'
                        : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Price'),
                textInputAction: TextInputAction.next,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                onSaved: (price) => _formData['price'] = _toDouble(price!)
                    as Object, // double.tryParse(price!) ?? 0,
                validator: (_price) =>
                    _price!.trim().isEmpty || _toDouble(_price) == null
                        ? 'A valid price is required'
                        : null,
                //onChanged: (value) => _formatPrice(value),
                inputFormatters: [
                  CurrencyInputFormatter(),
                ],
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Description'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.multiline,
                maxLines: 3,
                onSaved: (description) =>
                    _formData['description'] = description ?? '',
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
                      onFieldSubmitted: (_) => _submitForm(),
                      onSaved: (imageUrl) =>
                          _formData['imageUrl'] = imageUrl ?? '',
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
