library dartnow.common;

import 'dart:html';

/**
 * A [NodeValidator] which allows everything.
 */
class TrustedNodeValidator implements NodeValidator {
  bool allowsElement(Element element) => true;
  bool allowsAttribute(Element element, String attributeName, String value) {
    return true;
  }
}