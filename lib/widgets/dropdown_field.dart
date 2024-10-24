part of '../custom_dropdown.dart';

// overlay icon
const _defaultOverlayIconDown = Icon(
  Icons.keyboard_arrow_down_rounded,
  size: 20,
);

class _DropDownField<T> extends StatefulWidget {
  final VoidCallback onTap;
  final ValueNotifier<T?> selectedItemNotifier;
  final String hintText;
  final Color? fillColor;
  final BoxBorder? border;
  final BorderRadius? borderRadius;
  final String? errorText;
  final TextStyle? errorStyle, headerStyle, hintStyle;
  final BorderSide? errorBorderSide;
  final Widget? suffixIcon;
  final List<BoxShadow>? shadow;
  final EdgeInsets? headerPadding;
  final int maxLines;
  final _HeaderBuilder<T>? headerBuilder;
  final _HeaderListBuilder<T>? headerListBuilder;
  final _HintBuilder? hintBuilder;
  final _DropdownType dropdownType;
  final _ValueNotifierList<T> selectedItemsNotifier;
  final bool enabled;
  final VoidCallback resetSelection;

  const _DropDownField({
    super.key,
    required this.onTap,
    required this.selectedItemNotifier,
    required this.maxLines,
    required this.dropdownType,
    required this.selectedItemsNotifier,
    required this.resetSelection,
    this.hintText = 'Select value',
    this.fillColor,
    this.border,
    this.borderRadius,
    this.errorText,
    this.errorStyle,
    this.hintStyle,
    this.headerStyle,
    this.errorBorderSide,
    this.headerBuilder,
    this.shadow,
    this.headerListBuilder,
    this.hintBuilder,
    this.suffixIcon,
    this.headerPadding,
    this.enabled = true,
  });

  @override
  State<_DropDownField<T>> createState() => _DropDownFieldState<T>();
}

class _DropDownFieldState<T> extends State<_DropDownField<T>> {
  T? selectedItem;
  late List<T> selectedItems;

  @override
  void initState() {
    super.initState();
    selectedItem = widget.selectedItemNotifier.value;
    selectedItems = widget.selectedItemsNotifier.value;
  }

  void resetSelection() {
    widget.resetSelection();
    selectedItem = null;
    selectedItems = [];
    setState(() {});
  }

  Widget hintBuilder(BuildContext context) {
    return widget.hintBuilder != null
        ? widget.hintBuilder!(context, widget.hintText, widget.enabled)
        : defaultHintBuilder(widget.hintText, widget.enabled);
  }

  Widget headerBuilder(BuildContext context) {
    return widget.headerBuilder != null
        ? widget.headerBuilder!(context, selectedItem as T, widget.enabled)
        : defaultHeaderBuilder(oneItem: selectedItem);
  }

  Widget headerListBuilder(BuildContext context) {
    return widget.headerListBuilder != null
        ? widget.headerListBuilder!(
            context, selectedItems, widget.enabled, resetSelection)
        : defaultHeaderBuilder(
            itemList: selectedItems, resetSelection: resetSelection);
  }

  Widget defaultHeaderBuilder(
      {T? oneItem, List<T>? itemList, VoidCallback? resetSelection}) {
    return Row(
      children: [
        Expanded(
          child: Text(
            itemList != null ? itemList.join(', ') : oneItem.toString(),
            maxLines: widget.maxLines,
            overflow: TextOverflow.ellipsis,
            style: widget.headerStyle ??
                const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ),
        if (resetSelection != null)
          GestureDetector(
            onTap: resetSelection,
            child: const Icon(
              Icons.close,
              size: 20,
            ),
          ),
      ],
    );
  }

  Widget defaultHintBuilder(String hint, bool enabled) {
    return Text(
      hint,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: widget.hintStyle ??
          TextStyle(
            fontSize: 16,
            color: enabled ? const Color(0xFFA7A7A7) : const Color(0xFFB9B9B9),
          ),
    );
  }

  @override
  void didUpdateWidget(covariant _DropDownField<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    switch (widget.dropdownType) {
      case _DropdownType.singleSelect:
        selectedItem = widget.selectedItemNotifier.value;
      case _DropdownType.multipleSelect:
        selectedItems = widget.selectedItemsNotifier.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        padding: widget.headerPadding ?? _defaultHeaderPadding,
        decoration: BoxDecoration(
          color: widget.fillColor ??
              (widget.enabled
                  ? CustomDropdownDecoration._defaultFillColor
                  : CustomDropdownDecoration._defaultDisabledFillColor),
          border: widget.border,
          borderRadius: widget.borderRadius ?? _defaultBorderRadius,
          boxShadow: widget.shadow,
        ),
        child: Row(
          children: [
            Expanded(
              child: switch (widget.dropdownType) {
                _DropdownType.singleSelect => selectedItem != null
                    ? headerBuilder(context)
                    : hintBuilder(context),
                _DropdownType.multipleSelect => selectedItems.isNotEmpty
                    ? headerListBuilder(context)
                    : hintBuilder(context),
              },
            ),
            const SizedBox(width: 12),
            widget.suffixIcon ?? _defaultOverlayIconDown,
          ],
        ),
      ),
    );
  }
}
