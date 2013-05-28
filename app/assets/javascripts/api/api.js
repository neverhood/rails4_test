$.api = {
    loading: false,

    Notification: function(text) {
        this.text = text;
        this.element = _buildElement(this.text);

        this.append = function() {
            $('div#notifications').append(this.element);
        }

        this.remove = function() {
            this.element.remove();
        }

        function _buildElement(text) {
            var template = $('div#alert-template').clone().
                removeAttr('id').
                removeClass('hidden');
            var element = template.text(text);

            return element;
        }
    },

    utils: {
        appendNotification: function(text) {
            var notification = new $.api.Notification(text);

            notification.append();
        },

        appendNotificationWithTimeout: function(text, timeout) {
            if ( typeof timeout == 'undefined' ) timeout = 5000;

            var notification = new $.api.Notification(text);
            notification.append();

            callback = function() {
                notification.element.slideUp('fast', function() { notification.remove() });
            }

            setTimeout(callback, timeout);
        }
    }
}
