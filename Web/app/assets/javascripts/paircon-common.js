/****************************************/
//------------PJAX ENABLER--------------//
/****************************************/
function enablePJAX() {
    $.pjax.defaults.timeout = 2000;
    $(document).pjax("a:not('.skip-pjax')", '[data-pjax-container]')
    var animationSpeed = 0;

    $(document).on('pjax:complete', function () {
        switchContainer();
        initLoginBoxValidation();
        $('#error_callout').fadeTo('fast', 0);
    });

    window.addEventListener('popstate', function (e) {
        getViewportHeight();
        switchContainer();
        animationSpeed = 300;
        initLoginBoxValidation();
    });

    function switchContainer() {
        var is_confirmation = $('#new_user_confirmation').length > 0;
        var is_login = $('#new_user_session').length > 0;
        var is_recover = $('#new_user_password').length > 0;
        var is_edit_register = $('#edit_user_password').length > 0;
        var is_register = $('#new_user_registration').length > 0;
        var cheight = 100;

        if (is_login)
            cheight = 315;
        else if (is_register && window.innerWidth < 768)
            cheight = 340;
        else if (is_register && window.innerWidth >= 768)
            cheight = 445;
        else if (is_recover || is_confirmation)
            cheight = 260;
        else if (is_edit_register)
            cheight = 305;

        $('#loginbox').animate({'height': cheight + 'px'}, animationSpeed, function () {
            $('#loginbox form').fadeTo(animationSpeed, 1);
        });
    }

    getViewportHeight();
    switchContainer();
    animationSpeed = 300;
    initLoginBoxValidation();
    $(window).resize(function() {
        getViewportHeight();
        switchContainer();
    });

}

// For centering login form
var getViewportHeight = function () {
    $('.focusedform').css('height', $(window).height() - 40); // Prevent scroll of the whole content (mobile)

};

/******************************************/
//------------ERROR MESSAGES--------------//
/******************************************/
function showNotificationMsg(message) {
    hideProcessingMsg();
    hideErrorMsg();
    var notficationMsgBox = $('#notification_msg_box');
    notficationMsgBox.children('span').html(message);
    notficationMsgBox.fadeIn(1000);
}

function showErrorMsg(message) {
    hideProcessingMsg();
    hideNotificationMsg();
    var errorMsgBox = $('#error_message_box');
    errorMsgBox.children('span').html(message);
    errorMsgBox.fadeIn(1000);
}

function showProcessingMsg(message) {
    hideNotificationMsg();
    hideErrorMsg();
    var processing_msg_box = $('#processing_msg_box');
    processing_msg_box.children('span').html(message);
    processing_msg_box.fadeIn(1000);
}

function hideProcessingMsg() {
    $('#processing_msg_box').hide();
}

function hideNotificationMsg() {
    $('#notfication_msg_box').hide();
}

function hideErrorMsg() {
    $('#error_message_box').hide();
}

function setAutoHideFlashMsg(id) {
    var observer = new MutationObserver(function (mutations) {
        setTimeout(function () {
            $('#' + id).fadeOut('slow');
        }, 5000);
    });

    var target = document.getElementById(id);
    observer.observe(target, {attributes: true, attributeFilter: ['style']});
}