import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:the_guc_cc_app/MyRoundedLoadingButton.dart';
import 'package:the_guc_cc_app/Wrapper.dart';
import 'package:the_guc_cc_app/authorization/Auth.dart';
import 'package:the_guc_cc_app/objects/MyUser.dart';

class Signing extends StatefulWidget {
  const Signing({Key? key}) : super(key: key);
  static const routeName = '/signing';

  @override
  _SigningState createState() => _SigningState();
}

class _SigningState extends State<Signing> with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey1 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  late String _email;
  late String _password;
  late String _name;

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  bool _signUp = true;
  String defaultUserType = "Normal Student";
  TextEditingController userType = TextEditingController();

  late List<TextEditingController> allControllers;
  late TabController _tabController;
  @override
  void dispose() {
    _tabController.dispose();
    allControllers.map((e) => e.dispose());
    super.dispose();
  }

  MyUser? currentUser;
  @override
  void initState() {
    super.initState();
    userType.text = defaultUserType;
    _tabController = TabController(vsync: this, length: 2);
    allControllers = [_emailController, _passwordController, _nameController];
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                height: 70,
                child: Center(
                  child: Text(
                    "The GUC CC App",
                    style: TextStyle(fontSize: 40),
                  ),
                ),
              ),
              //SIGN UP OR SIGNIN
              Card(
                elevation: 8,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TabBar(
                        labelColor: Colors.black,
                        onTap: (int index) {
                          if (index == 0) {
                            setState(() {
                              _signUp = true;
                            });
                          } else {
                            setState(() {
                              _signUp = false;
                            });
                          }
                        },
                        // labelColor: Colors.white,
                        // unselectedLabelColor:
                        //     Theme.of(context).textTheme.bodyText1!.color,
                        indicator: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(50), // Creates border
                            color: Colors.amber),
                        controller: _tabController,
                        tabs: [
                          Tab(
                            child: Text(
                              "Sign Up",
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ),
                          Tab(
                            child: Text("Log In",
                                style: TextStyle(
                                  fontSize: 15,
                                )),
                          )
                        ],
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.65,
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          Form(
                              key: _formKey1,
                              child: SignUp(
                                  controllers: allControllers,
                                  userType: userType)),
                          Form(
                            key: _formKey2,
                            child: LogIn(
                              controllers: [
                                allControllers[0],
                                allControllers[1]
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 8.0),
                      child: MyRoundedLoadingButton(
                          action: () async {
                            print('hello in action loading button');
                            bool allIsOk = false;

                            if (_signUp) {
                              if (_formKey1.currentState!.validate()) {
                                print("userType is" + userType.text);
                                try {
                                  await auth.handleSignUp(
                                      _emailController.text,
                                      _passwordController.text,
                                      _nameController.text,
                                      userType.text);
                                  allIsOk = true;
                                  Navigator.of(context)
                                      .pushNamed(Wrapper.routeName);
                                } on Exception catch (e) {
                                  _showErrorDialog(context,
                                      "couldn't creat a new account", e);
                                }
                              }
                            } else {
                              print('hello in login');
                              if (_formKey2.currentState!.validate()) {
                                try {
                                  print('in try signIn');
                                  currentUser = await auth.handleSignInEmail(
                                      _emailController.text,
                                      _passwordController.text);
                                  print('signedIN');
                                  allIsOk = true;
                                  Navigator.of(context)
                                      .pushNamed(Wrapper.routeName);
                                } on Exception catch (e) {
                                  _showErrorDialog(
                                      context, "couldn't signIn", e);
                                }
                              }
                            }
                          },
                          child: Text('Submit')),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void _showErrorDialog(BuildContext context, String title, Exception e) {
  showDialog<void>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(
          title,
          style: const TextStyle(fontSize: 24),
        ),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(
                '${(e as dynamic).message}',
                style: const TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK')),
        ],
      );
    },
  );
}

//   void _showMessageDialog(BuildContext context, String title) {
//     showDialog<void>(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text(
//             title,
//             style: const TextStyle(fontSize: 24),
//           ),
//           content: SingleChildScrollView(
//             child: ListBody(
//               children: <Widget>[
//                 Text(
//                   "Verify your email by clicking the link sent to be able to access your account",
//                   style: const TextStyle(fontSize: 18),
//                 ),
//               ],
//             ),
//           ),
//           actions: <Widget>[
//             MyButton(
//                 action: () {
//                   Navigator.of(context).pop();
//                 },
//                 text: 'OK'),
//           ],
//         );
//       },
//     );
//   }
// }

class LogIn extends StatelessWidget {
  final List<TextEditingController> controllers;

  const LogIn({
    Key? key,
    required this.controllers,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            MyTextFormField(
              text: 'Email',
              obscureText: false,
              controller: controllers[0],
            ),
            MyTextFormField(
              text: 'Password',
              obscureText: true,
              controller: controllers[1],
            )
          ],
        ));
  }
}

class SignUp extends StatefulWidget {
  final List<TextEditingController> controllers;
  TextEditingController userType;

  SignUp({Key? key, required this.controllers, required this.userType})
      : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MyTextFormField(
                text: 'Email',
                obscureText: false,
                controller: widget.controllers[0]),
            MyTextFormField(
              text: 'Password',
              obscureText: true,
              controller: widget.controllers[1],
            ),
            MyTextFormField(
              text: 'Name',
              obscureText: false,
              controller: widget.controllers[2],
              constraint: 15,
              //inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'[.\\\[\]\*\`]'),replacementString: ' ')],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Type of User"),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButton<String>(
                value: widget.userType.text,
                icon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                ),
                iconSize: 24,
                elevation: 16,
                style: const TextStyle(color: Colors.black),
                underline: Container(
                  height: 2,
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    widget.userType.text = newValue!;
                  });
                },
                items: <String>['Normal Student', 'CC member']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            )
          ],
        ));
  }
}

class MyTextFormField extends StatefulWidget {
  final String text;
  final bool obscureText;
  final TextEditingController controller;
  final int? constraint;
  final List<TextInputFormatter>? inputFormatters;
  const MyTextFormField(
      {Key? key,
      required this.text,
      required this.obscureText,
      required this.controller,
      int? constraint,
      List<TextInputFormatter>? inputFormatters})
      : this.constraint = constraint,
        this.inputFormatters = inputFormatters,
        super(key: key);

  @override
  _MyTextFormFieldState createState() => _MyTextFormFieldState();
}

class _MyTextFormFieldState extends State<MyTextFormField> {
  late TextEditingController _controller;
  bool _showPassword = false;
  @override
  void initState() {
    // TODO: implement initState
    _controller = widget.controller;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        inputFormatters: widget.inputFormatters,
        maxLength: widget.constraint,
        maxLengthEnforcement: MaxLengthEnforcement.enforced,
        obscureText: (widget.obscureText && !_showPassword),
        controller: _controller,
        decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: widget.text,
            suffixIcon: (widget.obscureText)
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        _showPassword = !_showPassword;
                      });
                    },
                    icon: Icon(_showPassword
                        ? Icons.visibility
                        : Icons.visibility_off))
                : null),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please enter some text";
          }
          return null;
        },
      ),
    );
  }
}
