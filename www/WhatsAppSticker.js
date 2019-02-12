var exec = require('cordova/exec');

exports.sendToWhatsapp = function (arg0, success, error) {
    exec(success, error, 'WhatsAppSticker', 'sendToWhatsapp', [arg0]);
};
