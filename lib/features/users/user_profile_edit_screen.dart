import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tiktok_clone/features/authentication/view_models/signup_view_model.dart';
import 'package:flutter_tiktok_clone/features/users/view_models/users_view_model.dart';

class UserProfileEditScreen extends ConsumerStatefulWidget {
  const UserProfileEditScreen({super.key});

  @override
  ConsumerState<UserProfileEditScreen> createState() =>
      _UserProfileEditScreenState();
}

class _UserProfileEditScreenState extends ConsumerState<UserProfileEditScreen> {
  final _formKey = GlobalKey<FormState>();
  String _bio = '';
  String _link = '';

  @override
  void initState() {
    super.initState();
    _bio = ref.read(usersProvider).value!.bio;
    _link = ref.read(usersProvider).value!.link;
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final state = ref.read(signUpForm.notifier).state;
      ref.read(signUpForm.notifier).state = {...state, "bio": _bio};
      ref.read(signUpForm.notifier).state = {...state, "link": _link};

      ref.read(usersProvider.notifier).updateProfile(_bio, _link);

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(usersProvider).when(
          data: (data) => Scaffold(
            appBar: AppBar(
              title: const Text("Edit Profile"),
            ),
            body: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextFormField(
                      initialValue: data.bio,
                      decoration: const InputDecoration(labelText: 'bio'),
                      onSaved: (value) {
                        _bio = value!;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return '소개를 입력해주세요';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: data.link,
                      decoration: const InputDecoration(labelText: 'link'),
                      onSaved: (value) {
                        _link = value!;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return '링크를 입력해주세요';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: _saveProfile,
                        child: const Text('save'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          error: (error, stackTrace) => Center(
            child: Text(error.toString()),
          ),
          loading: () => const Center(
            child: CircularProgressIndicator.adaptive(),
          ),
        );
  }
}
