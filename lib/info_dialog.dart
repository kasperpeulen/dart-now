import "dart:html";

import 'package:mdl/mdl.dart';
import 'package:mdl/mdldialog.dart';

class InfoDialog extends MaterialDialog {

  InfoDialog() : super(new DialogConfig());

  onOk() => close(MdlDialogStatus.OK);

  String template = """
<div class="mdl-dialog">
  <div class="mdl-dialog__content">
    <p>Thanks for giving Dart Now a try! Be aware, you are probably one of my first users ;)</p>
    <p>Dart Now! ships a set of command line tools, to make sure you can get gist from dartnow.org and also add gist to dartnow.org directly from your local editor. </p>
    <p>If this is the first time you use those tools:</p>
    <pre><code> pub global activate dartnow<br>
      mkdir ~/dartnow_playground<br>
      cd ~/dartnow_playground<br>
      dartnow init<br>
      (... fill in your github details  ...)<br>
      dartnow get
    </code>
    </pre>
    <p>Otherwise, just run: (in the directory with the dartnow.yaml file)</p>
    <pre>
    <code>dartnow get
    </code></pre>
    <p>Make sure to use the same github account in dartnow.yaml as you use at dartnow.org, otherwise it won't know which snippet you want to clone.</p>
  </div>
</div>""";
}
