using Toybox.Lang;

class BasicException extends Lang.Exception {
    function initialize(msg) {
        Exception.initialize();
        self.mMessage = msg;
    }
}