var exec = require('cordova/exec');

module.exports.sendToWhatsapp = function (arg0, success, error) {
    this.exec(success, error, 'WhatsAppSticker', 'sendToWhatsapp', [arg0]);
};
