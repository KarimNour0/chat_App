import 'package:chat/Chat_Screen.dart';
import 'package:chat/auth/SignUp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  var emailController = TextEditingController();

  var passwordController = TextEditingController();

  var formkey = GlobalKey<FormState>();

  bool password = true;


  @override
  Widget build(BuildContext context) {
    return Form(
      key: formkey,
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Chat App Clone',
                      style: TextStyle(
                        fontSize: 35,
                        color: Colors.red[400],
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const Text(
                      'LOGIN',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    TextFormField(
                      controller: emailController,
                      validator: (value){
                        if(value!.isEmpty){
                          return 'please Enter invalid Email';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Email Address',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.email),
                      ),
                    ),
                    SizedBox(height: 20,),
                    TextFormField(
                        controller: passwordController,
                        validator: (value){
                          if(value!.isEmpty){
                            return 'please enter invalid password ';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: password,   //دي مهمه جدا عشان اعرف اخفي الباسورد
                        decoration: InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.lock),
                          suffixIcon: IconButton(onPressed: (){
                            setState(() {
                              password =!password;
                            });
                          },
                              icon : password ?  Icon(Icons.remove_red_eye) :Icon(Icons.visibility_off)),
                        )
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width - 40,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.red[400],
                        borderRadius: const BorderRadius.all(
                          Radius.circular(5),
                        ),
                      ),
                      child: InkWell(
                        onTap: () async {
                          if(formkey.currentState!.validate()){}

                          try{
                            UserCredential user = await FirebaseAuth.instance.signInWithEmailAndPassword(
                              email: emailController.text,
                              password: passwordController.text,
                            );
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (BuildContext context) => ChatScreen(email: emailController.text)),
                            );
                          }
                          on FirebaseAuthException catch(e)
                          {
                            if (e.code == 'user-not-found') {
                              ShowSnapBar(context, e);
                            }
                            else if (e.code == 'wrong-password') {
                              ShowSnapBar(context, e);
                            }

                          }

                          // ScaffoldMessenger.of(context).showSnackBar(
                          //     SnackBar(content: Text('Success')));

                        },


                        child: const Center(
                          child: Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Already have an account? ',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        InkWell(
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => SignupScreen(),
                            ),
                          ),
                          child: Text(
                            'Register Here',
                            style: TextStyle(fontSize: 20, color: Colors.red[400]),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void ShowSnapBar(BuildContext context, FirebaseAuthException e) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.code.toString())));
  }
}
