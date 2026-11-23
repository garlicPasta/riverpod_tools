import 'package:riverpod_forms/riverpod_forms.dart';

typedef ListItemError<ITEM, ERR> = EqualList<ItemError<ITEM, ERR>>;

final class ItemError<ITEM, ERR>(final ITEM item,final ERR error) {}
