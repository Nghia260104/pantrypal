import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pantrypal/widgets/rounded_box.dart';
import 'package:pantrypal/controllers/dropdown_controller.dart';

class CustomDropdownButton extends StatelessWidget {
  final RxString selectedValue; // Reactive variable for the selected value
  final RxInt? selectedIndex;
  final List<String> items; // List of dropdown items
  final Function(String) onChanged; // Callback for value change
  final dropdownController = Get.find<DropdownController>(); // GetX controller for managing dropdown state

  // Customization options
  final double? width;
  final double? height;
  final Color textColor;
  final TextStyle? textStyle;
  final TextStyle? selectedText;
  final Color buttonColor;
  final Color outlineColor;
  final Color selectedColor;
  final double outlineStroke;
  final Color iconColor;
  final EdgeInsets padding;

  // New property for enabling/disabling the dropdown
  final bool isEnabled;
  final TextStyle? disabledTextStyle;

  CustomDropdownButton({
    super.key,
    required this.selectedValue,
    this.selectedIndex,
    required this.items,
    required this.onChanged,
    this.width,
    this.height,
    this.textColor = Colors.black,
    this.textStyle,
    this.selectedText,
    this.buttonColor = Colors.white,
    this.outlineColor = Colors.grey,
    this.selectedColor = Colors.blue,
    this.outlineStroke = 1,
    this.iconColor = Colors.black,
    this.padding = const EdgeInsets.only(left: 16, right: 4, top: 12, bottom: 12),
    this.isEnabled = true, // Default to enabled
    this.disabledTextStyle, // Default disabled color
  });

  final RxBool isDropdownOpen = false.obs; // Reactive variable for dropdown open/close state
  final Rx<OverlayEntry?> overlayEntry = Rx<OverlayEntry?>(null); // Reactive OverlayEntry

  void _toggleDropdown(BuildContext context) {
    if (!isEnabled) return; // Do nothing if disabled
    if (isDropdownOpen.value) {
      _closeDropdown();
    } else {
      _openDropdown(context);
    }
  }

  void _openDropdown(BuildContext context) {
    if (!isEnabled) return; // Do nothing if disabled

    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    final Size size = renderBox.size;

    overlayEntry.value = OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            // Background overlay to detect taps outside the dropdown
            GestureDetector(
              onTap: _closeDropdown,
              child: Container(
                color: Colors.transparent,
              ),
            ),
            // Dropdown list
            Positioned(
              left: offset.dx,
              top: offset.dy + size.height + 2,
              width: size.width,
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  decoration: BoxDecoration(
                    color: buttonColor,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withAlpha(80),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: outlineColor,
                          width: outlineStroke,
                        ),
                      ),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: items.length > 3
                              ? 3 * ((height ?? 48) + 8) // Limit height to 3 items
                              : double.infinity, // No limit if items <= 3
                        ),
                        child: ListView.builder(
                          shrinkWrap: true,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            final item = items[index];
                            return Material(
                              color: (selectedValue.value == item
                                  ? selectedColor
                                  : buttonColor),
                              child: InkWell(
                                onTap: () {
                                  if (!isEnabled) return; // Do nothing if disabled
                                  selectedValue.value = item; // Update selected value
                                  selectedIndex?.value = index; // Update selected index
                                  onChanged(item); // Trigger callback
                                  _closeDropdown(); // Close dropdown
                                },
                                child: Padding(
                                  padding: padding,
                                  child: Text(
                                    item,
                                    style: (selectedValue.value == item
                                        ? (selectedText ??
                                            TextStyle(
                                              fontSize: 16,
                                              color: textColor,
                                            ))
                                        : (textStyle ??
                                            TextStyle(
                                              fontSize: 16,
                                              color: textColor,
                                            ))),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );

    // Overlay.of(context).insert(overlayEntry.value!);
    dropdownController.showOverlay(overlayEntry, context);
    isDropdownOpen.value = true;
  }

  void _closeDropdown() {
    // overlayEntry.value?.remove();
    // overlayEntry.value = null; // Reset the overlay entry
    dropdownController.closeOverlay();
    isDropdownOpen.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return GestureDetector(
        onTap: () => _toggleDropdown(context),
        child: RoundedBox(
          width: width,
          height: height,
          padding: padding,
          outlineColor: isEnabled ? outlineColor : outlineColor.withAlpha(50), // Dim outline when disabled
          outlineStroke: outlineStroke,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Wrap the Text widget in Expanded to prevent overflow
              Expanded(
                child: Text(
                  selectedValue.value,
                  style: isEnabled
                      ? textStyle
                      : (disabledTextStyle ??
                          TextStyle(
                            fontSize: 16,
                            color: Colors.grey, // Dim text when disabled
                          )),
                  overflow: TextOverflow.ellipsis, // Add ellipsis for overflowed text
                  maxLines: 1, // Ensure the text is limited to one line
                ),
              ),
              Icon(
                Icons.arrow_drop_down,
                color: isEnabled ? iconColor : iconColor.withAlpha(100), // Dim icon when disabled
              ),
            ],
          ),
        ),
      );
    });
  }
}