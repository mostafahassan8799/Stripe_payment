import 'package:checkout_payment_ui/Features/checkout/data/models/amount_model/amount_model.dart';
import 'package:checkout_payment_ui/Features/checkout/data/models/amount_model/details.dart';
import 'package:checkout_payment_ui/Features/checkout/data/models/item_list_model/item.dart';
import 'package:checkout_payment_ui/Features/checkout/data/models/item_list_model/item_list_model.dart';
import 'package:checkout_payment_ui/Features/checkout/data/models/payment_intent_input_model.dart';
import 'package:checkout_payment_ui/Features/checkout/presentation/manger/cubit/payment_cubit.dart';
import 'package:checkout_payment_ui/Features/checkout/presentation/views/thank_you_view.dart';
import 'package:checkout_payment_ui/core/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_paypal_payment/flutter_paypal_payment.dart';

class CustomButtonBlocConsumer extends StatelessWidget {
  const CustomButtonBlocConsumer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PaymentCubit, PaymentState>(
      listener: (context, state) {
        if (state is PaymentSuccess) {
          Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (context) {
            return const ThankYouView();
          }));
        }
        if (state is PaymentFailure) {
          Navigator.of(context).pop();
          SnackBar snackBar = SnackBar(content: Text(state.errMessage));
          print("Erorr: " + state.errMessage);
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      },
      builder: (context, state) {
        return CustomButton(
            text: "Choose your payment method",
            onTap: () {
              PaymentIntentInputModel paymentIntentInputModel =
                  PaymentIntentInputModel(amount: '100', currency: 'USD');
              BlocProvider.of<PaymentCubit>(context).makePayment(
                  paymentIntentInputModel: paymentIntentInputModel);
                  //TODO: When paypal is available
            //  var transactionData = getTransActionData();
            //   excutePaypalPayment(context, transactionData);
            // },
            // isLoading: state is PaymentLoading ? true : false,
            // text: 'Continue');
      
        });
      },
    );
  }

  void excutePaypalPayment(BuildContext context, ({AmountModel amount, ItemListModel itemList}) transactionData) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext context) => PaypalCheckoutView(
        sandboxMode: true,
        clientId: "YOUR CLIENT ID", //replace with your client id 
        secretKey: "YOUR SECRET KEY", //replace with your secret key
        transactions: [
          {
            "amount": transactionData.amount.toJson(),
            "description": "The payment transaction description.",
            "item_list": {
              "items": transactionData.itemList.toJson(),
            }
          }
        ],
        note: "Contact us for any questions on your order.",
        onSuccess: (Map params) async {
          print("onSuccess: $params");
          Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (context) {
            return const ThankYouView();
          }));
        },
        onError: (error) {
          print("onError: $error");
          Navigator.pop(context);
        },
        onCancel: () {
          print('cancelled:');
          Navigator.pop(context);
        },
      ),
    ));
  }
({AmountModel amount, ItemListModel itemList}) getTransActionData(){
   var amount = AmountModel(
                total: "100",
                currency: 'USD',
                details: Details(
                  shipping: "0",
                  shippingDiscount: 0,
                  subtotal: "100",
                )
              );
              List<OrderItemModel> orders = [
                OrderItemModel(
                  currency: 'USD',
                  name: 'Orange',
                  price: '4',
                  quantity: 10,
                ),
                OrderItemModel(
                  currency: 'USD',
                  name: 'Drinks',
                  price: '5',
                  quantity: 12,
                ),
              ];
              var itemList = ItemListModel(orders: orders);
              return(amount:amount,itemList:itemList);

}

}
