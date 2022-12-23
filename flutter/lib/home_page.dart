// Copyright 2022 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'main.dart';
import 'src/authentication.dart';
import 'src/widgets.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationState>(
        builder: (context, appState, child) => Scaffold(
          appBar: AppBar(
            title: const Text('Firebase Meetup'),
          ),
          body: ListView(
            children: <Widget>[
              Image.asset('assets/codelab.png'),
              const SizedBox(height: 8),
              const IconAndDetail(Icons.calendar_today, 'October 30'),
              const IconAndDetail(Icons.location_city, 'San Francisco'),
              Consumer<ApplicationState>(
                builder: (context, appState, _) => AuthFunc(
                    loggedIn: appState.loggedIn,
                    signOut: () {
                      FirebaseAuth.instance.signOut();
                    }),
              ),
              const Divider(
                height: 8,
                thickness: 1,
                indent: 8,
                endIndent: 8,
                color: Colors.grey,
              ),
              const Header("What we'll be doing"),
              const Paragraph(
                'Join us for a day full of Firebase Workshops and Pizza!',
              ),

              // Add from here
              Consumer<ApplicationState>(
                builder: (context, appState, _) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (appState.attendees >= 2)
                      Paragraph('${appState.attendees} people going')
                    else if (appState.attendees == 1)
                      const Paragraph('1 person going')
                    else
                      const Paragraph('No one going'),

                    if (appState.loggedIn) ...[
                      YesNoSelection(
                        state: appState.attending,
                        onSelection: (attending) => appState.attending = attending,
                      ),
                      const Header('Discussion'),
                      GuestBook(
                        addMessage: (message) =>
                            appState.addMessageToGuestBook(message),
                        messages: appState.guestBookMessages,
                      ),
                    ],
                  ],
                ),
              ),
              // to here
            ],
          ),
        ));
  }
}

class YesNoSelection extends StatelessWidget {
  const YesNoSelection(
      {super.key, required this.state, required this.onSelection});
  final Attending state;
  final void Function(Attending selection) onSelection;

  @override
  Widget build(BuildContext context) {
    switch (state) {
      case Attending.yes:
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(elevation: 0),
                onPressed: () => onSelection(Attending.yes),
                child: const Text('YES'),
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: () => onSelection(Attending.no),
                child: const Text('NO'),
              ),
            ],
          ),
        );
      case Attending.no:
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              TextButton(
                onPressed: () => onSelection(Attending.yes),
                child: const Text('YES'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(elevation: 0),
                onPressed: () => onSelection(Attending.no),
                child: const Text('NO'),
              ),
            ],
          ),
        );
      default:
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              StyledButton(
                onPressed: () => onSelection(Attending.yes),
                child: const Text('YES'),
              ),
              const SizedBox(width: 8),
              StyledButton(
                onPressed: () => onSelection(Attending.no),
                child: const Text('NO'),
              ),
            ],
          ),
        );
    }
  }
}
