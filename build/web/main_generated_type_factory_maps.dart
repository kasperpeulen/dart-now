library dartnow.web.main.generated_type_factory_maps;

import 'package:di/di.dart';
import 'package:di/src/reflector_static.dart';
import 'package:di/type_literal.dart';

import 'package:mdl/mdldialog.dart' as import_0;
import 'package:mdl/mdltemplate.dart' as import_1;
import 'package:mdl/mdlapplication.dart' as import_2;
import 'package:mdl/mdlcore.dart' as import_3;
import 'package:mdl/mdldirective.dart' as import_4;
import 'package:mdl/mdlformatter.dart' as import_5;

final Key _KEY_DomRenderer = new Key(import_2.DomRenderer);
final Key _KEY_EventCompiler = new Key(import_2.EventCompiler);
final Map<Type, Function> typeFactories = <Type, Function>{
  import_0.MaterialAlertDialog: () => new import_0.MaterialAlertDialog(),
  import_0.MdlConfirmDialog: () => new import_0.MdlConfirmDialog(),
  import_0.MaterialSnackbar: () => new import_0.MaterialSnackbar(),
  import_0.MaterialNotification: () => new import_0.MaterialNotification(),
  import_1.TemplateRenderer: (a1, a2) => new import_1.TemplateRenderer(a1, a2),
  import_1.ListRenderer: (a1, a2) => new import_1.ListRenderer(a1, a2),
  import_3.MaterialApplication: () => new import_3.MaterialApplication(),
  import_2.DomRenderer: () => new import_2.DomRenderer(),
  import_2.EventCompiler: () => new import_2.EventCompiler(),
  import_2.ViewFactory: () => new import_2.ViewFactory(),
  import_2.RootScope: () => new import_2.RootScope(),
  import_4.ModelObserverFactory: () => new import_4.ModelObserverFactory(),
  import_5.Formatter: () => new import_5.Formatter(),
};
final Map<Type, List<Key>> parameterKeys = {
  import_0.MaterialAlertDialog: const[],
  import_0.MdlConfirmDialog: const[],
  import_0.MaterialSnackbar: const[],
  import_0.MaterialNotification: const[],
  import_1.TemplateRenderer: [_KEY_DomRenderer, _KEY_EventCompiler],
  import_1.ListRenderer: [_KEY_DomRenderer, _KEY_EventCompiler],
  import_3.MaterialApplication: const[],
  import_2.DomRenderer: const[],
  import_2.EventCompiler: const[],
  import_2.ViewFactory: const[],
  import_2.RootScope: const[],
  import_4.ModelObserverFactory: const[],
  import_5.Formatter: const[],
};
setStaticReflectorAsDefault() => Module.DEFAULT_REFLECTOR = new GeneratedTypeFactories(typeFactories, parameterKeys);
