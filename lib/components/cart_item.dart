import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/cart.dart';
import 'package:shop/models/cart_item.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem item;

  const CartItemWidget({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(item.id),
      direction: DismissDirection.endToStart,
      background: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          alignment: Alignment.centerRight,
          color: Theme.of(context).errorColor,
          child: const Icon(
            Icons.delete,
            color: Colors.white,
            size: 40,
          ),
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4)),
      confirmDismiss: (_) {
        return showDialog<bool>(
            context: context,
            builder: (ctx) => (AlertDialog(
                  title: const Text('Are you sure?'),
                  content: const Text(
                      'Would you like to remove the item from the cart?'),
                  actions: [
                    TextButton(
                        onPressed: () => {Navigator.of(ctx).pop(true)},
                        child: const Text('Yes')),
                    TextButton(
                        onPressed: () => {Navigator.of(ctx).pop(false)},
                        child: const Text('No')),
                  ],
                )));
      },
      onDismissed: (_) =>
          Provider.of<Cart>(context, listen: false).removeItem(item.productId),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(item.imageUrl),
          ),
          title: Text(item.name),
          subtitle: Text('R\$ ${item.price * item.quantity}'),
          trailing: Text('${item.quantity}x R\$${item.price}'),
        ),
      ),
    );
  }
}
