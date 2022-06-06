import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/providers/products_provider.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({Key? key}) : super(key: key);

  static const routeName = '/edit-product';

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  late Product _product;
  String? _id;
  String? _title;
  String? _descriprion;
  double? _price;
  String? _imageUrl;
  bool? _isFavorite;

  final _form = GlobalKey<FormState>();
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  // final _imageUrlController = TextEditingController();
  var _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    // _imageUrlFocusNode.dispose();
  }

  Future<void> _saveForm() async {
    if (_form.currentState!.validate()) {
      _form.currentState?.save();
      setState(() {
        _isLoading = true;
      });
      if (_id == null) {
        _product = Product(
            id: DateTime.now().toString(),
            title: _title as String,
            description: _descriprion as String,
            price: _price as double,
            imageUrl: _imageUrl as String,
            isFavorite: false);
        try {
          await context.read<ProductsProvider>().addProduct(_product);
        } catch (error) {
          await showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                      title: const Text("An Error"),
                      content: const Text('Somthing went wrong'),
                      actions: [
                        TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: const Text("Ok"))
                      ]));
        }
        // finally {
        //   setState(() {
        //     _isLoading = false;
        //   });
        //   Navigator.pop(context);
        // }
      } else {
        _product = Product(
            id: _id as String,
            title: _title as String,
            description: _descriprion as String,
            price: _price as double,
            imageUrl: _imageUrl as String,
            isFavorite: _isFavorite as bool);
        await context.read<ProductsProvider>().updateProduct(_product);
      }
      setState(() {
        _isLoading = false;
      });
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              'Form was not validated !',
              textAlign: TextAlign.center,
            )),
      );
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    var routeArg = ModalRoute.of(context)!.settings.arguments;
    if (routeArg != null) {
      final product =
          context.read<ProductsProvider>().findById(routeArg as String);
      _id = product.id;
      _title = product.title;
      _descriprion = product.description;
      _price = product.price;
      _imageUrl = product.imageUrl;
      _isFavorite = product.isFavorite;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit product'),
        actions: [
          IconButton(
              onPressed: () {
                _saveForm();
              },
              icon: const Icon(Icons.save))
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Form(
                    key: _form,
                    child: Column(
                      children: [
                        TextFormField(
                          initialValue: _title,
                          decoration: const InputDecoration(labelText: 'Title'),
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(_priceFocusNode);
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please provide a value';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _title = value ?? '';
                          },
                        ),
                        TextFormField(
                          initialValue: _price == null ? '' : _price.toString(),
                          decoration: const InputDecoration(labelText: 'Price'),
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          focusNode: _priceFocusNode,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(_descriptionFocusNode);
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a price';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Please enter a valid number';
                            }
                            if (double.parse(value) <= 0) {
                              return 'Please enter a number greater than zero';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _price = double.parse(value as String);
                          },
                        ),
                        TextFormField(
                          initialValue: _descriprion,
                          maxLines: 3,
                          maxLength: 500,
                          decoration:
                              const InputDecoration(labelText: 'Description'),
                          keyboardType: TextInputType.multiline,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(500)
                          ],
                          focusNode: _descriptionFocusNode,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a desctiption';
                            }
                            if (value.length < 12) {
                              return 'Should be at least 12 characters long';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _descriprion = value ?? '';
                          },
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: TextFormField(
                                initialValue: _imageUrl,
                                decoration: const InputDecoration(
                                    labelText: "Image URL"),
                                keyboardType: TextInputType.url,
                                textInputAction: TextInputAction.done,
                                // controller: _imageUrlController,
                                focusNode: _imageUrlFocusNode,
                                onEditingComplete: () {
                                  setState(() {});
                                },
                                onFieldSubmitted: (_) {
                                  _saveForm();
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a image URL';
                                  }
                                  if (!value.startsWith('https://') &&
                                      !value.startsWith('http://')) {
                                    return 'Please enter a valid URL';
                                  }
                                  if (!value.endsWith('.png') &&
                                      !value.endsWith('.jpg') &&
                                      !value.endsWith('.jpeg')) {
                                    return 'Please enter a valid URL';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _imageUrl = value ?? '';
                                },
                              ),
                            ),
                            Container(
                              width: 100,
                              height: 100,
                              margin: const EdgeInsets.only(top: 10, left: 15),
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(width: 1, color: Colors.grey)),
                              child: _imageUrl == null
                                  ? const Text("Enter a URL")
                                  : FittedBox(
                                      child: Image.network(
                                        _imageUrl as String,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                            ),
                          ],
                        )
                      ],
                    )),
              ),
            ),
    );
  }
}
