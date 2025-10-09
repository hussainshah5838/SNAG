import 'package:snag/constants/app_colors.dart';
import 'package:snag/constants/app_fonts.dart';
import 'package:snag/constants/app_images.dart';
import 'package:snag/constants/app_sizes.dart';
import 'package:snag/view/widget/custom_app_bar_widget.dart';
import 'package:snag/view/widget/my_button_widget.dart';
import 'package:snag/view/widget/my_text_field_widget.dart';
import 'package:snag/view/widget/my_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
import 'package:flutter_native_contact_picker/model/contact.dart'
    as native_contact;

// ignore: must_be_immutable
class UserAddNewMeetup extends StatefulWidget {
  @override
  State<UserAddNewMeetup> createState() => _UserAddNewMeetupState();
}

class _UserAddNewMeetupState extends State<UserAddNewMeetup> {
  // Simple contact model for display
  final List<dynamic> _selectedContacts = [];

  Future<void> _pickContact() async {
    dynamic contact;
    try {
      final picker = FlutterNativeContactPicker();
      // prefer selecting a full contact first
      contact = await picker.selectContact();
      // if selectContact returns null or unsupported, try selectPhoneNumber
      if (contact == null) {
        try {
          contact = await picker.selectPhoneNumber();
        } catch (_) {
          contact = null;
        }
      }
    } catch (e) {
      contact = null;
    }

    if (contact != null) {
      // avoid adding duplicates
      if (_isDuplicate(contact)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Contact already added',
              style: TextStyle(
                color: kPrimaryColor,
                fontFamily: AppFonts.WORK_SANS,
              ),
            ),
          ),
        );
        return;
      }

      setState(() {
        _selectedContacts.add(contact);
      });
      return;
    }
  }

  // Normalize and compare contacts to avoid duplicates
  bool _isDuplicate(dynamic contact) {
    try {
      return _selectedContacts.any((c) => _contactEquals(c, contact));
    } catch (e) {
      return false;
    }
  }

  bool _contactEquals(dynamic a, dynamic b) {
    if (a == null || b == null) return false;

    // compare phone numbers if available
    final phonesA = _getPhones(a);
    final phonesB = _getPhones(b);
    for (final pa in phonesA) {
      for (final pb in phonesB) {
        if (pa.isNotEmpty && pb.isNotEmpty && pa == pb) return true;
      }
    }

    // fallback to comparing names when phones not available
    final nameA = _getName(a);
    final nameB = _getName(b);
    if (nameA != null &&
        nameB != null &&
        nameA.trim().isNotEmpty &&
        nameA.toLowerCase() == nameB.toLowerCase()) {
      return true;
    }

    return false;
  }

  List<String> _getPhones(dynamic c) {
    try {
      final List<String> out = [];

      // flutter_native_contact_picker Contact
      if (c is native_contact.Contact) {
        if (c.selectedPhoneNumber != null)
          out.add(_normalizePhone(c.selectedPhoneNumber!));
        if (c.phoneNumbers != null)
          out.addAll(c.phoneNumbers!.map((p) => _normalizePhone(p.toString())));
      }

      // common map-based structures
      if (c is Map) {
        if (c['phone'] != null) out.add(_normalizePhone(c['phone'].toString()));
        if (c['phoneNumber'] != null)
          out.add(_normalizePhone(c['phoneNumber'].toString()));
        if (c['contact'] != null)
          out.add(_normalizePhone(c['contact'].toString()));
      }

      // generic fields
      try {
        if (c.selectedPhoneNumber != null)
          out.add(_normalizePhone(c.selectedPhoneNumber.toString()));
      } catch (_) {}
      try {
        if (c.phoneNumber != null)
          out.add(_normalizePhone(c.phoneNumber.toString()));
      } catch (_) {}
      try {
        if (c.phones != null && c.phones is List)
          out.addAll(
            (c.phones as List).map((p) => _normalizePhone(p.toString())),
          );
      } catch (_) {}

      return out.where((s) => s.isNotEmpty).toSet().toList();
    } catch (e) {
      return [];
    }
  }

  String? _getName(dynamic c) {
    try {
      if (c is native_contact.Contact) return c.fullName;
      if (c is Map) {
        return (c['name'] ??
                c['fullName'] ??
                c['displayName'] ??
                c['contactName'])
            ?.toString();
      }
      try {
        if (c.fullName != null) return c.fullName.toString();
      } catch (_) {}
      try {
        if (c.displayName != null) return c.displayName.toString();
      } catch (_) {}
      try {
        if (c.name != null) return c.name.toString();
      } catch (_) {}
    } catch (e) {}
    return null;
  }

  String _normalizePhone(String raw) {
    // remove non-digits
    final cleaned = raw.replaceAll(RegExp(r'[^0-9+]'), '');
    // optionally remove leading country plus if present for consistent comparison
    return cleaned;
  }

  String _displayContactLabel(dynamic contact) {
    if (contact == null) return '';
    try {
      // Handle flutter_native_contact_picker Contact model
      if (contact is native_contact.Contact) {
        if (contact.fullName != null && contact.fullName!.trim().isNotEmpty)
          return contact.fullName!;
        if (contact.selectedPhoneNumber != null &&
            contact.selectedPhoneNumber!.trim().isNotEmpty)
          return contact.selectedPhoneNumber!;
        if (contact.phoneNumbers != null && contact.phoneNumbers!.isNotEmpty)
          return contact.phoneNumbers!.first;
      }
      // If local fallback stored a Map, use its fields
      if (contact is Map) {
        final name =
            contact['name'] ?? contact['fullName'] ?? contact['displayName'];
        final c =
            contact['contact'] ?? contact['phone'] ?? contact['phoneNumber'];
        if (name != null && name.toString().trim().isNotEmpty)
          return name.toString();
        if (c != null && c.toString().trim().isNotEmpty) return c.toString();
      }
      // try common fields used by various contact picker implementations
      if (contact.fullName != null &&
          contact.fullName.toString().trim().isNotEmpty)
        return contact.fullName.toString();
      if (contact.displayName != null &&
          contact.displayName.toString().trim().isNotEmpty)
        return contact.displayName.toString();
      if (contact.name != null && contact.name.toString().trim().isNotEmpty)
        return contact.name.toString();
      // try phone fields
      if (contact.phoneNumber != null) return contact.phoneNumber.toString();
      if (contact.phones != null &&
          contact.phones is List &&
          contact.phones.isNotEmpty)
        return contact.phones[0].toString();
      // fallback to generic string
      return contact.toString();
    } catch (e) {
      return contact.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(title: ''),
      body: ListView(
        shrinkWrap: true,
        padding: AppSizes.DEFAULT,
        physics: BouncingScrollPhysics(),
        children: [
          MyText(
            text: 'Add New Meetup',
            paddingTop: 8,
            size: 24,
            weight: FontWeight.w600,
            paddingBottom: 8,
          ),
          MyText(
            text:
                'Bring people together with Snag. We’ll keep it simple and organized for you.',
            size: 16,
            lineHeight: 1.5,
            weight: FontWeight.w500,
            color: kQuaternaryColor,
            paddingBottom: 30,
          ),
          MyTextField(
            labelText: 'Meetup Title',
            hintText: 'e.g., Weekend Shopping Spree',
            prefix: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Image.asset(Assets.imagesTt, height: 20)],
            ),
          ),
          MyTextField(
            maxLines: 2,
            labelText: 'Message to friends',
            hintText: 'e.g., Catching up with friends, planning an event',
            prefix: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Image.asset(Assets.imagesGps, height: 20)],
            ),
          ),
          MyTextField(
            labelText: 'Location',
            hintText: 'Search or enter a location',
            prefix: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Image.asset(Assets.imagesLoc, height: 20)],
            ),
            suffix: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Image.asset(Assets.imagesMap, height: 20)],
            ),
          ),
          MyTextField(
            labelText: 'Date',
            hintText: 'Select date',
            isReadOnly: true,
            prefix: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Image.asset(Assets.imagesDate, height: 16)],
            ),

            onTap: () async {},
          ),
          MyTextField(
            labelText: 'Time',
            hintText: 'Select time',
            isReadOnly: true,
            prefix: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Image.asset(Assets.imagesClock, height: 20)],
            ),
            suffix: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Image.asset(Assets.imagesStopWatch, height: 20)],
            ),
            onTap: () async {
              // Implement time picker logic here
            },
          ),
          MyTextField(
            onTap: () async {
              await _pickContact();
            },
            isReadOnly: true,
            labelText: 'Invite Participants',
            hintText: 'Invite by adding Email or selecting Contacts',
            prefix: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Image.asset(Assets.imagesParticipants, height: 20)],
            ),
            suffix: GestureDetector(
              onTap: () async {
                await _pickContact();
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Image.asset(Assets.imagesLink, height: 20)],
              ),
            ),
          ),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children:
                _selectedContacts
                    .map(
                      (contact) => GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedContacts.remove(contact);
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: kLightBlueColor2,
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(color: kSecondaryColor),
                          ),
                          child: MyText(
                            paddingLeft: 4,
                            paddingRight: 4,
                            text: _displayContactLabel(contact),
                            size: 10,
                            color: kSecondaryColor,
                          ),
                        ),
                      ),
                    )
                    .toList(),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: AppSizes.DEFAULT,
        child: MyButton(buttonText: 'Add', onTap: () {}),
      ),
    );
  }
}
