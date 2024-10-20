import 'dart:html' as html;

class PwaHelper {
  static late html.EventListener _beforeInstallPromptListener;

  static void initPwa() {
    // Listen for the beforeinstallprompt event
    html.window.on['beforeinstallprompt'].listen((event) {
      event.preventDefault(); // Prevent the default prompt
      _showInstallButton(event); // Show your custom install button
    });
  }

  static void _showInstallButton(html.Event event) {
    // Create and show your install button
    final button = html.ButtonElement()
      ..text = 'Install App'
      ..style.position = 'fixed'
      ..style.bottom = '20px'
      ..style.right = '20px'
      ..style.padding = '10px 20px'
      ..style.backgroundColor = 'green'
      ..style.color = 'white'
      ..style.border = 'none'
      ..style.borderRadius = '5px'
      ..style.cursor = 'pointer';

    // Add event listener for button click
    button.onClick.listen((_) {
      button.remove(); // Remove the button after clicking
      _promptInstall(event); // Prompt the installation
    });

    // Append the button to the body
    html.document.body!.append(button);
  }

  static void _promptInstall(html.Event event) {
    // Show the install prompt
    final promptEvent = event as html.Event;
    (promptEvent as dynamic).prompt(); // Use dynamic typing to call prompt
  }
}
