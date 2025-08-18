import 'package:kalbemd/Theme/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class CardCheckin extends StatefulWidget {
  final dynamic infoLog;
  final bool loading;
  final Function()? onTap;

  const CardCheckin({
    required this.infoLog,
    this.loading = false,
    this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  _CardCheckinState createState() => _CardCheckinState();
}

class _CardCheckinState extends State<CardCheckin> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: widget.loading ? null : widget.onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Icon(
                  FontAwesomeIcons.store,
                  color: Theme.of(context).primaryColor,
                  size: 36,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: widget.loading
                      ? const Center(
                          child: FittedBox(child: CircularProgressIndicator()),
                        )
                      : widget.infoLog["status_check_in"] == "Y"
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                const Text(
                                  "Anda sedang Check In di : ",
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  widget.infoLog["namaToko"],
                                  style: textStyleMediumBold,
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Card(
                                  margin: EdgeInsets.zero,
                                  shadowColor: Colors.transparent,
                                  color: Theme.of(context).primaryColor,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    child: Text(
                                      widget.infoLog["typeToko"],
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Card(
                                  margin: EdgeInsets.zero,
                                  shadowColor: Colors.transparent,
                                  color: Theme.of(context).primaryColor,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    child: Text(
                                      "Kunjungan ke - " +
                                          widget.infoLog["kunjungantokoke"],
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  children: [
                                    const Icon(
                                      FontAwesomeIcons.calendar,
                                      size: 16,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8),
                                      child: Text(
                                        DateFormat("d MMM y").format(
                                          DateTime.parse(
                                            widget.infoLog["infoLog"]
                                                ["time_check_in"],
                                          ),
                                        ),
                                      ),
                                    ),
                                    // const Icon(
                                    //   FontAwesomeIcons.clock,
                                    //   size: 16,
                                    // ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8),
                                      child: Text(
                                        DateFormat("H:m:s").format(
                                          DateTime.parse(
                                            widget.infoLog["infoLog"]
                                                ["time_check_in"],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                              ],
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  "Anda Belum Check In",
                                  style: textStyleMediumBold,
                                ),
                                Text(
                                  "Tap untuk Check In",
                                ),
                              ],
                            ),
                ),
              ),
              const Center(
                child: Icon(FontAwesomeIcons.chevronRight),
              )
            ],
          ),
        ),
      ),
    );
  }
}
